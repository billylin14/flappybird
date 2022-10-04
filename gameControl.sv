// Billy Lin
// EE 271
// 8/15/19
// Lab 6 gameControl.sv

// Input with 1-bit values of clock, bird's position, green light's position on the column,
// outputs a 1-bit lose indicator and a 1-bit pass indicator
// when red bird drops off the playfield (when bird's position is off) or 
// when the bird collides with the pipes, lose is on
// when the bird passes the pipes, pass is on.

module gameControl (clk, reset, position, green_position, lose, pass);
	input logic [7:0] position, green_position;
	input logic clk, reset;
	output logic lose, pass;
	
	logic collide;	
	
	always_comb begin
		if (position[0] == 1 && green_position[0] == 1)
			collide = 1;
		else if (position[1] == 1 && green_position[1] == 1)
			collide = 1;
		else if (position[2] == 1 && green_position[2] == 1)
			collide = 1;
		else if (position[3] == 1 && green_position[3] == 1)
			collide = 1;
		else if (position[4] == 1 && green_position[4] == 1)
			collide = 1;
		else if (position[5] == 1 && green_position[5] == 1)
			collide = 1;
		else if (position[6] == 1 && green_position[6] == 1)
			collide = 1;
		else if (position[7] == 1 && green_position[7] == 1)
			collide = 1;
		else
			collide = 0;
	end
	
	assign lose = ((position == 8'b00000000)||collide);
	
	enum {over, nOver} ps, ns;
	
	always_comb begin
			case (ps)
				over: begin
						ns = over;
						pass = 0;
						end
				nOver: begin
							if ((position == 8'b00000000) || collide) begin 
								// (1) when red dot drops out of the grid
								// (2) when red dot collides with green pipe
								ns = over;
								pass = 0;
							end else if (!(green_position == 8'b00000000) && ~collide) begin
								// when there's no collision with the red dot and there's green pipes on the col 4
								ns = nOver;
								pass = 1; 
							end else begin
								ns = nOver;
								pass = 0;
							end
						end
			endcase
	end
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= nOver;
		end else 
			ps <= ns;	
	end
	
endmodule

module gameControl_testbench();

	logic clk, reset, lose, pass;
	logic [7:0] position, green_position;
	
	gameControl dut (.clk, .reset, .position, .green_position, .lose, .pass);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		position = 8'b00000000;
		green_position = 8'b00000000;
	end
	
	initial begin
		reset <= 1; 																			@(posedge clk);
		reset <= 0; 																			@(posedge clk);
						position <= 8'b10000000; green_position <= 8'b00000000;	@(posedge clk); //lose = 0, pass = 0
						position <= 8'b01000000; green_position <= 8'b11110000;	@(posedge clk); //lose = 1, pass = 0
						position <= 8'b00100000; green_position <= 8'b11101111;	@(posedge clk); //lose = 1, pass = 0
						position <= 8'b00010000; green_position <= 8'b00000100;	@(posedge clk); //lose = 1, pass = 0
		reset <= 1; 																			@(posedge clk);
		reset <= 0; 																			@(posedge clk);
						position <= 8'b00001000; green_position <= 8'b11110111;	@(posedge clk); //lose = 0, pass = 1
						position <= 8'b00000100; green_position <= 8'b00001000;	@(posedge clk); //lose = 0, pass = 0
						position <= 8'b00000010; green_position <= 8'b11111111;	@(posedge clk); //lose = 1, pass = 0
						position <= 8'b00000001; green_position <= 8'b00000110;	@(posedge clk); //lose = 0, pass = 1
		reset <= 1; 																			@(posedge clk); //lose = 0, pass = 0
						
		$stop;
	end
	
endmodule

	