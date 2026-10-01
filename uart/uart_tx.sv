module uart_tx (
    input logic clk,
    input logic rst,
    input logic ps2_clk,
    input logic ps2_data,

    output logic tx_done,
    output logic tx_data
);

logic clk_9600;
logic send;
logic flag;


receiver receiver (
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .send(send),
    .scancode(scancode)
);



if ( scancode != 8'hf0 ) begin
    if ( send ) begin
        if ( !flag ) begin
            displays[0] <= scancode;
            displays[1] <= displays[0];
            displays[2] <= displays[1];
            displays[3] <= displays[2];
            displays[4] <= displays[3];
            displays[5] <= displays[4];
            displays[6] <= displays[5];
            displays[7] <= displays[6];
        end else begin
            flag <= 1'b0;
        end
    end
end else begin
    lag <= 1'b1;
end


endmodule