module ac(
    input logic LOAD_AC,    // Control signal to load accumulator
    input logic [7:0] Z_BUS, // Data input to the accumulator
    input logic CLK,        // Clock signal
    output logic [7:0] AC   // Output value of accumulator
);

    always_ff @(posedge CLK)
        if (LOAD_AC) AC <= Z_BUS; // Load Z_BUS data into AC when LOAD_AC is high
endmodule