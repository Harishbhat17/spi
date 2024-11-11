`timescale 1ns / 1ps
module spi(input clk, R_or_W,vaildin,start,
input[7:0] sdata,output reg [7:0] rxd,
output reg sclk,input miso,
output reg mosi,
output reg cs,
output reg busy,validout);
typedef enum {start_s,wait_s,send_s,read_s,write_s,recive_s,readvaild_s} spi_states;
spi_states state;
reg vaild_q,start_q,start_edge;
reg [7:0] shift_reg,shift_reg_in;
wire vaild_edge;
reg [2:0] counter=0;
always @(posedge clk)
begin
vaild_q<=vaildin;
start_q<=start_s;
end
assign vaild_edge=vaildin & ~vaild_q;
assign start_edge= start &~start_q;
always @(posedge clk)
begin
case(state)
start_s:if(start_edge)

		if(R_or_W)
			state<=read_s;
		else
			state<=write_s;
	  

write_s:if(start_edge)
		state<=send_s;


send_s: if(counter==7)
		state<=start_s;
		
read_s:
		if(counter==7)
			state<=readvaild_s;
readvaild_s:
			state<=start_s;
						
	endcase
	end
	
always @(posedge clk)
		begin
			if(state==write_s && vaild_edge==1)
				shift_reg<=sdata;
			else if(state==send_s)
				shift_reg<={shift_reg[6:0],1'b0};
		
			if(state==send_s || state==recive_s)
				counter<=counter+1;
			if(state==read_s)
				shift_reg_in<={mosi,shift_reg_in[7:1]};
			if(state == readvaild_s)
				rxd<=shift_reg_in;
			else
				rxd<=0;
			if(state== readvaild_s)
					validout<=1'b1;
			else
					validout<=1'b0;
		end
		
		
		
assign mosi=shift_reg[7];	
assign sck=	(state==send_s)?clk:1'b0;
assign cs=(state==send_s)?1'b0:1'b1;
	
endmodule
