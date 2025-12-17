module data_memory (
    input  logic        clk,
    input  logic        memread,
    input  logic        memwrite,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

  logic [31:0] mem[0:255];

  wire [7:0] word_addr = address[9:2];

  initial begin
    $readmemh("rtl/single_cycle/dmem.hex", mem);
  end

  always_comb begin
    if (memread) read_data = mem[word_addr];
    else read_data = 32'b0;
  end

  always_ff @(posedge clk) begin
    if (memwrite) mem[word_addr] <= write_data;
  end

endmodule
