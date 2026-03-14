module mux2by1 (
    input  logic [7:0] in0, in1, // 8-bit inputs
    input  logic sel,            // Select signal
    output logic [7:0] out       // 8-bit output
);
    
    // Assign output based on select signal
    assign out = sel ? in1 : in0;
    
endmodule