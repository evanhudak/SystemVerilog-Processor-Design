module up3_tb(input logic [6:0] SW, input logic [1:0] KEY, 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
	output logic [6:0] LEDR);
	
	logic [7:0] ac, pc, opcode, value, mdr, address;
	logic nflg, zflg;
	
	up3 myup3(.CLK(KEY[0]), .RESET(~KEY[1]), .LOAD_AC(SW[6]), .LOAD_PC(SW[3]), .INCR_PC(SW[2]), 
	.LOAD_IRU(SW[5]), .LOAD_IRL(SW[4]), .STORE_MEM(SW[0]), .FETCH(SW[1]), .NFLG(nflg), .ZFLG(zflg), 
	.AC(ac), .PC(pc), .opcode(opcode), .value(value), .MDR(mdr), .address(address));

	assign LEDR = SW;
		
	dualseg7 right(.data(value), .left_out(HEX1), .right_out(HEX0));
	dualseg7 middle(.data(opcode), .left_out(HEX3), .right_out(HEX2));
	dualseg7 left(.data(pc), .left_out(HEX5), .right_out(HEX4));
	
endmodule