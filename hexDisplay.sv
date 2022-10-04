// Billy Lin
// EE 271
// 8/15/19
// Lab 6 hexDisplay.sv

// Input with 1-bit values of clock, a toggle of slower clock, reset, lose indicator, pass indicator,
// outputs 5 7-bit HEX codes
// when loses, the count is frozen therefore the HEX (score) is frozen; 
// when one digit reaches 9, the nextIncr of the previous one turns on to increment the next digit.
// when reset, all increment become zeroes.

module hexDisplay (clk, cycle, reset, lose, pass, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input logic clk, cycle, pass, reset, lose;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	//HEX display logic
	logic [4:0]nextIncr;
	
	logic q0, q1, q2, q3, q4, q5;
	
	hexCount hex0 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q0), .nextIncr(nextIncr[0]), .HEX(HEX0));
	hexCount hex1 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q1), .nextIncr(nextIncr[1]), .HEX(HEX1));
	hexCount hex2 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q2), .nextIncr(nextIncr[2]), .HEX(HEX2));
	hexCount hex3 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q3), .nextIncr(nextIncr[3]), .HEX(HEX3));
	hexCount hex4 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q4), .nextIncr(nextIncr[4]), .HEX(HEX4));
	hexCount hex5 (.clk(clk), .cycle(cycle), .reset(reset), .lose(lose), .incr(q5), .nextIncr(), .HEX(HEX5));
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			q0 <= 0;
			q1 <= 0;
			q2 <= 0;
			q3 <= 0;
			q4 <= 0;
			q5 <= 0;
		end else if (lose) begin
			q0 <= q0;
			q1 <= q1;
			q2 <= q2;
			q3 <= q3;
			q4 <= q4;
			q5 <= q5;
		end else if (cycle) begin
			q0 <= pass;
			q1 <= nextIncr[0];
			q2 <= nextIncr[1];
			q3 <= nextIncr[2];
			q4 <= nextIncr[3];
			q5 <= nextIncr[4];
		end else begin
			q0 <= q0;
			q1 <= q1;
			q2 <= q2;
			q3 <= q3;
			q4 <= q4;
			q5 <= q5;
		end
	end

endmodule

module hexDisplay_testbench ();

	logic clk, cycle, reset, pass, lose;
	logic [6:0]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	hexDisplay dut (.clk, .cycle, .reset, .lose, .pass, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/4) clk <= ~clk;
	end
	
	initial begin
		cycle <= 0;
		forever #(CLOCK_PERIOD) cycle <= ~cycle;
	end
	
	initial begin
		reset <= 1;	lose <= 0;				  @(posedge clk);
		reset <= 0; lose <= 0; pass <= 0;  @(posedge clk); //test 1~10 pattern
		for (int i = 1; i <= 20; i++) begin
			pass <= 1; @(posedge clk);
			pass <= 0; @(posedge clk);
		end
		reset <= 0; lose <= 1; pass <= 0;  @(posedge clk); //test lose
		for (int i = 1; i <= 3; i++) begin
			pass <= 1; @(posedge clk);
			pass <= 0; @(posedge clk);
		end
		reset <= 0; lose <= 0; pass <= 0;  @(posedge clk); //test turning off lose
		for (int i = 1; i <= 3; i++) begin
			pass <= 1; @(posedge clk);
			pass <= 0; @(posedge clk);
		end
		reset <= 1; lose <= 0; pass <= 0;  @(posedge clk); //test turning on reset
		reset <= 0; lose <= 0; pass <= 0;  @(posedge clk); 
		for (int i = 1; i <= 3; i++) begin
			pass <= 1; @(posedge clk);
			pass <= 0; @(posedge clk);
		end
		$stop;
	end
endmodule

	