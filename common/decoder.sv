// decoder code taken from slide 86 in slide set 6
module decoder #(
    parameter int N = 2,
    parameter int M = 4
) (
    input  logic [N-1:0] a,

    output logic [M-1:0] b
);

  assign b = 1 << a;

endmodule
