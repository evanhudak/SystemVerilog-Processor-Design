module alu_tb(
    input logic [9:0] SW,               // Switches for input data
    input logic [3:0] KEY,              // Keys for input
    output logic [6:0] HEX0,            // Display output for Z (lower 7-segment)
    output logic [6:0] HEX1,            // Display output for Z (upper 7-segment)
    output logic [6:0] HEX2,            // Display output for AC (lower 7-segment)
    output logic [6:0] HEX3,            // Display output for AC (upper 7-segment)
    output logic [6:0] HEX4,            // Display output for MDR (lower 7-segment)
    output logic [6:0] HEX5,            // Display output for MDR (upper 7-segment)
    output logic [9:0] LEDR,            // LEDR outputs (LEDR0-LEDR9)
    output logic [7:0] MDR,             // Memory Data Register (MDR)
    output logic [7:0] AC,              // Accumulator (AC)
    output logic [7:0] Z,               // ALU result output (Z)
    output logic [7:0] value,           // Value output
    output logic ZFLG,                  // Zero Flag
    output logic NFLG                   // Negative Flag
);
    // Internal signals
    logic [7:0] IRU, IRL;               // Instruction Register (upper and lower)
    logic [7:0] Z_BUS;                  // Bus for ALU result
   
    // Instantiate ALU module
    alu alu1 (
        .opcode(IRU),                    // Opcode from IRU
        .addr_value(IRL),                 // Address/Value from IRL
        .MDR(MDR),                        // Data from MDR
        .AC(AC),                          // Accumulator input
        .Z(Z),                            // Output from ALU
        .ZFLG(ZFLG),                      // Zero Flag output
        .NFLG(NFLG)                       // Negative Flag output
    );

    // Instantiate AC module
    ac ac1 (
        .LOAD_AC(KEY[2]),                  // Load AC when KEY2 pressed
        .Z_BUS(SW[7:0]),                        // Z output from ALU as input to AC
        .CLK(KEY[0]),                       // Clock signal (KEY0)
		  .AC(AC)                           // Output AC value
    );

    // Instantiate IR module
    ir ir1 (
        .LOAD_IRU(SW[9]),                 // Load opcode (upper byte) into IRU (KEY4)
        .LOAD_IRL(KEY[1]),                 // Load address/value (lower byte) into IRL (KEY1)
        .MDR(MDR),                        // Data from MDR to IR
        .CLK(KEY[0]),                       // Clock signal (KEY0)
        .RESET(SW[8]),                    // Active-low reset
        .IRU(IRU),                        // Upper byte of IR
        .IRL(IRL)                         // Lower byte of IR
    );

    // Instantiate PC module for MDR logic
    pc pc1 (
        .LOAD_PC(KEY[3]),                  // Load PC (MDR) when KEY3 pressed
        .INCR_PC(1'b0),                   // No increment in this case
        .ADDR_VALUE_BUS(SW[7:0]),         // 8-bit data from SW[7:0] input
        .CLK(KEY[0]),                       // Clock signal (KEY0)
        .RESET(SW[8]),                    // Active-low reset
        .PC(MDR)                          // Output to MDR
    );

    // Instantiate dualseg7 for HEX outputs (Z output)
    dualseg7 seg7_z (
        .data(Z),                         // ALU result output
        .blank(0),                        // No blanking
        .test(0),                         // No test mode
        .left_out(HEX1),                  // Left 7-segment for Z
        .right_out(HEX0)                  // Right 7-segment for Z
    );

    // Instantiate dualseg7 for HEX outputs (AC output)
    dualseg7 seg7_ac (
        .data(AC),                        // AC output
        .blank(0),                        // No blanking
        .test(0),                         // No test mode
        .left_out(HEX3),                  // Left 7-segment for AC
        .right_out(HEX2)                  // Right 7-segment for AC
    );

    // Instantiate dualseg7 for HEX outputs (MDR output)
    dualseg7 seg7_mdr (
        .data(MDR),                       // MDR output
        .blank(0),                        // No blanking
        .test(0),                         // No test mode
        .left_out(HEX5),                  // Left 7-segment for MDR
        .right_out(HEX4)                  // Right 7-segment for MDR
    );

    // Assign LEDR outputs (value, NFLG, and ZFLG)
    assign LEDR[7:0] = value;             // Display value output on LEDs 0-7
    assign LEDR[8] = NFLG;                // Display NFLG on LEDR8
    assign LEDR[9] = ZFLG;                // Display ZFLG on LEDR9

    // Logic for the value output
    assign value = Z;                     // Set value equal to Z output
   
endmodule
