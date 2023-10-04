//
// Design unit  : Program counter
//              :
// File name    : pc.sv
//              :
// Module name  : PC
//              :
// Description  : Program counter for RISC 32I processor
//              : Added reset for version 2
//
// Version      : 2.0
//

//PC bus width is 5 bits since instruction mem spaces are 64
module PC #(parameter WIDTH = 32) (
    input logic clk, rst,en,
    input logic [WIDTH - 1: 0] in,
    output logic [WIDTH - 1: 0] out
);
    //Setting the PC
    logic [WIDTH -1:0] pc;

    //Funtionality
    always_ff @(posedge clk ) begin
        if (rst) begin
            out <= 'd0;
        end else if (en) begin
            out <= in;
        end
    end
endmodule