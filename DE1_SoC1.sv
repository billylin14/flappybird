module DE1_SoC1(CLOCK_50, GPIO_0);

	input  logic        CLOCK_50;
	output logic [35:0] GPIO_0;
	
	// ------------------------------------------------------ //

	//Clock Divider setup
	
	logic [31:0] divided_clocks;
	
	clock_divider divider (.clock(CLOCK_50), .divided_clocks(divided_clocks));
	
	// ------------------------------------------------------ //
	
	// LED Driver setup
	logic            driver_clk;                         // Driver clock, under 1 MHz
	logic [7:0]      red_driver, green_driver, row_sink; // Driver pin mappings. Set once and forget.
	logic [7:0][7:0] red_array, green_array;             // 8x8 arrays you use to set the display.
	
	assign driver_clk   = divided_clocks[15]; // 50 MHz/2^(15+1) = 763 Hz. Anything below 1 MHz is fine 
                                             // but slower clocks will give a brighter display.
	assign GPIO_0[35:28] = red_driver;
	assign GPIO_0[27:20] = green_driver;
	assign GPIO_0[19:12] = row_sink;

	// LED Driver (performs automatic ground multiplexing). Set it once and forget it.
	led_matrix_driver driver (.clock(driver_clk), .red_driver, .green_driver, .row_sink, .red_array, .green_array); 
	
	// ------------------------------------------------------ //

	// Flash LED matrix all red, then all green, twice per second
	
	integer cycle_count;
	
	initial red_array   = '1;
	initial green_array = '0;
	
	always_ff @ (posedge driver_clk) begin
		
		// driver_clk is 763 Hz, so an internal counter to 400 will cause 
		// the animation to toggle about twice per second.
		
		if (cycle_count >= 400) begin // change this number to adjust the speed of animation
			red_array   <= ~red_array;
			green_array <= ~green_array;
			cycle_count <= 0; // be sure to reset the counter when the animation triggers
		end
		else
			cycle_count <= cycle_count + 1;
	end
		
endmodule
