module uart_tx (
    input logic clk,
    input logic rst,
    input logic ps2_clk,
    input logic ps2_data,

    output logic tx_done,
    output logic tx_data
);

logic clk_9600;
logic send;
logic flag;


// ---------------- RECEIVER ----------------
logic [7:0] scancode;

receiver receiver (
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .send(send),
    .scancode(scancode)
);



// ---------------- DECODER ASCII ABNT2 ----------------
logic [7:0] ascii;
decoder_ascii_abnt2 decoder (
  .scancode(scancode),
  .ascii(ascii)
);



// ---------------- DOUBLE LETTER CASE ----------------
logic [7:0] ascii_out;
always_ff @( posedge clk, posedge rst ) begin
  if ( scancode != 8'hf0 ) begin
      if ( send ) begin
          if ( !flag ) begin
              ascii_out <= ascii;
          end else begin
              flag <= 1'b0;
          end
      end
  end else begin
      lag <= 1'b1;
  end
end


// ---------------- CLK DIVIDER ----------------
logic [12:0] clk_divider;

always_ff @( posedge clk, negedge rst_n ) begin
  if ( !rst_n ) begin
    clk_divider <= '0;
    clk_9600    <= '0;
  end else begin
    if ( clk_divider >= 13'd5208 ) begin
      clk_divider <= '0;
      clk_9600    <= ~clk_9600;
    end else begin
      clk_divider <= clk_divider + 1'b1;
    end
  end
end



// ---------------- TX_DATA ----------------
logic [2:0] count; 
always_ff @( posedge clk_9600 ) begin
  if( send ) begin
    if( count == '1 ) begin
      tx_data <= ascii_out[count];
      count <= count + 1'b1;
      tx_done <= 1'b1;
    end else begin
      tx_done <= 1'b0;
      tx_data <= ascii_out[count];
      count <= count + 1'b1;
    end
  end
end
endmodule