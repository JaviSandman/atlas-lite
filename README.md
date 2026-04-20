# Atlas Lite

Atlas Lite converts natural-language goals into clear outcomes by coordinating specialized skills without requiring technical expertise.

## What Atlas Lite Provides

1. Persistent memory using Engram.
2. Project-based work model using `.projects/<project_name>/`.
3. Full agent workflow (SDD command set).
4. Non-programmer-first communication and outputs.
5. Basic data flow support (Data Engineering, Data Science, BI skill tiers).

## Windows Installation

1. Descarga o clona este repositorio.
2. Abre la carpeta.
3. Haz doble clic en **`instalar-atlas.bat`**.

Si ves `Atlas Lite instalado correctamente`, ya está listo.

Detailed guide: `docs/INSTALL_WINDOWS.md`

## Core Files

- Global orchestrator: `.github/copilot-instructions.md`
- Global rules: `.github/atlas-work-system.md`
- Memory policy: `.github/engram-memory-instruction.md`
- Skill tiers: `.github/atlas-skill-catalog.json`
- Skill growth policy: `.github/atlas-skill-growth-policy.md`
- Project template: `.projects/_template/`

## Classroom First Run

1. Doble clic en `instalar-atlas.bat` y espera el mensaje de éxito.
2. Abre VS Code en esta carpeta.
3. Crea un proyecto con el comando de PowerShell:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\installer\windows\new-atlas-project.ps1 -ProjectName clase-01
   ```
4. Abre GitHub Copilot Chat y empieza con `/sdd-init`.

## License

MIT — see `LICENSE`.
