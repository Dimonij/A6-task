module A6_task

#( parameter WIDTH = 8 )

(
  input logic                          clk_i, srst_i, 
  
  input logic                          data_val_i,
  input logic  [WIDTH-1:0]             data_i,
  
  output logic                         data_val_o,
  output logic [$clog2( WIDTH ) + 1:0] data_o
);  

localparam cnw=$clog2( WIDTH ) + 1;

logic [cnw:0]     out_temp; 
logic [WIDTH-1:0] data_temp;

int wrap;

//data lock
always_ff @( posedge clk_i )
  if ( srst_i ) 
    data_temp <= 0;
  else if ( data_val_i ) 
    data_temp <= data_i;

always_ff @( posedge clk_i )
  if ( srst_i ) 
    data_val_o <= 1'b0;
  else 
    data_val_o <= data_val_i;
    
//the "ONE" unit counter 
always_comb 
  begin
    out_temp = 0;
    for ( wrap = 0; wrap < (WIDTH); wrap = wrap + 1)
      begin
        out_temp = out_temp + data_temp[ wrap ];
      end
    end 

assign data_o = out_temp;

endmodule
