# Changelog

Historial de versiones del skill `codigo-civil-formulacion-juridica`. Las versiones siguen el patrón `vMAJOR.MINOR`. Mientras el skill no haya sido validado con casos reales por jurista en ejercicio, la versión mayor permanece en `0`.

---

## v0.4 — Estado actual

Cambio de empaquetado, **sin tocar el contenido jurídico**: ni el `SKILL.md`, ni el flujo de seis pasos, ni la plantilla de caso, ni los criterios deontológicos. Solo cambia dónde viven los archivos y cómo se instala.

- El repositorio es ahora un **plugin conforme a [Agent Plugins 1.0.0](https://agent-plugins.org/specification)**, el formato portátil de la Agentic AI Foundation. Se añaden `plugin.json` (portable, con el `$schema` canónico) y `.claude-plugin/plugin.json` (Claude Code). Habilita una vía de instalación nueva —como plugin en Claude Code y Cowork, Opción 5 del README— sin retirar ninguna anterior.
- El skill pasa de la raíz a `skills/codigo-civil-formulacion-juridica/`, junto con `flujo.md` y `plantilla-caso.md`: es la ubicación fija que el §6.1 de la spec exige para descubrir skills. Los acompañantes quedan planos al lado del `SKILL.md`, no bajo `references/`, porque el cuerpo los referencia por nombre pelado.
- `scripts/build-dist.sh` regenera `dist/`, que hasta ahora se armaba a mano.
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
