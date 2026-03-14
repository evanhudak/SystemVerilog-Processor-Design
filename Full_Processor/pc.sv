module pc (
    input logic LOAD_PC,        // Load new value into PC
    input logic INCR_PC,        // Increment the PC
    input logic [7:0] ADDR_VALUE_BUS, // Input value to load into PC
    input logic CLK,            // Clock signal
    input logic RESET,          // Reset control signal
    output logic [7:0] PC       // Current value of Program Counter
);

    always_ff @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            PC <= 8'b0;  // Clear Program Counter on RESET
        end else begin
            if (LOAD_PC) begin
                PC <= ADDR_VALUE_BUS;  // Load the new value into PC
            end else if (INCR_PC) begin
                PC <= PC + 1;  // Increment the PC
            end
        end
    end

endmodule