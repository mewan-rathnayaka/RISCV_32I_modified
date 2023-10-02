//
// Design unit  : Arithmetic and logic unit
//              :
// File name    : alu.sv
//              :
// Module name  : ALU
//              :
// Description  : 32 bit ALU for RISC V processor
//              : 
// Version      : 3.0 (Adding instructions to work with Branch )
//

module ALU #(parameter WIDTH = 32) (
    input logic [3:0] control,
    input logic signed [WIDTH - 1: 0] src_a, src_b,
    output logic zero,
    output logic signed [WIDTH - 1: 0] out
);
    always_comb begin
        case (control)
            4'b0000:out = src_a & src_b;            //AND
            4'b0001:out = src_a | src_b;            //OR
            4'b0011:out = src_a ^ src_b;            //XOR
            
            
            4'b0010:out = src_a + src_b;            //ADD
            4'b0110:out = src_a - src_b;            //SUB
            
            
            4'b1000:out = src_a << src_b;           //SLL
            4'b1001:out = src_a >> src_b;           //SRL
            4'b1011:out = src_a >>> src_b;          //SRA

            4'b1111:out = (src_a < src_b) ? 32'd1 : 32'd0;           //SLT
            //Any operation with an unsgined value will make result unsigned
            4'b1110:out = (src_a*1'b1 < src_b*1'b1) ? 32'd1 : 32'd0; //SLTU

            //For branching
            //Not equal
            4'b0111:out = (src_a != src_b) ? 32'd0 : 32'dx;   //NEQ
            //Less than 
            4'b0100:out = (src_a < src_b)  ? 32'd0 : 32'dx;   //LST
            //greater than or equal
            4'b0101:out = (src_a >= src_b) ? 32'd0 : 32'dx;   //GTE

            //Less than unsigned
            4'b1100:out = (src_a*1'b1 < src_b*1'b1)  ? 32'd0 : 32'dx;   //LSTU
            //greater than or equal unsigned
            4'b1101:out = (src_a*1'b1 >= src_b*1'b1) ? 32'd0 : 32'dx;   //GTEU

            //Unsigned multiplication
            4'b1010:out = src_a*1'b1 * src_b*1'b1;          //UMUL

            default: begin
                out = {32{1'bx}};
            end
        endcase
    end

    //Setting zero output
    assign zero = (out == 32'd0) ? 1 : 0;

endmodule


