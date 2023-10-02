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
// Version      : 3.0 (Change to byte addressable memory)
//

module Mem_tb;

    timeunit 10ns; timeprecision 1ns;
    localparam DEPTH = 64,
               WIDTH = 32;

    logic clk = 0, write_en, rst;
    logic [WIDTH - 1: 0] addr;
    logic [32 - 1: 0] write_data;
    logic [32 - 1: 0] data;

    Mem dut(.*);


    //Setting a clock
    localparam PERIOD = 10;
    initial forever begin
            #(PERIOD/2)
            clk <= ~clk;            
    end

    initial begin
        {write_en, addr, write_data} = 0;
        //Reading
        for (int i=0; i<33; i = i+4) begin
            @(posedge clk) #1
            addr <= i;
            $display("data[%0h] = %h", addr, data );
            #10;
        end
        
        //Writing and reading
        @(posedge clk) #1
        write_en <= 1;
        @(posedge clk) #1
        addr <= 6'd4; write_data <= 32'd15;
        @(posedge clk) #1
        write_en <= 0;
        @(posedge clk) #1
        $display("data[%0h] = %h", addr, data );

        //Reading after resetting
        rst = 1; #1
        rst = 0;
        @(posedge clk) #1
        for (int i=0; i<32;i = i+4) begin
            @(posedge clk) #1
            addr <= i;
            $display("data[%0h] = %h", addr, data );
            #10;
        end
        
        $finish();
    end
endmodule