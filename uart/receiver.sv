module receiver (
  input  logic       clk,
  input  logic       rst,       // ativo em nível alto
  input  logic       ps2_clk,
  input  logic       ps2_data,

  output logic       send,      // pulso de 1 ciclo de clk: scancode válido
  output logic [7:0] scancode
);

  logic [3:0] receive_count;

// ---------------- SYNC LOGIC ----------------


// -------- CLK --------
  logic [1:0] ps2_clk_sync;
  logic       ps2_clk_sync_delayed;
  logic       ps2_clk_negedge;

  always_ff @( posedge clk ) begin : SYNC_CLKs
    if ( rst ) begin
      ps2_clk_sync         <= '1;
      ps2_clk_sync_delayed <= 1'b1;
    end else begin
      ps2_clk_sync         <= {ps2_clk_sync[0], ps2_clk};
      ps2_clk_sync_delayed <= ps2_clk_sync[1];
    end
  end

  assign ps2_clk_negedge = ( !ps2_clk_sync[1] && ps2_clk_sync_delayed );

// -------- DATA --------
  logic [1:0] ps2_data_sync;

  always_ff @( posedge clk ) begin : SYNC_DATA
    if ( rst ) begin
      ps2_data_sync <= '1;
    end else begin
      ps2_data_sync <= { ps2_data_sync[0], ps2_data };
    end
  end


// ---------------- State Logic ----------------
  typedef enum logic [1:0] {
    WAIT    = 2'b00,
    RECEIVE = 2'b01,
    DONE    = 2'b10
  } state_t;

  state_t current_state, next_state;

  always_comb begin : FSM_COMB
    next_state = WAIT;
    case ( current_state )
      WAIT: begin
        if ( !ps2_data_sync[1] ) next_state = RECEIVE;
        else                     next_state = WAIT;
      end
      RECEIVE: begin
        if ( receive_count == 4'd11 ) next_state = DONE;
        else                          next_state = RECEIVE;
      end
      DONE:    next_state = WAIT;
      default: next_state = WAIT;
    endcase
  end


// ---------------- FSM_SEQUENTIAL ----------------
  logic [8:0] ps2_data_interno;
  logic       parity;

  always_ff @( posedge clk ) begin : FSM_SEQ
    if ( rst ) begin
      current_state    <= WAIT;
      receive_count    <= '0;
      ps2_data_interno <= '0;
      parity           <= 1'b0;
      send             <= 1'b0;
      scancode         <= '0;
    end else begin
      current_state <= next_state;

      case ( current_state )

      // -------- WAIT --------
        WAIT: begin
          receive_count <= '0;
          parity        <= 1'b0;
          send          <= 1'b0;
        end

      // -------- RECEIVE --------
        RECEIVE: begin
          if ( ps2_clk_negedge ) begin
            if ( receive_count > 0 && receive_count < 10 ) begin
              ps2_data_interno[receive_count-1] <= ps2_data_sync[1];
              parity <= ( parity ^ ps2_data_sync[1] );   // dados ^ paridade == 1 -> paridade ímpar OK
            end
            receive_count <= receive_count + 1'b1;
          end
        end

      // -------- DONE --------
        DONE: begin
          if ( parity ) begin
            scancode <= ps2_data_interno[7:0];
            send     <= 1'b1;
          end
        end

        default: ;
      endcase
    end
  end

endmodule