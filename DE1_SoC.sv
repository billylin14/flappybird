// Billy Lin
// EE 271
// 8/15/19
// Lab 6 DE1_SoC.sv

// Input with a 1-bit clock, 6 7-bit values of HEX lights, 9 switches and 3 keys, 
// outputs a flappy bird game which player can play with a key and make the red bird flaps
// to pass through a set of green pipes to score a point.

module DE1_SoC(CLOCK_50,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,KEY,LEDR, SW, GPIO_0);

	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	output logic [35:0] GPIO_0;
	
	logic lose, pass;
	
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 15; //set the clock speed to about 1.56MHz
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));
	
	logic clock_select;
	
   //assign clock_select = CLOCK_50; // For simulation
	assign clock_select = clk[whichClock]; // For board
	
	// Generate led matrix connection
	logic [7:0] red_driver, green_driver, row_sink;
	logic [7:0][7:0] red_array, green_array;
	assign GPIO_0[35:28] = green_driver;
	assign GPIO_0[27:20] = red_driver;
	assign GPIO_0[19:12] = row_sink;
	
	led_matrix_driver matrix (.clock(clock_select), .red_array(red_array), .green_array(green_array), 
									  .red_driver(red_driver), .green_driver(green_driver), .row_sink(row_sink));

	// Generate the slower clock rate for gravity
	logic cycle;
	realClock realCycle (.clk(clock_select), .reset(SW[9]), .toggle(cycle));
	
	// logics for user inputs 
	logic metaPress, metaComp;
	logic press, compPress;
	
	meta antiMeta1 (.clk(clock_select), .d1(cycle), .q2(metaComp));
	meta antiMeta (.clk(clock_select), .d1(~KEY[3]), .q2(metaPress));
	userInput antiHold (.clk(clock_select), .reset(SW[9]), .in(metaPress), .out(press));
	userInput antiHold1 (.clk(clock_select), .reset(SW[9]), .in(metaComp), .out(compPress));
	
	// score keeping
	hexDisplay score (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .pass(pass), .HEX0(HEX0), .HEX1(HEX1), 
							.HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	
	// red bird, starting at 4x4 [row][column]
	logic [7:0] redPosition;
	
	redMovement move (.clk(clock_select), .reset(SW[9]), .lose(lose), .L(press), .R(compPress), .position(redPosition));
	  
	always_comb begin
		red_array[7][4] = redPosition[7];
		red_array[6][4] = redPosition[6];
		red_array[5][4] = redPosition[5];
		red_array[4][4] = redPosition[4];
		red_array[3][4] = redPosition[3];
		red_array[2][4] = redPosition[2];
		red_array[1][4] = redPosition[1];
		red_array[0][4] = redPosition[0];
	end
	
	
	// generate green pipe pattern
	logic [7:0]lastColPattern;
	
	greenPattern generatePattern (.clk(cycle), .pattern(lastColPattern), .reset(SW[9]), .lose(lose));
	
	initial begin
		green_array = '0; 
	end
	
	// assign the green pipe pattern to the rightmost column
	// shift green pipes leftwards, excluding the rightmost one
	
	greenShifting shiftRow8 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[7]), .green_row(green_array[7]));
	greenShifting shiftRow7 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[6]), .green_row(green_array[6]));
	greenShifting shiftRow6 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[5]), .green_row(green_array[5]));
	greenShifting shiftRow5 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[4]), .green_row(green_array[4]));
	greenShifting shiftRow4 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[3]), .green_row(green_array[3]));
	greenShifting shiftRow3 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[2]), .green_row(green_array[2]));
	greenShifting shiftRow2 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[1]), .green_row(green_array[1]));
	greenShifting shiftRow1 (.clk(clock_select), .cycle(cycle), .reset(SW[9]), .lose(lose), .lastColPattern(lastColPattern[0]), .green_row(green_array[0]));
	
	// logics for resetting games
	// lose logic, if loses, all freeze
	logic [7:0] green_position;
	gameControl passing (.clk(clock_select), .reset(SW[9]), .position(redPosition), 
								.green_position(green_position), .lose(lose), .pass(pass));
								
	always_comb begin
		green_position[7] = green_array[7][4];
		green_position[6] = green_array[6][4];
		green_position[5] = green_array[5][4];
		green_position[4] = green_array[4][4];
		green_position[3] = green_array[3][4];
		green_position[2] = green_array[2][4];
		green_position[1] = green_array[1][4];
		green_position[0] = green_array[0][4];
	end
	
	assign LEDR[0] = lose;
	assign LEDR[1] = pass;
	
endmodule

// Testing the different combinations of inputs to see the expected output
// this time we are testing if we set the switches to be the largest value 
// and let the key be unpressed, we should be able to see the light going from 5 to 1 to win
module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // True when not pressed, False when pressed
	logic [9:0] SW;
	logic CLOCK_50;
	logic [35:0] GPIO_0;

	initial begin
		CLOCK_50 <= 0;
		forever #(50) CLOCK_50 <= ~CLOCK_50; // toggles every 50 ps for an effective 100 ps clock period
	end
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_0);
	
	initial begin
		SW[9] <= 1; KEY[3] = 0;	 			 @(posedge CLOCK_50); //reset
													 @(posedge CLOCK_50);
		SW[9] <= 0;	KEY[3] = 0;				 @(posedge CLOCK_50);
		SW[9] <= 0; KEY[3] = 0;	 			 @(posedge CLOCK_50);
		for (int i = 1; i <= 10; i++) begin
			KEY[3] = 1; @(posedge CLOCK_50);
			KEY[3] = 0;	@(posedge CLOCK_50);
		end
		for (int i = 1; i <= 7; i++) begin
			@(posedge CLOCK_50);
		end
		$stop; // End the simulation.
	end
endmodule
	
	