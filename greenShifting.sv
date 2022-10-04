// Billy Lin
// EE 271
// 8/15/19
// Lab 6 greenPattern.sv
// Input with a 1-bit of clock, reset, lose indicator, and the last column light
// outputs a 8-bit pattern of the green pipe in a row.

module greenShifting (clk, cycle, reset, lose, lastColPattern, green_row);
	input logic clk, reset, lose, cycle;
	input logic lastColPattern;
	output logic [7:0] green_row;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			green_row[7] <= 0;
			green_row[6] <= 0;
			green_row[5] <= 0;
			green_row[4] <= 0;
			green_row[3] <= 0;
			green_row[2] <= 0;
			green_row[1] <= 0;
			green_row[0] <= 0;
	   end else if (lose) begin
			green_row[7] <= green_row[7];
			green_row[6] <= green_row[6];
			green_row[5] <= green_row[5];
			green_row[4] <= green_row[4];
			green_row[3] <= green_row[3];
			green_row[2] <= green_row[2];
			green_row[1] <= green_row[1];
			green_row[0] <= green_row[0];
		end else if (cycle) begin
			green_row[7] <= green_row[6];
			green_row[6] <= green_row[5];
			green_row[5] <= green_row[4];
			green_row[4] <= green_row[3];
			green_row[3] <= green_row[2];
			green_row[2] <= green_row[1];
			green_row[1] <= green_row[0];
			green_row[0] <= lastColPattern;
		end else begin
			green_row[7] <= green_row[7];
			green_row[6] <= green_row[6];
			green_row[5] <= green_row[5];
			green_row[4] <= green_row[4];
			green_row[3] <= green_row[3];
			green_row[2] <= green_row[2];
			green_row[1] <= green_row[1];
			green_row[0] <= green_row[0];
		end
	end
endmodule
	
module greenShifting_testbench ();

	logic clk, cycle, reset, lose, lastColPattern;
	logic [7:0] green_row;
	
	greenShifting dut (clk, cycle, reset, lose, lastColPattern, green_row);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/4) clk <= ~clk;
	end
	
	initial begin
		cycle <= 1;
		forever #(CLOCK_PERIOD/2) cycle <= ~cycle;
	end
		
	
	initial begin
		reset <= 1; lose <= 0;									@(posedge clk);
		reset <= 0; lose <= 0; lastColPattern <= 1;		@(posedge clk); //testing the lastColPattern (should all be 1);
		for (int i = 1; i <= 10; i++) begin											//have increment by 1 each clock
			lose <= 0; lastColPattern <= 1; @(posedge clk);
		end
		reset <= 0; lose <= 1; lastColPattern <= 1;		@(posedge clk); //testing losing 
		for (int i = 1; i <= 10; i++) begin										
			lose <= 1;												@(posedge clk);
		end
		reset <= 1;	lose <= 0;									@(posedge clk); //testing reset
		reset <= 0;	lose <= 0;									@(posedge clk); //testing reset
		for (int i = 1; i <= 10; i++) begin										
			lose <= 0; lastColPattern <= 1; @(posedge clk);
		end
		$stop;
	end
endmodule

	
	
	
	