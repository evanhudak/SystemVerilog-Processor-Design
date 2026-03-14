// Evan Hudak
// emh564
// Logic Circuits
// all_seg7_tb.sv

module all_seg7_tb (input logic [9:0] SW, output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2, output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5);
    dualseg7 left (.data(SW[7:0]), .blank(SW[9]), .test(SW[8]), .left_out(HEX0), .right_out(HEX1));
    dualseg7 middle (.data(SW[7:0]), .blank(SW[9]), .test(SW[8]), .left_out(HEX2), .right_out(HEX3));
    dualseg7 right (.data(SW[7:0]), .blank(SW[9]), .test(SW[8]), .left_out(HEX4), .right_out(HEX5));
endmodule