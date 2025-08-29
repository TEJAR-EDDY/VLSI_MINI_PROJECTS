

# 🧺 Washing Machine Controller – FSM-Based RTL & Verification



## 📖 Project Overview

This project implements a **digital Washing Machine Controller** using **Verilog HDL**, modeled as a **Moore Finite State Machine (FSM)**.
It manages a complete wash cycle with configurable timing for each stage, reset/emergency stop support, and waveform-based verification.

This repository is part of my **self-learning VLSI journey** where I progressively enhance the project by:

1. **RTL Design in Verilog** (current version)
2. **SystemVerilog Enhancements** – Assertions (SVA), Functional Coverage
3. **UVM Verification Environment** – Constrained random stimulus, scoreboarding, coverage closure
4. **Advanced Verification** – Formal verification, code coverage, and regression setup

---

## 🔑 Features

* FSM with **6 States**: IDLE, FILL, WASH, RINSE, SPIN, DONE
* **Timer-based state duration** (configurable: 2, 5, 3, 2 cycles)
* **Emergency Stop & Asynchronous Reset** support
* **Moore FSM Implementation** → outputs depend only on current state (stable, glitch-free)
* **RTL verified with self-checking testbench**
* **Future-ready Verification Plan** (SV + UVM)

---

## 📂 Repository Structure

```
📁 RTL_Design/          # RTL code in Verilog (FSM-based controller)
📁 Test_Bench/          # Testbench code (stimulus, monitors, assertions)
📁 Simulation_Results/  # VCD waveforms, logs, coverage reports
📁 Reports_Final_docs/  # Project documentation, design report, synthesis results

```

---

## ⚙️ Tools & Technologies

* **HDL:** Verilog, SystemVerilog (planned)
* **Verification:** SystemVerilog, UVM (future extension)
* **Simulators:** [Icarus Verilog](https://steveicarus.github.io/iverilog/), [Verilator](https://www.veripool.org/verilator/)
* **Waveform Viewer:** [GTKWave](http://gtkwave.sourceforge.net/)
* **Formal Verification (planned):** SymbiYosys / JasperGold
* **Scripting:** Python & TCL (planned for regression automation)

---

## ▶️ How to Run (Icarus Verilog)

1. Clone this repository:

```bash
git clone https://github.com/yourusername/washing-machine-controller.git
cd washing-machine-controller/Test_Bench
```

2. Compile design + testbench:

```bash
iverilog -o washing_machine_tb washing_machine_tb.v ../RTL_Design/washing_machine_controller.v
```

3. Run simulation:

```bash
vvp washing_machine_tb
```

4. View waveform in GTKWave:

```bash
gtkwave washing_machine.vcd
```

 Expected state sequence:

```
IDLE → FILL → WASH → RINSE → SPIN → DONE → IDLE
```

---

## Verification Approach

###  Current (Verilog Testbench)

* Deterministic testbench with clock, reset, and stimulus
* `$display` logs for state transitions & outputs
* VCD waveform generation (`washing_machine.vcd`)
* Basic assertions (reset → IDLE, done active only in DONE state)

###  Future (Planned Enhancements)

1. **SystemVerilog Assertions (SVA):**

   * Reset safety property
   * State sequence correctness
   * One-hot checks for outputs

2. **Functional Coverage:**

   * State coverage (all 6 states hit)
   * Transition coverage (all legal paths hit)
   * Edge cases (stop/reset during operation)

3. **UVM Testbench:**

   * Sequence generators (random wash cycles)
   * Monitor + Scoreboard for output checking
   * Constrained random stimulus
   * Coverage closure report

4. **Formal Verification:**

   * LTL properties for FSM correctness
   * Deadlock/livelock analysis
   * Safety checks (stop/reset priority)

---

## Example Waveform (GTKWave)

*https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE/tree/main/washing_machine_controller/Simulation_Results*

---

## 📝 Learning Outcomes

* FSM Design & RTL coding in Verilog
* Writing reusable & modular HDL code
* Testbench methodology: clocks, resets, assertions, and self-checking
* Using Icarus Verilog + GTKWave for simulation & debugging
* Roadmap to advanced **SystemVerilog/UVM verification**

---

##  Future Enhancements

* Multiple wash programs (Quick, Delicate, Heavy)
* Sensor integration (water level, temperature)
* FPGA prototyping for hardware validation
* IoT-enabled controller (remote operation)
* Regression automation with Python/TCL scripts

---

## 📚 References

1. [Design and Implementation of Automatic Washing Machine Using Verilog HDL](https://eudoxuspress.com/index.php/pub/article/download/2634/1851/5027?utm_source=chatgpt.com)
2. [Implementation of Automatic Washing Machine Control System using Verilog HDL](https://www.jetir.org/view?paper=JETIR2503956&utm_source=chatgpt.com)
3. [Design and Implementation of Washing Machine HUD Using FPGAs](https://arxiv.org/abs/2506.11287?utm_source=chatgpt.com)

---

✨ *This repo evolves from a simple Verilog FSM into a **complete verification-ready project**, demonstrating both RTL design and modern verification methodologies (UVM, coverage, formal). It’s my digital lab to showcase learning and growth in VLSI design & verification.*





