`timescale 1ns/1ps

module tb_counter_8bit;

    logic clk, rst;
    logic [7:0] count;

    counter_8bit dut (
        .clk(clk), .rst(rst), .count(count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst =   1'b1;

        repeat(5) @(posedge clk);

        @(posedge clk);
        rst = 1'b0;

        repeat(2) @(posedge clk);

        #256;

        assert (count < 255)
            else $error("overload %d", count);

        $display("Simulação concluida");
    end
endmodule