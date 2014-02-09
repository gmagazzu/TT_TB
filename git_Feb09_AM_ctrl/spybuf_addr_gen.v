//-- AMBSLIM: spybuf address generator
//-- Author: Marco Piendibene (INFN Pisa)
//-- Created: 25.06.2008 (fa un caldo si more)
//-- Revision:
//-------------------------------------------------------------------------------

`timescale 1 ns / 100 ps	
module spybuf_addr_gen	(	clk,
													reset,
													incr,
													addr,
													overflow
												);


// port declaration     
input clk;
input reset;
input incr;

output [9:0] addr;
output overflow;


// wire and reg declaration
wire logic1 = 1'b1;
reg [10:0] count11;  // 11 bits counter; bit 11 is used as overflow detector
reg ena_overflow;
reg overflow;

//-----------------------------------------------------------------------------------

// 11 bits counter and overflow detection
always@(posedge clk or posedge reset)
begin
  if (reset)
    begin
    count11 <= 11'b0;
    ena_overflow <= 1'b0;
    end
  else
    begin
    if (incr) count11 <= count11 + 1;
    if (count11 == 11'b10000000000) ena_overflow <= 1'b1;		// overflow detection
    end
end
    

//  register
always@(posedge clk or posedge reset)
begin
	if (reset)
		overflow <= 1'b0;
	else
		if (ena_overflow) overflow <= logic1;
end


// concurrent assignment
assign addr = count11[9:0];



endmodule
