# Atlas Lite v0.1.0

Atlas Lite convierte objetivos en lenguaje natural en resultados claros, coordinando especialistas sin exigir conocimientos tecnicos.

## Highlights

- Instalacion guiada para Windows.
- Diagnostico automatico con Atlas Doctor.
- Memoria persistente con Engram.
- Modelo de trabajo por proyectos con plantilla base en `.projects/_template/`.
- Flujo SDD operativo con skills basicas y catalogo ampliado.

## Incluye

- Orquestador global: `.github/copilot-instructions.md`
- Contrato global de trabajo: `.github/atlas-work-system.md`
- Politica de memoria: `.github/engram-memory-instruction.md`
- Catalogo de skills: `.github/atlas-skill-catalog.json`
- Politica de crecimiento de skills: `.github/atlas-skill-growth-policy.md`
- Instalador Windows: `installer/windows/install-atlas.ps1`
- Doctor de salud: `installer/windows/atlas-doctor.ps1`
- Creacion de proyecto: `installer/windows/new-atlas-project.ps1`

## Instalacion (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-atlas.ps1
```

## Verificacion de salud

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas-doctor.ps1
```

## Primer uso en clase

1. Instalar Atlas Lite.
2. Comprobar `Atlas Doctor: PASS`.
3. Crear un proyecto de clase:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\new-atlas-project.ps1 -ProjectName clase-01
```

4. Empezar flujo con comandos SDD (`/sdd-init`, `/sdd-explore`, etc.).

## Alcance de esta version

- Soporte oficial: Windows.
- Objetivo: primera version estable para aulas de no programadores.

## Known Limitations

- Distribucion centrada en VS Code y entorno Windows.
- Version inicial sin empaquetado nativo tipo MSI/EXE.

## Seguridad y privacidad

- `.env` no contiene rutas locales sensibles.
- `.env` esta ignorado por Git para evitar fugas de configuracion local.
