//
// Design unit  : I/O selector testbench
//              :
// File name    : io_selector_tb.sv
//              :
// Module name  : IO_Selector
//              :
// Description  : The FPGA has limited I/O pins, so setting 
//              : a unit surface to manage data in out write of
//              : intruction and data memory
//
// Version      : 2.0
//

module IO_Selector_tb;
    timeunit 10ns ; timeprecision 1ns;
    localparam WIDTH = 32;

    logic  selector;
    logic [WIDTH - 1 : 0] data_in, ins_out, mem_out;
    logic [WIDTH - 1 : 0] data_out, ins_in, mem_in;

    IO_Selector dut(.*);

    initial begin
        {selector, data_in, ins_out, mem_out, data_out, ins_in, mem_in} = 0;

        #10 ins_out <= 32'd4; mem_out <= 32'd8; data_in <= 32'd12;
        selector <= 1'b0;
        #10
        assert ((data_out == ins_out) && (ins_in == data_in))
            $display("Ins mem works");
            else $error("Assertion ins_mem failed!");

        selector <= 1'b1;
        #10
        assert ((data_out == mem_out) && (mem_in == data_in))
            $display("Data mem works");
            else $error("Assertion Data mem failed!");

        selector <= 1'bx;
        #10
        assert ((data_out == 32'bx) && (mem_in == 32'bx) && (ins_in == 32'bx))
            $display("Invalid state works");
            else $error("Assertion invalid state failed!");
        
        #(10*2)
        $finish();
    end


    
endmodule