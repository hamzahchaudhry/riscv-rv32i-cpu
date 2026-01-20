module dmem #(
    parameter string DMEM_INIT = "dmem.hex"
) (
    input  logic        clk,
    input  logic        we,
    input  logic [ 2:0] funct3,
    input  logic [31:0] addr,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

  /* 256 words of 32-bit memory */
  logic [31:0] mem[256];

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
    if (we) begin
      case (funct3)
        3'b000: begin  /* sb */
          unique case (addr[1:0])
            2'b00: mem[word_addr][7:0] <= wd[7:0];
            2'b01: mem[word_addr][15:8] <= wd[7:0];
            2'b10: mem[word_addr][23:16] <= wd[7:0];
            2'b11: mem[word_addr][31:24] <= wd[7:0];
          endcase
        end
        3'b001: begin  /* sh */
          if (addr[1] == 1'b0) mem[word_addr][15:0] <= wd[15:0];
          else mem[word_addr][31:16] <= wd[15:0];
        end
        3'b010: begin  /* sw */
          if (addr[1:0] == 2'b00) mem[word_addr] <= wd;
        end
        default: begin
        end
      endcase
    end
  end

endmodule
