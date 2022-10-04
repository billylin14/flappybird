// Billy Lin
// EE 271
// 8/15/19
// Lab 6 normalLight.sv

// Input with 1-bit values of clock, left button, right button, Next left light, Next right light, lose indicator
// outputs a 1-bit lightOn if the light is supposed to be on.
// lightOn is off when reset and on when the next left light is on and the right is pressed, 
// or the next right light is on and the left is pressed

module normalLight (clk, reset, lose, L, R, NL, NR, lightOn);

	input logic clk, reset, lose;
	
	// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on
	input logic L, R, NL, NR;
	
	// when lightOn is true, the center light should be on.
	output logic lightOn;
	
	enum {lit, Nlit} ps, ns;
	
	always_comb begin
		case (ps) 
			Nlit: if ((R&NL&~L)^(L&NR&~R)) begin	//if either R is pressed and the left light next to it is on 
														//or L is pressed and the right light next to it is on but not the same time
						lightOn = 0;				//then the light goes back on
						ns = lit; 					//and the state goes to lit state
					end else begin					//otherwise stays (including pressing both at the same time and other possible states)
						lightOn = 0;				//light stays off
						ns = Nlit;					// present state stays in Nonlit
					end
			lit:  if (R^L) begin    //if either R or L is pressed but not the same time
						lightOn = 1;   //then light turns off
						ns = Nlit;  	//and goes to Nonlit state
					end else begin		//otherwise stays (including pressing both the same time and not pressed at all)
						lightOn = 1;	//light stays on
						ns = lit;		//present state stays in lit
					end 					
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) ps <= Nlit;
		else if (lose) ps <= ps;
		else ps <= ns;
	end
	
endmodule

//Testing the different combinations of inputs to see the expected outputs
module normalLight_testbench();

	logic clk, reset, lose, L, R, NL, NR, lightOn;
	
	normalLight dut (.clk, .reset, .lose, .L, .R, .NL, .NR, .lightOn);

	// Set up the clk.
	parameter clk_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(clk_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1;	lose <= 0;								 @(posedge clk); //off
		reset <= 0;	lose <= 0;								 @(posedge clk); //off

						L <= 1; R <= 0; NL <= 0; NR <= 1; @(posedge clk); //off
						L <= 1; R <= 0; NL <= 0; NR <= 0; @(posedge clk); //on
						L <= 0; R <= 1; NL <= 1; NR <= 0; @(posedge clk); //off						
						L <= 0; R <= 1; NL <= 1; NR <= 0; @(posedge clk); //on
						L <= 0; R <= 1; NL <= 1; NR <= 0; @(posedge clk); //on
		lose <= 1;	L <= 0; R <= 0; NL <= 0; NR <= 0; @(posedge clk); //on
		lose <= 1;	L <= 0; R <= 0; NL <= 0; NR <= 0; @(posedge clk); //on
		lose <= 1;	L <= 0; R <= 0; NL <= 0; NR <= 0; @(posedge clk); //on
		reset<= 1;  lose <= 0;								 @(posedge clk); //testing reset off
		reset<= 0;  L <= 1; R <= 0; NL <= 0; NR <= 1; @(posedge clk); //off
						L <= 0; R <= 0; NL <= 0; NR <= 0; @(posedge clk); //on

		$stop; // End the simulation
	end
endmodule
