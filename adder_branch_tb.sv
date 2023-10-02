//
// Design unit  : Branching adder testbench
//              :
// File name    : adder_branch_tb.sv
//              :
// Module name  : Adder_Branch_tb
//              :
// Description  : Testbench for branching adder
//              : 
//

module Adder_Branch_tb;

    timeunit 10ns ; timeprecision 1ns;
    localparam WIDTH = 32,
               DEPTH = 64;

    logic [WIDTH - 1 : 0] pc_in;
    logic [WIDTH - 1 : 0] branch;
    logic [WIDTH - 1 : 0] out;

    Adder_Branch dut(.*);

    initial begin
        {pc_in,branch} = 0;

        #10 pc_in <= 6'd4;  branch <= 32'd4;
        #1
        assert (out == 6'd8)
            $display("Correct_1");
            else $error("Assertion failed!");

        #10 pc_in <= 6'd8;  branch <= 32'd4;
        #1
        assert (out == 6'd12)
            $display("Correct_2");
            else $error("Assertion failed!");        

        #20
        $finish();
    end



endmodule
