// Billy Lin
// EE 271
// 8/15/19
// Lab 6 LFSR_3bit.sv

// Input with 1-bit values of clock, reset,
// outputs a 3-bit value from a 3-bit LFSR machine

module LFSR_3bit (clk, reset, Q);

	input logic clk, reset;
	output logic [2:0]Q;
	
	always_ff @(posedge clk) begin
		if (reset) Q <= 3'b000;
		else begin
			Q[2] <= Q[0] ~^ Q[2];
			Q[1] <= Q[2];
			Q[0] <= Q[1];
		end
	end
endmodule

// Test the different outputs of the LFSR machine, 
// expect to see the very first pattern after 1024 clock cycles.
module LFSR_3bit_testbench();

	logic clk, reset;
	logic [2:0]Q;
	
	// Set up the clk.
	parameter clk_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(clk_PERIOD/2) clk <= ~clk;
	end
	
	LFSR_3bit dut (.clk, .reset, .Q);
	
	initial begin
		reset = 1; @(posedge clk);
		reset = 0; @(posedge clk);
		for (int i = 1; i <= 8; i++) begin
			@(posedge clk); 
		end
		$stop;
	end
endmodule
				
	