module debouncer #(
  parameter CLK_FREQ = 100_000_000,   // Clock frequency in hz
  parameter DEBOUNCE_TIME_MS = 10     // Time in ms that the debouncer must wait for it to count as a valid signal
)(
  input logic  clk,
  input logic  rst_n,
  input loigc  data_in,   // Raw unfiltered data
  output logic pulse      // Gives off a pulse for when the button was pressed
);

  localparam COUNTER_VALUE = (CLK_FREQ / 1000) * _DEBOUNCE_TIME_MS;   // Defines the value that the counter must count to, to reach the desired time delay
  localparam COUNTER_SIZE = $clog2(COUNTER_VALUE + 1);                // Size of the array necessary to represent the counter value

  logic [COUNTER_SIZE-1:0] counter;   // counts until the time in ms has passed
  
  logic reg_a;       // stores a filtered version of the raw input "data"
  logic reg_b;       // stores a delayed version of reg_a


  always_ff @( posedge clk or negedge rst_n ) begin
    if (!rst_n) begin
      reg_a <= 1'b0;
      reg_b <= 1'b0;
    end else begin
      reg_a <= data;
    end
  end

  always_ff @( posedge clk or negedge rst_n ) begin
    if (!rst_n) begin
      counter  <= '0;
      data_out <= 1'b0;
    end else begin
      if (reg_b != reg_a) begin
        counter++;
        if (counter >= COUNTER_VALUE) begin
          reg_b <= reg_a;
          counter  <= '0;
        end
      end else begin
        counter <= '0;
      end
    end
  end

  assign pulse = reg_a & ~reg_b;
  
endmodule
