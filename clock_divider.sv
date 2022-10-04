// Billy Lin
// EE 271
// 8/15/19
// Lab 6 clock_divider.sv

// input with a clock,
// outputs a clock with a slower rate

module clock_divider (clock, divided_clocks);
	// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
	// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
	input logic clock;    
	output logic [31:0] divided_clocks;    
	
	initial begin        
		divided_clocks <= 0;    
	end    
	
	always_ff @(posedge clock) begin        
		divided_clocks <= divided_clocks + 1;
    end
endmodule
