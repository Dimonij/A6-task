module A6_task
#(parameter WIDTH=8)
(input logic clk_i, srst_i, data_val_i,
 input logic [WIDTH-1:0] data_i,
 output logic [$clog2(WIDTH)+1:0] data_o,
 output logic data_val_o);

localparam cnw=$clog2(WIDTH)+1;

logic [cnw:0] out_temp; 
logic [WIDTH-1:0] data_temp;
logic uup,count_ready,count_start;
enum {IDLE,LOAD,COUNT,PULSE} state, nextstate;
int wrap;

// main fsm
always_ff @(posedge clk_i) // synchro process
	if (srst_i)
		state<=IDLE;
	else
		state<=nextstate;

always_comb // state logic
	begin
	nextstate=state;
	case (state)
	IDLE: if (data_val_i) nextstate=LOAD; else nextstate=IDLE;
	LOAD: nextstate=COUNT;
	COUNT: if (count_ready) nextstate=PULSE; else nextstate=COUNT;
	PULSE: nextstate=IDLE;
	default:nextstate=IDLE;
	endcase;
	end

always_comb  //output logic
	begin
//	data_val_o=0;
//	count_start=0;
//	data_temp=0;
	
	case (state)
	IDLE: begin
		count_start=0;
		data_val_o=0;
		end
		
	LOAD: data_temp=data_i;
	COUNT: count_start=1;
	PULSE: data_val_o=1;
	default: 
				begin
				data_val_o=0;
				count_start=0;
				data_temp=0;
				end
				
	endcase;
	end

//the "ONE" unit counter :)
always_ff @(posedge clk_i)
	if (~count_start) begin
				wrap<=0;
				count_ready<=0;
				out_temp<=0;
			  end
	else 
		if (wrap<=WIDTH) begin
					if (data_temp[wrap]) 
							begin
							out_temp<=out_temp+1;
							wrap<=wrap+1;
							end
					else wrap<=wrap+1;
 				 end
								 
		else 
		     if (wrap>WIDTH) count_ready<=1;


assign data_o=out_temp;

endmodule
