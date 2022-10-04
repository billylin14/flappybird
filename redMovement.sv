// Billy Lin
// EE 271
// 8/15/19
// Lab 6 redMovement.sv
// Input with 1-bit values of clock, reset, lose indicator, L, R
// outputs a 8-bit of position of the red bird

module redMovement (clk, reset, lose, L, R, position);

	input logic clk, reset, lose, L, R;
	output logic [7:0] position;
	//clk, reset, press, gravity, bottom, lightOn
	topLight L8 (.clk(clk), .reset(reset), .lose(lose), .press(L), .gravity(R), .bottom(position[6]), .lightOn(position[7])); //8
	normalLight L7 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[7]), .NR(position[5]), .lightOn(position[6])); //7
	normalLight L6 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[6]), .NR(position[4]), .lightOn(position[5])); //6
	centerLight L5 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[5]), .NR(position[3]), .lightOn(position[4])); //5
	normalLight L4 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[4]), .NR(position[2]), .lightOn(position[3])); //4
	normalLight L3 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[3]), .NR(position[1]), .lightOn(position[2])); //3
	normalLight L2 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[2]), .NR(position[0]), .lightOn(position[1])); //2
	normalLight L1 (.clk(clk), .reset(reset), .lose(lose), .L(L), .R(R), .NL(position[1]), .NR(1'b0), .lightOn(position[0])); //1

endmodule

module redMovement_testbench();

	logic clk, reset, lose, L, R;
	logic [7:0]position;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	redMovement dut (.clk, .reset, .lose, .L, .R, .position);
	
	initial begin
		@(posedge clk);
		reset <= 1;	lose <= 0;				@(posedge clk);
		reset <= 0;								@(posedge clk);
													@(posedge clk);
		for (int i = 0; i <= 10; i++) begin      //testing normal operation
			L <= 1;	R <= 0; lose <= 0;	@(posedge clk);
			L <= 0;	R <= 0; lose <= 0;	@(posedge clk);
		end												  //remain at top light
		
		reset <= 0; lose <= 1;							@(posedge clk);
		for (int i = 0; i <= 10; i++) begin      //testing lose, should be back to only top on
			L <= 1;	R <= 0; lose <= 1;	@(posedge clk);
			L <= 0;	R <= 0; lose <= 1;	@(posedge clk);
		end
			
		reset <= 1; lose <= 0;				@(posedge clk);
		for (int i = 0; i <= 10; i++) begin      //testing reset, should be back to only middle on
			L <= 1;	R <= 0; lose <= 0;	@(posedge clk);
			L <= 0;	R <= 0; lose <= 0;	@(posedge clk);
		end		
		reset <= 0; lose <= 0;
		for (int i = 0; i <= 10; i++) begin      //go to the top
			L <= 1;	R <= 0; lose <= 0;	@(posedge clk);
			L <= 0;	R <= 0; lose <= 0;	@(posedge clk);
		end
		$stop;
	end
	
endmodule

	