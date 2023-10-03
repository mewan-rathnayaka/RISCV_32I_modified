//
// Design unit  : Immediate extender
//              :
// File name    : extender.sv
//              :
// Module name  : Extender
//              :
// Description  : Immediate extending the different immediates to
//              : input to ALU
// Version      : 4.0 J type removed
//              : 

//Different immediate types
//           |   31:25       |  24:20   |  19:15  | 14:12      |  11:7     |  6:0
//Size       |      7        |    5     |   5     |    3       |    5      |    7
//R type     |   funct7      |  rs2     |  rs1    | funct3     |  rd       |  opcode
//
//I type     |           imm[11:0]      |  rs1    | funct3     |  rd       |  opcode
// lw                                               010                       0000011
// 
//S type     |   imm[11:5]   |  rs2     |  rs1    | funct3    |  imm[4:0]  |  opcode
// sw                                               010           010         0100011
//
//SB type    |   imm[12,10:5]|  rs2     |  rs1    | funct3     |imm[4:1,11]|  opcode
// beq                                              000                       1100011
//
//U type     |                   imm[31,12]                    |  rd       |  opcode
//

//Setting case   as   type
//         0      |     I
//         1      |     S
//         2      |     SB
//         3      |     U

module Extender #(parameter WIDTH = 32) (
    input logic [1 : 0] selector,
    input logic [WIDTH - 1 : 7] in,
    output logic [WIDTH - 1 : 0] out
);
    always_comb begin
        case (selector)
            2'd0 : out = {{21{in[31]}}, in[30:20]};                                 //I
            2'd1 : out = {{21{in[31]}},in[30:25],in[11:7]};                         //S
            2'd2 : out = {{20{in[31]}},in[7],in[30:25],in[11:8],1'b0};              //SB
            2'd3 : out = {in[31:12],12'b0};                                         //U
            default: begin
                out = 32'bx;
            end
        endcase
    end

    
endmodule