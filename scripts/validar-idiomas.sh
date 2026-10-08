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

if [ "$ERRORES" -gt 0 ]; then
  echo "❌ $ERRORES error(es) en los catálogos"
  exit 1
fi
echo "✅ catálogos correctos: $(wc -l < "$TMP/es.tsv") claves en 5 idiomas"
