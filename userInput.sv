// Billy Lin
// EE 271
// 7/25/19
// Lab 4 userInput.sv

// Input with 1-bit values of clock, in, and reset
// outputs a 1-bit out. Out is true only when the user pressed the key but not hold it.

module userInput (clk, reset, in, out);

	input logic clk, reset;
	
	input logic in;
	output logic out;
	
	enum {p, np} ps, ns;
	
	always_comb begin
		case (ps)
			p: begin
					if (in) begin
						ns = p;
						out = 0; end
					else begin
						ns = np; 
						out = 0; end
				end
			np: begin
					if (in) begin
						ns = p;
						out = 1;
					end
					else begin
						ns = np;
						out = 0;
					end
				end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) ps <= np;
		else ps <= ns;
	end
	
endmodule

//Testing the different combinations of inputs to see the expected outputs
module userInput_testbench();

	logic clk, reset, in, out;
	
	userInput dut (.clk, .reset, .in, .out);

	// Set up the clk.
	parameter clk_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(clk_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; 			 @(posedge clk); //reset
		reset <= 0;	in <= 0;  @(posedge clk); //button not pressed, output should be 0
						in <= 1;	 @(posedge clk); //button pressed, output should be 1
									 @(posedge clk); //button pressed for another cycle, output should be 0
						in <= 0;	 @(posedge clk); //button lifted, output should stay 0
						in <= 1;  @(posedge clk); //button pressed, output should be 1
		$stop;
	end
endmodule

