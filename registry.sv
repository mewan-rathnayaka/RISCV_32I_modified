//
// Design unit  : Internal registry
//              :
// File name    : registry.sv
//              :
// Module name  : Registry
//              :
// Description  : Internal registry for RISC 32I processor
//              : 32 * 32 bit
//

module Registry #(parameter WIDTH = 32, DEPTH = 32) (
    input logic clk, write_en,
    input logic [$clog2(DEPTH) -1:0] rs1,
    input logic [$clog2(DEPTH) -1:0] rs2,
    input logic [$clog2(DEPTH) -1:0] rd,
    input logic [WIDTH - 1 : 0]  write_data,
    output logic [WIDTH - 1 : 0] data_1, data_2
);

    //Setting the registry
    logic [WIDTH - 1 : 0] registry [0: DEPTH - 1];
    //Setting registry funtions
    initial begin
        $readmemh("registry.dat",registry);
        registry[0] <= 32'd0;    
        //Check and complete     
    end

    always_comb begin
        data_1 = registry[rs1];
        data_2 = registry[rs2];      
    end
    always_ff @(posedge clk ) begin
        if (write_en) begin
            registry[rd] <= write_data;
        end
    end
    
endmodule