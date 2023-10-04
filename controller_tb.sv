//
// Design unit  : Controller Testbench
//              :
// File name    : controller_tb.sv
//              :
// Module name  : Controller_tb
//              :
// Description  : Testbench for microcontroller type controller 
//              : For RISC 32I processor
//              : Start from version2
//
// Version      : 4.0
//

module Controller_tb;
    timeunit 10ns; timeprecision 1ns;

    localparam WIDTH = 32;

    logic clk, rst, zero;
    logic [WIDTH - 1 : 0] instr;
    logic alu_src_2, alu_src_1, data_write_en, reg_write_en, multi_cy;
    logic [1:0] pc_src, result_src, imm_src;
    logic [2:0] ls_src;
    logic [3:0] alu_control;

    Controller dut(.*);

    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    initial begin
        {rst, zero, instr, clk} = 0;

        #(PERIOD)

        //*I type -Load
        instr = 32'h232BB7;                  //LUI
        @(posedge clk)
        #(PERIOD)

        instr = 32'h232C17;                  //AUIPC
        @(posedge clk)
        #(PERIOD)

        //*Control T- I type
        instr = 32'h840667;                  //JALR
        @(posedge clk)
        #(PERIOD)

        //*SB type instructions
        instr <= 32'h418463;                 //BEQ
        zero <= 1;
        @(posedge clk)
        #(PERIOD)

        instr <= 32'h419463;                 //BNE
        zero <= 0;
        @(posedge clk)
        #(PERIOD)

        //*S type instructions
        instr <= 32'hC22583;                 //LW
        zero <= 0;
        @(posedge clk)
        #(PERIOD)

        instr <= 32'hF19AA3;                 //SH
        zero <= 0;
        @(posedge clk)
        #(PERIOD)   

        instr <= 32'h100D903;                 //LHU
        zero <= 0;
        @(posedge clk)
        #(PERIOD)

        //*I type
        instr <= 32'h90013;                  //ADDI
        @(posedge clk)
        #(PERIOD)

        //*R type
        instr <= 32'h232433;                 //SLT
        @(posedge clk)
        #(PERIOD)

        //*New
        instr <= 32'h2081B0;                 //UMUL
        @(posedge clk)
        #(PERIOD)

        instr <= 32'h810A00;                  //MEMC
        @(posedge clk)
        #(PERIOD)


    #(PERIOD*2)
    $finish();
    end
endmodule