Here is your content formatted as a single, comprehensive README file in Markdown, suitable for direct use in your repository :

```markdown
# VLSI Mini Projects in Verilog HDL 🚀

This repository contains self-developed **VLSI mini projects** implemented in **Verilog HDL**.  
These projects were created as part of a **self-learning journey** to strengthen RTL design, digital logic, and verification skills.  
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

- **Icarus Verilog**  
  [Download Here](https://steveicarus.github.io/iverilog/)
- **GTKWave** (for waveform viewing)  
  [Download Here](http://gtkwave.sourceforge.net/)

---

## ▶️ How to Run the Projects

1. **Clone this Repository**
    ```
    git clone https://github.com/TEJAR-EDDY/VLSI_MINI_PROJECTS_FE.git
    cd VLSI_MINI_PROJECTS_FE
    ```

2. **Navigate to Any Project Folder**
    ```
    cd traffic_light_controller
    ```

3. **Compile the Design and Testbench**
    ```
    iverilog -o sim_out design.v testbench.v
    ```

4. **Run the Simulation**
    ```
    vvp sim_out
    ```

5. **View the Waveform**
    ```
    gtkwave dump.vcd
    ```

---

## 📖 Learning Outcomes

Through these projects, the following skills were gained:
- RTL design and Verilog HDL coding
- Testbench development and simulation
- FSM-based digital system design
- Memory architecture (RAM, ROM, FIFO)
- Waveform analysis with GTKWave
- Debugging and verification at IP level

---

## 🌟 About

This repository represents self-driven projects to enhance VLSI design and verification skills.  
It demonstrates the practical application of digital logic concepts in Verilog HDL.
```
