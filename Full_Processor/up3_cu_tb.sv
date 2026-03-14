module up3_cu_tb(
    input logic [3:0] KEY,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    output logic [9:0] LEDR
);
    logic [7:0] dat0, dat1, dat2, PC, address, MDR, AC, opcode, value;
    logic LOAD_IRU, LOAD_IRL, LOAD_PC, INCR_PC, LOAD_AC, STORE_MEM, FETCH;
    logic NFLG, ZFLG;
    logic [3:0] STATE;

    // Instantiate the UP3 Control Unit
    up3_cu myup3_cu(
        .CLK(KEY[0]),
        .RESET(~KEY[1]),
        .LOAD_AC(LOAD_AC),
        .LOAD_PC(LOAD_PC),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_IRL(LOAD_IRL),
        .INCR_PC(INCR_PC),
        .STORE_MEM(STORE_MEM),
        .FETCH(FETCH),
        .AC(AC),
        .PC(PC),
        .opcode(opcode),
        .value(value),
        .MDR(MDR),
        .address(address),
        .STATE(STATE)
    );
   
    // Instantiate 7-segment display modules
    dualseg7 left(.data(dat0), .left_out(HEX5), .right_out(HEX4));
    dualseg7 mid(.data(dat1), .left_out(HEX3), .right_out(HEX2));
    dualseg7 right(.data(dat2), .left_out(HEX1), .right_out(HEX0));
   
    always_comb begin
	     LEDR = 10'b0;
        LEDR[9] = KEY[3];
        if (KEY[3]) begin
            dat0 = PC;
            dat1 = address;
            dat2 = MDR;
            LEDR[8:7] = STATE[3:2]; // Optional debugging bits
            LEDR[6] = LOAD_AC;
            LEDR[5] = LOAD_IRU;
            LEDR[4] = LOAD_IRL;
            LEDR[3] = LOAD_PC;
            LEDR[2] = INCR_PC;
            LEDR[1] = FETCH;
            LEDR[0] = STORE_MEM;
        end
		  else begin
            dat0 = opcode;
            dat1 = value;
            dat2 = AC;
            LEDR[3:0] = STATE;
        end
    end
endmodule