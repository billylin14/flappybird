// Billy Lin
// EE 271
// 8/15/19
// Lab 6 greenPattern.sv
// Input with a 1-bit of clock, reset, and lose indicator
// outputs a 8-bit pattern of the green pipe.

module greenPattern (clk, pattern, reset, lose);
	input logic clk, reset, lose;
	output logic [7:0] pattern;
	
	logic [2:0] n;
	LFSR_3bit random (.clk(clk), .reset(reset), .Q(n));
	
	//parameter A = 0, B = 1, C = 2, D = 3, E = 4;
	enum {A, B, C, D, E} ps, ns;
	
	//next state logic
	always_comb begin
		case (ps) 
			A: if (n[0]) ns = C;
				else ns = B;
			B: if (n[0]) ns = C;
				else ns = A;
			C: if (n[0]) ns = D;
				else ns = B;
			D: if (n[0]) ns = E;
				else ns = C;
			E: if (n[0]) ns = D;
				else ns = C;
		endcase
	end
	
	//output logic
	integer gap_count = 0;
	
	always_comb begin
		if (gap_count != 2)
			pattern = 8'b00000000;
		else
			case (ps)
				A: pattern = 8'b10011111;
				B: pattern = 8'b11001111;
				C: pattern = 8'b11100111;
				D: pattern = 8'b11110011;
				E: pattern = 8'b11111001;
			endcase
	end
	
	//DFF logic
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= C;
			gap_count <= 0;
		end else if (lose) begin
			ps <= ps;
			gap_count <= gap_count;
		end else if (gap_count == 2) begin
			ps <= ns;
			gap_count <= 0;
		end else begin
			ps <= ns;
			gap_count <= gap_count + 1;
		end
	end

endmodule

module greenPattern_testbench();

	logic clk, reset, lose;
	logic [7:0] pattern;
	
	greenPattern dut (.clk, .pattern, .reset, .lose);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; 			  @(posedge clk);
		reset <= 0; lose <= 0; @(posedge clk);
		for (int i = 1; i <= 10; i++) begin     //testing patterns
			reset <= 0; lose <= 0; @(posedge clk);
		end
		reset <= 0; lose <= 1; @(posedge clk); //testing lose
		for (int i = 1; i <= 10; i++) begin
			reset <= 0; lose <= 1; @(posedge clk);
		end
		reset <= 1; lose <= 0; @(posedge clk); //testing reset
		for (int i = 1; i <= 10; i++) begin
			reset <= 0; lose <= 0; @(posedge clk);
		end
		$stop;
	end
endmodule