Got it ✅ You want a **single `README.md` file** that fully covers **all your VLSI mini projects** (instead of repeating small README in each folder).

Here’s a **complete, technical, but simple** README you can directly put in your repository root:

---

````markdown
# VLSI Mini Projects in Verilog HDL 🚀

This repository contains a collection of **VLSI mini projects** that I designed and verified in **Verilog HDL** as part of my **self-learning journey**.  
The projects cover **fundamental digital design concepts** such as memory, FSMs, controllers, and data flow.  

Each project includes:
- RTL design in Verilog
- Testbench for simulation
- VCD waveform output (for GTKWave)

---

## 📂 Project List

1. **[Dual Port RAM & ROM](./dual_port_ram_rom_a_s)**  
   - Implements dual-port memory modules (RAM and ROM).  
   - Supports simultaneous read/write.  
   - Helps understand memory design concepts.  

2. **[Single Port RAM & ROM](./single_port_ram_rom_a_s)**  
   - Implements single-port memory modules.  
   - Focus on address, control, and data path understanding.  

3. **[Synchronous & Asynchronous FIFO](./synchronous_asynchronous_fifo)**  
   - Designs a FIFO buffer with synchronous and asynchronous clocking.  
   - Key learning: metastability, data buffering, and flow control.  

4. **[Traffic Light Controller](./traffic_light_controller)**  
   - FSM-based controller for traffic lights.  
   - Demonstrates state transitions and timing control.  

5. **[Vending Machine Controller](./vending_machine_controller)**  
   - FSM design for a vending machine.  
   - Includes coin input recognition and product dispensing logic.  

6. **[Washing Machine Controller](./washing_machine_controller)**  
   - FSM-based washing machine automation.  
   - Covers multiple states like wash, rinse, dry.  

---

## 🛠️ Tools Used
- **Icarus Verilog** → [Download Here](https://steveicarus.github.io/iverilog/)  
- **GTKWave** (waveform viewer) → [Download Here](http://gtkwave.sourceforge.net/)  

---

## ▶️ How to Run the Projects

1. **Clone this Repository**
   ```bash
   git clone https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE.git
   cd VLSI_MINI_PROJECTS_FE
````

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

Through these projects, I gained hands-on experience in:

* RTL design and Verilog HDL coding
* Testbench development and simulation
* FSM-based digital system design
* Memory architecture (RAM, ROM, FIFO)
* Waveform analysis with GTKWave
* Debugging and verification at IP level

---

## 🌟 About

This repository represents my **self-driven projects** to enhance my **VLSI design and verification skills**.
It demonstrates the **practical application of digital logic concepts** in Verilog HDL.

SCII art or a simple image link), so it looks more visually standout?
```
