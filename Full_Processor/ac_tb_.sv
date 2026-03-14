module ac_tb(
    input logic [8:0] SW,            // Switches for input data
    input logic [0:0] KEY[0],        // Clock input (KEY[0])
    output logic [6:0] HEX0,         // Display output (lower 7-segment)
    output logic [6:0] HEX1          // Display output (upper 7-segment)
);
    logic [7:0] AC;                  // Internal AC bus

    // Instantiate the AC register (AC module)
    ac ac1 (
        .LOAD_AC(SW[8]),              // Load control signal (SW[8])
        .Z_BUS(SW[7:0]),              // Data input (SW[7:0])
        .CLK(KEY[0]),                 // Clock input (KEY[0])
        .AC(AC)                       // AC output connected to internal AC bus
    ); dualseg7 dualright (
        .data(AC),                    // Input data (AC bus)
        .blank(0),                     // No blanking
        .test(0),                      // No test mode
        .left_out(HEX1),               // Left display (upper 7-segment)
        .right_out(HEX0)               // Right display (lower 7-segment)
    );
    
endmodule

