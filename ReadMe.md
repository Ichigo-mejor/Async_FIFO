# Asynchronous FIFO with Pointer Synchronization

A parameterized asynchronous FIFO designed in VHDL and verified in Vivado, built 
incrementally from first principles to properly understand each CDC (Clock Domain 
Crossing) concept involved.

## Features
- 8-depth, 8-bit wide, dual-clock FIFO
- 4-bit Gray-coded read/write pointers (3 address bits + 1 wrap bit)
- 2-stage synchronizers for safe multi-bit pointer transfer across clock domains
- Gray-code-based full/empty flag detection, free of metastability hazards
- Overflow and underflow protection on independent write/read clocks

## Project structure
Each module was built and simulated independently before integration:
- `t_ff.vhd`, `ripple_counter.vhd` — ripple counter (reference/contrast exercise)
- `gray_counter.vhd` — synchronous binary counter with Gray-code output
- `synchronizer.vhd` — 2-stage flip-flop synchronizer for CDC
- `sync_fifo.vhd` — single-clock FIFO (pointer/full/empty logic baseline)
- `async_fifo.vhd` — final dual-clock asynchronous FIFO, combining all of the above

## Tools
Xilinx Vivado 2026.1 — Behavioral simulation (XSIM)
