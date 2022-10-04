// Billy Lin
// EE 271
// 8/15/19
// Lab 6 centerBird.sv

// done testing

module centerBird (clk, reset, press, gravity, bottom, top, lightOn);

	input logic clk, reset;
	
	input logic press, gravity, bottom, top;
	
	output logic lightOn;
	
	enum {on_pressed, off} ps, ns;
	
	// next state logic
	always_comb begin
		case (ps) 
			//on: if (press) ns = off;
				// else ns = on;
			on_pressed: if (gravity^press) ns = off;
							else ns = on_pressed;
			off: if ((press&bottom)^(gravity&top)) ns = on_pressed;
				  else ns = off;
		endcase
	end
	
	// output logic
	always_comb begin
		case (ps) 
			//on: lightOn = 1;
			on_pressed: lightOn = 1;
			off: lightOn = 0;
		endcase
	end
	
	// DFF logic
	always_ff @(posedge clk) begin
		if (reset) ps <= on_pressed;
		else ps <= ns;
	end
	
endmodule


//Testing the different combinations of inputs to see the expected outputs
module centerBird_testbench();

	logic clk, reset, press, gravity, bottom, top, lightOn;
	
	centerBird dut (clk, reset, press, gravity, bottom, top, lightOn);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;												 					@(posedge clk); //off
		reset <= 0;	press <= 0; gravity <= 0; bottom <=0; top <= 0;	@(posedge clk); //off
						press <= 1; gravity <= 0; bottom <=0; top <= 0;	@(posedge clk); //go up, off
						press <= 0; gravity <= 1; bottom <=0; top <= 1;	@(posedge clk); //go down, on
						press <= 0; gravity <= 1; bottom <=0; top <= 0;	@(posedge clk); //go down, off
						press <= 1; gravity <= 0; bottom <=1; top <= 0;	@(posedge clk); //go up, on
						press <= 1; gravity <= 1; bottom <=0; top <= 0;	@(posedge clk); //stays, on
						press <= 1; gravity <= 0; bottom <=0; top <= 0;	@(posedge clk); //go up, off
						
						
		$stop; // End the simulation
	end
endmodule
