# Pendientes

Estado a 2026-10-08, tras la versión 0.5.0 (`main` en `68d4bee`). Lo que aquí aparece no está verificado, salvo que se diga lo contrario.

## Requiere una persona

- **Revisión humana de las traducciones** de inglés, catalán, euskera y gallego. Son borrador de IA sin revisor. El euskera es el de mayor riesgo, porque no se ha podido juzgar su calidad jurídica. Cada cabecera de `skills/codigo-civil-formulacion-juridica/idiomas/*.md` indica el estado. Cambiar a `revisado` exige un revisor en la cabecera; el validador lo comprueba.
- **Revisión jurídica de los avisos de riesgo alto** (`aviso.foral`, `aviso.consumidor`, `aviso.apoyo`, `aviso.menor`, `nota_final`) en cada idioma.
- **Decisión sobre el aviso de IA en la primera línea de la salida en español**, aprobada como excepción. Si se retira, basta con quitar el punto 1 de la sección «Idioma de la salida» de `SKILL.md`.

## Requiere una sesión nueva o acceso a la red

- **Norma navarra en el BOE.** El mapa identifica la norma como Ley 1/1973, de 1 de marzo (BOE de 7 de marzo de 1973), con una base de datos y la fecha del BOE como apoyo. El acceso directo a `www.boe.es` y `boe.gob.es` estuvo bloqueado por el proxy de salida en la sesión de trabajo. Un único artículo académico cita un «Decreto-ley 1/1973, de 3 de marzo», sin confirmar. Hay que leer el registro del BOE para cerrar el punto.
- Dominios que hacen falta para verificar el mapa: `www.boe.es`, `boe.gob.es`, `www.euskadi.eus`, `www.xunta.gal`.

## Ejecución de pruebas de comportamiento

- **Escenarios de idioma** (`tests/escenarios-idioma.md`, 13 casos). Están sin ejecutar. Cada escenario necesita una conversación nueva con el skill cargado, para que no arrastre contexto de otros. Su nivel será «simulado», no automático. La columna «Resultado» se rellena al ejecutar.

## Mapa foral (`derecho-foral.md`)

- Sin fuente oficial: el nombre catalán de Baleares (`nombre_ca`, Compilación de 1990), el nombre catalán de Valencia 2011 (`nombre_ca`), y el nombre euskera de Navarra (`nombre_eu`).
- Libros del Código civil de Cataluña distintos del IV: no están en el mapa.
- Normas sobre uniones de hecho en la Comunitat Valenciana: no comprobadas, no incluidas.
- La mayoría de las fuentes son secundarias. Solo tienen nivel «oficial» las entradas con enlace a un boletín o a un sitio institucional.
- Valencia (2007 y 2011) figura como anulada por el Tribunal Constitucional según fuente secundaria. Conviene confirmarlo en la sentencia.

## Documentación

- **Manual PDF**: existe la versión 0.5 (`docs/codigo-civil-formulacion-juridica-manual-v0.5.pdf`), generada desde HTML. Queda pendiente su revisión humana. La v0.3 se conserva como historial.

## Cambios de repositorio pendientes de integrar

- **Commit `27337db`** en la rama `claude/keen-euler-0wbbhp`: corrige la frase del CHANGELOG sobre el CI. Aún no está en `main`. Requiere un PR.
- **Descripción de la Release v0.5.0**: sigue con la frase antigua sobre el CI. El texto corregido está en el CHANGELOG de la rama; hay que pegarlo a mano en la Release.
- **Etiqueta `v0.5.0`**: existe en GitHub, creada con la Release.
