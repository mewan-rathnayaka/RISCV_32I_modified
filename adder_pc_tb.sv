//
// Design unit  : Adder_PC testbench
//              :
// File name    : adder_pc_tb.sv
//              :
// Module name  : Adder_PC_tb
//              :
// Description  : Testbench for adder_pc 
//              : 
// Version      : 3.0 Change to test byte addressability
//              : 
//

module Adder_PC_tb;

    timeunit 10ns ; timeprecision 1ns;
    localparam WIDTH = 32;
    logic [WIDTH - 1 : 0] in;
    logic [WIDTH - 1 : 0] out;

    Adder_PC dut(.*);

    initial begin
        in = 6'd0;
        #10 in <= 6'd3;
        #10
        assert (out == 6'd7)
            $display("Correct-1");
            else $error("Assertion failed!");

        #10 in <= 6'd43;
        #10
        assert (out == 6'd47)
            $display("Correct-2");
            else $error("Assertion failed!");

        #20    
        $finish();
    end
    
endmodule