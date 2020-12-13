
module niosLab2 (
	clk_clk,
	leds_name,
	reset_reset_n,
	sw_export,
	vroomvroom_export);	

	input		clk_clk;
	output	[5:0]	leds_name;
	input		reset_reset_n;
	input	[9:0]	sw_export;
	output	[3:0]	vroomvroom_export;
endmodule
