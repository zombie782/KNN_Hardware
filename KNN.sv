`include "defs.sv"

module KNN(
	input logic clk,
	input logic reset,
	output logic [$clog2(CLASSIFICATIONS)-1:0] classif [QUERY_DATA_POINTS-1:0],
	output logic done
);
	
	logic [(DATA_DIM*DIM_PREC)-1:0] query_ram [QUERY_DATA_POINTS-1:0];
	logic [$clog2(CLASSIFICATIONS)+(DATA_DIM*DIM_PREC)-1:0] ref_ram [REF_DATA_POINTS-1:0];
	
	logic [2*DIM_PREC+1-1:0] distances [QUERY_DATA_POINTS-1:0][REF_DATA_POINTS-1:0];
	logic [2*DIM_PREC+1-1:0] sorted [QUERY_DATA_POINTS-1:0][REF_DATA_POINTS-1:0];
	logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] k_indices [QUERY_DATA_POINTS-1:0][K-1:0];
	
	logic [QUERY_DATA_POINTS-1:0] bubble_done;
	logic [QUERY_DATA_POINTS-1:0] classify_done;
	logic bubble_sort_done;
	logic cl_reset;
	
	assign bubble_sort_done=bubble_done==1;
	assign cl_reset=reset?1:bubble_sort_done?0:cl_reset;
	assign done=classify_done==1;
	
	genvar i;
	genvar j;
	generate
		for(i=0;i!=QUERY_DATA_POINTS;++i) begin: gen_query_loop
			bubble_sort bubble(.clk(clk),
									 .reset(reset),
									 .data(distances[i]),
									 .sorted_data(sorted[i]),
									 .k_indices(k_indices[i]),
									 .done(bubble_done[i]));
			classify cl(.clk(clk),
							.reset(cl_reset),
							.ref_ram(ref_ram),
							.k_indices(k_indices[i]),
							.classification(classif[i]),
							.done(classify_done[i]));
			for(j=0;j!=REF_DATA_POINTS;++j) begin: gen_ref_loop
				distance d(.query(query_ram[i][DATA_DIM*DIM_PREC-1:0]),
							  .reference(ref_ram[j][DATA_DIM*DIM_PREC-1:0]),
							  .distance(distances[i][j]));
			end
		end
	endgenerate
	
	initial begin
		$readmemb(QUERY_FILE,query_ram);
		$readmemb(REF_FILE,ref_ram);
	end 
	
endmodule 