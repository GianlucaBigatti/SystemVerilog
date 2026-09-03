module controle_da_multiplexação (
    input clk,
    input rst,

    output [2:0] out
);

    logic [2:0] count;

    always_ff @( posedge clk || posedge rst ) begin
        if (rst) begin
            count <= '0;
        end else begin
            count++;
        end
    end

    assign out = count;

endmodule
