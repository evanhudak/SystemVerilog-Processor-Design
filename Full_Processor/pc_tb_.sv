module pc_tb(
    input logic [8:0] SW,            // Switches for input data
    input logic KEY0,                // Clock input (KEY[0])
    input logic KEY1,                // Reset input (KEY[1])
    output logic [6:0] HEX0,         // Display output for PC (lower 7-segment)
    output logic [6:0] HEX1          // Display output for PC (upper 7-segment)
);

    logic [7:0] PC;                  // Internal Program Counter (PC)
    logic [7:0] ADDR_VALUE_BUS;      // Address bus input for loading PC

    // Instantiate the PC register (PC module)
    pc pc1 (
        .LOAD_PC(SW[8]),              // Load control signal (SW[8])
        .INCR_PC(SW[7]),              // Increment control signal (SW[7])
        .ADDR_VALUE_BUS(SW[7:0]),     // Address bus input (SW[7:0])
        .CLK(KEY0),                   // Clock input (KEY[0])
        .RESET(~KEY1),                // Active-low reset (inverted from KEY[1])
        .PC(PC)                       // Output current value of PC
    );

    // Instantiate the dualseg7 display module for the lower byte of PC
    dualseg7 dualright_lower (
        .data(PC),                    // Input data (Program Counter)
        .blank(0),                     // No blanking
        .test(0),                      // No test mode
        .left_out(HEX1),               // Left display (upper 7-segment for PC)
        .right_out(HEX0)               // Right display (lower 7-segment for PC)
    );
    
endmodule
