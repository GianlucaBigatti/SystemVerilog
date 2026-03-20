module ADD (
    input logic     [7:0]   a,
    input logic     [7:0]   b,
    output logic            c_out
    output logic    [7:0]   sum;
) (
    always @ (a || b) begin
        {c_out, sum} <= a + b;
    end
);

endmodule