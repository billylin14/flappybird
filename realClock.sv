// Billy Lin
// EE 271
// 8/15/19
// Lab 6 realClock.sv
// Input with 1-bit values of clock and reset logic
// outputs a slower clock with 1-bit toggle every 400 clock cycles.

module realClock (clk, reset, toggle);

	input logic clk, reset;
	output logic toggle;
	
	integer cycle_count;
	
	always_ff @ (posedge clk) begin
		if (reset) begin
			cycle_count <= 0;
			toggle <= 0;
		end
		else if (cycle_count >= 400) begin 
			cycle_count <= 0; 
			toggle <= 1;
		end
		else begin
			cycle_count <= cycle_count + 1;
			toggle <= 0;
		end
	end
endmodule

module realClock_testbench();

	logic clk, toggle, reset;
	
	realClock dut (.clk, .reset, .toggle);
	
	// Set up the clock.
	parameter CLOCK_PERIOD= 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset<= 1; @(posedge clk);
		reset<= 0; @(posedge clk);
		for (int i = 1; i <= 800; i++) 
			@(posedge clk);
		$stop;
	end
endmodule
