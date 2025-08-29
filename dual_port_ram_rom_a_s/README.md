
# 🧠 Dual Port RAM & ROM design and verification using Verilog HDL

## 📌 Project Overview

This is a **self-learning VLSI mini project** where I designed and verified **Dual Port RAM and ROM** (both synchronous and asynchronous) using **Verilog HDL**.
The project focuses on handling **simultaneous read/write operations**, **address conflicts**, and **conflict resolution** using **FSM-based control logic**.

### ✨ Why Dual Port Memory?

Unlike single-port RAM, which allows only one operation at a time, **Dual Port RAM/ROM** supports **parallel accesses from two independent ports**, making it highly suitable for:

* 🖥️ **Multi-processor shared memory**
* 🎮 **Graphics frame buffers**
* 📡 **Communication buffers (routers/switches)**
* 🔄 **FIFO for clock domain crossing**
* 📊 **DSP lookup tables and microcode storage**

---

## 🚀 Features

* ✅ **Synchronous & Asynchronous** RAM/ROM designs
* ✅ **FSM-based arbitration** for dual-port conflict handling
* ✅ **Priority-based conflict resolution** (Port A priority)
* ✅ **Write-through behavior** for faster read-after-write
* ✅ **Parameterizable design** (easy to scale address/data widths)
* ✅ **Comprehensive testbench** covering:

  * Single port operations
  * Dual port simultaneous access
  * Address conflict resolution
  * ROM lookup functionality
  * Asynchronous memory behavior

---

## 🛠️ Tech Stack

* **Language**: [Verilog HDL](https://www.chipverify.com/verilog/verilog-introduction)
* **Simulation Tool**: [Icarus Verilog](http://iverilog.icarus.com/)
* **Waveform Viewer**: [GTKWave](http://gtkwave.sourceforge.net/)

---

## 📂 Project Structure

```
📁 RTL_Design/          # RTL code in Verilog (FSM-based controller)
📁 Test_Bench/          # Testbench code (stimulus, monitors, assertions)
📁 Simulation_Results/  # VCD waveforms, logs, coverage reports
📁 Reports_Final_docs/  # Project documentation, design report, synthesis results

```

---

## ▶️ How to Run (Simulation + Waveform)

### 1️⃣ Compile the design + testbench

```bash
iverilog -o dual_port_memory_tb.vvp sync_dual_port_ram.v sync_dual_port_rom.v async_dual_port_ram.v dual_port_memory_tb.v
```

### 2️⃣ Run simulation

```bash
vvp dual_port_memory_tb.vvp
```

### 3️⃣ View waveforms

```
gtkwave dual_port_memory.vcd
```
---
## 📊 Example Waveforms

Below are example waveforms captured during simulation:
  
* https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/dual_port_ram_rom_a_s/Simulation_Results
  
---

## 📊 Example Verification Scenarios

| Test Case                         | Expected Result  | Status |
| --------------------------------- | ---------------- | ------ |
| Port A Write + Read               | Data match ✅     | PASS   |
| Port B Write + Read               | Data match ✅     | PASS   |
| Dual Read (different addresses)   | Both correct ✅   | PASS   |
| Dual Write (different addresses)  | Both stored ✅    | PASS   |
| Conflict: Both write same address | Port A wins ✅    | PASS   |
| ROM Lookup                        | Preloaded data ✅ | PASS   |
| Async RAM Write/Read              | Immediate ✅      | PASS   |

---

## 📚 References

1. [Xilinx Vivado UG901: Simple Dual-Port RAM Verilog](https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Simple-Dual-Port-Block-RAM-with-Dual-Clocks-Verilog)
2. [Dual-Port ROM Multiplier (IJEEE)](https://ijeee.iust.ac.ir/article-1-2011-en.pdf)
3. [Configurable Multi-Port Memory (arXiv 2024)](https://arxiv.org/abs/2407.20628)
4. [Dual Port RAM UVM Verification](https://repository.rit.edu/cgi/viewcontent.cgi?article=10948&context=theses)

---

## 🙋 About This Project

This project is part of my **self-learning journey in VLSI Design & Verification**.
I built it to **strengthen my fundamentals in memory design**, FSM modeling, and testbench writing.
Feel free to **fork, star ⭐, and suggest improvements**!

---


