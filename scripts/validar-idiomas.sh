#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# validar-idiomas.sh — comprueba los catálogos de idioma del skill.
#
# Solo usa bash, grep, awk, sort y diff. Sale con código 1 si
# encuentra algún error.
#
# Uso:  ./scripts/validar-idiomas.sh [raíz]
# La raíz por defecto es este repositorio. Las pruebas sintéticas
# (scripts/pruebas-validador.sh) la apuntan a copias rotas a propósito.
# ═══════════════════════════════════════════════════════════════

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SKILL="$ROOT/skills/codigo-civil-formulacion-juridica"
IDIOMAS="$SKILL/idiomas"
LANGS="es en ca eu gl"
FRONTMATTER_SHA="d4d0e58a52cb1bf1a5012b91ef9c468cbd4690c421dd4668c51b4e4cefed2c6a"
ESTADOS="referencia borrador-ia experimental revisado"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
ERRORES=0
err() { echo "❌ $*"; ERRORES=$((ERRORES + 1)); }

# Marcadores {nombre} y [contrato] de un texto, ordenados
ph() { printf '%s' "$1" | grep -o '{[a-z_]*}' | sort | tr '\n' ' '; }
br() { printf '%s' "$1" | grep -o '\[[^]]*\]' | sort | tr '\n' ' '; }

for l in $LANGS; do
  [ -f "$IDIOMAS/$l.md" ] || err "falta $IDIOMAS/$l.md"
done
if [ "$ERRORES" -gt 0 ]; then echo "❌ $ERRORES error(es)"; exit 1; fi

# 1. Por idioma: cabeceras, formato de cada línea, claves únicas, valores no vacíos
for l in $LANGS; do
  f="$IDIOMAS/$l.md"
  [ "$(sed -n 's/^# idioma: //p' "$f")" = "$l" ] || err "$l.md: la cabecera '# idioma:' debe ser '$l'"
  est="$(sed -n 's/^# estado: //p' "$f")"
  rev="$(sed -n 's/^# revisor: //p' "$f")"
  case " $ESTADOS " in *" $est "*) ;; *) err "$l.md: estado no válido '$est'" ;; esac
  [ -n "$rev" ] || err "$l.md: falta la cabecera '# revisor:'"
  if [ "$est" = revisado ] && [ "$rev" = ninguno ]; then
    err "$l.md: marcado 'revisado' sin revisor"
  fi

  grep -v '^#' "$f" | grep -v '^[[:space:]]*$' \
    | awk -F' [|] ' '
        NF != 4 { print "línea mal formada: " $0 > "/dev/stderr"; bad = 1; next }
        { print $1 "\t" $2 "\t" $3 "\t" $4 }
        END { exit bad }' > "$TMP/$l.tsv" 2> "$TMP/$l.err" || err "$l.md: hay líneas mal formadas: $(cat "$TMP/$l.err")"

  dup="$(cut -f1 "$TMP/$l.tsv" | sort | uniq -d | tr '\n' ' ')"
  [ -z "$dup" ] || err "$l.md: claves duplicadas: $dup"

  vacios="$(awk -F'\t' '$4 == "" { printf "%s ", $1 }' "$TMP/$l.tsv")"
  [ -z "$vacios" ] || err "$l.md: valores vacíos en: $vacios"
  todos="$(awk -F'\t' '$4 ~ /TODO/ { printf "%s ", $1 }' "$TMP/$l.tsv")"
  [ -z "$todos" ] || err "$l.md: TODO en: $todos"
done

# 2. Cada idioma distinto de es tiene exactamente las mismas claves
cut -f1 "$TMP/es.tsv" | sort > "$TMP/claves-es"
for l in en ca eu gl; do
  cut -f1 "$TMP/$l.tsv" | sort > "$TMP/claves-$l"
  if ! diff -q "$TMP/claves-es" "$TMP/claves-$l" > /dev/null; then
    err "$l.md: las claves no coinciden con es.md: $(diff "$TMP/claves-es" "$TMP/claves-$l" | grep '^[<>]' | tr '\n' ' ')"
  fi
done

# 3. Cada clave de es.md: mismo origen y riesgo, mismos marcadores, traducción real,
#    y las literales del original aparecen tal cual en SKILL.md o flujo.md
while IFS=$'\t' read -r k orig riesgo valor; do
  if [ "$orig" = original ]; then
    grep -F -q -- "$valor" "$SKILL/SKILL.md" "$SKILL/flujo.md" \
      || err "es.md: '$k' no aparece literal en SKILL.md ni en flujo.md"
  fi
  for l in en ca eu gl; do
    fila="$(awk -F'\t' -v k="$k" '$1 == k' "$TMP/$l.tsv")"
    [ -n "$fila" ] || continue
    o2="$(printf '%s' "$fila" | cut -f2)"
    r2="$(printf '%s' "$fila" | cut -f3)"
    v2="$(printf '%s' "$fila" | cut -f4)"
    [ "$o2" = "$orig" ] || err "$l.md: '$k' tiene origen '$o2' y es.md tiene '$orig'"
    [ "$r2" = "$riesgo" ] || err "$l.md: '$k' tiene riesgo '$r2' y es.md tiene '$riesgo'"
    [ "$(ph "$v2")" = "$(ph "$valor")" ] || err "$l.md: '$k' tiene marcadores {…} distintos de es.md"
    [ "$(br "$v2")" = "$(br "$valor")" ] || err "$l.md: '$k' tiene marcadores [...] distintos de es.md"
    [ "$v2" != "$valor" ] || err "$l.md: '$k' sin traducir (igual que es.md)"
  done
done < "$TMP/es.tsv"

# 4. Bloque de idioma en SKILL.md y flujo.md (delimitado por marcadores)
SKILL_MD="$SKILL/SKILL.md"
FLUJO_MD="$SKILL/flujo.md"
for f in "$SKILL_MD" "$FLUJO_MD"; do
  ini="$(grep -c '^<!-- i18n:inicio -->$' "$f")"
  fin="$(grep -c '^<!-- i18n:fin -->$' "$f")"
  [ "$ini" = 1 ] && [ "$fin" = 1 ] \
    || err "$(basename "$f"): debe tener un bloque i18n (marcas de inicio: $ini, de fin: $fin)"
done
BLOQUE="$(sed -n '/^<!-- i18n:inicio -->$/,/^<!-- i18n:fin -->$/p' "$SKILL_MD")"
BYTES="$(printf '%s' "$BLOQUE" | wc -c)"
PRESUPUESTO=4000
[ "$BYTES" -le "$PRESUPUESTO" ] || err "bloque de idioma de SKILL.md: $BYTES bytes, presupuesto $PRESUPUESTO"
for c in es en ca eu gl; do
  printf '%s' "$BLOQUE" | grep -q "idiomas/$c.md" || err "el bloque de SKILL.md no menciona idiomas/$c.md"
done
printf '%s' "$BLOQUE" | grep -q 'idioma=xx' || err "el bloque de SKILL.md no documenta la marca idioma=xx"
PRIMERA="$(printf '%s\n' "$BLOQUE" | grep -m1 '^1\. ')"
case "$PRIMERA" in *aviso.ia*) ;; *) err "el aviso de IA no es el primer punto del orden de avisos" ;; esac
# Frontmatter: huella fijada en la línea base (commit ec86111); cambiarla exige decidirlo
FM="$(awk 'NR==1 && /^---$/{f=1;next} f && /^---$/{exit} f' "$SKILL_MD" | sha256sum | cut -c1-64)"
[ "$FM" = "$FRONTMATTER_SHA" ] || err "el frontmatter de SKILL.md ha cambiado"

# 5. Mapa de fuentes forales (derecho-foral.md)
MAPA="$SKILL/derecho-foral.md"
FLUJO_MD_F="$SKILL/flujo.md"
if [ ! -f "$MAPA" ]; then
  err "falta derecho-foral.md"
else
  awk '
    /^## / { n++; next }
    /^- [a-z_]+: / {
      k = $0; sub(/^- /, "", k); sub(/: .*/, "", k)
      v = $0; sub(/^- [a-z_]+: /, "", v)
      print n "\t" k "\t" v
    }' "$MAPA" > "$TMP/mapa.tsv"
  NENT="$(cut -f1 "$TMP/mapa.tsv" | sort -un | wc -l)"
  [ "$NENT" -ge 1 ] || err "derecho-foral.md no tiene entradas"
  IDS_DUP="$(awk -F'\t' '$2 == "id" { print $3 }' "$TMP/mapa.tsv" | sort | uniq -d | tr '\n' ' ')"
  [ -z "$IDS_DUP" ] || err "derecho-foral.md: ids duplicados: $IDS_DUP"
  for n in $(cut -f1 "$TMP/mapa.tsv" | sort -un); do
    val() { awk -F'\t' -v n="$n" -v k="$1" '$1 == n && $2 == k { print $3; exit }' "$TMP/mapa.tsv"; }
    id="$(val id)"
    for c in id nombre_es nombre_ca nombre_eu nombre_gl nivel_fuente fuente publicacion vigencia ambito materias derivacion; do
      awk -F'\t' -v n="$n" -v k="$c" '$1 == n && $2 == k { f = 1 } END { exit !f }' "$TMP/mapa.tsv" \
        || err "derecho-foral.md, entrada $n ($id): falta el campo $c"
    done
    nivel="$(val nivel_fuente)"
    fuente="$(val fuente)"
    vig="$(val vigencia)"
    der="$(val derivacion)"
    case "$nivel" in oficial|"segunda mano"|"no comprobada") ;; *) err "entrada $id: nivel_fuente no válido '$nivel'" ;; esac
    if [ "$nivel" != "no comprobada" ]; then
      case "$fuente" in https://*) ;; *) err "entrada $id: nivel '$nivel' exige una fuente https" ;; esac
    fi
    case "$vig" in vigente*|anulada*|"no comprobada"*) ;; *) err "entrada $id: vigencia no válida '$vig'" ;; esac
    [ -n "$der" ] || err "entrada $id: derivacion vacía"
    [ -n "$(val nombre_es)" ] || err "entrada $id: nombre_es vacío"
    for l in ca eu gl; do
      nm="$(val nombre_$l)"
      [ -n "$nm" ] || err "entrada $id: nombre_$l vacío (usa «no aplica» o «no comprobado»)"
      case "$nm" in "no aplica"|"no comprobado") ;;
        *) [ "$nivel" != "no comprobada" ] || err "entrada $id: nombre_$l con texto, pero nivel «no comprobada»" ;;
      esac
    done
  done
fi
grep -q 'derecho-foral.md' "$FLUJO_MD_F" || err "flujo.md no remite a derecho-foral.md"

# 6. Versión: manifiestos, README, SKILL.md y CHANGELOG deben decir lo mismo
V_PLUGIN="$(sed -n 's/.*"version": "\([^"]*\)".*/\1/p' "$ROOT/plugin.json" | head -1)"
V_CLAUDE="$(sed -n 's/.*"version": "\([^"]*\)".*/\1/p' "$ROOT/.claude-plugin/plugin.json" | head -1)"
V_MKT="$(sed -n 's/.*"version": "\([^"]*\)".*/\1/p' "$ROOT/.claude-plugin/marketplace.json" | head -1)"
[ "$V_PLUGIN" = "$V_CLAUDE" ] && [ "$V_CLAUDE" = "$V_MKT" ] \
  || err "versiones de los manifiestos distintas: plugin.json=$V_PLUGIN, .claude-plugin/plugin.json=$V_CLAUDE, marketplace.json=$V_MKT"
MM="${V_PLUGIN%.*}"
V_README="$(sed -n 's/^> \*\*Versión actual:\*\* v\(.*\)$/\1/p' "$ROOT/README.md" | head -1)"
V_SKILL="$(sed -n 's/^v\([0-9.]*\) — .*/\1/p' "$SKILL_MD" | head -1)"
V_LOG="$(sed -n 's/^## v\([0-9.]*\).*/\1/p' "$ROOT/CHANGELOG.md" | head -1)"
[ "$V_README" = "$MM" ] || err "README dice v$V_README; el manifiesto dice $V_PLUGIN"
[ "$V_SKILL" = "$MM" ] || err "SKILL.md dice v$V_SKILL en su sección de versión; el manifiesto dice $V_PLUGIN"
[ "$V_LOG" = "$MM" ] || err "CHANGELOG.md empieza en v$V_LOG; el manifiesto dice $V_PLUGIN"
grep -q "(v$MM)" "$ROOT/README.md" || err "la cita del README no dice (v$MM)"

if [ "$ERRORES" -gt 0 ]; then
  echo "❌ $ERRORES error(es) en los catálogos"
  exit 1
fi
echo "✅ catálogos correctos: $(wc -l < "$TMP/es.tsv") claves en 5 idiomas"
