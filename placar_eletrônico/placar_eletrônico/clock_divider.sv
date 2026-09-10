/*
module clock_divider #(
  parameter CLK_IN_FREQ  = 100_000_000,
  parameter CLK_OUT_FREQ = 1000
)(
  input logic clk_in,
  input logic rst,

  output logic clk_out
);

localparam CLK_DIVISOR = $clog2((CLK_IN_FREQ / CLK_OUT_FREQ) / 2);

logic [CLK_DIVISOR-1:0] count;

always_ff @( posedge clk_in or posedge rst ) begin
  if ( rst ) begin
    count <= '0;
    clk_out <= '0;
  end else begin
    if ( count == CLK_DIVISOR ) begin
      count <= '0;
      clk_out <= ~clk_out;
    end else begin
      count++;
    end
  end
end

endmodule
*/

module clock_divider
#(
	parameter int	DIVISOR		= 10,
	parameter int	DUTY_CYCLE	= 50
)(
	input	logic	clk_in,
	output	logic	clk_out
);

	const real	DUTY_CYCLE_CALC	= real'(DIVISOR)*(real'(DUTY_CYCLE) / 100);	// duty cycle calculado.
	int			cont			= 0;										// contador da divisão.

	// referência da divisão.
	always_ff @(posedge clk_in)
	begin
		if (cont < DIVISOR-1)
			cont <= cont + 1;
		else
			cont <= 0;
			
		if (cont < int'(DUTY_CYCLE_CALC))
			clk_out	<= 1'b1;
		else
			clk_out	<= 1'b0;
			
	end


endmodule
