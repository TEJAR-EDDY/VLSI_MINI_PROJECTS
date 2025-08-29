# VLSI Mini Projects in Verilog HDL 🚀

This repository contains my self-developed **VLSI mini projects** implemented in **Verilog HDL**.  
I created these projects as part of my **self-learning journey** to strengthen RTL design, digital logic, and verification skills.  

Each project includes Verilog design files, testbenches, and simulation support.

---

## 📂 Project List
- **[Dual Port RAM & ROM](./dual_port_ram_rom_a_s)**  
- **[Single Port RAM & ROM](./single_port_ram_rom_a_s)**  
- **[Synchronous & Asynchronous FIFO](./synchronous_asynchronous_fifo)**  
- **[Traffic Light Controller](./traffic_light_controller)**  
- **[Vending Machine Controller](./vending_machine_controller)**  
- **[Washing Machine Controller](./washing_machine_controller)**  

---

## 🛠️ Tools Used
- **Icarus Verilog** → [Download Here](https://steveicarus.github.io/iverilog/)  
- **GTKWave** (for waveform viewing) → [Download Here](http://gtkwave.sourceforge.net/)  

---

## ▶️ How to Run the Projects

1. **Clone this Repository**
   ```bash
   git clone https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE.git
   cd VLSI_MINI_PROJECTS_FE
Go to any Project Folder

cd traffic_light_controller


Compile the Design and Testbench using Icarus Verilog

iverilog -o output design.v testbench.v


Run the Simulation

vvp output


View the Waveform

gtkwave dump.vcd

📖 Learning Outcome

Through these projects, I practiced:

RTL coding in Verilog

Writing effective testbenches

Simulation and waveform analysis

Understanding digital design concepts (FSMs, memory, and controllers)

🌟 About

This repository is part of my self-learning initiative in VLSI design and verification.
It demonstrates my ability to design and verify digital circuits using industry-standard practices in Verilog HDL.
