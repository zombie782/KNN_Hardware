`include "defs.sv"

module classify(
	input logic clk,
	input logic reset,
	input logic [$clog2(CLASSIFICATIONS)+(DATA_DIM*DIM_PREC)-1:0] ref_ram [REF_DATA_POINTS-1:0],
	input logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] k_indices [K-1:0],
	output logic [$clog2(CLASSIFICATIONS)-1:0] classification,
	output logic done
);

	logic [$clog2(K):0] classification_tally [CLASSIFICATIONS-1:0];
	logic [$clog2(K):0] cnt;
	
	always_ff @(posedge clk) begin
		if(reset) begin
			for(logic [$clog2(CLASSIFICATIONS):0] i=0;i!=CLASSIFICATIONS;++i)
				classification_tally[i]<=0;
			cnt<=0;
		end
		else if(cnt!=K) begin
			classification_tally[ref_ram[k_indices[cnt]][$clog2(CLASSIFICATIONS)+(DATA_DIM*DIM_PREC)-1:(DATA_DIM*DIM_PREC)]]<=
			classification_tally[ref_ram[k_indices[cnt]][$clog2(CLASSIFICATIONS)+(DATA_DIM*DIM_PREC)-1:(DATA_DIM*DIM_PREC)]]+1;
			cnt<=cnt+1;
		end
	end
	
	always_comb begin
		done=0;
		classification=0;
		if(cnt==K) begin
			for(logic [$clog2(CLASSIFICATIONS):0] i=0;i!=CLASSIFICATIONS;++i) begin
				if(classification_tally[i]>classification_tally[classification]) begin
					classification=i;
				end
			end
			done=1;
		end
	end
	
endmodule 