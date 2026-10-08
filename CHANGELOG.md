# Changelog

Historial de versiones del skill `codigo-civil-formulacion-juridica`. Las versiones siguen el patrón `vMAJOR.MINOR`. Mientras el skill no haya sido validado con casos reales por jurista en ejercicio, la versión mayor permanece en `0`.

---

## v0.5 — Estado actual

Cambio de idiomas y de fuentes forales. El razonamiento de los seis pasos, las reglas duras y la plantilla de caso **no cambian**. La salida en español sí cambia en un punto: lleva ahora el aviso de IA en la primera línea (excepción aprobada).

**Añadido**

- Salida en **español, inglés, catalán, euskera o gallego**, elegida con la marca `idioma=xx` en el mensaje del usuario. Sin marca, español. Sección «Idioma de la salida» en `SKILL.md`.
- Catálogos de textos fijos en `skills/codigo-civil-formulacion-juridica/idiomas/`: 22 claves por idioma, con el mismo conjunto de claves en los cinco.
- Aviso de IA en la primera línea de cada salida, en el idioma elegido.
- Aviso de «traducción sin revisar» en inglés, catalán, euskera y gallego.
- `derecho-foral.md`: mapa de 8 entradas de fuentes forales (Galicia, País Vasco, Cataluña libro IV, Aragón, Navarra, Baleares, y dos normas valencianas), con nivel de fuente, vigencia, nombres en catalán, euskera y gallego, y regla de derivación. No reproduce texto legal.
- Pruebas: `scripts/validar-idiomas.sh` (catálogos, bloques, mapa y versiones), `scripts/pruebas-validador.sh` (33 mutantes, todos detectados), `scripts/pruebas-empaquetado.sh` (contenido exacto del zip) y `tests/escenarios-idioma.md` (13 escenarios).

**Cambiado**

- **Excepción aprobada en español:** la primera línea de la salida es ahora el aviso de IA. Antes solo aparecía en la nota final. Si se quiere retirar, basta con quitar el punto 1 de la sección «Idioma de la salida».
- `scripts/build-dist.sh`: copia también `idiomas/`. Es la única línea cambiada en los scripts.
- Versión **0.5.0** en `plugin.json`, `.claude-plugin/plugin.json` y `.claude-plugin/marketplace.json`.
- Sin líneas existentes modificadas en `SKILL.md` ni en `flujo.md`: los cambios son adiciones delimitadas por marcas.

**Corregido**

- Versiones desfasadas: los manifiestos decían 0.3.0, el README y el CHANGELOG decían v0.4, y `SKILL.md` decía v0.3 en su sección de versión. Ahora todo dice 0.5.
- Referencias forales de la versión preliminar de este trabajo: una «Ley 5/2015» valenciana que no es civil valenciana, y una «Ley 5/2024» balear que no existe en las fuentes consultadas. No están en el mapa.

**Limitaciones**

- Las traducciones de inglés, catalán, euskera y gallego son **borrador de IA sin revisión humana**. No hay revisor. El euskera es el de mayor riesgo.
- Los escenarios de idioma (`tests/escenarios-idioma.md`) están **pendientes de ejecución**. Su nivel de verificación será «simulado», no automático.
- La regla de idioma la aplica el modelo siguiendo `SKILL.md`; no hay ningún programa que la aplique.
- El mapa foral se basa sobre todo en fuentes secundarias. Solo tienen nivel «oficial» las entradas con enlace a un boletín o a un sitio institucional. Valencia figura como anulada por el Tribunal Constitucional según fuente secundaria. Quedan pendientes el nombre catalán de Baleares y el euskera de Navarra. Los demás libros del Código civil de Cataluña no están en el mapa.
- El manual PDF sigue en v0.3 y no recoge estos cambios.
- El workflow `validar` se ha ejecutado en GitHub Actions sobre la rama de trabajo, en el commit `cce1a72` (ejecución 37728724359, conclusión: éxito, los cinco pasos en verde). No se ha ejecutado todavía sobre un Pull Request ni sobre `main`.
- Un paquete v0.4 o anterior no incluye `idiomas/`: quien lo tenga instalado debe reinstalar el paquete completo.

*Texto elaborado con asistencia de IA; requiere revisión humana.*

## v0.4

Cambio de empaquetado, **sin tocar el contenido jurídico**: ni el `SKILL.md`, ni el flujo de seis pasos, ni la plantilla de caso, ni los criterios deontológicos. Solo cambia dónde viven los archivos y cómo se instala.

- El repositorio es ahora un **plugin conforme a [Agent Plugins 1.0.0](https://agent-plugins.org/specification)**, el formato portátil de la Agentic AI Foundation. Se añaden `plugin.json` (portable, con el `$schema` canónico) y `.claude-plugin/plugin.json` (Claude Code). Habilita una vía de instalación nueva —como plugin en Claude Code y Cowork, Opción 5 del README— sin retirar ninguna anterior.
- El skill pasa de la raíz a `skills/codigo-civil-formulacion-juridica/`, junto con `flujo.md` y `plantilla-caso.md`: es la ubicación fija que el §6.1 de la spec exige para descubrir skills. Los acompañantes quedan planos al lado del `SKILL.md`, no bajo `references/`, porque el cuerpo los referencia por nombre pelado.
- `scripts/build-dist.sh` regenera `dist/`, que hasta ahora se armaba a mano. Desde la publicación en el directorio de plugins de Claude, `dist/` ya no se versiona (el validador no puede inspeccionar binarios): los paquetes `.zip` y `.skill` se distribuyen en [Releases](https://github.com/novanoticia/codigo-civil-formulacion-juridica/releases), y se añade un icono al plugin.
- **El paquete de `dist/` conserva exactamente la misma forma**: una carpeta `codigo-civil-formulacion-juridica/` con `SKILL.md`, `flujo.md`, `plantilla-caso.md` y `LICENSE`. Verificado comparando la lista de ficheros antes y después. Las opciones 1 a 4 del README siguen funcionando igual, y `tests/` sigue fuera del paquete.

---

## v0.3

Tercer borrador, tras segunda ronda de tests con dos casos ficticios adicionales: familia con custodia disputada y mediación familiar autonómica andaluza; mercantil entre empresarios sin consumo con concurso del deudor en horizonte.

**Añadido**

- Generalización de la limitación "mapa de derivación, no formulación cerrada" a toda materia con centro normativo fuera del CC, no solo a supuestos forales. Listado de áreas afectadas (concurso y derecho preconcursal, materia mercantil específica, derecho de la edificación, urbanismo, propiedad intelectual, materias con régimen sectorial fuerte).
- Incorporación al paso 5 (carga de la prueba) de las matizaciones del dispositivo en procedimientos especiales: art. 752 LEC para familia, capacidad, filiación y jurisdicción voluntaria; régimen específico TRLC en concurso.
- Nuevo ángulo en el paso 6 (cuestionamiento argumental): riesgos pasivos del cliente no planteados por él, especialmente en mercantil, concurso, sucesiones con preterición, derecho de la edificación y supuestos donde el cliente puede ser objeto de acciones rescisorias, calificación culpable, responsabilidad subsidiaria o reclasificación crediticia.
- Sección de autoría y licencia añadida al `SKILL.md` y al manual PDF.
- Campo `license: CC BY 4.0` en el frontmatter del `SKILL.md`.
- Compatibilidad de instalación con **Perplexity** (`.zip` directo) y **Mistral AI** (carpeta en el espacio *Work*); campo `description` ajustado a menos de 500 caracteres (485) para el límite de Mistral, conservando trigger, modos y límites de seguridad; paquete `dist/` regenerado.

**Estado**

Estable para uso por jurista habilitado con conocimiento del régimen especial aplicable. Probado con cinco casos ficticios en total. Pendiente de validación con casos reales.

---

## v0.2

Segundo borrador, tras primera ronda de tests con tres casos ficticios: vicios del consentimiento con caducidad del art. 1301 CC; sucesiones forales catalanas; responsabilidad extracontractual con concurrencia de culpas y vía penal alternativa.

**Añadido**

- Limitación expresa sobre alcance del skill en supuestos forales (mapa de derivación, no formulación cerrada).
- Sub-bloque sobre litisconsorcio pasivo necesario y eventual en el paso 5 (legitimación), con lista de codemandados típicos (aseguradora con acción directa, empleador, codeudores solidarios, copropietarios, cónyuge en gananciales, herederos, tercero adquirente).
- Sub-bloque "Vías previas y resolución alternativa" en el paso 5: cláusula compromisoria, mediación familiar autonómica, RAL en consumo (Ley 7/2017), conciliación previa LJV, art. 21 LPH para reclamaciones de gastos comunes.
- Regla anti-cita-de-relleno en reglas duras transversales: cada artículo invocado debe anclarse a un hecho del caso.
- Regla sobre materias en evolución normativa rápida (vehículos de movilidad personal, criptoactivos, IA, plataformas digitales, derecho de la edificación reciente, contratos energéticos, datos personales, normativa post-Ley 8/2021), con marca explícita de verificación de vigencia.
- Criterio específico de cita en derecho foral: preferencia por referencia a la institución y al texto legal por nombre antes que números de artículo.

---

## v0.1

Primer borrador. Estructura base del skill.

**Añadido**

- Tres ficheros base: `SKILL.md` (descriptor), `flujo.md` (razonamiento de seis pasos con apéndice canónico), `plantilla-caso.md` (formato de entrada).
- Seis pasos del flujo: caso estructurado, calificaciones jurídicas a considerar, calificaciones alternativas / descartes obligatorios, lagunas y plan de exploración, riesgos procesales, cuestionamiento argumental.
- Cinco modos de invocación: `completo` (default), `alternativas`, `lagunas`, `riesgo`, `auditoria`.
- Dos puertas de entrada: pseudonimización y mediación profesional.
- Cuatro avisos automáticos al inicio del flujo: vecindad civil distinta de la común, materia consumidor, persona con medidas de apoyo, menor de edad como parte.
- Reglas duras transversales: no transcripción de articulado, no estrategia procesal, no asesoramiento al cliente, hechos no acreditados ≠ inexistentes, marca `[fuera del CC]` para leyes conexas, marca `[verificar]` para citas jurisprudenciales concretas.
- Apéndice canónico: caso de responsabilidad civil extracontractual por caída en supermercado, resuelto en modo `completo` con la estructura completa del flujo.
