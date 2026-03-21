module led(
    input logic clk,
    input logic rst_n,
    input logic state_i,
    output logic state_o
);

logic state;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
        state <= 0;
    end 
    else begin
        state <= state_i;
    end
end 

assign state_o = state;

endmodule