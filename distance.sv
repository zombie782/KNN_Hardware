`include "defs.sv"

module distance(
	input logic [DATA_DIM*DIM_PREC-1:0] query,
	input logic [DATA_DIM*DIM_PREC-1:0] reference,
	output logic [2*DIM_PREC+1-1:0] distance
);

	logic [2*DIM_PREC-1:0] terms [DATA_DIM-1:0];
	
	assign distance=terms.sum;
	
	genvar i;
	generate
		for(i=0;i!=DATA_DIM;++i) begin: gen_dim
			assign terms[i]=(query[DIM_PREC*(i+1)-1:DIM_PREC*i]-reference[DIM_PREC*(i+1)-1:DIM_PREC*i])*
								 (query[DIM_PREC*(i+1)-1:DIM_PREC*i]-reference[DIM_PREC*(i+1)-1:DIM_PREC*i]);
		end
	endgenerate
	
endmodule 