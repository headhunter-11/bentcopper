module imem(
    input  logic [31:0] a,   // byte address
    output logic [31:0] rd   // instruction
);
    logic [31:0] RAM [0:63]; // 64 x 32-bit words

    initial $readmemh("riscvtest.txt", RAM);

    assign rd = RAM[a[7:2]]; // word index = a/4, combinational read
endmodule
