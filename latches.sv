always_comb begin
    case (opcode)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        default: result = -1;
    endcase
end

always_comb begin
    case (sel)
        2'00: y = a;
        2'01: y = b;
        default: y = 0;
    endcase
end

always_ff @(posedge clk) begin
    if (enable) begin
        x <= data_in;
        valid <= 1;
    end
end

module problematic (
    input logic clk,
    input logic a, b,

    output logic y
);

    logic temp;
    always_ff @( posedge clk ) begin
        temp = a & b;
        if (temp)
            y <= ~y;
        else
            y <= 1'b0;
    end
endmodule

typedef enum logic [1:0] {IDLE, CHECK, DISPENSE, CHANGE} state;



// Implemente a FSM garantindo valores default
// para TODAS as saidas em TODOS os estados