
# 🥤 Vending Machine Controller – FSM in Verilog

![Verilog](https://img.shields.io/badge/code-Verilog-blue)
![SystemVerilog](https://img.shields.io/badge/verification-SystemVerilog-green)
![UVM](https://img.shields.io/badge/framework-UVM-yellow)
![Coverage](https://img.shields.io/badge/coverage-Functional%20%7C%20Code-orange)

---

## 📖 Project Overview

This project implements a **digital Vending Machine Controller** using **Verilog HDL**, modeled as a **Finite State Machine (FSM)**.
It simulates a vending machine that accepts coins (5, 10, 25 units), validates transactions, dispenses a product (priced at 25 units), and returns change for overpayment.

I developed this as a **self-learning project** to enhance my VLSI design and verification skills. The repo will also evolve with **SystemVerilog assertions, coverage, UVM testbenches, and formal verification**.

---

## 🔑 Features

* Accepts **coins of 5, 10, and 25 units**
* **Single product priced at 25 units**
* **Automatic change calculation** for overpayment
* FSM with **6 states**: IDLE, COIN5, COIN10, COIN15, COIN20, DISPENSE
* **One-cycle product dispensing**
* **Reset handling** to return system to IDLE
* **Overpayment support** with correct change output

---

## 📂 Repository Structure

```
📁 RTL_Design/           # RTL Verilog code (FSM design)
📁 Test_Bench/           # Testbench files
📁 Simulation_Results/   # Waveform dumps, logs, coverage
📁 Reports_Docs/         # Final report, documentation, synthesis results

```

---

## ⚙️ Tools & Technologies

* **HDL:** Verilog (RTL), SystemVerilog (future)
* **Verification:** Icarus Verilog, GTKWave
* **Planned Verification Upgrade:** SystemVerilog Assertions, UVM, Functional & Code Coverage
* **Formal Tools (future):** SymbiYosys / JasperGold
* **Scripting (future):** Python/TCL for automation

---

## ▶️ How to Run (Icarus Verilog + GTKWave)

1. Clone the repo:

```bash
git clone https://github.com/yourusername/vending-machine-controller.git
cd vending-machine-controller/Test_Bench
```

2. Compile design + testbench:

```bash
iverilog -o vending_machine_tb vending_machine_tb.v ../RTL_Design/vending_machine.v
```

3. Run the simulation:

```bash
vvp vending_machine_tb
```

4. View waveforms in GTKWave:

```bash
gtkwave vending_machine.vcd
```

✅ Expected behavior:

* Exact 25 units → Dispense, no change
* Overpayment (e.g., 10+25=35) → Dispense, 10 units change
* Insufficient funds + select → No dispense
* Reset → Back to IDLE

---

## 📊 Verification Approach

### ✅ Current (Verilog Testbench)

* Clock, reset, and stimulus-based TB
* `$monitor` and `$display` logs for states, outputs, and amounts
* `$dumpfile` + `$dumpvars` for waveform viewing
* Covers **reset, exact payment, overpayment, insufficient funds, manual selection, reset mid-cycle**

### 🚀 Planned Enhancements

1. **SystemVerilog Assertions (SVA)** – correctness of change, reset, dispense
2. **Functional Coverage** – state coverage, transition coverage, coin input combinations
3. **UVM Testbench** – random coin sequences, scoreboarding, coverage closure
4. **Formal Verification** – prove correctness of FSM transitions and safety properties

---

## 📊 Example Waveform (GTKWave)

*https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/vending_machine_controller/Simulation_Results*

---

## 📝 Learning Outcomes

* FSM-based RTL design in Verilog
* Coin-based transaction modeling
* Writing reusable testbenches
* Using Icarus Verilog + GTKWave for simulation & debug
* Roadmap to UVM + formal verification for advanced coverage

---

## 🚀 Future Scope

* Multi-product vending with inventory array
* Timeout & error handling (coin jams, incomplete transactions)
* Power optimization (clock gating, low-power FSM encoding)
* User interface (LCD/LED/keypad integration)
* Remote monitoring with UART/WiFi integration
* FPGA prototyping

---

## 📚 References

1. [Design of a Vending Machine Using Verilog HDL and Implementation in Genus Encounter](https://www.researchgate.net/publication/377690262_Design_of_a_Vending_Machine_Using_Verilog_HDL_and_Implementation_in_Genus_Encounter)
2. [Efficient Change System for Vending Machines (2025)](https://www.ijsat.org/papers/2025/2/4977.pdf)
3. [Multi-Level Vending Machine FSM Using Kintex-7 FPGA](https://www.ijfmr.com/papers/2024/3/19877.pdf)
4. [FPGA-Based Vending Machine Optimization](https://www.atlantis-press.com/proceedings/raisd-25/126013732)

---

✨ *This repo is my digital lab for **VLSI learning** – starting from RTL FSM design and growing into advanced verification with UVM and formal methods. Feedback and collaboration are always welcome!*



