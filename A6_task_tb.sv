module A6_task_tb;

localparam WIDTH=32;

bit clk, reset,d_val_i, d_val_o;
bit [WIDTH-1:0] d_in,test_counter;
bit [$clog2(WIDTH)+1:0] d_dut;


// takt generator
initial 
forever #5 clk=!clk;

// port mapping
A6_task #(WIDTH) DUT  (
.clk_i (clk),
.srst_i(reset),
.data_val_i(d_val_i),
.data_val_o(d_val_o),
.data_i(d_in),
.data_o(d_dut)
);

initial
	begin
	#10;
	test_counter=0;
	@(posedge clk) reset=1'b1;
	@(posedge clk) reset=1'b0;	
	#10;

	do begin
	d_in=test_counter;
	@(posedge clk) d_val_i=1'b1;
	@(posedge clk) d_val_i=1'b0;	
        wait (d_val_o==1) $display("data input=%b, ONE`s found=%d",d_in,d_dut);
	test_counter=test_counter+1;
	end
	while ($countones(test_counter)!=WIDTH);
	d_in=test_counter;
	@(posedge clk) d_val_i=1'b1;
	@(posedge clk) d_val_i=1'b0;	
        wait (d_val_o==1) $display("data input=%b, ONE`s found=%d",d_in,d_dut);
	end
endmodule
