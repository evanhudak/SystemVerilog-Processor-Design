module control (
    input logic CLK,
    input logic RESET,
    input logic [7:0] opcode,
    input logic NFLG,
    input logic ZFLG,
    output logic FETCH,
    output logic INCR_PC,
    output logic LOAD_IRU,
    output logic LOAD_IRL,
    output logic LOAD_AC,
    output logic LOAD_PC,
    output logic STORE_MEM,
    output logic [3:0] STATE
);

    typedef enum logic [3:0] {
        START, PREPU, FETCHU, PREPL, FETCHL,
        READ, EXEC, STORE, JUMP
    } state_t;

    state_t state, nextstate;

    always_ff @(posedge CLK or posedge RESET) begin
        if (RESET)
            state <= START;
        else
            state <= nextstate;
    end

    // Next state logic
    always_comb begin
        case (state)
            START: nextstate = PREPU;
            PREPU: nextstate = FETCHU;
            FETCHU:
                case (opcode)
                    8'h00: nextstate = PREPU;
                    8'h04: nextstate = EXEC;
                    default: nextstate = PREPL;
                endcase
            PREPL: nextstate = FETCHL;
            FETCHL: case (opcode)
                8'h01, 8'h05, 8'h07, 8'h09, 8'h0A, 8'h0B, 8'h0C, 8'h0D: nextstate = READ;
                8'h02, 8'h06, 8'h08, 8'h0E, 8'h0F: nextstate = EXEC;
                8'h03: nextstate = STORE;
                8'h10: nextstate = JUMP;
                8'h11: nextstate = (NFLG) ? JUMP : PREPU;
                8'h12: nextstate = (NFLG) ? PREPU : JUMP;
                8'h13: nextstate = (ZFLG) ? JUMP : PREPU;
                8'h14: nextstate = (ZFLG) ? PREPU : JUMP;
                default: nextstate = PREPU;
            endcase
            READ: nextstate = EXEC;
            EXEC: nextstate = PREPU;
            STORE: nextstate = PREPU;
            JUMP: nextstate = PREPU;
            default: nextstate = START;
        endcase
    end

    // Output logic
    assign FETCH = (state == PREPU || state == FETCHU || state == PREPL || state == FETCHL);
    assign INCR_PC = (state == FETCHU || state == FETCHL);
    assign LOAD_IRU = (state == FETCHU);
    assign LOAD_IRL = (state == FETCHL);
    assign LOAD_AC = (state == EXEC);
    assign LOAD_PC = (state == JUMP);
    assign STORE_MEM = (state == STORE);
    assign STATE = state;

endmodule