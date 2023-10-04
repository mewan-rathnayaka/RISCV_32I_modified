//
// Design unit  : Datapath
//              :
// File name    : datapath.sv
//              :
// Module name  : Datapath
//              :
// Description  : Setting the datapath of the processor 
//              : Controller to be connected externally
//
// Version      : 4.0 Completing instructions running
//              : Multi_cycle
//

//PC_SIZE = $clog2(DEPTH = 64)
module Datapath #(parameter WIDTH = 32, DEPTH = 64) (
    //With controller
    input logic clk, rst,
    input logic alu_src_2, alu_src_1,reg_write_en,pc_en,
    input logic [1:0] result_src, pc_src, imm_src,
    input logic [2:0] ls_src,
    input logic [3:0] alu_control,
    output logic zero, 

    //With memories
    input logic [WIDTH - 1 : 7] instr,
    input logic [WIDTH - 1 : 0] data_in,
    output logic [WIDTH - 1: 0] pc_out, alu_out, write_data_mod

    );
    // Wire naming convention - by the ouput
    //                        - name says where it coming from
    logic [WIDTH - 1 : 0] pc_target_out, branch_pc_out, adder_pc_out;
    logic [WIDTH - 1 : 0] reg_1_out, alu_mux_out_2, alu_mux_out_1, result_out, ext_out;
    logic [WIDTH - 1 : 0] reg_2_out, result_out_mod;

    //Mux
    assign alu_mux_out_1 = (alu_src_1)  ? pc_out   : reg_1_out;
    assign alu_mux_out_2 = (alu_src_2)  ? ext_out  : reg_2_out;
    always_comb begin
        case (pc_src)
            2'b00 : pc_target_out = adder_pc_out;
            2'b01 : pc_target_out = branch_pc_out;
            2'b10 : pc_target_out = alu_out;
            default:pc_target_out = {32{1'bx}};
        endcase
    end
    //expanding for JALR
    always_comb begin
        case (result_src)
            2'b00 : result_out = alu_out;
            2'b01 : result_out = data_in;
            2'b10 : result_out = adder_pc_out;
            2'b11 : result_out = ext_out;
            default:result_out = {32{1'bx}};
        endcase
    end


    //PC
    PC              pc(.clk(clk), .rst(rst), .en(pc_en), .in(pc_target_out), .out(pc_out));
    Adder_PC        pcplus_4(.in(pc_out),    .out(adder_pc_out));
    //With SLL 1 in branch
    Adder_Branch    pcbranch(.pc_in(pc_out), .branch({ext_out[WIDTH - 2:0],1'b0}),
                            .out(branch_pc_out));

    //Extender
    Extender extender(.in(instr), .selector(imm_src), .out(ext_out));
    //LS_extender
    LS_extender ls_extender(.selector(ls_src), .load_in(result_out), .store_in(reg_2_out),
                            .load_out(result_out_mod), .store_out(write_data_mod));

    //Reg
    //           |   31:25       |  24:20   |  19:15  | 14:12      |  11:7     |  6:0
    //Size       |      7        |    5     |   5     |    3       |    5      |    7
    //R type     |   funct7      |  rs2     |  rs1    | funct3     |  rd       |  opcode
    Registry registry (.clk(clk), .write_en(reg_write_en), .rs1(instr[19:15]), 
                        .rs2(instr[24:20]), .rd(instr[11:7]), 
                       .write_data(result_out_mod), .data_1(reg_1_out), .data_2(reg_2_out));


    //ALU
    ALU alu (.control(alu_control), .src_a(alu_mux_out_1), .src_b(alu_mux_out_2), .zero(zero),
             .out(alu_out));

    
    //assign instr = instr;

endmodule
