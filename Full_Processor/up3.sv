module up3 (
    input  logic        CLK,
	 input  logic			RESET,
    input  logic        FETCH,
	 input  logic			LOAD_AC,
	 input  logic			LOAD_IRU,
	 input  logic			LOAD_IRL,
	 input  logic			LOAD_PC,
	 input  logic			INCR_PC,
	 input  logic			STORE_MEM,
    output logic [7:0]  PC,
	 output logic [7:0]  opcode,
	 output logic [7:0]  value,
	 output logic [7:0]  MDR,
	 output logic [7:0]  AC,
	 output logic [7:0]  address,
	 output logic        ZFLG,
	 output logic        NFLG
);
    
    // Internal Buses
	 logic [7:0] z;
    
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
        .MDR(MDR), // From memory (MDR bus)
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
        .in0(value),   // Non-fetch cycles: Use value bus
        .in1(PC),      // Fetch cycles: Use PC
        .out(address)  // RAM address input
    );
	 
	 
	 ramup3 RAM (
		  .address(address),
		  .clock(CLK),
		  .data(AC),
		  .wren(STORE_MEM),
		  .q(MDR)
	);
		  

endmodule