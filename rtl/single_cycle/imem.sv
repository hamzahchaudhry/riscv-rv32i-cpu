module imem #(
    parameter string IMEM_INIT = "imem.hex"
) (
    input  logic [31:0] pc,
    output logic [31:0] instr
);

  /* 256 words of 32-bit instruction memory */
  logic [31:0] mem [0:255];

  /* word index: 256 words -> 8 bits, use pc bits [9:2] */
  logic [ 7:0] idx;
  assign idx = pc[9:2];

  /* asynchronous read */
  always_comb begin
    instr = mem[idx];
  end

  initial begin
    $readmemh(IMEM_INIT, mem);
  end

endmodule
