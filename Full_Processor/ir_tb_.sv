module ir_tb(
    input logic [8:0] SW,            // Switches for input data
    input logic KEY0,                // Clock input (KEY[0])
    input logic KEY1,                // Reset input (KEY[1])
    output logic [6:0] HEX0,         // Display output for lower byte of IR (IRL)
    output logic [6:0] HEX1,         // Display output for lower byte of IR (IRL)
    output logic [6:0] HEX2,         // Display output for upper byte of IR (IRU)
    output logic [6:0] HEX3          // Display output for upper byte of IR (IRU)
);
    logic [7:0] IRU, IRL;            // Internal instruction register (upper and lower bytes)
    logic [7:0] MDR;                 // Memory data register for input to IR

    // Instantiate the IR register (IR module)
    ir ir1 (
        .LOAD_IRU(SW[8]),             // Load upper byte (SW[8])
        .LOAD_IRL(SW[7]),             // Load lower byte (SW[7])
        .MDR(SW[7:0]),                // Data input from memory (SW[7:0])
        .CLK(KEY0),                   // Clock input (KEY0)
        .RESET(~KEY1),                // Active-low reset (inverted from KEY1)
        .IRU(IRU),                    // Upper byte of instruction register (IRU)
        .IRL(IRL)                     // Lower byte of instruction register (IRL)
    );

    // Instantiate the dualseg7 display module for the IRU (upper byte)
    dualseg7 dualright_upper (
        .data(IRU),                   // Input data for upper byte of IR (IRU)
        .blank(0),                     // No blanking
        .test(0),                      // No test mode
        .left_out(HEX3),               // Left display (upper 7-segment for IRU)
        .right_out(HEX2)               // Right display (lower 7-segment for IRU)
    );

    // Instantiate the dualseg7 display module for the IRL (lower byte)
    dualseg7 dualright_lower (
        .data(IRL),                   // Input data for lower byte of IR (IRL)
        .blank(0),                     // No blanking
        .test(0),                      // No test mode
        .left_out(HEX1),               // Left display (upper 7-segment for IRL)
        .right_out(HEX0)               // Right display (lower 7-segment for IRL)
    );
    
endmodule

