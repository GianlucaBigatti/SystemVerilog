module contador_equipe (
  input  logic clk,
  input  logic rst,

  input  logic incr,
  input  logic decr,

  output logic [3:0][3:0] team_counter
);
  logic [3:0][3:0] counter;

  assign team_counter = counter;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= '0;
    end else if (incr) begin
      if (counter[0] == 4'b1001) begin
        counter[0] <= '0;
        if (counter[1] == 4'b1001) begin
          counter[1] <= '0;
          if (counter[2] == 4'b1001) begin
            counter[2] <= '0;
            if (counter[3] != 4'b1001) counter[3] <= counter[3] + 1'b1;
          end else begin
            counter[2] <= counter[2] + 1'b1;
          end
        end else begin
          counter[1] <= counter[1] + 1'b1;
        end
      end else begin
        counter[0] <= counter[0] + 1'b1;
      end
    end else if (decr) begin
  if (counter[0] != '0) begin
    counter[0] <= counter[0] - 1'b1;
  end else begin
    counter[0] <= 4'b1001;
    if (counter[1] != '0) begin
      counter[1] <= counter[1] - 1'b1;
    end else begin
      counter[1] <= 4'b1001;
      if (counter[2] != '0) begin
        counter[2] <= counter[2] - 1'b1;
      end else begin
        counter[2] <= 4'b1001;
        if (counter[3] != '0) begin
          counter[3] <= counter[3] - 1'b1;
        end else begin
          couter[3] <= 4'1001;
        end
      end
    end
  end
  end
end
endmodule
