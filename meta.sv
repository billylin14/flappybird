// Billy Lin
// EE 271
// 8/1/19
// Lab 5 meta.sv

// Input with 1-bit values of clock, d1 for input,
// outputs a delayed output to eliminate metastability

module meta (clk, d1, q2);
	input logic clk, d1;
	
	logic q1;
	output logic q2;
	
	always_ff @(posedge clk) begin
		q1 <= d1;
		q2 <= q1;
	end
endmodule

//testing for different inputs to see what the outputs would be like.
module meta_testbench();
	logic clk, d1, q1, q2;
	
	// Set up the clk.
	parameter clk_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(clk_PERIOD/2) clk <= ~clk;
	end
	
	meta dut (.clk, .d1, .q2);
	
	initial begin
		d1 <= 0;			@(posedge clk); //input with 0, q1 = 0, q2 = NA;
							@(posedge clk); //delay 1 cycle, q2 = q1;
		d1 <= 1;			@(posedge clk); //input with 1, q1 = 1, q2 = 0;
							@(posedge clk); //delay 1 cycle, q1 = 1, q2 = 1, 
		d1 <= 0;			@(posedge clk); //input with 0, q1 = 0, q2 = 1;
		d1 <= 1;			@(posedge clk); //input with 1, q1 = 1, q2 = 0;
		d1 <= 0;			@(posedge clk); //input with 0, q1 = 0, q2 = 1;
							@(posedge clk); //delay 1 cycle, q1 = 0, q2 = 0;
		$stop;
	end
endmodule
