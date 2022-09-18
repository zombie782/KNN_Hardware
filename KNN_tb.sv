`timescale 1ps/1ps
`include "defs.sv"

module KNN_tb();
	
	logic clk,reset,done;
	logic [$clog2(CLASSIFICATIONS)-1:0] classif [QUERY_DATA_POINTS-1:0];
	
	KNN dut(.clk(clk),.reset(reset),.classif(classif),.done(done));
	
	initial begin
		clk=0;
		reset=0;
		
		#1 reset=1;
		#1 clk=1;
		#1 clk=0;
		#1 reset=0;
		
		
		forever begin
			#1 clk=1;
			#1 clk=0;
		end
		
		
	end
	
endmodule 