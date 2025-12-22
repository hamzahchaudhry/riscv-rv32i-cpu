# **riscv-rv32i-cpu**

An experimental **RISC-V RV32I** processor core implemented in **SystemVerilog**, developed as a progressive exploration of CPU microarchitecture.

The design begins with a **single-cycle baseline implementation**, transitions to a **classic 5-stage in-order pipeline**, and is extended over time to investigate more advanced techniques such as **speculation, out-of-order execution, branch prediction, and cache hierarchies**. Each stage is intended to remain functionally correct and independently verifiable.

---

## Design progression

### 1. Single-cycle core

* RV32I base integer instruction set
* One instruction completed per cycle
* Monolithic datapath with centralized control
* Minimal instruction and data memory interface

### 2. Five-stage in-order pipeline

* IF / ID / EX / MEM / WB pipeline organization
* Data hazard detection and stall insertion
* Forwarding / bypass networks
* Basic control hazard handling

### 3. Advanced microarchitectural extensions (ongoing work)

The following features are explored incrementally and may evolve as the design matures:

* Enhanced branch handling and dynamic branch prediction
* Instruction and data caching
* Dynamic scheduling and out-of-order execution
* Tomasulo-style issue and wakeup mechanisms
* Reorder buffer (ROB) for precise architectural state
* Store buffering and load–store ordering mechanisms
* Multiple-issue (superscalar) execution

---

## Repository layout

* `rtl/` — SystemVerilog RTL sources by core type
* `tb/` — Testbenches and test assets (e.g., memory init hex files)
* `work/` — Simulator work directory (ignored)

---

## Simulation (ModelSim/Questa)

From the repo root:

```sh
make sim
```

Clean generated artifacts:

```sh
make clean
```
