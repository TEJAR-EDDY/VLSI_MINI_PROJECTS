# VLSI Mini Projects in Verilog HDL 🚀  

This repository contains my **self-developed VLSI mini projects** implemented in **Verilog HDL**.  
I created these projects as part of my **self-learning journey** to improve RTL design, digital logic, and verification skills.  

Each project includes Verilog design files, testbenches, and simulation support with waveforms.  

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
- **Icarus Verilog (iverilog)** → [Download Here](https://steveicarus.github.io/iverilog/)  
- **GTKWave (for waveform viewing)** → [Download Here](http://gtkwave.sourceforge.net/)  

---

## ▶️ How to Run the Projects

1. **Clone this Repository**
   ```bash
   git clone https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE.git
   cd VLSI_MINI_PROJECTS_FE


2. **Navigate to Any Project Folder**

   ```bash
   cd traffic_light_controller
   ```

3. **Compile the Design and Testbench**

   ```bash
   iverilog -o sim_out design.v testbench.v
   ```

4. **Run the Simulation**

   ```bash
   vvp sim_out
   ```

5. **View the Waveform**

   ```bash
   gtkwave dump.vcd
   ```

---

## 📖 Learning Outcomes

Through these projects, I gained practical skills in:

* RTL design and Verilog HDL coding
* Testbench development and simulation
* FSM-based digital system design
* Memory architecture (RAM, ROM, FIFO)
* Waveform analysis with GTKWave
* Debugging and verification at IP level

---

## 🌟 About

This repository represents my **self-driven VLSI projects** to strengthen design and verification skills.
It demonstrates the **practical application of digital logic concepts** in Verilog HDL.

---


