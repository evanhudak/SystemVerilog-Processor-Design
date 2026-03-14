module up3_cu(
    input logic CLK, RESET,
    output logic FETCH, LOAD_IRU, LOAD_IRL, INCR_PC, LOAD_PC, STORE_MEM, LOAD_AC,
    output logic [3:0] STATE,
    output logic [7:0] PC, address, AC, opcode, MDR, value
);
   
    logic [7:0] z;
    logic ZFLG, NFLG;
   
    // Control Unit
    control control_unit (
        .CLK(CLK),
        .RESET(RESET),
        .opcode(opcode),
        .NFLG(NFLG),
        .ZFLG(ZFLG),
        .STATE(STATE),
        .FETCH(FETCH),
        .LOAD_AC(LOAD_AC),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_IRL(LOAD_IRL),
        .LOAD_PC(LOAD_PC),
        .INCR_PC(INCR_PC),
        .STORE_MEM(STORE_MEM)
    );
   
    // Program Counter (PC)
    pc program_counter (
        .CLK(CLK),
        .RESET(RESET),
        .LOAD_PC(LOAD_PC),
        .INCR_PC(INCR_PC),
        .ADDR_VALUE_BUS(value),
        .PC(PC)
    );
   
    // Instruction Register (IR)
    ir instruction_register (
        .CLK(CLK),
        .RESET(RESET),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_IRL(LOAD_IRL),
        .MDR(MDR),
        .IRU(opcode),
        .IRL(value)
    );
   
    // Accumulator (AC)
    ac accumulator (
        .CLK(CLK),
        .LOAD_AC(LOAD_AC),
        .Z_BUS(z),
        .AC(AC)
    );
   
    // ALU
    alu arithmetic_logic_unit (
        .opcode(opcode),
        .ac(AC),
        .mdr(MDR),
        .value(value),
        .z(z),
        .zflg(ZFLG),
        .nflg(NFLG)
    );
   
    // Address Multiplexer (8-bit 2-to-1 Mux)
    mux2by1 addr_mux (
        .sel(FETCH),
        .in0(value),
        .in1(PC),
        .out(address)
    );
   
    // RAM
    ramup3 RAM (
        .address(address),
        .clock(CLK),
        .data(AC),
        .wren(STORE_MEM),
        .q(MDR)
    );
   
endmodule
