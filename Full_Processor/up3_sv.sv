module up3(
    // Control inputs
    input logic FETCH,           // Control to select address source (PC or value bus)
    input logic LOAD_AC,         // Control to load Accumulator (AC)
    input logic LOAD_IRU,        // Control to load Instruction Register Upper (IRU)
    input logic LOAD_IRL,        // Control to load Instruction Register Lower (IRL)
    input logic LOAD_PC,         // Control to load Program Counter (PC)
    input logic INCR_PC,         // Control to increment PC
    input logic STORE_MEM,       // Control to store data to memory (STORE instruction)

    // Buses for PC, opcode, and value
    output logic [7:0] PC,       // Program Counter (PC) output
    output logic [7:0] opcode,   // Instruction Register Upper (IRU) output (opcode)
    output logic [7:0] value,    // Instruction Register Lower (IRL) output (value)
   
    // Connections to RAM and Accumulator
    output logic [7:0] address,  // Memory Address (MUX output)
    output logic [7:0] MDR,      // Memory Data Register (MDR) bus, same as memory output
    input logic [7:0] AC,        // Accumulator (AC) bus input
    output logic [7:0] DATA_IN   // Data input to memory (for STORE instruction)
);

    // Internal wire declarations for connections
    wire [7:0] PC_bus, value_bus;  // The two possible address sources: PC or value
    wire [7:0] mux_out;            // Output of the multiplexer for address selection

    // Instantiate the memory (RAM) module with MDR as the output
    ramlpminit ram_inst (
        .address(address),            // Address from the mux
        .clock(KEY[0]),               // Clock from the test bench (or the external clock signal)
        .data(DATA_IN),              // Data input for memory (from AC for STORE)
        .wren(STORE_MEM),            // Write enable from STORE_MEM
        .q(MDR)                      // Memory data output, connected to MDR bus
    );

    // Instantiate the multiplexer (mux2by1) to select between PC and value bus for memory address
    mux2by1 mux_inst (
        .sel(FETCH),                 // Control signal to select between PC or value bus
        .in0(value),                 // Data from value bus (used during execution of non-fetch instructions)
        .in1(PC),                    // Data from PC bus (used during instruction fetch)
        .out(mux_out)                // Output is selected address for memory
    );

    // Assign the address to the output of the multiplexer
    assign address = mux_out;    // The address to RAM comes from mux_out

    // Connect the opcode and value buses to appropriate outputs for the IR
    assign opcode = (LOAD_IRU) ? MDR[7:0] : opcode;  // Load opcode from memory to IRU
    assign value = (LOAD_IRL) ? MDR[7:0] : value;    // Load value from memory to IRL

    // Assign the data input to memory for STORE operation (from Accumulator)
    assign DATA_IN = (STORE_MEM) ? AC : 8'b0;  // Data input is the value of AC for STORE

    // The PC is controlled by either incrementing or loading
    assign PC = (LOAD_PC) ? 8'b0 : (INCR_PC ? PC + 1 : PC);  // Load or increment PC

endmodule
