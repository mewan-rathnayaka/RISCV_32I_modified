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
// Version      : 2.0
//

module Controller_tb;
    timeunit 10ns; timeprecision 1ns;

    localparam WIDTH = 32;

    logic rst, zero, clk;
    logic [WIDTH - 1 : 0] instr;
    logic alu_src, pc_src, result_src, data_write_en, reg_write_en;
    logic [1:0] imm_src;
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
        //Checking add instr 
        instr <= 32'h2081B3;
        #10
        $display("alu_src = %b, pc_src = %b, result_src = %b", alu_src, pc_src, result_src );
        $display("data_write_en = %b, reg_write_en = %b", data_write_en, reg_write_en);
        $display("imm_src = %b, alu_control = %b", imm_src, alu_control);

    #(10*2)
    $finish();
    end
endmodule