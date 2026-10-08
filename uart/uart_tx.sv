module uart_tx #(
  parameter int CLK_FREQ = 100_000_000,   // AJUSTE para o clock da sua placa
  parameter int BAUD     = 9600
)(
    input  logic clk,
    input  logic rst,          // ativo em nível alto
    input  logic ps2_clk,
    input  logic ps2_data,

    output logic tx_done,      // pulso de 1 ciclo de clk ao fim do stop bit
    output logic tx_data       // linha TX da UART (8N1), repouso em 1
);

localparam int DIV = CLK_FREQ / BAUD;

logic send;
logic flag;        // próximo scancode é o código de soltar tecla (veio F0)
logic ext_flag;    // próximo scancode é estendido (veio E0)


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
// Tecla pressionada: make code.  Solta: F0 + código.  Estendidas: E0 + código.
// Só aceita o make code de teclas não estendidas e mapeadas.
logic [7:0] ascii_out;
logic       char_valid;   // pulso: ascii_out tem um novo caractere para enviar

always_ff @( posedge clk ) begin
  if ( rst ) begin
    flag       <= 1'b0;
    ext_flag   <= 1'b0;
    ascii_out  <= 8'h00;
    char_valid <= 1'b0;
  end else begin
    char_valid <= 1'b0;

    if ( send ) begin
      if ( scancode == 8'hF0 ) begin
        flag <= 1'b1;
      end else if ( scancode == 8'hE0 ) begin
        ext_flag <= 1'b1;
      end else begin
        flag     <= 1'b0;
        ext_flag <= 1'b0;
        if ( !flag && !ext_flag && ascii != 8'h00 ) begin
          ascii_out  <= ascii;
          char_valid <= 1'b1;
        end
      end
    end
  end
end


// ---------------- TX_DATA (8N1) ----------------
// Quadro: start(0) | D0..D7 (LSB primeiro) | stop(1)
logic [9:0]                 frame;
logic [3:0]                 bit_idx;
logic                       busy;
logic [$clog2(DIV)-1:0]     baud_cnt;

logic       pending_valid;   // 1 caractere de espera se chegar um novo durante a transmissão
logic [7:0] pending_byte;

always_ff @( posedge clk ) begin
  if ( rst ) begin
    tx_data       <= 1'b1;
    tx_done       <= 1'b0;
    busy          <= 1'b0;
    bit_idx       <= '0;
    baud_cnt      <= '0;
    frame         <= '1;
    pending_valid <= 1'b0;
    pending_byte  <= '0;
  end else begin
    tx_done <= 1'b0;

    if ( !busy ) begin
      baud_cnt <= '0;
      if ( pending_valid ) begin
        frame         <= {1'b1, pending_byte, 1'b0};
        tx_data       <= 1'b0;
        busy          <= 1'b1;
        bit_idx       <= '0;
        pending_valid <= 1'b0;
      end else if ( char_valid ) begin
        frame   <= {1'b1, ascii_out, 1'b0};
        tx_data <= 1'b0;
        busy    <= 1'b1;
        bit_idx <= '0;
      end
    end else begin
      if ( char_valid ) begin
        pending_valid <= 1'b1;
        pending_byte  <= ascii_out;
      end

      if ( baud_cnt == DIV-1 ) begin
        baud_cnt <= '0;
        if ( bit_idx == 4'd9 ) begin
          busy    <= 1'b0;
          tx_done <= 1'b1;
          tx_data <= 1'b1;
        end else begin
          bit_idx <= bit_idx + 1'b1;
          tx_data <= frame[bit_idx + 1'b1];
        end
      end else begin
        baud_cnt <= baud_cnt + 1'b1;
      end
    end
  end
end

endmodule