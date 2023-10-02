//
// Design unit  : Immediate extender_tb
//              :
// File name    : extender_tb.sv
//              :
// Module name  : Extender_tb
//              :
// Description  : Testbench for immediate extender
//              : 
// Version      : 4.0 J type removed
//              : 
//

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

module Extender_tb;

    timeunit 10ns ; timeprecision 1ns;

    localparam WIDTH = 32;

    logic [2 : 0] selector;
    logic [WIDTH - 1 : 7] in;
    logic [WIDTH - 1 : 0] out;

    Extender dut(.*);

    initial begin
        {selector, in, out} = 0;
        
        //I type
        #10 selector <= 2'd0; in = 25'b1000000000000000000000000;
        #10 $display("immediate_1 = %b", out);
        #10 selector <= 2'd0; in = 25'b0000000000000000000000000;
        //S type
        #10 selector <= 2'd1; in = 25'b1000000000000000000000000;
        #10 selector <= 2'd1; in = 25'b1000000000000000000011111;
        #10 $display("immediate_2.1= %b", out);
        #10 selector <= 2'd1; in = 25'b0000000000000000000011111;
        #10 $display("immediate_2.2= %b", out);
        //SB type
        #10 selector <= 2'd2; in = 25'b1000000000000000000000000;
        #10 $display("immediate_3.1= %b", out);
        #10 selector <= 2'd2; in = 25'b1100000000000000000011111;
        #10 $display("immediate_3.2= %b", out);
        //U type
        #10 selector <= 2'd3; in = 25'b1000000000000000000000000;
        #10 $display("immediate_4.1= %b", out);
        #10 selector <= 2'd3; in = 25'b1100000000011100001100000;
        #10 $display("immediate_4.2= %b", out);
        
        
        #(10*2)
        $finish();
    end

    
endmodule