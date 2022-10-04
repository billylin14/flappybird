// Billy Lin
// EE 271
// 8/15/19
// Lab 6 topLight.sv
// Input with 1-bit values of clock, press logic, gravity button, bottom-light indicator, lose indicator
// outputs a 1-bit lightOn if the light is supposed to be on.
// lightOn is off when reset and on when the bottom light is on and the press is on. 
// bottom light indicates the light right below this light

module topLight (clk, reset, lose, press, gravity, bottom, lightOn);

	input logic clk, reset, lose;
	input logic press, bottom, gravity;
	output logic lightOn;
	
	enum {on, off} ps, ns;
	
	// next state logic
	always_comb begin
		case (ps)
			on: if (gravity&~press) ns = off;
				 else ns = on;
			off: if (press&bottom&~gravity) ns = on;
				  else ns = off;
		endcase
	end
	
	// output logic
	always_comb begin
		case (ps)
			on: lightOn = 1;
			off: lightOn = 0;
		endcase
	end
	
	// DFF logic
	always_ff @(posedge clk) begin
		if (reset) ps <= off; 
		else if (lose) ps <= ps;
		else ps <= ns;
	end
endmodule

//Testing the different combinations of inputs to see the expected outputs
module topLight_testbench();

	logic clk, reset, lose, press, bottom, gravity, lightOn;
	
	topLight dut (clk, reset, lose, press, gravity, bottom, lightOn);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;	lose <= 0;								 @(posedge clk); //off
		reset <= 0;	lose <= 0;								 @(posedge clk); //off

						press <= 1; gravity <= 0; bottom <= 1;  @(posedge clk); //off
						press <= 1; gravity <= 0; bottom <= 0;  @(posedge clk); //on
						press <= 1; gravity <= 1; bottom <= 0;  @(posedge clk); //on						
						press <= 0; gravity <= 1; bottom <= 0;  @(posedge clk); //on
						press <= 1; gravity <= 0; bottom <= 1;  @(posedge clk); //off
		lose <= 1;	press <= 0; gravity <= 0; bottom <= 0;  @(posedge clk); //on
		lose <= 1;	press <= 0; gravity <= 0; bottom <= 0;  @(posedge clk); //on
		lose <= 1;	press <= 0; gravity <= 0; bottom <= 0;  @(posedge clk); //on
		reset<= 1;  lose <= 0;								 @(posedge clk); //testing reset off
		reset<= 0;  press <= 1; gravity <= 0; bottom <= 1;  @(posedge clk); //off
						press <= 0; gravity <= 0; bottom <= 0;  @(posedge clk); //on

		$stop; // End the simulation
	end
endmodule
