
# 📝 Synchronous & Asynchronous FIFO Design & Verification using Verilog_HDL

## 📌 Project Overview

This project explores the design and verification of **Synchronous** and **Asynchronous FIFO (First-In First-Out) Buffers** using **Verilog HDL**. The goal was to strengthen my learning in digital design and verification while understanding **clock domain crossing (CDC)**, **pointer management**, and **flag generation** for robust data transfer.

FIFO buffers are widely used in:

* Processor–memory interfaces
* Communication protocols (e.g., UART)
* Multi-core processor pipelines
* Audio/video streaming systems

This project is part of my **self-learning practice** to gain strong RTL design and verification skills.

---

## ⚙️ Technical Features

* **Synchronous FIFO**

  * Single clock domain
  * Dual-port memory array (16 × 8)
  * Full/empty flag detection
  * Simple FSM states: EMPTY, PARTIAL, FULL

* **Asynchronous FIFO**

  * Separate read and write clock domains
  * Gray code counters for safe pointer crossing
  * Double-flip-flop synchronizers to prevent metastability
  * Correct full/empty detection across domains

* **Verification**

  * Testbenches written in Verilog
  * Corner cases tested: reset, full, empty, read/write overlap
  * Random delay injection for async FIFO
  * Waveform dumping (`.vcd`) for GTKWave analysis

---

## 🏗️ Repository Structure

```
📁 RTL_Design/          # RTL code in Verilog (FSM-based controller)
📁 Test_Bench/          # Testbench code (stimulus, monitors, assertions)
📁 Simulation_Results/  # VCD waveforms, logs, coverage reports
📁 Reports_Final_docs/  # Project documentation, design report, synthesis results

```

---

## 🚀 How to Run (with Icarus Verilog + GTKWave)

### 1. Compile and run **Synchronous FIFO**

```bash
# Compile
iverilog -o sync_fifo_tb.out src/sync_fifo.v tb/sync_fifo_tb.v
# Run simulation
vvp sync_fifo_tb.out
# View waveform
gtkwave sync_fifo_tb.vcd
```

### 2. Compile and run **Asynchronous FIFO**

```bash
# Compile
iverilog -o async_fifo_tb.out src/async_fifo.v tb/async_fifo_tb.v
# Run simulation
vvp async_fifo_tb.out
# View waveform
gtkwave async_fifo_tb.vcd
```

---

## 📊 Example Simulation Results

### ✅ Synchronous FIFO

* FIFO depth: 16
* Data correctly written and read in FIFO order
* Full/empty flags toggled as expected

*https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/synchronous_asynchronous_fifo/Simulation_Results*

### ✅ Asynchronous FIFO

* Independent read/write clocks (125 MHz / 83 MHz)
* Data integrity preserved across domains
* Random delays handled safely using synchronizers

*https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/synchronous_asynchronous_fifo/Simulation_Results*

---

## 📚 References

* [Review on Synchronous & Asynchronous FIFOs in Digital Systems](https://www.scirp.org/journal/paperinformation?paperid=132240)
* [Asynchronous FIFO Design Based on Verilog](https://www.researchgate.net/publication/369465587_Asynchronous_FIFO_Design_Based_on_Verilog)
* [Advances in Asynchronous FIFO Design](https://www.researchgate.net/publication/387913887_A_Study_of_Advances_in_Asynchronous_FIFO_Design)
* [Design & Verification of Synchronous FIFO (arXiv)](https://arxiv.org/abs/2504.10901)

---

## 📈 Learning Outcomes

* Understood **synchronous vs asynchronous FIFO trade-offs**.
* Learned **Gray code pointer synchronization** for safe CDC.
* Gained hands-on practice with **testbench writing** and **waveform debugging**.
* Strengthened skills in **RTL design, functional verification, and simulation using open-source tools**.

---

## 🔮 Future Scope

* Make FIFO **parameterized** (configurable width and depth).
* Extend verification using **SystemVerilog, UVM, functional coverage, and assertions**.
* Explore **formal verification** for corner cases.
* Integrate FIFO into a **SoC or processor pipeline**.
* Investigate **low-power FIFO designs**.

---

✨ This project is part of my **self-learning journey in VLSI design and verification**.

---

