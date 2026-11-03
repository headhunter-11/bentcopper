module extend(input  logic [31:7] instr,
              input  logic [1:0]  immsrc,
              output logic [31:0] immext);

  // B- and J-type values contain the encoded immediate bits [12:1]
  // and [20:1], respectively. The datapath shifts these left by one.
  always_comb
    case (immsrc)
      2'b00: immext = {{20{instr[31]}}, instr[31:20]}; // I-type
      2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
      2'b10: immext = {{20{instr[31]}}, instr[31], instr[7],
                       instr[30:25], instr[11:8]}; // B-type, bits [12:1]
      2'b11: immext = {{12{instr[31]}}, instr[31], instr[19:12],
                       instr[20], instr[30:21]}; // J-type, bits [20:1]
      default: immext = 32'bx;
    endcase
endmodule
