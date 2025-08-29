
# 📘 Single Port RAM/ROM – Synchronous & Asynchronous (Design & verification using Verilog HDL)

## 🔹 Project Overview

This project implements a **Single Port Memory System** in Verilog HDL with support for both **RAM and ROM**, and with **Synchronous** (clock-based) as well as **Asynchronous** (immediate response) operation modes.

The project is designed as part of my **self-learning journey in VLSI Design & Verification**, focusing on memory subsystem design, FSM-based control, and testbench-driven verification.

---

## 🎯 Motivation

Memory is the backbone of any digital system. The aim of this project is to **gain a deep understanding of memory operations at RTL level** by implementing:

* How **data is stored and retrieved** in digital systems
* The **difference between synchronous and asynchronous memory access**
* FSM-based **memory control logic**
* Practical verification methodology using **Icarus Verilog + GTKWave**

---

## ⚡ Features

✔ 16 × 8-bit memory depth (RAM and ROM)
✔ Single port for **read/write operations**
✔ Supports both **synchronous and asynchronous RAM**
✔ Includes a **preloaded ROM** with demo data pattern
✔ FSM-based control with **IDLE, ACTIVE, READ, WRITE states**
✔ **Reset** and **Enable** functionality for robust design
✔ Fully verified with **comprehensive testbench** (100% pass rate)

---

## 🛠️ Applications

* **Single Port RAM**

  * Cache memory in processors
  * Buffers in communication systems
  * Temporary storage in DSP/embedded systems
* **Single Port ROM**

  * Boot code storage in microcontrollers
  * Lookup tables (e.g., sin/cos functions)
  * Firmware/config data storage

---

## 📂 Project Structure

```
📁 RTL_Design/          # RTL code in Verilog (FSM-based controller)
📁 Test_Bench/          # Testbench code (stimulus, monitors, assertions)
📁 Simulation_Results/  # VCD waveforms, logs, coverage reports
📁 Reports_Final_docs/  # Project documentation, design report, synthesis results

```

---

## 🧩 FSM Overview

The memory controller uses a **4-state FSM**:

* **IDLE** → Waiting for enable signal
* **ACTIVE** → Memory enabled, checking operation
* **WRITE** → Writing data to memory
* **READ** → Reading data from memory

---

## ▶️ Simulation & Run Commands

This project uses **Icarus Verilog** for simulation and **GTKWave** for waveform analysis.

### 1️⃣ Compile the design + testbench

```bash
iverilog -o memory_sim.out sync_single_port_ram.v async_single_port_ram.v single_port_rom.v tb_memory_system.v
```

### 2️⃣ Run the simulation

```bash
vvp memory_sim.out
```

### 3️⃣ Open waveform in GTKWave

```bash
gtkwave memory_simulation.vcd
```

---

## 📊 Example Waveforms

Below are example waveforms captured during simulation:
* https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/single_port_ram_rom_a_s/Simulation_Results *
---

## ✅ Verification Summary

The testbench verifies:

* ROM read operations (0x00 → 0xFF sequence)
* Sync RAM write/read with random data
* Async RAM write/read with incremental pattern
* Reset functionality
* Enable/disable functionality

| Test Case | Module | Operation   | Status |
| --------- | ------ | ----------- | ------ |
| ROM Read  | ROM    | Addr 0 → F  | ✅ PASS |
| Sync RAM  | RAM    | Write/Read  | ✅ PASS |
| Async RAM | RAM    | Write/Read  | ✅ PASS |
| Reset     | All    | Reset Ops   | ✅ PASS |
| Enable    | All    | Disable Ops | ✅ PASS |

---

## 📖 References

* [IEEE Std 1800-2023: SystemVerilog LRM](https://ieeexplore.ieee.org/document/10115428)
* [Icarus Verilog](http://iverilog.icarus.com/)
* [GTKWave](http://gtkwave.sourceforge.net/)

---

## 🚀 Future Enhancements

* Extend memory depth and width for FPGA prototyping
* Implement **Dual-Port RAM**
* Apply **SystemVerilog Assertions (SVA)** for formal verification
* Expand verification using **UVM testbench** with functional coverage

---

✨ *This project was implemented as part of my self-learning journey in Digital Design & Verification using Verilog HDL.*

---


