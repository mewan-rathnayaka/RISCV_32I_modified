//
// Design unit  : Adder for selecting next pc
//              :
// File name    : adder_pc.sv
//              :
// Module name  : Adder_PC
//              :
// Description  : Direct the PC to select next instruction from 
//              : instruction memory
//
// Version      : 3.0 Instruction memory is byte addressable
//              : Initally double word addressable
//

module Adder_PC #(parameter WIDTH = 32) (
    input logic [WIDTH - 1 : 0] in,
    output logic [WIDTH - 1 : 0] out
);
    //Since next instruction location is 1 set of 32 bits away,
    always_comb begin
        out = in + 32'd4;
    end
    
endmodule