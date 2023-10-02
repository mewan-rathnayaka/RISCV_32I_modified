//
// Design unit  : RISC_V processor
//              :
// File name    : risc.sv
//              :
// Module name  : RISC
//              :
// Description  : Processor combininng Controller and datapath
//
// Version      : 3.0
//

module RISC #(parameter WIDTH = 32) (
    input logic clk, rst,
    input logic [WIDTH - 1 : 0] instr, data_in,
    output logic data_write_en,
    output logic [WIDTH - 1 : 0] pc_out, alu_out, reg_2_out
    
);
    //logic pc_src, alu_src, result_src,reg_write_en;
    logic [1:0] imm_src;
    logic [3:0] alu_control;

    //Datapath
    Datapath Datapath_1 (.clk(clk), .rst(rst), .instr(instr[31:7]), .data_in(data_in), 
     .pc_out(pc_out), .alu_out(alu_out), .reg_2_out(reg_2_out), .pc_src(pc_src), 
     .alu_src(alu_src), .result_src(result_src), .reg_write_en(reg_write_en),
    .imm_src(imm_src), .alu_control(alu_control), .zero(zero));

    //Controller
    Controller CPU (.rst(rst), .zero(zero), .instr(instr), .alu_src(alu_src), .pc_src(pc_src),
     .result_src(result_src), .data_write_en(data_write_en), .reg_write_en(reg_write_en),
      .imm_src(imm_src), .alu_control(alu_control));
    
endmodule


