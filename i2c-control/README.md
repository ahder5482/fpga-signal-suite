# I2C Control Module

This project implements an I2C control module in Verilog, supporting both **register read/write operations** with configurable addressing mode and device ID.  
It also includes a testbench that simulates communication with an EEPROM (`M24LC04B`).

---

## 📂 Files

- **src/i2c_control.v**  
  RTL implementation of the I2C control module (supports start/stop, read, write, ACK/NACK handling).

- **sim/i2c_bit_shift_tb.v**  
  Testbench for verifying I2C bit shifting, start/stop conditions, and EEPROM communication.

- **docs/**  
  Simulation waveforms and notes can be placed here.

---

## 🧩 Features

- Supports **I2C register read/write** with 8-bit or 16-bit addressing.  
- Handles **Start / Stop / ACK / NACK** conditions automatically.  
- Parameterized FSM with clear states for write/read sequencing.  
- Includes testbench with pullup model and EEPROM (`M24LC04B`) verification.

---

## ⚙️ Interfaces

### Inputs
- `Clk` : System clock  
- `Rst_n` : Active-low reset  
- `wrreg_req` : Write request  
- `rdreg_req` : Read request  
- `addr[15:0]` : Register address  
- `addr_mode` : Address mode (8-bit / 16-bit)  
- `wrdata[7:0]` : Write data  
- `device_id[7:0]` : Target I2C device ID  

### Outputs
- `rddata[7:0]` : Read data result  
- `RW_Done` : Operation complete flag  
- `ack` : ACK result from device  

### I2C Bus
- `i2c_sclk` : I2C serial clock  
- `i2c_sdat` : I2C serial data (bidirectional)  

---

## 🚀 How to Run Simulation

1. Add `i2c_control.v` and `i2c_bit_shift_tb.v` into Vivado or ModelSim simulation sources.  
2. Run simulation.  
3. Observe waveform:
   - Correct **Start + Device ID + Address + Data** sequences.  
   - EEPROM responds with **ACK** and returns expected data.  

---

## 📘 Notes

- The FSM structure makes it easy to extend for multi-byte operations.  
- `task write_byte` and `task read_byte` abstract low-level control, keeping RTL clean.  
- Future improvement: parameterize clock divider for multi-speed I2C support.

---

## 🔗 Reference

- EEPROM model: **M24LC04B** (used in testbench).  
- I2C standard: [UM10204 I²C-bus specification](https://www.nxp.com/docs/en/user-guide/UM10204.pdf)

