# APB Slave Design using FSM in SystemVerilog

## Overview

This project implements an APB (Advanced Peripheral Bus) Slave using a Finite State Machine (FSM) in SystemVerilog.

The design supports:

- APB Write Operation
- APB Read Operation
- FSM-based Control Logic
- Memory Read/Write
- Behavioral Simulation in Vivado

The project demonstrates the implementation and verification of an APB Slave protocol commonly used in ARM AMBA architectures.

---

# Project Objective

The main objective of this project is to:

- Understand APB Protocol
- Design APB Slave using FSM
- Perform Read and Write transactions
- Verify functionality using SystemVerilog testbench
- Analyze waveforms in Vivado

---

# Tools Used

| Tool | Purpose |
|------|----------|
| Vivado | Simulation and Verification |
| SystemVerilog | RTL Design |
| XSIM | Behavioral Simulation |

---

# APB Protocol Introduction

The Advanced Peripheral Bus (APB) is part of the ARM AMBA protocol family.

<img width="850" height="490" alt="image" src="https://github.com/user-attachments/assets/111b4be6-20b1-4f2b-be60-77d9becf43db" />


APB is mainly used for:

- Low power peripherals
- Register access
- Control interfaces
- Simpler bus communication

---

# APB Signals

| Signal | Description |
|--------|-------------|
| PCLK | APB Clock |
| PRESETn | Active low reset |
| PSEL | Peripheral select |
| PENABLE | Enables transfer |
| PWRITE | Write or Read control |
| PADDR | Address bus |
| PWDATA | Write data |
| PRDATA | Read data |
| PREADY | Transfer complete |

---

# FSM States

The APB Slave uses 3 FSM states:

## 1. SETUP
Initial state for transfer setup.

## 2. WRITE
Writes data into memory.

## 3. READ
Reads data from memory.

---

# FSM Flow

```text
SETUP → WRITE → SETUP
SETUP → READ  → SETUP
```

---

# Design Features

- FSM-based APB Slave
- 8-bit Address Bus
- 8-bit Data Bus
- Internal Memory
- Read and Write Support
- Synthesizable RTL

---

# Design Code

```systemverilog
module apb_slave(

input logic PCLK,
input logic PRESETn,

input logic PSEL,
input logic PENABLE,
input logic PWRITE,

input logic [7:0] PADDR,
input logic [7:0] PWDATA,

output logic [7:0] PRDATA,
output logic PREADY

);

typedef enum logic [1:0]
{
SETUP,
WRITE,
READ
} state_type;

state_type present_state,next_state;

logic [7:0] mem [255:0];

always_ff @(posedge PCLK or negedge PRESETn)
begin

if(!PRESETn)
present_state <= SETUP;

else
present_state <= next_state;

end

always_comb
begin

next_state = present_state;

case(present_state)

SETUP:
begin

if(PSEL && PENABLE && PWRITE)
next_state = WRITE;

else if(PSEL && PENABLE && !PWRITE)
next_state = READ;

else
next_state = SETUP;

end

WRITE:
next_state = SETUP;

READ:
next_state = SETUP;

endcase

end

endmodule
```

---

# Testbench

The testbench performs:

- Reset sequence
- APB Write transaction
- APB Read transaction
- Waveform monitoring

---

# Simulation Waveform

<img width="1618" height="862" alt="Screenshot 2026-05-17 221402" src="https://github.com/user-attachments/assets/9bcb2c33-3ee8-4159-98f1-2bb15395dcb5" />


---

# RTL Schematic

<img width="1571" height="760" alt="image" src="https://github.com/user-attachments/assets/b2d15511-71c1-4f07-ad15-f1f6068fe33d" />


---

# Expected Results

## Write Operation
- Data written into internal memory.

## Read Operation
- Previously written data is read correctly.

Example:

```text
Address = 0x10
Write Data = 0xAA
Read Data = 0xAA
```

---

# Applications

- ARM AMBA Systems
- SoC Design
- Peripheral Interfaces
- Embedded Systems
- ASIC Verification
- FPGA Design

---

# Future Enhancements

- Add APB Wait States
- Add Multiple Slaves
- Add Assertions
- Add Functional Coverage
- Convert to UVM Environment

