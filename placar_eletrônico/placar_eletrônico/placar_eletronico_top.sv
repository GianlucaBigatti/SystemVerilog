module placar_top (
  input logic clk,
  input logic rst,

  input logic incr_a,
  input logic incr_b,

  input logic decr_a,
  input logic decr_b,

  output logic [7:0] display_en,
  output logic [6:0] display
);


// ---------------- Clock Divider ----------------
logic clk_display;
clock_divider #(
  .DIVISOR(100000),
  .DUTY_CYCLE(50)
  //.CLK_IN_FREQ(100_000_000),
  //.CLK_OUT_FREQ(1)
) div (
  .clk_in(clk),
  //.rst(rst),
  .clk_out(clk_display)
);


// ---------------- Debouncer incr_a ----------------
  logic incr_a_pulse;
  debouncer #( 
    .CLK_FREQ(100_000_000),
    .DEBOUNCE_TIME_MS(10)
  ) debouncer_incr_a (
    .clk(clk),
    .rst(rst),
    .data_in(incr_a),
    .pulse(incr_a_pulse)
  );

// ---------------- Debouncer incr_b ----------------
  logic incr_b_pulse;
  debouncer #(
    .CLK_FREQ(100_000_000),
    .DEBOUNCE_TIME_MS(10)
  ) debouncer_incr_b (
    .clk(clk),
    .rst(rst),
    .data_in(incr_b),
    .pulse(incr_b_pulse)
  );

// ---------------- Debouncer decr_a ----------------
  logic decr_a_pulse;
  debouncer #(
    .CLK_FREQ(100_000_000),
    .DEBOUNCE_TIME_MS(10)
  ) debouncer_decr_a (
    .clk(clk),
    .rst(rst),
    .data_in(decr_a),
    .pulse(decr_a_pulse)
  );

// ---------------- Debouncer decr_b ----------------
  logic decr_b_pulse;
  debouncer #(
    .CLK_FREQ(100_000_000),
    .DEBOUNCE_TIME_MS(10)
  ) debouncer_decr_b (
    .clk(clk),
    .rst(rst),
    .data_in(decr_b),
    .pulse(decr_b_pulse)
  );



// ---------------- Equipe A counter ----------------
  logic [3:0][3:0] team_A_counter;
  contador_equipe contador_equipe_a (
    .clk(clk),
    .rst(rst),
    .incr(incr_a_pulse),
    .decr(decr_a_pulse),
    .team_counter(team_A_counter)
  );

// ---------------- Equipe A counter ----------------
  logic [3:0][3:0] team_B_counter;
  contador_equipe contador_equipe_b (
    .clk(clk),
    .rst(rst),
    .incr(incr_b_pulse),
    .decr(decr_b_pulse),
    .team_counter(team_B_counter)
  );



// ---------------- Controle da Multiplexacao ----------------
  logic [2:0] count_seven;
  controle_da_multiplexacao dut (
    .clk(clk_display),
    .rst(rst),
    .out(count_seven)
  );



// ---------------- Decoder display_en ----------------
// logic [7:0] display_en_comb;
//   always_ff @( posedge clk_display ) begin
//     display_en <= display_en_comb;
//   end
  
  assign display_en = ~(8'b00000001 << count_seven);



// ---------------- Decoder e Mux ----------------
  decoder_mux decoder_display (
    .clk(clk),
    .rst(rst),
    .count(count_seven),
    .team_A_counter(team_A_counter),
    .team_B_counter(team_B_counter),
    .display_out(display)
  );

endmodule
