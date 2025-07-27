# Nios System Project

This repository contains a hardware system project built with **Intel Quartus** and **Platform Designer (formerly Qsys)**, featuring a Nios V soft-core processor system.

## 🧰 Project Structure

| File / Folder        | Description |
|----------------------|-------------|
| `Nios.qpf`, `Nios.qsf`, `Nios.qws` | Quartus project, settings, and workspace files |
| `Nios_V.qsys`        | Platform Designer (Qsys) system configuration file |
| `Nios_V.sopcinfo`    | SOPC system info, auto-generated |
| `Nios_V/`            | HDL source files and components |
| `output_files/`      | Generated output files (e.g., `.sof`, `.elf`) |
| `db/`, `incremental_db/` | Compilation databases (can be ignored in version control) |
| `simulation/`        | Questa/ModelSim simulation files |
| `LICENSE`            | Project license (GPL-3.0) |
| `.gitattributes`     | Git settings for line-ending normalization |

## 🚀 Features

- Nios V CPU subsystem (customizable)
- Clock and reset integration
- Memory-mapped peripherals via Platform Designer
- Questa simulation support

## 🛠️ Tools Required

- Intel Quartus Prime (recommended: Lite or Standard Edition)
- Platform Designer (included in Quartus)
- ModelSim / Questa (for simulation)

## 📦 Build Instructions

1. Open `Nios.qpf` in Quartus
2. Launch **Platform Designer** and generate HDL from `Nios_V.qsys`
3. Compile the full project in Quartus
4. Optionally, run simulation via Questa using `simulation/questa`

## ⚠️ Notes

- Some folders like `db/`, `incremental_db/`, and `output_files/` are auto-generated and can be added to `.gitignore` if not needed in version control
- Ensure `*.sopcinfo` and `*.qsys` remain under version control for reproducibility
- This very simple project for DE-10 standard SoC
  
## 📜 License

This project is licensed under the **GNU GPL v3.0**. See [`LICENSE`](./LICENSE) for details.
