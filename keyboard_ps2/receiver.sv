module receiver (
  input logic clk,
  input logic rst,
  input logic ps2_clk,
  input logic ps2_data,

  input logic begin,

  output logic [7:0] scancode
);

// ---------------- State Logic ----------------
  typedef enum logic { 
    WAIT    = 1'b0,
    RECEIVE = 1'b1,
  } state_t;

  state_t current_state, next_state;

  always_comb begin : FSM_COMB
    case ( current_state )
      WAIT:    next_state = ( !ps2_data ) ? RECEIVE : WAIT;
      RECEIVE: next_state = ( receive_count == 4'b1011 ) ? WAIT : RECEIVE;
      default: next_state = WAIT;
    endcase
  end


// ---------------- ps2_clk logic ----------------
  logic ps2_clk_sync;
  logic ps2_clk_sync_delayed;
  logic ps2_clk_negedge;

  always_ff @( posedge clk ) begin : SYNC_CLKs
    ps2_clk_sync <= ps2_clk;
    ps2_clk_sync_delayed <= ps2_clk_sync;
  end

  assign ps2_clk_negedge = ( !ps2_clk_sync and ps2_clk_sync_delayed );


// ---------------- FSM_SEQUENTIAL ----------------
  logic [3:0] receive_count;
  logic [10:0] ps2_data_interno;

  always_ff @( posedge clk ) begin : FSM_SEQ
    case ( current_state )

    // -------- WAIT --------
      WAIT: begin
        scancode <= ps2_data_interno;
        receive_count <= '0;
      end

    // -------- RECEIVE --------
      RECEIVE: begin
        if ( ps2_clk_negedge ) begin
          receive_count <= receive_count + 1'b1;
          ps2_data_interno[receive_count] <= ps2_data;
        end
      end

    // -------- DEFAULT --------
      default: receive_count <= '0;
    endcase
  end

endmodule
