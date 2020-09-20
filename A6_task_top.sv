module A6_task_top

#( parameter WIDTH = 8 )

(
input  logic                         clk_i, srst_i,

input  logic                         data_val_i,
input  logic [WIDTH-1:0]             data_i,

output logic                         data_val_o,
output logic [$clog2( WIDTH ) + 1:0] data_o
);

logic [$clog2( WIDTH ) + 1:0] data_o_buf; //output  data   buffer
logic [WIDTH-1:0]             data_i_buf; //input   data   buffer
logic                         srst_i_buf;
logic                         data_val_i_buf;
logic                         data_val_o_buf;

// port mapping
A6_task #( WIDTH ) A6_core_unit
(
  .clk_i      ( clk_i ),
  .srst_i     ( srst_i_buf ),
  .data_val_i ( data_val_i_buf ),
  .data_val_o ( data_val_o_buf ),
  .data_i     ( data_i_buf ),
  .data_o     ( data_o_buf )
);

//data locking
always_ff @( posedge clk_i )
  begin
   srst_i_buf      <= srst_i;
   data_val_i_buf  <= data_val_i;
   data_i_buf      <= data_i;
  
   data_o          <= data_o_buf;
   data_val_o      <= data_val_o_buf;
  end

endmodule
