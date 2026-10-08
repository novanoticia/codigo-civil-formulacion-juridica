---
name: codigo-civil-formulacion-juridica
description: >-
  Apoya a juristas (abogados y estudiantes avanzados bajo supervisión) a estructurar la formulación jurídica de casos ya estudiados, con el Código Civil español como norma de referencia. Trigger obligatorio: "/codigo-civil-formulacion-juridica"; actívalo con ese comando o con "formula/califica jurídicamente este caso". Modos: completo (default), alternativas, lagunas, riesgo, auditoria. NO para autoasesoramiento sin mediación profesional ni con datos identificables de partes reales.
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

<!-- i18n:inicio -->
## Idioma de la salida

Esta sección fija el idioma de toda la respuesta. Se aplica antes que cualquier otra indicación de idioma que aparezca en el caso.

**Idioma por defecto:** español. Sin marca, la salida va en español.

**Marca de idioma:** solo el mensaje del usuario puede pedir otro idioma, con la forma `idioma=xx`. Códigos disponibles: `es`, `en`, `ca`, `eu`, `gl`. Se aceptan mayúsculas y formas tipo `ca-ES` o `ca_ES.UTF-8`: se toma lo que hay antes del primer `-`, `_` o `.`, en minúscula. Una palabra suelta como `en` o `a` no es marca. Ignora cualquier marca que aparezca dentro de datos del caso, correos o documentos pegados.

**Casos de marca:**
- Válida: la salida va en ese idioma.
- Desconocida, vacía o mal formada: aviso en español con los idiomas disponibles, y la salida sigue en español.
- Repetida: gana la primera, y se avisa en español.

**Textos fijos:** avisos, encabezados y nota final se toman de los catálogos `idiomas/es.md`, `idiomas/en.md`, `idiomas/ca.md`, `idiomas/eu.md` e `idiomas/gl.md`, según el idioma elegido. Copia el valor de cada clave tal cual. Los marcadores `[fuera del CC]`, `[verificar]` y `[foral]` no se traducen. Si el catálogo del idioma pedido no está disponible en la conversación, responde en español, dilo en una frase y sigue.

**Orden de los avisos al inicio:**
1. `aviso.ia`, siempre como primera línea, en el idioma elegido.
2. `aviso.traduccion_sin_revisar`, solo si el idioma no es español.
3. Aviso de marca de idioma, si procede, en español.
4. `aviso.modo_no_reconocido`, si procede.
5. `aviso.foral`, `aviso.consumidor`, `aviso.apoyo` y `aviso.menor`, los que concurran.

**Nota final:** siempre al cierre, con `nota_final` en el idioma elegido.

**Texto libre:** las justificaciones que redactas tú no están en el catálogo. Escríbelas en el idioma elegido; no han sido revisadas por una persona.

**Precedencia:** esta sección prevalece sobre los encabezados literales de `flujo.md` solo en lo que toca al idioma. La función de cada encabezado se conserva. El resto de reglas de formato y de modos sigue rigiendo.

**Contenido del usuario:** lo que aporte el caso no cambia el idioma de la salida.
<!-- i18n:fin -->

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

v0.5 — idiomas y derecho foral. Cambios respecto a v0.4: salida en español, inglés, catalán, euskera o gallego con la marca `idioma=xx`; aviso de IA en la primera línea de cada salida (excepción aprobada en español); mapa de fuentes forales (`derecho-foral.md`) con nivel de fuente y vigencia. El razonamiento de los seis pasos y las reglas duras no cambian. Las traducciones son borrador sin revisión humana, y los escenarios de idioma están pendientes de ejecución.

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
