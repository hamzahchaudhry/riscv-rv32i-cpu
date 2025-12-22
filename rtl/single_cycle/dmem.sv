module dmem #(
    parameter string DMEM_INIT = "dmem.hex"
) (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

  /* 256 words of 32-bit memory */
  logic [31:0] mem[0:255];

  /* word address: 256 words -> 8 bits, use address bits [9:2] */
  logic [7:0] word_addr;
  assign word_addr = addr[9:2];

  initial begin
    $readmemh(DMEM_INIT, mem);
  end

  /* asynchronous read */
  always_comb begin
    rd = mem[word_addr];
  end

  /* synchronous write */
  always_ff @(posedge clk) begin
    if (we && (addr[1:0] == 2'b00)) mem[word_addr] <= wd;
  end

endmodule
