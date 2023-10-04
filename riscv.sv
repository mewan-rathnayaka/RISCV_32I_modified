//
// Design unit  : RISC_V processor
//              :
// File name    : risc.sv
//              :
// Module name  : RISC
//              :
// Description  : Processor combininng Controller and datapath
//
// Version      : 4.0 (Added Multicycle funtioning)
//

module RISC #(parameter WIDTH = 32) (
    input logic clk, rst,
    input logic [WIDTH - 1 : 0] instr_in, data_in,
    output logic data_write_en,
    output logic [WIDTH - 1 : 0] instr_addr, data_addr, data_out
    
);
    //logic pc_src, alu_src, result_src,reg_write_en;
    logic multi_cy;
    logic [1:0] imm_src, pc_src, result_src;
    logic [2:0] ls_src;
    logic [3:0] alu_control;
    logic [WIDTH - 1 : 0] pc, instr_mod;

    //Datapath
    Datapath Datapath_1 (.clk(clk), .rst(rst), .pc_en(pc_en), .instr(instr_mod[31:7]), .data_in(data_in), 
     .pc_out(pc), .alu_out(data_addr), .write_data_mod(data_out), .pc_src(pc_src), 
     .alu_src_1(alu_src_1), .alu_src_2(alu_src_2), .result_src(result_src), .ls_src(ls_src) , .reg_write_en(reg_write_en),
    .imm_src(imm_src), .alu_control(alu_control), .zero(zero));

    //Controller
    Controller CPU (.clk(clk), .rst(rst), .zero(zero), .instr(instr_mod), .alu_src_1(alu_src_1), .alu_src_2(alu_src_2), .pc_src(pc_src),
     .result_src(result_src), .ls_src(ls_src), .data_write_en(data_write_en), .reg_write_en(reg_write_en),
      .imm_src(imm_src), .alu_control(alu_control), .multi_cy(multi_cy));


    //MI_dec
    MI_dec mi_decorder (.clk(clk) , .rst(rst), .en(multi_cy), .pc_in(pc), .pc_out(instr_addr),
     .instr_in(instr_in), .instr_out(instr_mod), .pc_en(pc_en));


    
endmodule


