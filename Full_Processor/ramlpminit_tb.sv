module ramlpminit_tb(
    input logic [9:0] SW,            // Switches for control and data input
    input logic KEY[2:0],                // Clock input (KEY[0])                // Load input (KEY[2])
    output logic [6:0] HEX3,         // Display output for PC (upper 7-segment)
    output logic [6:0] HEX2,         // Display output for PC (lower 7-segment)
    output logic [6:0] HEX1,         // Display output for memory q (upper 7-segment)
    output logic [6:0] HEX0          // Display output for memory q (lower 7-segment)
);

    logic [7:0] PC;                   // Internal Program Counter (PC)
    logic [7:0] DATA_IN;              // Data input for RAM
    logic [7:0] Q_OUT;                // RAM output
    logic WREN, INCR_PC, LOAD_PC;

    // Assign inputs from switches
    assign INCR_PC = SW[9];           // SW[9] controls PC increment
    assign WREN = SW[8];              // SW[8] controls RAM write enable
    assign DATA_IN = SW[7:0];         // SW[7:0] is the data input
    assign LOAD_PC = ~KEY[2];           // ~KEY2 is used to load PC from switches

    // Instantiate the PC module
    pc pc_inst (
        .LOAD_PC(LOAD_PC),            // Load control from ~KEY2
        .INCR_PC(INCR_PC),            // Increment control from SW[9]
        .ADDR_VALUE_BUS(DATA_IN),     // Address bus input (from switches)
        .CLK(KEY[0]),                   // Clock input (KEY[0])
        .RESET(~KEY[1]),                // Active-low reset (~KEY[1])
        .PC(PC)                       // PC output
    );

    // Instantiate the RAM module
    ramlpminit ram_inst (
        .address(PC),                 // Memory address is PC output
        .clock(KEY[0]),                  // RAM clock is the same as PC clock (KEY[0])
        .data(DATA_IN),                // Data input from switches
        .wren(WREN),                   // Write enable from SW[8]
        .q(Q_OUT)                      // RAM output
    );

    // Instantiate dual 7-segment displays for address (HEX3 and HEX2)
    dualseg7 hex_addr (
        .data(PC),                     // Address from PC
        .blank(0),                      // No blanking
        .test(0),                       // No test mode
        .left_out(HEX3),                // HEX3 (upper PC display)
        .right_out(HEX2)                // HEX2 (lower PC display)
    );

    // Instantiate dual 7-segment displays for RAM output (HEX1 and HEX0)
    dualseg7 hex_data (
        .data(Q_OUT),                   // Data output from RAM
        .blank(0),                      // No blanking
        .test(0),                        // No test mode
        .left_out(HEX1),                 // HEX1 (upper RAM display)
        .right_out(HEX0)                 // HEX0 (lower RAM display)
    );

endmodule