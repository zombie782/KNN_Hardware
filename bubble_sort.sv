`include "defs.sv"

module bubble_sort(
	input logic clk,
	input logic reset,
	input logic [2*DIM_PREC+1-1:0] data [REF_DATA_POINTS-1:0],
	output logic [2*DIM_PREC+1-1:0] sorted_data [REF_DATA_POINTS-1:0],
	output logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] k_indices [K-1:0],
	output logic done
);
	
	logic go;
	logic [2*DIM_PREC+1-1:0] local_data [REF_DATA_POINTS-1:0];
	logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] indices [REF_DATA_POINTS-1:0];
	
	function void swap_consec(logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] index);
		if(index<REF_DATA_POINTS-1 && local_data[index]>local_data[index+1]) begin
			automatic logic [2*DIM_PREC+1-1:0] local_data_temp=local_data[index];
			automatic logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] indices_temp=indices[index];
			local_data[index]=local_data[index+1];
			local_data[index+1]=local_data_temp;
			indices[index]=indices[index+1];
			indices[index+1]=indices_temp;
		end
	endfunction
	
	logic [$clog2(REF_DATA_POINTS-2+2*(K-1))-1:0] swap_index [K-1:0];
	logic bubble_status [K-1:0];
	
	assign go=(reset | done)?0:1;
	assign sorted_data=local_data;
	assign k_indices=indices[K-1:0];
	
	always_ff @(posedge clk) begin
		if(reset) begin
			local_data=data;
			for(logic [$clog2(REF_DATA_POINTS):0] i=0;i!=REF_DATA_POINTS;++i) begin
				indices[i]=i;
			end
			for(logic [$clog2(K):0] i=0;i!=K;++i) begin
				swap_index[i]<=REF_DATA_POINTS-2+2*i;
				bubble_status[i]=1;
			end
		end
		else if(go) begin
			for(logic [$clog2(K):0] i=0;i!=K;++i) begin
				if(bubble_status[i])
					swap_consec(.index(swap_index[i]));
				swap_index[i]<=swap_index[i]==0?0:swap_index[i]-1;
				bubble_status[i]<=swap_index[i]==0?0:bubble_status[i];
			end
		end
	end
	
	always_ff @(posedge clk) begin
		if(reset)
			done<=0;
		else if(~done)
			done<=swap_index[K-1]==K-1;
	end

endmodule 