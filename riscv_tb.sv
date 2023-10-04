//
// Design unit  : RISC_V processor testbench
//              :
// File name    : risc_tb.sv
//              :
// Module name  : RISC_tb
//              :
// Description  : Processor combininng Controller and datapath
//
// Version      : 4.0
//

module RISC_tb;
    timeunit 10ns; timeprecision 1ns;

    localparam WIDTH = 32;

    logic clk, rst;
    logic [WIDTH - 1 : 0] instr_in, data_in;
    logic data_write_en;
    logic [WIDTH - 1 : 0] instr_addr, data_addr, data_out;

    RISC dut(.*);

    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    initial begin
        {clk, rst, instr_in, data_in} = 0;

        #(PERIOD)

        rst = 1;
        #(PERIOD)
        rst = 0;

        //*I type -Load
        instr_in <= 32'h232BB7;                  //LUI
        @(posedge clk)
        #(PERIOD)

        instr_in <= 32'h232C17;                  //AUIPC
        @(posedge clk)
        #(PERIOD)

        //*Control T- I type
        instr_in = 32'h840667;                  //JALR
        @(posedge clk)
        #(PERIOD)

        //*SB type instructions
        instr_in <= 32'h418463;                 //BEQ
        @(posedge clk)
        #(PERIOD)

        instr_in <= 32'h419463;                 //BNE
        @(posedge clk)
        #(PERIOD)

        //*S type instructions
        instr_in <= 32'hC22583;                 //LW
        data_in <= 32'h778B5;
        @(posedge clk)
        #(PERIOD)

        instr_in <= 32'hF19AA3;                 //SH
        @(posedge clk)
        #(PERIOD)   

        instr_in <= 32'h100D903;                 //LHU
        data_in <= 32'h809BDFC0;
        @(posedge clk)
        #(PERIOD)

        //*I type
        instr_in <= 32'h90013;                  //ADDI
        data_in <= 0;
        @(posedge clk)
        #(PERIOD)

        //*R type
        instr_in <= 32'h232433;                 //SLT
        @(posedge clk)
        #(PERIOD)

        //*New
        instr_in <= 32'h2081B0;                 //UMUL
        @(posedge clk)
        #(PERIOD)

        instr_in <= 32'h810A00;                  //MEMC
        @(posedge clk)
        #(PERIOD)


        instr_in <= 32'h2081B0;                 //UMUL
        @(posedge clk)
        #(PERIOD)





        #(PERIOD*20)
        $finish();
        
    end


    
endmodule