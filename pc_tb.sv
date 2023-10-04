//
// Design unit  : Program counter testbench
//              :
// File name    : pc_tb.sv
//              :
// Module name  : PC_tb
//              :
// Description  : Testbench of program counter for RISC 32I processor
//              : Added testing reset for version 2
//
// Version      : 2.0
//

module PC_tb;

    timeunit 10ns; timeprecision 1ns;
    localparam WIDTH = 32;

    logic clk, rst, en;
    logic [WIDTH - 1: 0] in;
    logic [WIDTH - 1: 0] out;

    PC dut(.*);

    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    initial begin
        {clk, in, rst, en} = 0;
        @(posedge clk) #1
        in <= 5'd4; en <= 1;

        @(posedge clk) #1
        assert (out == in)
            $display("Correct_1");
        else 
            $error("Assertion_1 failed!");
        
        @(posedge clk) #1
        in = 5'd15;

        @(posedge clk) #1
        assert (out == in)
            $display("Correct_2");
        else 
            $error("Assertion_2 failed!");

        @(posedge clk) #1
        in <= 5'd20; en <= 0;

        @(posedge clk) #1
        assert (out == 5'd15)
            $display("Enabler works");
        else 
            $error("Assertion Enabler failed!");


        rst <= 1;
        
        @(posedge clk)
        #1
        assert (out == 0)
            $display("Reset works");
        else 
            $error("Assertion reset failed!");

        #(PERIOD*2)
        $finish();
    end



    
endmodule