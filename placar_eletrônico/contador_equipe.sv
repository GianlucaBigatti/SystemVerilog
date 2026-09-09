module contador_equipe (
  input logic clk,
  input logic rst,

  input logic incr,
  input logic decr,

  output logic [3:0][3:0] team_counter
);
  logic [3:0][3:0] counter;

  assign team_counter = counter;

  always_ff @( posedge clk || posedge rst ) begin
    if (rst) begin
      counter <= '0;
    end else if (incr) begin
      if ( counter[0] == 4'b1001 ) begin
          counter[0] <= '0;
          counter[1]++;
      end
      if ( counter[1] == 4'b1001 ) begin
          counter[1] <= '0;
          counter[2]++;
      end
      if ( counter[2] == 4'b1001 ) begin
          counter[2] <= '0;
          counter[3]++;
      end
    end else if (decr) begin
      if ( counter[0] != '0 ) begin
        counter[0]--;
      end else begin
        if ( counter[1] != '0 ) begin
          counter[1]--;
          counter[0] <= 4'b1001;
        end else begin
          if ( counter[2] != '0 ) begin
            counter[2]--;
            counter[1] <= 4'b1001;
          end else begin
            if ( counter[3] != '0 ) begin
              counter[3]--;
              counter[2] <= 4'b1001;
            end
          end
        end
      end
    end
  end
    
endmodule
