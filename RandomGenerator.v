`ifndef  TEST_BENCH
	`include "config.v"
`endif


module RandomGenerator
  #(parameter bitlength = 8)
	(reset, clk, seed, dataOut);
/*
this implementation is very simple, contains small bias
to avoid bias, a more complex implementation is needed, like 'Tkacik LFSR'.
*/

	input reset, clk;
	input [bitlength-1: 0] seed;
	output  [bitlength-1: 0] dataOut;
	reg [bitlength-1: 0] shiftReg = 0;
	wire shiftIn, xorOut, zeroDetector;
	reg start = 1;

	assign xorOut = shiftReg[`R_1] ^ shiftReg[`R_2] ^ shiftReg[`R_3] ^ shiftReg[`R_4];
	assign zeroDetector = ~(|(shiftReg[bitlength-1: 0])); // all together, avoid fall into all zero case and stuck!
	assign shiftIn = xorOut ^ zeroDetector;
	assign dataOut = shiftReg;

	// initial begin
	// 	$display("[Before Initial RandomGenerator.shiftReg = %d]", shiftReg); // ok
	// 	$display("[Before Initial RandomGenerator.shiftIn = %d]", shiftIn);
	// 	$display("[Before Initial RandomGenerator.zeroDetector = %d]", zeroDetector);
	// 	$display("[Before Initial RandomGenerator.xorOut = %d]", xorOut);
	// 	// shiftReg = bitlength'b0000010;
	// 	$display("[After Initial RandomGenerator.shiftReg = %d]", shiftReg); // ok
	// 	$display("[After Initial RandomGenerator.shiftIn = %d]", shiftIn);
	// 	$display("[After Initial RandomGenerator.zeroDetector = %d]", zeroDetector);
	// 	$display("[After Initial RandomGenerator.xorOut = %d]", xorOut);
	// end


	always @(posedge clk or posedge reset) begin
		// $display("[RandomGenerator.reset = %d]",reset);  // ok
		// $display("[RandomGenerator.shiftReg = %d]", shiftReg); // ok
		if(reset || start)
			begin
				start = 0;
				// $display("[RandomGenerator.shiftReg = seed]"); // ok
				shiftReg <= seed;
			end
		else
			begin
				// $display("[RandomGenerator.shiftIn = %d]", shiftIn); // problem! shiftIn = x
				// $display("[RandomGenerator.shiftReg[bitlength-2: 0] = %d]", shiftReg[bitlength-2: 0]); // ok
				// $display("[RandomGenerator.shiftReg = %d]",{shiftReg[bitlength-2: 0], shiftIn}); // ok
				shiftReg <= {shiftReg[bitlength-2: 0], shiftIn};
			end
	end




endmodule
