#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# pruebas-validador.sh — comprueba que validar-idiomas.sh detecta roturas.
#
# Cada mutante se aplica sobre una copia temporal y debe hacer fallar
# al validador. Reglas de medida:
#  - Guarda: si el validador no pasa sobre el repo sin mutar, no se mide nada.
#  - Cada mutante se aplica exactamente una vez; si no encuentra su blanco
#    (o lo encuentra varias veces), es un error de esta herramienta.
# ═══════════════════════════════════════════════════════════════

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VAL="$ROOT/scripts/validar-idiomas.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

copia() {
  rm -rf "$TMP/c"
  mkdir -p "$TMP/c"
  cp -r "$ROOT/skills" "$TMP/c/"
}

# Guarda: el validador debe pasar sobre el repo sin mutar
copia
if ! bash "$VAL" "$TMP/c" > "$TMP/guarda.txt" 2>&1; then
  echo "❌ guarda: el validador no pasa sobre el repo sin mutar. No mido nada."
  cat "$TMP/guarda.txt"
  exit 2
fi
echo "✅ guarda: el validador pasa sobre el repo sin mutar"

TOTAL=0
MUERTOS=0
HERR=0
SUPERVIVIENTES=0

# $1 descripción · $2 fichero dentro de idiomas/ · $3 patrón (fijo) que
# identifica el blanco · $4 expresión sed que aplica el mutante
mutante() {
  local desc="$1" fich="$2" pat="$3" expr="$4" ruta n salida codigo
  copia
  ruta="$TMP/c/skills/codigo-civil-formulacion-juridica/idiomas/$fich"
  n="$(grep -F -c -- "$pat" "$ruta")"
  if [ "$n" != 1 ]; then
    echo "⚠️  error de herramienta: «$desc» encuentra $n blancos (debe ser 1)"
    HERR=$((HERR + 1))
    return
  fi
  sed -i -e "$expr" "$ruta"
  TOTAL=$((TOTAL + 1))
  salida="$(bash "$VAL" "$TMP/c" 2>&1)"
  codigo=$?
  if [ "$codigo" -ne 0 ]; then
    MUERTOS=$((MUERTOS + 1))
    echo "✅ muerto: $desc → $(printf '%s\n' "$salida" | grep -m1 '❌')"
  else
    SUPERVIVIENTES=$((SUPERVIVIENTES + 1))
    echo "❌ superviviente: $desc"
  fi
}

mutante "borra la clave aviso.ia en ca" ca.md "aviso.ia |" '/^aviso\.ia |/d'
mutante "quita [verificar] de nota_final en en" en.md "nota_final |" 's/\[verificar\]/verificar/'
mutante "vacía el valor de aviso.ia en eu" eu.md "aviso.ia |" 's/^\(aviso\.ia | .* | \).*$/\1/'
mutante "inserta TODO en nota_final de gl" gl.md "nota_final |" 's/^\(nota_final | .* | \).*$/\1TODO/'
mutante "marca ca como revisado sin revisor" ca.md "# estado: borrador-ia" 's/# estado: borrador-ia/# estado: revisado/'
mutante "quita {codigo} de aviso.idioma_no_disponible en ca" ca.md "aviso.idioma_no_disponible |" 's/{codigo}//'
mutante "rompe el formato de aviso.menor en eu" eu.md "aviso.menor |" 's/ | / /'
mutante "duplica la clave enc.6 en en" en.md "enc.6 |" '/^enc\.6 |/p'
mutante "borra la clave enc.nota en gl" gl.md "enc.nota |" '/^enc\.nota |/d'
mutante "deja aviso.modo_no_reconocido en español dentro de en" en.md "aviso.modo_no_reconocido |" 's/^aviso\.modo_no_reconocido | .*/aviso.modo_no_reconocido | original | normal | Modo no reconocido, ejecuto modo completo./'
mutante "baja el riesgo de aviso.menor en gl" gl.md "aviso.menor |" 's/\(aviso\.menor | original | \)alto/\1normal/'
mutante "cambia una palabra de una literal de es.md" es.md "aviso.modo_no_reconocido |" 's/Modo no reconocido/Modo desconocido/'
mutante "cambia una palabra de nota_final en es.md" es.md "nota_final |" 's/jurista responsable/abogado responsable/'
mutante "cabecera de idioma errónea en ca" ca.md "# idioma: ca" 's/# idioma: ca/# idioma: en/'
mutante "quita los corchetes [foral] en eu" eu.md "aviso.foral |" 's/\[foral\]/(foral)/'
mutante "estado no válido en en" en.md "# estado: borrador-ia" 's/borrador-ia/listo/'

echo "──────────────────────────────────────────"
echo "Mutantes: $TOTAL · muertos: $MUERTOS · supervivientes: $SUPERVIVIENTES · errores de herramienta: $HERR"
if [ "$SUPERVIVIENTES" -gt 0 ] || [ "$HERR" -gt 0 ]; then
  exit 1
fi
