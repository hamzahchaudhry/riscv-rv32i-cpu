# **riscv-cpu**

A RISC-V CPU written in SystemVerilog that evolves from a simple single-cycle core into a pipelined, speculative, and eventually out-of-order microarchitecture.

This project is intended to be a clean, modular sandbox for experimenting with modern CPU architecture concepts.

---

## **Planned Features**

This CPU will gradually incorporate a range of advanced microarchitectural techniques, including:

* **Pipelining**
* **Hazard detection and forwarding**
* **Branch handling and branch prediction**
* **Scoreboarding**
* **Tomasulo’s algorithm**
* **Register renaming**
* **Reservation stations**
* **Reorder Buffer (ROB)** for in-order commit
* **Out-of-order execution**
* **Speculative execution**
* **Multi-issue / superscalar dispatch**
* **Instruction and data caches**

Additional features may be added as the architecture evolves.
