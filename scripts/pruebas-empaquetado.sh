#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# pruebas-empaquetado.sh — comprueba el paquete que genera build-dist.sh.
#
# Trabaja en una copia temporal del repositorio, sin .git ni dist/, para
# no tocar nada del original. Exige que el zip contenga exactamente los
# ficheros esperados: ni uno menos (p. ej. idiomas/) ni uno más (tests/,
# scripts/, docs/, el propio repositorio).
# ═══════════════════════════════════════════════════════════════

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
NOMBRE="codigo-civil-formulacion-juridica"
ERRORES=0
err() { echo "❌ $*"; ERRORES=$((ERRORES + 1)); }

cp -r "$ROOT/." "$TMP/repo"
rm -rf "$TMP/repo/.git" "$TMP/repo/dist"

if ! (cd "$TMP/repo" && bash scripts/build-dist.sh > "$TMP/build.txt" 2>&1); then
  echo "❌ build-dist.sh termina con error:"
  cat "$TMP/build.txt"
  exit 1
fi

ZIP="$TMP/repo/dist/$NOMBRE.zip"
SKILLF="$TMP/repo/dist/$NOMBRE.skill"
[ -f "$ZIP" ] || { echo "❌ no se genera $NOMBRE.zip"; exit 1; }

echo "── unzip -l del paquete ──"
unzip -l "$ZIP"
echo "──────────────────────────"

# Solo ficheros (las entradas de directorio terminan en /)
unzip -Z1 "$ZIP" | grep -v '/$' | sort > "$TMP/obtenido.txt"
cat > "$TMP/esperado.txt" <<EOF
$NOMBRE/LICENSE
$NOMBRE/SKILL.md
$NOMBRE/derecho-foral.md
$NOMBRE/flujo.md
$NOMBRE/idiomas/ca.md
$NOMBRE/idiomas/en.md
$NOMBRE/idiomas/es.md
$NOMBRE/idiomas/eu.md
$NOMBRE/idiomas/gl.md
$NOMBRE/plantilla-caso.md
EOF
sort -o "$TMP/esperado.txt" "$TMP/esperado.txt"

if ! diff "$TMP/esperado.txt" "$TMP/obtenido.txt" > "$TMP/diff.txt"; then
  err "el contenido del zip no coincide con el esperado (< falta, > sobra):"
  cat "$TMP/diff.txt"
fi

# El .skill es copia byte a byte del .zip
if [ -f "$SKILLF" ]; then
  cmp -s "$ZIP" "$SKILLF" || err "$NOMBRE.skill no es copia idéntica de $NOMBRE.zip"
else
  err "no se genera $NOMBRE.skill"
fi

# Nada fuera de la carpeta del skill
FUERA="$(unzip -Z1 "$ZIP" | grep -v "^$NOMBRE/" || true)"
[ -z "$FUERA" ] || err "entradas fuera de $NOMBRE/: $FUERA"

if [ "$ERRORES" -gt 0 ]; then
  echo "❌ $ERRORES error(es) de empaquetado"
  exit 1
fi
echo "✅ paquete correcto: $(wc -l < "$TMP/obtenido.txt") ficheros, sin tests, scripts ni docs"
