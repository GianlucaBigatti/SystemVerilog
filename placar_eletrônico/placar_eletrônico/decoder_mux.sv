module decoder_mux (
  input logic clk,
  input logic rst,

  input logic [3:0][3:0] team_A_counter,
  input logic [3:0][3:0] team_B_counter,

  input logic [2:0] count,

  output logic [6:0] display_out
);


  logic [6:0] display;
  logic [3:0] value;

always_comb begin
  case ( count )
    3'b000: value = team_A_counter[0];
    3'b001: value = team_A_counter[1];
    3'b010: value = team_A_counter[2];
    3'b011: value = team_A_counter[3];
    3'b100: value = team_B_counter[0];
    3'b101: value = team_B_counter[1];
    3'b110: value = team_B_counter[2];
    3'b111: value = team_B_counter[3];
    default: value = '0;
  endcase

  case (value)
    4'h0: display = 7'b0000001;
    4'h1: display = 7'b1001111;
    4'h2: display = 7'b0010010;
    4'h3: display = 7'b0000110;
    4'h4: display = 7'b1001100;
    4'h5: display = 7'b0100100;
    4'h6: display = 7'b0100000;
    4'h7: display = 7'b0001111;
    4'h8: display = 7'b0000000;
    4'h9: display = 7'b0000100;
    default: display = 7'b1111111;
  endcase
end

  always_ff @( posedge clk or posedge rst ) begin
    if ( rst ) begin
      display_out <= '0;
    end else begin
      display_out <= display;
    end
  end

endmodule