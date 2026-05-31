# codigo-civil-formulacion-juridica

Skill para asistentes conversacionales (Claude, Anthropic) de **apoyo a la formulación jurídica de casos civiles** ya estudiados por jurista habilitado, usando el **Código Civil español** como referencia normativa primaria. Estructura el caso, jerarquiza calificaciones, identifica descartes obligatorios, detecta lagunas de información y de Derecho, anticipa riesgos procesales y somete la propia formulación a cuestionamiento argumental. **No emite dictamen ni asesora a la parte.**

> **Autor:** Pablo · [mindandhealth.org](https://mindandhealth.org) · [github.com/novanoticia](https://github.com/novanoticia)
> **Licencia:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.es)
> **Versión actual:** v0.3

---

## Antes de empezar: lee el manual

Antes de probar el skill, conviene leer el manual profesional. Explica encuadre, presupuestos deontológicos, anatomía de la salida, modos de invocación, convenciones de marcado, reglas duras transversales, limitaciones conocidas, recomendaciones de uso prudente y autoría:

📄 **[Manual de uso para profesionales del derecho (PDF, v0.3)](./docs/codigo-civil-formulacion-juridica-manual-v0.3.pdf)**

Es un documento pensado para leer una vez antes del primer uso. Sin esa lectura, hay riesgo de tratar la herramienta como caja negra, lo que en este caso significa creer que produce dictamen jurídico cuando solo produce un andamio de calificaciones a contrastar por el jurista responsable.

---

## Estado del proyecto

Versión **v0.3**. Probado con cinco casos sintéticos: contractual con vicios del consentimiento y caducidad del art. 1301 CC; sucesiones con vecindad civil catalana (foral); responsabilidad extracontractual con concurrencia de culpas y vía penal alternativa; familia con custodia disputada y mediación familiar autonómica andaluza; mercantil entre empresarios sin consumo con concurso del deudor en horizonte.

> **No validado con casos reales por juristas en ejercicio.** Pendiente de prueba en despacho real antes de cualquier uso institucional.

---

## Audiencia esperada

Profesionales habilitados en derecho (abogados en ejercicio, asesores jurídicos, juristas de empresa) y estudiantes avanzados bajo supervisión académica o profesional, que quieran un andamio metodológico para preparar casos civiles destinados a uso interno: redacción de dictámenes, preparación de demandas o contestaciones, supervisión de asuntos en despacho, formación.

**No es para autoasesoramiento legal del propio usuario en asuntos personales sin mediación profesional, no es para uso por personas no cualificadas profesionalmente, no sustituye revisión humana experta, no es asesoramiento jurídico ni dictamen.**

---

## Sobre el autor

Desarrollado por **Pablo** ([mindandhealth.org](https://mindandhealth.org), GitHub: [novanoticia](https://github.com/novanoticia)) — **no jurista en ejercicio**. Es un proyecto personal con interés autodidacta en razonamiento jurídico, dogmática civil y crítica de la mediación algorítmica de la información profesional sensible.

El skill se ha construido con **asistencia de Claude (Anthropic)** en la redacción de los archivos de texto. Las decisiones de diseño, la estructura, los criterios deontológicos y la responsabilidad del contenido corresponden al autor humano. Requiere validación profesional antes de cualquier uso real.

---

## Qué hace

Recibe un caso civil real ya estudiado por un jurista habilitado y devuelve, en este orden (modo `completo`):

1. **Avisos iniciales**, si concurren: vecindad civil foral, materia consumidor, persona con medidas de apoyo (Ley 8/2021), menor de edad como parte.
2. **Caso estructurado** en formato consistente de diez apartados.
3. **Calificaciones jurídicas a considerar**: principales (las que se sostienen con los hechos disponibles) y, en su caso, a vigilar (las que requerirían más hechos acreditados).
4. **Calificaciones alternativas y descartes obligatorios**: norma especial vs CC, calificaciones concurrentes en el propio CC, otras vías de tutela, normativa imperativa que reescribe la lectura.
5. **Lagunas y plan de exploración**: lagunas de información y legales (art. 1.3 CC), traducidas en bloques operativos (documentación a recabar, pruebas a articular, investigación jurídica pendiente, fuentes externas).
6. **Riesgos procesales**: plazos (prescripción, caducidad), presupuestos procesales, legitimación con análisis de litisconsorcio cuando proceda, carga de la prueba con matizaciones del art. 752 LEC en procedimientos especiales, vías previas y resolución alternativa.
7. **Cuestionamiento argumental**: dos o tres ángulos seleccionados (steelmanning de la posición contraria, riesgos pasivos del cliente, supuestos del relato no contrastados, sesgo de disponibilidad jurisprudencial, lectura constitucional, lectura desde el Derecho de la UE, etc.).
8. **Nota final** que recuerda el carácter del documento como andamio, no dictamen.

**Modos disponibles:**

- `completo` (default) — los seis pasos completos.
- `alternativas` — pasos 1, 2 y 3. Para jerarquizar calificaciones y descartes sin desplegar plan de exploración ni auditoría.
- `lagunas` — pasos 1 y 4. Para casos con calificación ya hecha donde se busca plan operativo (acreditación, documentación, jurisprudencia a comprobar).
- `riesgo` — pasos 1 y 5. Para revisión sobria de contadores procesales y obstáculos de admisibilidad.
- `auditoria` — pasos 1 y 6. Para someter una formulación ya hecha a cuestionamiento argumental.

Detalle completo en [`SKILL.md`](./SKILL.md), lógica del razonamiento en [`flujo.md`](./flujo.md), formato de entrada en [`plantilla-caso.md`](./plantilla-caso.md), y discusión exhaustiva en el manual PDF.

---

## Qué NO hace

- No emite **dictamen jurídico**. Lo que entrega es un andamio de calificaciones a contrastar por el jurista responsable.
- No **asesora al cliente**. Toda la salida está redactada para el jurista, no para la parte.
- No propone **estrategia procesal específica**, redacción de demandas o contestaciones, hojas de ruta de actuación.
- No **cuantifica pretensiones**. Cuando orienta sobre criterios de cuantificación (por ejemplo, baremos analógicos), lo hace exclusivamente como puntero metodológico.
- No **transcribe articulado** del CC ni de leyes conexas. Cita por número y palabra clave para no sustituir el razonamiento jurídico por una checklist normativa.
- No **garantiza la exactitud de las citas jurisprudenciales**. Las marca con `[verificar]` para que el jurista las compruebe en CENDOJ o fuente oficial antes de cualquier uso procesal.
- No **sustituye el estudio del articulado vigente** en BOE ni la consulta de jurisprudencia actualizada.
- No es **producto sanitario, asesoramiento legal ni dictamen pericial**.

---

## Instalación

Hay cuatro formas de usar el skill, según dónde quieras invocarlo. Las dos primeras son las más sencillas.

### Opción 1 — Claude.ai (web, app de escritorio o móvil)

Es la vía recomendada y más rápida.

1. Descarga el paquete de instalación: **[`dist/codigo-civil-formulacion-juridica.zip`](./dist/codigo-civil-formulacion-juridica.zip)**.
2. En Claude.ai, ve a **Ajustes → Capacidades → Skills**.
3. Asegúrate de que **Code execution and file creation** está activado.
4. Pulsa **Subir skill** (o *Upload skill*).
5. Selecciona el archivo `.zip` descargado.
6. El skill aparece en tu lista de Skills, activado por defecto.

A partir de ese momento, el skill se invoca con `/codigo-civil-formulacion-juridica` seguido opcionalmente del modo (`alternativas`, `lagunas`, `riesgo`, `auditoria`) en cualquier conversación. Si no se especifica modo, se ejecuta el modo `completo` por defecto.

> El archivo equivalente con extensión `.skill` (**[`dist/codigo-civil-formulacion-juridica.skill`](./dist/codigo-civil-formulacion-juridica.skill)**) es el mismo paquete con extensión alternativa, presente para compatibilidad con marketplaces de terceros (Agensi, etc.). Para Claude.ai oficial hay que renombrarlo a `.zip` antes de subirlo, o simplemente usar directamente el `.zip`.

### Opción 2 — Perplexity (Skills)

Perplexity admite el mismo paquete de skill que Claude.ai, subiendo el `.zip` directamente.

1. Descarga **[`dist/codigo-civil-formulacion-juridica.zip`](./dist/codigo-civil-formulacion-juridica.zip)**.
2. En Perplexity, entra en la gestión de **Skills** y elige **subir / importar skill**.
3. Selecciona el archivo `.zip` descargado.
4. Se invoca igual que en Claude: `/codigo-civil-formulacion-juridica` seguido opcionalmente del modo (`alternativas`, `lagunas`, `riesgo`, `auditoria`).

> **Nota técnica:** Perplexity valida la longitud del campo `description` del skill **en bytes UTF-8** (límite 1024), no en caracteres; en español, las vocales acentuadas y la `ñ` cuentan como 2 bytes. La descripción de este skill se mantiene dentro del umbral (766 bytes), por lo que la importación es directa. Si editas la descripción, no superes ~1000 bytes UTF-8.

### Opción 3 — Claude Code (línea de comandos)

Para usar el skill desde Claude Code en tu Mac:

```bash
# Skills personales (disponibles en cualquier proyecto)
mkdir -p ~/.claude/skills
cd ~/.claude/skills
unzip /ruta/a/codigo-civil-formulacion-juridica.zip

# O bien, skills del proyecto actual
mkdir -p .claude/skills
cd .claude/skills
unzip /ruta/a/codigo-civil-formulacion-juridica.zip
```

Tras descomprimir tendrás `~/.claude/skills/codigo-civil-formulacion-juridica/` con los archivos del runtime. Claude Code lo detecta automáticamente; se invoca igual que en la app: `/codigo-civil-formulacion-juridica [modo]`.

### Opción 4 — Otras inteligencias artificiales

El skill es texto Markdown. Cualquier asistente conversacional capaz de seguir instrucciones extensas puede aplicarlo, pegándolo como prompt inicial.

1. Abre una conversación efímera o temporal en la IA correspondiente:
   - **ChatGPT**: *Temporary Chat*.
   - **Mistral LeChat**: conversación efímera.
   - **Google Gemini**: chat temporal cuando esté disponible.
   - **LLM local** (Ollama, LM Studio): cualquier sesión nueva.
2. Pega como primer mensaje el contenido concatenado de:
   - `SKILL.md`
   - `flujo.md`
   - `plantilla-caso.md`
3. Añade al final del bloque: *«Sigue este protocolo. Espera mi caso.»*
4. La IA debería confirmar que el protocolo está cargado. A partir de ahí, invoca con `/codigo-civil-formulacion-juridica [modo]` o describe el modo en lenguaje natural si la IA no soporta comandos de barra.

> Avisos por plataforma:
> - **Meta AI en WhatsApp**: no recomendado para casos sensibles por la integración con la cuenta del usuario y la falta de un modo temporal verificable.
> - **Modelos pequeños** (≤ 7B parámetros): tienden a saltarse pasos del flujo o a generar citas jurisprudenciales inventadas con mayor frecuencia. Prefiere modelos de razonamiento de tamaño medio o grande.
> - **El modo `auditoria`** puede aplicarse a formulaciones producidas por cualquier IA para revisar su solidez con un segundo modelo distinto del primero.

### Modo recomendado de uso (cualquier opción)

Independientemente de cómo lo instales:

1. **Pseudonimiza el caso en origen** antes de pegarlo. Sustituye nombres, DNI/NIE, denominaciones sociales identificables, número de procedimiento, juzgado y partido judicial concretos, número de finca registral, datos bancarios, fechas exactas (usar marcas relativas: «hace 14 meses»). Para esta tarea puede usarse el skill complementario [`seudonimizador-clinico-juridico`](https://github.com/novanoticia/seudonimizador-clinico-juridico) en modo `B`.
2. **Activa Conversación Temporal** o equivalente antes de pegar nada sensible.
3. **Invoca** con `/codigo-civil-formulacion-juridica [modo]`.
4. **Verifica las citas marcadas `[verificar]`** en CENDOJ, BOE u otra fuente oficial antes de cualquier uso procesal o publicado.
5. **Consulta el articulado vigente en BOE** para los artículos del CC y leyes conexas citados; el skill no garantiza estar sincronizado con la última reforma.
6. **Cierra la conversación** una vez tengas el resultado en disco local, dentro del expediente del cliente.

> La pseudonimización por el jurista no resuelve por sí sola el cumplimiento del RGPD ni del secreto profesional (art. 542.3 LOPJ). El sometimiento de información profesional sensible a un sistema de IA externo puede comprometer el deber de sigilo. La compatibilidad del uso del skill con las normas profesionales aplicables debe valorarse caso por caso por el propio jurista usuario.

---

## Estructura del repositorio

```
codigo-civil-formulacion-juridica/
├── SKILL.md                 # Descriptor del skill: trigger, modos, función
├── flujo.md                 # Razonamiento de los seis pasos + apéndice canónico
├── plantilla-caso.md        # Formato de entrada para el jurista
├── LICENSE                  # CC BY 4.0
├── README.md                # Este archivo
├── CHANGELOG.md             # Historial de versiones
├── .gitignore
├── dist/
│   ├── codigo-civil-formulacion-juridica.zip    # Paquete de instalación para Claude.ai
│   └── codigo-civil-formulacion-juridica.skill  # Mismo paquete, extensión alternativa
├── docs/
│   └── codigo-civil-formulacion-juridica-manual-v0.3.pdf
└── tests/
    ├── test-A-vicios-caducidad.md
    ├── test-B-sucesiones-foral.md
    ├── test-C-extracontractual-penal.md
    ├── test-D-familia-mediacion.md
    └── test-E-mercantil-concurso.md
```

El paquete de `dist/` es ligero: contiene solo los archivos que el skill necesita en tiempo de ejecución (`SKILL.md`, `flujo.md`, `plantilla-caso.md`) más `LICENSE`. El directorio `tests/` agrupa los cinco enunciados sintéticos usados durante el desarrollo y queda fuera del paquete instalable; sirve como material de referencia para colaboradores y para futuras iteraciones.

---

## Encadenamiento con otros skills

Está pensado para encadenarse con los skills de pseudonimización y formulación clínica del mismo autor:

- Caso jurídico crudo → [`seudonimizador-clinico-juridico`](https://github.com/novanoticia/seudonimizador-clinico-juridico) modo `B` → `/codigo-civil-formulacion-juridica`.

El primer skill produce un texto seudonimizado con cronología consistente, apto para uso secundario (estudio, supervisión, formación). El segundo formula jurídicamente sobre ese texto. La separación de responsabilidades es deliberada: pseudonimización y formulación son operaciones distintas que conviene mantener desacopladas.

---

## Disclaimer

Este skill es una **herramienta metodológica experimental sin validación formal**. Lo que produce es un **andamio de calificaciones**; no es dictamen jurídico, no es consulta legal, no es estrategia procesal. El uso real con casos reales es responsabilidad exclusiva del jurista habilitado que lo emplee y debe ajustarse al marco normativo aplicable (RGPD, LOPDGDD, Estatuto General de la Abogacía, secreto profesional del art. 542.3 LOPJ).

Las citas jurisprudenciales que produce el skill marcadas con `[verificar]` son orientativas y pueden contener errores en número, fecha o atribución; ninguna debe usarse en escrito procesal sin haber sido comprobada en CENDOJ, BOE u otra fuente oficial. La actualización del modelo subyacente va por detrás del BOE; leyes recientes pueden no estar reflejadas.

Ni el autor ni la herramienta ofrecen garantía alguna sobre la exactitud, idoneidad o consecuencias derivadas de su uso. Cualquier uso por personas no cualificadas profesionalmente queda fuera del alcance previsto del proyecto y bajo entera responsabilidad de quien lo realice.

---

## Referencias y atribuciones

Este skill referencia, sin reproducir literalmente, las siguientes obras y marcos:

- **Código Civil español** — Real Decreto de 24 de julio de 1889, con sus reformas posteriores. Referencia normativa primaria del skill.
- **LEC** — Ley 1/2000, de Enjuiciamiento Civil. Referencia procesal central.
- **LOPJ** — Ley Orgánica 6/1985 del Poder Judicial. Citada respecto al secreto profesional (art. 542.3) y a aspectos competenciales.
- **RGPD** — Reglamento (UE) 2016/679. Citado para el régimen de pseudonimización (art. 4.5) y categorías especiales de datos (art. 9).
- **LOPDGDD** — Ley Orgánica 3/2018, de Protección de Datos Personales y garantía de los derechos digitales (España).
- **TRLC** — Texto Refundido de la Ley Concursal (RDLeg 1/2020), con sus reformas.
- **Ley 8/2021** — Reforma del régimen de capacidad y medidas de apoyo a personas con discapacidad.
- **RDL 1/2007** — Texto Refundido de la Ley General para la Defensa de los Consumidores y Usuarios.
- **Compilaciones y leyes civiles forales**: Código Civil de Catalunya (Llei 10/2008 y reformas), Código del Derecho Foral de Aragón, Compilación Navarra (Fuero Nuevo), Ley de Derecho Civil Foral del País Vasco, Ley de Derecho Civil de Galicia, Compilación de Derecho Civil de las Islas Baleares.

Toda referencia es nominativa y conceptual. El usuario es responsable de cumplir las condiciones de licencia o derechos de autor de cualquier material consultado a partir de estas referencias.

---

## Asistencia de IA

Este skill ha sido elaborado con asistencia de **Claude (Anthropic)** en la redacción del `SKILL.md`, el `flujo.md` y la plantilla de caso. El diseño conceptual, la decisión sobre estructura, los criterios deontológicos, la selección de los pasos del flujo, las reglas duras transversales y la validación con casos ficticios son del autor humano. La asistencia de IA se ha empleado como herramienta de redacción y de iteración, no como autoría conceptual. Requiere revisión profesional adicional antes de cualquier uso real.

---

## Licencia

[Creative Commons Atribución 4.0 Internacional (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.es). Texto resumido en [`LICENSE`](./LICENSE).

Eres libre de:

- **Compartir** — copiar y redistribuir el material en cualquier medio o formato.
- **Adaptar** — remezclar, transformar y construir a partir del material para cualquier propósito, incluso comercialmente.

Bajo el siguiente término:

- **Atribución** — Debes dar crédito de manera adecuada, proporcionar un enlace a la licencia, e indicar si se han realizado cambios. Puedes hacerlo en cualquier forma razonable, pero no de forma tal que sugiera que tienes el apoyo del licenciante o lo recibes por el uso que haces.

La licencia cubre el contenido textual del skill (`SKILL.md`, `flujo.md`, `plantilla-caso.md`, manual). No cubre las salidas generadas por el skill al ser ejecutado sobre casos concretos: dichas salidas son material de trabajo del jurista usuario, sometidas al régimen que cada profesional acuerde con su cliente y a las normas deontológicas aplicables.

---

## Cómo citarlo

Si lo referencias en un trabajo o adaptación:

> Pablo (2026). *codigo-civil-formulacion-juridica* (v0.3). Skill de apoyo a la formulación jurídica civil para juristas habilitados. mindandhealth.org · github.com/novanoticia/codigo-civil-formulacion-juridica

---

## Feedback y contribuciones

Cualquier feedback profesional es valioso, especialmente sobre: errores doctrinales en la salida del skill, omisión de calificaciones obligatorias en supuestos típicos, fallos en la detección de los avisos iniciales (foral, consumidor, discapacidad, menor), citas jurisprudenciales inventadas o desplazadas en el tiempo, casos donde el régimen normativo aplicable está fuera del CC y el skill no deriva correctamente, sugerencias de modos adicionales o de ángulos de cuestionamiento argumental no recogidos.

El autor puede ser contactado a través de [mindandhealth.org](https://mindandhealth.org). Issues y pull requests en GitHub también son bienvenidos. Las contribuciones de **juristas habilitados** que quieran probar el skill con casos reales (sometidos a la pseudonimización adecuada) son especialmente valoradas, porque a partir de la versión actual el principal vector de mejora ya no son las rondas con casos ficticios sino el contacto con casos reales en despacho.

Más detalles sobre el skill, sus limitaciones y su uso prudente en el manual PDF.
