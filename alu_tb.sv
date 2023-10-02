//
// Design unit  : Arithmetic and logic unit testbench
//              :
// File name    : alu_tb.sv
//              :
// Module name  : ALU_tb
//              :
// Description  : Testbench for 32 bit ALU of RISC V processor
//              : 
// Version      : 3.0 (Adding instructions to work with Branch and multiplication)
//

module ALU_tb;

    timeunit 10ns ; timeprecision 1ns;
    localparam WIDTH =32;

    logic[3:0] control;
    logic signed [WIDTH - 1: 0] src_a, src_b;
    logic zero;
    logic signed [WIDTH - 1: 0] out;

    ALU dut(.*);

    initial begin
        {control, src_a, src_b} = 0;
        //*SB type
        #10 src_a <= 32'd9; src_b <= 32'd8; control <= 4'b0111;
        #1 
        assert (out == (32'd0))
            $display("Not equal works!");
            else $error("Assertion Not equal failed!");
        
        #10 src_a <= 32'd9; src_b <= 32'd10; control <= 4'b0100;
        #1 
        assert (out == (32'd0))
            $display("Less than works!");
            else $error("Assertion Less than failed!");

        #10 src_a <= 32'd9; src_b <= 32'd8; control <= 4'b0101;
        #1 
        assert (out == (32'd0))
            $display("Greater than or equal works!");
            else $error("Assertion Greater than or equal failed!");

        #10 src_a <= 32'd8; src_b <= 32'ha00000; control <= 4'b1100;
        #1 
        assert (out == (32'd0))
            $display("Less than unsigned works!");
            else $error("Assertion Less than unsigned failed!");

        #10 src_a <= 32'ha00000; src_b <= 32'd0; control <= 4'b1101;
        #1 
        assert (out == (32'd0))
            $display("Greater than or equal unsigned works!");
            else $error("Assertion Greater than or equal unsigned failed!");

        //*Unsinged multiplication
        #10 src_a <= 32'ha000_0000; src_b <= 32'd1; control <= 4'b1010;
        #1 
        //assert (out == (32'd0))
            $display("out = %b", out);
            //else $error("Assertion Greater than or equal unsigned failed!");


        //*R type
        #10 src_a <= 32'd9; src_b <= 32'd8; control <= 4'b0000;
        #1 
        assert (out == (src_a & src_b))
            $display("And works!");
            else $error("Assertion And failed!");

        #10 src_a <= 32'd8; src_b <= 32'd4; control <= 4'b0001;
        #1
        assert (out == src_a | src_b)
            $display("OR works!");
            else $error("Assertion OR failed!");   

        #10 src_a <= 32'hf000; src_b <= 32'h000f; control <= 4'b0011;
        #1
        assert (out == (src_a ^ src_b))
            $display("XOR works!");
            else $error("Assertion XOR failed!");  

        #10 src_a <= 32'hf000_0000; src_b <= 32'h0000_000f; control <= 4'b0010;
        #1
        assert (out == src_a + src_b)
            $display("Add works!");
            else $error("Assertion Add failed!");   

        #10 src_a <= 32'd8; src_b <= 32'd4; control <= 4'b0110;
        #1
        assert (out == src_a - src_b)
            $display("SUB works!");
            else $error("Assertion SUB failed!"); 

        #10 src_a <= 32'b1; src_b <= 32'd4; control <= 4'b1000;
        #1
        assert (out == (src_a << src_b))
            $display("SLL works!");
            else $error("Assertion SLL failed!");  

        #10 src_a <= 32'h8; src_b <= 32'd3; control <= 4'b1001;
        #1
        assert (out == (src_a >> src_b))
            $display("SRL works!");
            //$display("SRL works!, src_a = %b, out = %b",src_a,out);
            else $error("Assertion SRL failed!");  

        #10 src_a <= 32'h8000_0000; src_b <= 32'd1; control <= 4'b1011;
        #1
        assert (out == (src_a) >>> src_b)
            $display("SRA works!, out = %h", out);
            else $error("Assertion SRA failed, out = %b, check = %b", out, src_a >>> src_b); 
        //$display("src_a = %b, out = %b",src_a ,out);        

        #10 src_a <= 32'h9000_0000; src_b <= 32'd4; control <= 4'b1111;
        #1
        assert (out == 1)
            $display("SLT works!, out = %h", out);
            else $error("Assertion SLT failed"); 

        #10 src_a <= 32'h9000_0000; src_b <= 32'd4; control <= 4'b1110;
        #1
        assert (out == 0)
            $display("SLTU works!, out = %h", out);
            else $error("Assertion SLTU failed");
              

        #20
        $finish();
    end
    
endmodule