//
// Design unit  : Adder for selecting next branching pc
//              :
// File name    : adder_branch.sv
//              :
// Module name  : Adder_Branch
//              :
// Description  : Direct the PC to select next instruction from 
//              : instruction memory in branching
//

module Adder_Branch #(parameter WIDTH = 32) (
    input logic [WIDTH - 1 : 0] pc_in,
    input logic [WIDTH - 1 : 0] branch,
    output logic [WIDTH - 1 : 0] out
);  

    always_comb begin
        out = pc_in + branch; 
    end
    
endmodule