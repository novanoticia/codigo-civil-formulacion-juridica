---
name: codigo-civil-formulacion-juridica
description: >-
  Apoya a juristas (abogados en ejercicio, estudiantes avanzados bajo supervisión) a estructurar la formulación jurídica de casos ya estudiados, usando el Código Civil español como referencia normativa primaria. **Trigger principal "/codigo-civil-formulacion-juridica"**, que activa el skill siempre que el usuario lo escriba exacto. Soporta modos completo (default), alternativas, lagunas, riesgo, auditoria. Activa también con expresiones como "formula este caso", "califica jurídicamente este supuesto", "qué calificaciones alternativas debería considerar" o "audita esta formulación jurídica". NO se activa para autoasesoramiento legal del propio usuario sin mediación profesional, ni cuando el caso contenga datos identificables de partes reales.
license: CC BY 4.0
---

# Formulación Jurídica (Código Civil español)

Skill de apoyo a la formulación de casos jurídicos basado en el **Código Civil español** como referencia normativa primaria. **No emite dictamen, no asesora a la parte, no propone estrategia procesal.** Genera un andamio de calificaciones a contrastar por el jurista responsable.

## Para qué sirve

Recibe un caso ya estudiado por un jurista habilitado y devuelve, en este orden (modo completo):

1. Caso estructurado en formato consistente.
2. Calificaciones jurídicas a considerar (artículos del CC y, cuando proceda, leyes conexas y jurisprudencia), separando calificaciones principales de calificaciones a vigilar.
3. Calificaciones alternativas / descartes obligatorios (norma especial vs general, calificaciones concurrentes en el propio CC, vías procesales alternativas, normativa imperativa que cambie la lectura).
4. Lagunas (de información y legales) con plan de exploración priorizado.
5. Riesgos procesales a vigilar (prescripción, caducidad, competencia, jurisdicción, legitimación, carga de la prueba).
6. Cuestionamiento argumental (2-3 ángulos seleccionados).

## Modos de invocación

El skill admite cinco modos. La sintaxis es `/codigo-civil-formulacion-juridica [modo]` seguido del caso.

- **`completo`** (default). Ejecuta los seis pasos.
- **`alternativas`**. Solo pasos 1, 2 y 3. Útil cuando el jurista quiere centrarse en jerarquizar calificaciones y descartes sin entrar todavía en plan de exploración o auditoría.
- **`lagunas`**. Solo pasos 1 y 4. Útil cuando ya hay calificación y se busca un plan operativo (qué hechos acreditar, qué documentación recabar, qué jurisprudencia comprobar).
- **`riesgo`**. Solo pasos 1 y 5. Útil para revisar contadores procesales y obstáculos de admisibilidad sin desplegar el resto.
- **`auditoria`**. Solo pasos 1 y 6. Útil para someter una formulación ya hecha a cuestionamiento argumental.

El paso 1 (caso estructurado) se ejecuta siempre, en todos los modos. La nota final también es obligatoria en todos los modos.

Ejemplo: `/codigo-civil-formulacion-juridica alternativas` + caso → respuesta con pasos 1-3 + nota final.

## Para qué NO sirve

- Asesoramiento legal a un particular sin mediación de jurista habilitado.
- Reproducción literal extensa de articulado del CC ni de leyes conexas. Las citas se hacen por número de artículo y palabra clave; no se sustituye al razonamiento jurídico por una checklist normativa.
- Dictamen jurídico definitivo, redacción de demandas o contestaciones, decisiones de estrategia procesal.
- Sustitución del juicio del jurista, del estudio de la jurisprudencia actualizada ni de la consulta del articulado vigente en BOE.
- Procesamiento de datos identificables de partes reales (RGPD, secreto profesional). Trabajar siempre con casos pseudonimizados.

## Cómo usarlo

1. Lee `flujo.md` antes de procesar cualquier caso.
2. Detecta si el usuario ha indicado un modo (`completo`, `alternativas`, `lagunas`, `riesgo`, `auditoria`); si no, asume `completo`.
3. Verifica las dos puertas de entrada: pseudonimización y mediación profesional. Si fallan, detente y pide ajustes.
4. Detecta concurrencia de derecho foral, normativa fuera del CC y poblaciones especiales (menores, personas con medidas de apoyo, consumidores) antes de empezar.
5. Sigue los pasos correspondientes al modo, en orden, sin saltar ninguno.
6. Devuelve la salida con el formato y los encabezados especificados, incluida la nota final obligatoria.

## Archivos del skill

- `SKILL.md` — este descriptor.
- `flujo.md` — flujo de razonamiento de seis pasos con reglas duras transversales y un caso resuelto canónico como apéndice de referencia.
- `plantilla-caso.md` — formato esperado de entrada como referencia para el jurista.

## Limitaciones conocidas

- **Calibrado para Derecho civil común con centro de gravedad en el CC.** Cuando la materia central del caso esté fuera del CC, el skill funciona como **mapa de derivación y verificación**, no como formulación dogmática cerrada: alerta de la norma propia aplicable, deriva a su consulta directa, y mantiene el CC como supletorio o referencia general en lo no desplazado. La densidad de la salida será menor en estos casos; el jurista debe completarla con la consulta de la norma específica vigente y de su jurisprudencia. Este patrón aplica a:
  - Supuestos forales (Cataluña, Aragón, Navarra, País Vasco, Galicia, Baleares).
  - Concurso y derecho preconcursal (TRLC).
  - Materia mercantil específica (CCom, normativa de sociedades, propiedad industrial, transporte, seguros).
  - Derecho de la edificación (LOE), urbanismo, propiedad intelectual.
  - Materias con régimen sectorial fuerte (energía, telecomunicaciones, audiovisual, sanitario).
  - Cualquier área donde la norma especial desplace materialmente al CC.
- Las citas jurisprudenciales generadas por el skill van marcadas como pendientes de verificación. **Ninguna cita debe usarse en escrito procesal sin haber sido comprobada en CENDOJ, BOE u otra fuente oficial.**
- La actualización normativa va por detrás del BOE: leyes recientes pueden no estar reflejadas. Confirmar vigencia y redacción actual del articulado citado.
- No reemplaza el estudio de la jurisprudencia menor (audiencias provinciales) cuando el caso lo requiera.
- Pendiente de validación con casos reales por juristas en ejercicio antes de uso profesional.

## Versión

v0.3 — tercer draft tras segunda ronda de tests (familia con custodia disputada y mediación familiar autonómica andaluza; mercantil entre empresarios con concurso del deudor en horizonte). Cambios respecto a v0.2:
- Generalización de la limitación "mapa de derivación, no formulación cerrada" a toda materia con centro normativo fuera del CC (no solo foral): concurso, mercantil, urbanismo, propiedad intelectual, sectoriales, etc.
- Incorporación al paso 5 de las matizaciones del dispositivo en procedimientos especiales (art. 752 LEC para familia, capacidad, filiación y jurisdicción voluntaria; régimen específico TRLC en concurso).
- Incorporación al paso 6 de un ángulo expreso sobre riesgos pasivos del cliente no planteados por él (acciones rescisorias, calificación culpable, responsabilidad subsidiaria, reclasificación crediticia, conducta en periodo sospechoso).

Estado: estable para uso por jurista habilitado con conocimiento del régimen especial aplicable. Probado con cinco casos ficticios (vicios + caducidad 1301; sucesiones forales catalanas; extracontractual + vía penal; familia + mediación autonómica; mercantil + concurso). Pendiente de validación con casos reales por juristas en ejercicio.

v0.2 — segundo draft. Iterado tras tres tests ficticios. Cambios: limitación expresa sobre alcance del skill en supuestos forales, sub-bloque sobre litisconsorcio en el paso 5, regla sobre materias en evolución normativa rápida, criterio específico de cita en derecho foral.

v0.1 — primer draft. Tres ficheros base.

## Autoría y licencia

Skill diseñado y desarrollado por **Pablo** (web: <https://mindandhealth.org> · repositorio y contacto técnico: <https://github.com/novanoticia>), con asistencia de Claude (Anthropic) en la redacción del SKILL.md, el flujo.md y la plantilla de caso. El diseño conceptual, la decisión sobre estructura, los criterios deontológicos y la validación con casos ficticios son del autor.

Licencia: **Creative Commons Atribución 4.0 Internacional (CC BY 4.0)**. Texto íntegro: <https://creativecommons.org/licenses/by/4.0/deed.es>. Uso, copia, modificación y redistribución libres, incluso con fines comerciales, siempre que se cite al autor. La obligación de atribución se considera satisfecha si la copia o derivado conserva la mención al autor original tal como figura en este SKILL.md.
