# Atlas Lite - Windows Install Guide

## Quick Install (recommended)

1. Descarga o clona este repositorio en tu equipo.
2. Comprueba que el archivo **`engram.exe`** está en la raíz del repositorio.
   - Si no está, descárgalo de [GitHub Releases de Engram](https://github.com/Gentleman-Programming/engram/releases): coge el archivo `engram_<version>_windows_amd64.zip`, extrae `engram.exe` y colócalo en la raíz.
3. Abre la carpeta del repositorio.
4. Haz doble clic en **`instalar-atlas.bat`**.
5. Cuando veas `Atlas Lite instalado correctamente`, ya puedes abrir VS Code.

No necesitas abrir PowerShell ni escribir ningún comando.

## Run health check manually

Si quieres verificar que todo está bien después de instalar:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas-doctor.ps1
```

## Create a new project

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\new-atlas-project.ps1 -ProjectName mi-proyecto
```

## One-command wrapper

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas.ps1 -Command install
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas.ps1 -Command doctor
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas.ps1 -Command new-project -ProjectName clase-01
```

## Expected output after install

- `.atlas/install/install-report.json`
- `.projects/classroom-demo/` (unless skipped)
- Atlas Doctor status PASS

## Qué hace el instalador por dentro

Esta sección explica en detalle cada paso que ejecuta el instalador. Es útil si quieres entender qué está pasando, solucionar un error, o simplemente tienes curiosidad.

---

### Paso 1 — Verifica que el repositorio está completo

Antes de hacer nada, el instalador comprueba que los 6 elementos esenciales están presentes en la carpeta:

| Archivo o carpeta | Para qué sirve |
|---|---|
| `.github/copilot-instructions.md` | Las instrucciones del agente de IA (el "cerebro" de Atlas) |
| `.github/atlas-work-system.md` | El contrato global de cómo trabaja Atlas |
| `.github/atlas-skill-catalog.json` | El catálogo de habilidades disponibles |
| `.github/skills/` | La carpeta con todas las habilidades especializadas |
| `.projects/_template/` | La plantilla para crear nuevos proyectos |
| `engram.exe` | El motor de memoria persistente de Atlas |

Si alguno de estos elementos falta — porque el ZIP se descargó incompleto o se borró accidentalmente — el instalador se detiene en este punto y muestra exactamente cuál es el problema. No continúa para evitar una instalación a medias.

---

### Paso 2 — Prepara la carpeta de instalación

Crea la carpeta `.atlas/install/` dentro del repositorio. Esta carpeta es donde el instalador guardará el informe final. No contiene nada imprescindible para que Atlas funcione — solo documentación del proceso de instalación.

---

### Paso 3 — Crea un proyecto de demostración

Atlas trabaja siempre dentro de proyectos. Para que el estudiante pueda empezar a trabajar inmediatamente sin tener que crear un proyecto desde cero, el instalador genera automáticamente `.projects/classroom-demo/` copiando la plantilla estándar.

La plantilla incluye:
- `ORCHESTRATOR.md` — instrucciones locales del proyecto (el nombre `<project_name>` se reemplaza automáticamente por `classroom-demo`)
- `RULES.md` — reglas específicas del proyecto (vacías, para que el usuario las defina)
- Carpetas `context/`, `openspec/`, `reports/`, `work/` — estructura de trabajo del proyecto

Si el proyecto `classroom-demo` ya existía de una instalación anterior, este paso se salta sin error.

---

### Paso 4 — Carga las memorias de configuración en Engram

Engram es el sistema de memoria de Atlas. Funciona como una base de datos personal que el agente consulta al inicio de cada conversación para recordar las reglas y convenciones con las que debe trabajar.

El instalador importa el archivo `installer/windows/engram-seed.json` en la base de datos local del usuario, que se guarda en `C:\Users\<tu_nombre>\.engram\engram.db`.

Este archivo contiene 23 memorias preconfiguradas divididas en tres categorías:

- **Rules (11)** — Restricciones que el agente nunca debe violar: no inventar respuestas sin evidencia, no saltar pasos del flujo de trabajo, no borrar archivos sin permiso explícito, entre otras.
- **Policies (9)** — Cómo se hacen las cosas: estructura de carpetas, cómo seleccionar habilidades, cómo comunicarse con usuarios no técnicos.
- **Discoveries (3)** — Datos de infraestructura: dónde está el binario de Engram, dónde está la base de datos, cómo actualizar el seed para nuevas versiones.

Sin este paso, el agente arrancaría sin contexto y cada conversación empezaría desde cero. Con él, tiene las reglas cargadas desde el primer mensaje.

---

### Paso 5 — Ejecuta Atlas Doctor (verificación final)

Atlas Doctor es una herramienta de diagnóstico que realiza 18 comprobaciones independientes y reporta cuáles pasan y cuáles fallan:

**Archivos de configuración (7 comprobaciones)**
Verifica que existen los 7 archivos de política y configuración en `.github/`:
`copilot-instructions.md`, `atlas-work-system.md`, `atlas-skill-catalog.json`, `atlas-skill-growth-policy.md`, `engram-memory-instruction.md`, y los dos archivos de la plantilla de proyecto.

**Motor de memoria (2 comprobaciones)**
- Que `engram.exe` responde al comando `version` sin error
- Que `engram.exe` puede leer su base de datos y devolver estadísticas (`stats`)

**Skills SDD (9 comprobaciones — una por skill)**
Verifica que cada una de las 9 habilidades del flujo de trabajo tiene su archivo `SKILL.md` en la ubicación correcta:
`sdd-init`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`.

Si las 18 pasan → estado `PASS`.
Si alguna falla → estado `FAIL` con la lista exacta de qué ha fallado y en qué ruta.

---

### Paso 6 — Guarda el informe de instalación

Escribe el archivo `.atlas/install/install-report.json` con:
- Fecha y hora exacta de la instalación
- Ruta completa del repositorio en el equipo
- Versión de Engram instalada
- Nombre del proyecto de demo creado
- Resultado del Doctor (PASS/FAIL) y cuántas comprobaciones han pasado

Este archivo es especialmente útil para soporte: si un estudiante tiene un problema, puede compartir este archivo y permite diagnosticar el estado de su instalación sin necesidad de acceso remoto al equipo.

---

### Paso 7 — Resultado final

**Si todo va bien:** la ventana muestra `Atlas Lite instalado correctamente` y espera a que el usuario pulse una tecla para cerrarse.

**Si algo falla:** la ventana muestra `ERROR: La instalación ha fallado` junto con el detalle del paso que ha fallado, y **no se cierra automáticamente** para que el usuario pueda leer el error, hacer una captura de pantalla o copiar el mensaje para pedir ayuda.

## Prerrequisitos

El instalador **no instala** estos componentes — deben estar presentes antes:
- VS Code
- Extensión GitHub Copilot activa con sesión iniciada
- Cuenta de GitHub con acceso a Copilot
