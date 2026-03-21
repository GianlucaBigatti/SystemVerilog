`timescale 1ns/1ns

module tb_ledBar;

    parameter N_LEDS = 8;

    logic                   clk;
    logic                   rst_n;
    logic [$clog2(N_LEDS):0]  level;
    logic [N_LEDS-1:0]      leds;

    ledBar #(N_LEDS) dut (
        .clk(clk),
        .rst_n(rst_n),
        .level(level),
        .leds(leds)
    );

    initial clk = 0;
    always #5 clk = !clk;

    initial begin
        rst_n = 1'b0;
        level = 0;

        repeat(5) @(posedge clk);

        @(posedge clk);
        rst_n = 1'b1;

        repeat(2) @(posedge clk);

        #5  //time delayed
      
        @(posedge clk);
        level = 3;

        @(posedge clk);
        level = 1;

        @(posedge clk);
        level = 2;

        @(posedge clk);
        level = 4;

        @(posedge clk);
        level = 6;

        @(posedge clk);
        level = 8;

        repeat(5) @(posedge clk);
    end

endmodule