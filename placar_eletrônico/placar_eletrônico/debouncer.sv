module debouncer #(
  parameter CLK_FREQ = 100_000_000,
  parameter DEBOUNCE_TIME_MS = 10
)(
  input  logic clk,
  input  logic rst,
  input  logic data_in,
  output logic pulse
);

  localparam COUNTER_VALUE = (CLK_FREQ / 1000) * DEBOUNCE_TIME_MS;
  localparam COUNTER_SIZE  = $clog2(COUNTER_VALUE + 1);

  logic [COUNTER_SIZE-1:0] counter;
  logic reg_a;       // amostra do data_in
  logic reg_b;       // valor debounced
  logic reg_b_prev;  // valor debounced no ciclo anterior (p/ detectar borda)

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_a      <= 1'b0;
      reg_b      <= 1'b0;
      reg_b_prev <= 1'b0;
      counter    <= '0;
    end else begin
      reg_a      <= data_in;
      reg_b_prev <= reg_b;

      if (reg_b != reg_a) begin
        if (counter >= COUNTER_VALUE - 1) begin
          reg_b   <= reg_a;
          counter <= '0;
        end else begin
          counter <= counter + 1;
        end
      end else begin
        counter <= '0;
      end
    end
  end

  assign pulse = reg_b & ~reg_b_prev; // pulso de 1 ciclo na borda de subida do sinal debounced

endmodule
