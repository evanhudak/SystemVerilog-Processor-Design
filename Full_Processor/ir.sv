module ir (
    input logic LOAD_IRU,   // Load upper byte (opcode)
    input logic LOAD_IRL,   // Load lower byte (address/value)
    input logic [7:0] MDR,  // Data from memory
    input logic CLK,        // Clock signal
    input logic RESET,      // Reset control signal
    output logic [7:0] IRU, // Upper byte of instruction register (opcode)
    output logic [7:0] IRL  // Lower byte of instruction register (address/value)
);

    always_ff @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            IRU <= 8'b0;  // Clear upper byte
            IRL <= 8'b0;  // Clear lower byte
        end else begin
            if (LOAD_IRU) IRU <= MDR;  // Load MDR into IRU
            if (LOAD_IRL) IRL <= MDR;  // Load MDR into IRL
        end
    end

endmodule