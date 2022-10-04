// Billy Lin
// EE 271
// 8/15/19
// Lab 6 hexCount.sv

// Input with 1-bit values of clock, a toggle of slower clock, reset, lose indicator, increment indicator,
// outputs a 1-bit next-bit-increment indicator and a 7-bit HEX code
// when loses, the count is frozen therefore the HEX (score) is frozen; 
// when count reaches 9, we know it's time to increment the next digit of the hex, so nextIncr should be on
// when reset, the HEX and count should be reset to zero.
module hexCount (clk, cycle, reset, lose, incr, nextIncr, HEX);
	input logic clk, cycle, reset, incr, lose;
	output logic nextIncr;
	output logic [6:0] HEX;
	
	logic [3:0]count = 4'b0000;
	assign nextIncr = (count == 9);
	
	always_comb begin
		if (reset) begin
			HEX = 7'b1000000;
		end else 
			case (count)
				0: HEX = 7'b1000000;
				1: HEX = 7'b1111001;
				2: HEX = 7'b0100100;
				3: HEX = 7'b0110000;
				4: HEX = 7'b0011001;
				5: HEX = 7'b0010010;
				6: HEX = 7'b0000010;
				7: HEX = 7'b1111000;
				8: HEX = 7'b0000000;
				9: HEX = 7'b0010000;
				10: HEX = 7'b1000000;
				default: HEX = 7'bx;
			endcase
	end

	enum {add, nAdd} ps, ns;
	
	
	always_comb begin
		case (ps) 
			nAdd: if (incr && cycle) 
						ns = add;
					else 
						ns = nAdd;
			add: ns = nAdd;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			count <= 0;
			ps <= nAdd;
		end else if (cycle && count == 10) begin //if on cycle and if counts up to 10
			count <= 0;
			ps <= nAdd;
		end else if (lose) begin //if lose
			count <= count;
			ps <= ps;
		end else if (ns == add) begin //if at add state (if want to add), count add 1 and leave
			count <= count + 1;
			ps <= ns;
		end else begin
			count <= count;
			ps <= ns;
		end
	end
	
	
endmodule

module hexCount_testbench();
	logic clk, cycle, reset, lose, incr, nextIncr;
	logic [6:0] HEX;
	
	hexCount dut (clk, cycle, reset, lose, incr, nextIncr, HEX);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/4) clk <= ~clk;
	end
	
	initial begin
		cycle <= 0;
		forever #(CLOCK_PERIOD) cycle <= ~cycle;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; incr <= 0; @(posedge clk);
		for (int i = 1; i <= 11; i++) begin
			incr <= 1; @(posedge clk);
			incr <= 0; @(posedge clk);
			incr <= 0; @(posedge clk);
		end
		$stop;
	end
endmodule

	
	
	
	
	