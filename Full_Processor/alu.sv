module alu(input logic signed [7:0] ac, mdr, value, 
	input logic [7:0] opcode, 
	output logic nflg, zflg, output logic signed [7:0] z);

	assign zflg = (ac == 0);
	assign nflg = ac[7];

	always_comb
		case(opcode)
		8'h01: z = mdr; // LOAD
		8'h02: z = value; // LOADI
		8'h05: z = ac + mdr; // ADD
		8'h06: z = ac + value; // ADDI
		8'h07: z = ac - mdr; // SUBTRACT
		8'h08: z = ac - value; // SUBTRACTI
		8'h09: z = ~mdr + 1; // NEG
		8'h0A: z = ~mdr; // NOT
		8'h0B: z = ac & mdr; // AND
		8'h0C: z = ac | mdr; // OR
		8'h0D: z = ac ^ mdr; // EXCL OR
		8'h0E: z = ac << value[2:0]; // SHL
		8'h0F: z = ac >> value[2:0]; // SHR
		default: z = 8'b0; // all other cases
		endcase
endmodule