<h1 align="center">
  <br>
  <a href="">
    <img src="https://emulation.gametechwiki.com/images/thumb/9/99/DOSBox-X.png/180px-DOSBox-X.png" alt="DOSBox-X" style="width:40%; max-width:200px; height:auto; border-radius:12px;">
  </a>
  <br>
    DOSBox-X ASM 2D Draw App
  <br>
</h1>

--------

[Romanian (RO)](https://DarkSoulEngineer.github.io/DOS-X_ASM/index_ro.html) | [English (EN)](https://DarkSoulEngineer.github.io/DOS-X_ASM/index_en.html)

Overview
--------

Menu-driven drawing toolkit for DOS, written in 16-bit x86 assembly (8086). Runs in text mode for input and switches to VGA Mode 13h (320x200, 256 colors) for rendering. Ships with build scripts and Obsidian-formatted docs for quick onboarding.

Features
--------

- Interactive text menu with numeric navigation
- Mode 13h rendering with direct video memory access
- Drawing primitives: pixels, lines, filled squares, and outlines
- File I/O: save the current screen to `IMAGE.BIN`, load or preview an existing image, resume drawing on loaded canvases
- Buffer restore before drawing when an image is loaded
- Designed for DOS or DOSBox/DOSBox-X

Project Layout
--------------

- `app/src` - assembly sources (`MAIN.ASM`, `MENU.ASM`, `IO.ASM`, `FILE.ASM`, `PIXEL.ASM`, `SHAPES.ASM`, `INP.ASM`, `DATA.ASM`)
- `app/scripts` - build helpers (`build.bat`, `clean.bat`)
- `app/build` - generated `.EXE`, `.OBJ`, `.MAP`, `.BIN`, logs
- `app/tools` - TASM, TLINK, Turbo Debugger
- `docs` - Obsidian vault with getting-started, architecture, and module reference
- `assets` / `versions` - supporting media and backups

Build and Run
-------------

Prerequisite: DOSBox-X (or DOSBox) installed and on your PATH.

1) Open a shell in `app\scripts`.
2) Build (defaults to `MAIN.ASM`):
   ```batch
   build.bat
   ```
   Build a specific module:
   ```batch
   build.bat MENU
   ```
3) Run the executable from `app` (DOSBox-X CLI example):
   ```batch
   dosbox-x -c "mount c ." -c "c:" -c "build\\MAIN.exe"
   ```
4) To clean artifacts (from `app\scripts`):
   ```batch
   clean.bat
   ```

Usage
-----

1) Launch `MAIN.exe` in DOS or DOSBox-X.
2) Navigate menus with number keys.
3) Choose a drawing action (line, filled square, outline) and supply coordinates, size, and color values when prompted.
4) Save or load screens to or from `IMAGE.BIN`; loaded images are restored before new draws.
5) Exit via the menu when finished.

Architecture Notes
------------------

- `MAIN.ASM` initializes, clears the screen, and hands off to `ShowMenu` in `MENU.ASM`.
- `IO.ASM` handles text-mode output and Mode 13h setup.
- `PIXEL.ASM` exposes the pixel primitive; `SHAPES.ASM` builds line and square routines on top.
- `FILE.ASM` manages capture and restore, save, load, preview, and load-time buffering.
- `INP.ASM` contains numeric input helpers and prompts.

Documentation (@docs)
---------------------

- Start at `docs/README.md` for the Obsidian index.
- New to the project? Follow `docs/01-Getting-Started/Project-Overview.md` then `docs/01-Getting-Started/Build-Guide.md`.
- For design details, see `docs/02-Technical/Architecture.md`.
- For APIs and entry points, see `docs/03-Reference/Modules.md`.

---

Universitatea Transilvania din Brasov - MIC (Microcontrollers), 2025.
