

module dualseg7 (input logic [7:0] data, input logic blank, input logic test, output logic [6:0] left_out, output logic [6:0] right_out);
    seg7 left_display (.data(data[7:4]), .blank(blank), .test(test), .seg(left_out));
    seg7 right_display (.data(data[3:0]), .blank(blank), .test(test), .seg(right_out));
endmodule