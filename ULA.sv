module ULA (
    input logic clk,
    input logic [3:0]   sort_i,
    input logic [7:0]   a,
    input logic [7:0]   b,
    output logic [7:0]  out,
    output logic [7:0]  out_2;
    
);

always_ff @(posedge clk) begin : ula
    case (sort_i)
        001 : {out_2, out} <= ADD(a, b);
        010 : 
        011 : 
        100 : 
        101 : 
        110 : 
        default: 
    endcase
end

    
endmodule