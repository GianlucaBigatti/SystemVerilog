module ledBar #(parameter N_LEDS=8)(
    input clk, input rst_n,
    input logic[$clog2(N_LEDS):0] level,
    output logic[N_LEDS-1:0] leds
);

genvar i;
generate
    for(i = 0; i < N_LEDS; i++) begin : vetor_leds
        led ll(
            .clk(clk), 
            .rst_n(rst_n),
            .state_o(leds[i]),
            .state_i(i < level)
        );
    end

endgenerate
endmodule