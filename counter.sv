module counter_8bit (
    input  logic clk, rst,
    output logic [7:0] count
);

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        count <= 8'b00000000;
    else
        count <= count + 1;
end
endmodule