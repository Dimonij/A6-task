module A6_task_tb;

localparam WIDTH    = 8;
localparam MAX_DATA = 2 **  WIDTH;

bit clk, reset; 
bit d_val_i, d_val_o;
bit end_flag1, end_flag2;

bit [WIDTH-1:0]             d_in,test_counter;

bit [$clog2( WIDTH ) + 1:0] d_dut;

bit [WIDTH-1:0]             data_i_flow [$];
bit [$clog2(WIDTH) + 1:0]   d_dut_flow [$];

int                         flow_cnt;
int                         dut_count;
int                         i;


// takt generator
initial 
  forever #5 clk = !clk;

// port mapping
A6_task #( WIDTH ) DUT  (
  .clk_i     ( clk ),
  .srst_i    ( reset ),
  .data_val_i( d_val_i ),
  .data_val_o( d_val_o ),
  .data_i    ( d_in ),
  .data_o    ( d_dut )
);

initial
  begin
    end_flag1              = 0;
    #10;
    test_counter           = 0;
    flow_cnt               = 0;
    @( posedge clk ) reset = 1'b1;
    @( posedge clk ) reset = 1'b0;	
    #10;
	
	// test stimulus generator
  do begin
    @( posedge clk ) begin
      if ( $urandom_range( 1,0 ) == 1 )
        begin
          d_in     = ( $urandom_range( MAX_DATA,0 ) );
          d_val_i  = 1; 
          data_i_flow.push_front( d_in );
          flow_cnt = flow_cnt + 1;
//        $display( "data input = %b, ITERATION = %d",d_in,flow_cnt );
        end
      else 
          d_val_i = 0;
    end
  end
  while ( flow_cnt <= ( MAX_DATA / 4 ) );

  end_flag1 = 1;
  end

initial
  begin

    dut_count = 0;
    end_flag2 = 0;

    do 
    @( posedge clk ) 
      if ( d_val_o )
        begin
        d_dut_flow.push_front( d_dut );
        dut_count = dut_count + 1;
//      $display( "data output = %d, out_queue size = %d",d_dut,dut_count);
        end
    while ( dut_count <= ( MAX_DATA / 4 ) );

    end_flag2 = 1;
  end
	
initial
  begin
    wait ( end_flag1 & end_flag2 );
    for ( i = 0;i <= ( MAX_DATA / 4 );i++)
      begin
        if ( d_dut_flow [i] != $countones( data_i_flow[i] ) )
          begin
            $display( "error at data input = %b, iteration = %d", data_i_flow[i],i );
            $stop;
          end
        else
          begin
            $display( "test sucsessful!"  );
            $stop;
          end;
      end
  end
	
endmodule
