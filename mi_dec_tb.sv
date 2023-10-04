//
// Design unit  : Multicycle Instrcution decorder testbench
//              :
// File name    : mi_dec_tb.sv
//              :
// Module name  : MI_dec_tb
//              :
// Description  : Testbench for Multicycle Instrcution decorder  
//
// Version      : 4.0 
//

module MI_dec_tb;
    timeunit 10ns; timeprecision 1ns;

    localparam WIDTH = 32;

    logic clk, rst, en;
    logic [WIDTH - 1 : 0] pc_in, instr_in;
    logic pc_en;
    logic [WIDTH - 1 : 0] pc_out, instr_out;
    logic [1:0] state;

    MI_dec dut(.*);

    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    
    initial begin
        {clk, rst, en, pc_in, instr_in} = 0;

        #(PERIOD)

        rst = 1;
        #(PERIOD)
        rst = 0;

        en <= 0; pc_in <= 32'd4; instr_in <= 32'h002081B3;
        @(posedge clk)
        #(PERIOD/2)

        en <= 1; pc_in <= 32'd8; instr_in <= 32'h810A00; 
        @(posedge clk)
        #(PERIOD/2)

        
        pc_in <= 32'd12;
        @(posedge clk)
        #(PERIOD/2)

        en = 0;
        pc_in <= 32'd16; instr_in <= 32'h002081B3;
        @(posedge clk)
        #(PERIOD/2)


        #(PERIOD*20)
        $finish();
    end

    
endmodule