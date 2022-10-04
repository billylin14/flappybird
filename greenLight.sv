// Billy Lin
// EE 271
// 8/15/19
// Lab 6 greenLight.sv

//done testing

module greenLight(clk, reset, lose, rightOn, lightOn);
	input logic clk, reset, rightOn, lose;
	output logic lightOn;
	
	enum {on, off}ps, ns;
	
	always_comb begin
		case (ps)
			on: begin 
					ns = off;
					lightOn = 1;
				 end
			off:begin
					if (rightOn) begin
						ns = on;
						lightOn = 0;
					end
					else begin
						ns = off;
						lightOn = 0;
					end
				 end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) ps <= off;
		else if (lose) ps <= ps;
		else ps <= ns;
	end
endmodule


module greenLight_testbench();

	logic clk, reset, lose, rightOn, lightOn;
	
	greenLight dut (clk, reset, lose, rightOn, lightOn);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1;					 				@(posedge clk); 
		reset <= 0;	rightOn <=0; lose <= 0; @(posedge clk); //off 	
						rightOn <=1; lose <= 0; @(posedge clk); //off	
						rightOn <=0; lose <= 1; @(posedge clk); //on
						rightOn <=0; lose <= 1; @(posedge clk); //on		
						rightOn <=1; lose <= 1; @(posedge clk); //on
						rightOn <=0; lose <= 0; @(posedge clk); //on
						rightOn <=0; lose <= 0; @(posedge clk); //off
		reset <= 1;									@(posedge clk); //off
		reset <= 0;	rightOn <=0; lose <= 1; @(posedge clk); //off
						rightOn <=0; lose <= 1; @(posedge clk); //off
						rightOn <=0; lose <= 1; @(posedge clk); //off
						$stop; // End the simulation
	end
endmodule


