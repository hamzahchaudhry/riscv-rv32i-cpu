module instruction_memory #(
    parameter int DEPTH_WORDS = 1024
) (
    input  logic        ce,
    input  logic        read_en,
    input  logic [31:0] pc,
    output logic [31:0] instr
);

  logic [31:0] mem[0:DEPTH_WORDS-1];

  /* word index (PC >> 2) */
  wire [$clog2(DEPTH_WORDS)-1:0] idx = pc[2+:$clog2(DEPTH_WORDS)];

  always_comb begin
    if (ce && read_en) instr = mem[idx];
    else instr = 32'h0000_0000;
  end

  initial begin
    $readmemh("rtl/single_cycle/imem.hex", mem);
  end

endmodule
