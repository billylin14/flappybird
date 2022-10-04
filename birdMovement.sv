module birdMovement (clk, reset, press, cycle, position);

	input logic clk, reset, press, cycle;
	output logic [7:0] position;
	
	topLight row8 (.clk(clk), .reset(reset), .press(press), .gravity(cycle),
						  .bottom(position[6]), .lightOn(position[7]));
	birdLight row7 (.clk(clk), .reset(reset), .press(press), .gravity(cycle), 
						  .bottom(position[5]), .top(position[7]), .lightOn(position[6]));
	birdLight row6 (.clk(clk), .reset(reset), .press(press), .gravity(cycle), 
						  .bottom(position[4]), .top(position[6]), .lightOn(position[5]));					  
	centerBird start (.clk(clk), .reset(reset), .press(press), 
						  .bottom(position[3]), .top(position[5]), .lightOn(position[4]));
	birdLight row4 (.clk(clk), .reset(reset), .press(press), .gravity(cycle), 
						  .bottom(position[2]), .top(position[4]), .lightOn(position[3]));
	birdLight row3 (.clk(clk), .reset(reset), .press(press), .gravity(cycle), 
						  .bottom(position[1]), .top(position[3]), .lightOn(position[2]));
	birdLight row2 (.clk(clk), .reset(reset), .press(press), .gravity(cycle), 
						  .bottom(position[0]), .top(position[2]), .lightOn(position[1]));
	birdLight row1 (.clk(clk), .reset(reset), .press(press), .gravity(cycle),
						  .bottom(1'b0), .top(position[1]), .lightOn(position[0]));
endmodule

module birdMovement_testbench();

	logic clk, reset, press;
	logic [7:0]position;
	
	logic cycle;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	birdMovement dut (clk, reset, press, cycle, position);
	
	initial begin
		@(posedge clk);
		reset <= 1;				@(posedge clk);
		reset <= 0;				@(posedge clk);
		@(posedge clk);
		for (int i = 0; i <= 20; i++) begin
			press <= 1;	cycle <= 0;		@(posedge clk);
			press <= 1;	cycle <= 0;		@(posedge clk);
		end
		$stop;
	end
	
endmodule

	