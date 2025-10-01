# FPGA UART Suite

This repository contains several UART-based Verilog projects, implemented and tested using **Vivado 2025.1**.

---

## 📂 Sub-projects

### 1. [uart-tx](uart-tx/)
Implements an 8-bit UART transmitter (`uart_byte_tx`) and a simple test top (`uart_tx_test`).
- Configurable baud rate
- Sends incrementing data
- Includes testbench and waveform

### 2. [uart-rx](uart-rx/)
Implements a UART receiver (`uart_byte_rx`) with testbench.
- Detects start bit
- Samples data bits
- Provides `rx_done` flag and data output

### 3. [uart-ctrl-led](uart-ctrl-led/)
Demo project that connects UART RX to LED control.
- PC sends byte via UART
- FPGA decodes and drives LEDs
- Demonstrates RX usage in a practical scenario

---

## 🧪 Simulation & Test
- All modules tested in **Vivado xsim**
- Waveform screenshots are included in each sub-project’s `doc/` folder

---

## 🚀 Next Steps
- Add loopback demo (TX → RX)
- Add FIFO buffer for TX and RX
- Test on Basys3 or ACX750 FPGA board

---
