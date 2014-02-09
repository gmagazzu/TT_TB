// NEW AM GLUE (MP).

// This module simulate a glue chip. As its behaviour does not depend from its 
// level in the 'tree', it can be used in every step of it. 
// It's made up of a multiplexer driven by a priority decoder which assigns    
// the priority to one of the four input streams. 
//
// Author Marco Pietri
// Revision: MARCO PIENDIBENE 2008
// Revision: DANIEL MAGALOTTI & MARCO PIENDIBENE 2011

`timescale 1ns/1ps
module am_glue (	clk,
						init,
						dr0_,
						dr1_,
						dr2_,
						dr3_,
						ladd0,
						ladd1,
						ladd2,
						ladd3,
					 	sel0_,
					 	sel1_,
					 	sel2_,
					 	sel3_,
					 	oadd,
					 	dr_, 
					 	bitmap_en,
						finish_road,
						rhold
					 );



//****************************
//		INPUT 
//****************************
input clk;              			  // clock input addresses & logic
input init;              			  // chip inizialization
input dr0_, dr1_, dr2_, dr3_; 	 // 'data ready' signal on each streams
input [20:0] ladd0, ladd1, ladd2, ladd3;	// local addresses, that is data flowing on each stream
input rhold;											 
input bitmap_en;	 				// bitmap ON/OFF 

//****************************
//		OUTPUT 
//****************************
output sel0_, sel1_, sel2_, sel3_;   // 'select' signals sent to inferior devices
												// praticamente servono a dire "ho letto il dato" cosi'
												// il dispositivo (lamb) ne puo mettere un altro
output [22:0] oadd;        // multiplexed data to the superior device
output dr_;                 // 'data ready' signal to the superior device
														// diventera' PUSH/WE ai serializzatori
//output [7:0] debug_am_glue;		
output finish_road;	
//output [3:0] bitmap_status;	 // bitmap ON/OFF to each LAMBGLUE (not used now)
														 // NOI LO UTILIZZEREMO!!!	

//****************************
//WIRE AND REGISTER
//****************************
wire init;
wire dr0, dr1, dr2, dr3;
wire [20:0] ladd0, ladd1, ladd2, ladd3;
wire sel0, sel1, sel2 ,sel3;
reg dr, orout_temp;
reg [22:0] oadd;

wire [20:0] data_out_fifo_0, data_out_fifo_1, data_out_fifo_2, data_out_fifo_3;

//Reverse polarity for SVT protocol compatibility	 AB may 2004
assign dr_ = !dr;
assign dr0 =!dr0_;
assign dr1 =!dr1_;
assign dr2 =!dr2_;
assign dr3 =!dr3_;
assign sel0_ =!sel0;
assign sel1_ =!sel1;
assign sel2_ =!sel2;
assign sel3_ =!sel3;

//Signal for the register before FIFO
reg [20:0] ladd0_reg, ladd1_reg, ladd2_reg, ladd3_reg;
wire almost_full_0, empty_0, full_0;
wire prog_full_0;
reg sel0_d1, sel0_d2;

//Insert the register for the road from LAMB #0
always @(posedge clk or posedge init)
  if (init)
		ladd0_reg <= 21'b000000000000000000000;
  else
		ladd0_reg <= ladd0;
		
//assign sel0 =  dr0 && (!almost_full_0);
assign sel0 =  dr0 && (!prog_full_0);

always @(posedge clk)
  begin
    sel0_d1 <= sel0;
		sel0_d2 <= sel0_d1;
end

wire wr_road_0 = sel0_d1;
wire wr_bitmap_0 = bitmap_en && sel0_d2;
		
// INPUT FROM LAMB #0
//wire fifo_0_wen = sel0_d1;
wire fifo_0_wen = wr_road_0 || wr_bitmap_0;
//wire fifo_0_ren = (!empty_0) && (!rhold);

reg fifo_0_ren;

always #2
	fifo_0_ren = (!empty_0) && (!rhold);

fifo_glue fifo_glue_0(	.clk				(clk),
								.din				(ladd0_reg),
								.rd_en			(fifo_0_ren),
								.rst				(init),
								.wr_en			(fifo_0_wen),   // ci posso scrivere se ho il dv e la fifo ha posto
								.almost_full	(almost_full_0),
								.dout				(data_out_fifo_0),
								.empty			(empty_0),
								.full				(full_0),
								.prog_full		(prog_full_0)		//insert the programmable full per non perdere una bitmap
							);


//Insert the register for the road from LAMB #1
wire almost_full_1, empty_1, full_1;
reg sel1_d1, sel1_d2;
wire prog_full_1;

always @(posedge clk or posedge init)
  if (init)
		ladd1_reg <= 21'b000000000000000000000;
  else
		ladd1_reg <= ladd1;
		
//assign sel1 =  dr1 && (!almost_full_1);
assign sel1 =  dr1 && (!prog_full_1);
  	
always @(posedge clk)
  begin
    sel1_d1 <= sel1;
		sel1_d2 <= sel1_d1;
  end

wire wr_road_1 = sel1_d1;
wire wr_bitmap_1 = bitmap_en && sel1_d2;

// INPUT FROM LAMB #1
//wire fifo_1_wen = sel1_d1;
wire fifo_1_wen = wr_road_1 || wr_bitmap_1;
wire fifo_1_ren = (!empty_1) && (empty_0) && (!rhold);

fifo_glue fifo_glue_1(	.clk				(clk),
								.din				(ladd1_reg),
								.rd_en			(fifo_1_ren),
								.rst				(init),
								.wr_en			(fifo_1_wen),   // ci posso scrivere se ho il dv e la fifo ha posto
								.almost_full	(almost_full_1),
								.dout				(data_out_fifo_1),
								.empty			(empty_1),
								.full				(full_1),
								.prog_full		(prog_full_1)
							);
										
//Insert the register for the road from LAMB #2
wire almost_full_2, empty_2, full_2;
reg sel2_d1, sel2_d2;
wire prog_full_2;

always @(posedge clk or posedge init)
  if (init)
		ladd2_reg <= 21'b000000000000000000000;
  else
		ladd2_reg <= ladd2;
		
//assign sel2 =  dr2 && (!almost_full_2);
assign sel2 =  dr2 && (!prog_full_2);
  	
always @(posedge clk)
  begin
    sel2_d1 <= sel2;
		sel2_d2 <= sel2_d1;
  end

wire wr_road_2 = sel2_d1;
wire wr_bitmap_2 = bitmap_en && sel2_d2;
	

// INPUT FROM LAMB #2
//wire fifo_2_wen = sel2_d1;
wire fifo_2_wen = wr_road_2 || wr_bitmap_2;
wire fifo_2_ren = (!empty_2) && (empty_0) && (empty_1) && (!rhold);

fifo_glue fifo_glue_2(	.clk				(clk),
								.din				(ladd2_reg),
								.rd_en			(fifo_2_ren),
								.rst				(init),
								.wr_en			(fifo_2_wen),   // ci posso scrivere se ho il dv e la fifo ha posto
								.almost_full	(almost_full_2),
								.dout				(data_out_fifo_2),
								.empty			(empty_2),
								.full				(full_2),
								.prog_full		(prog_full_2)
							);


//Insert the register for the road from LAMB #3
wire almost_full_3, empty_3, full_3;
reg sel3_d1, sel3_d2;
wire prog_full_3;

always @(posedge clk or posedge init)
  if (init)
		ladd3_reg <= 21'b000000000000000000000;
  else
		ladd3_reg <= ladd3;
		
//assign sel3 =  dr3 && (!almost_full_3);
assign sel3 =  dr3 && (!prog_full_3);

always @(posedge clk)
  begin
    sel3_d1 <= sel3;
		sel3_d2 <= sel3_d1;
  end

wire wr_road_3 = sel3_d1;
wire wr_bitmap_3 = bitmap_en && sel3_d2;
	
// INPUT FROM LAMB #3
//wire fifo_3_wen = sel3_d1;
wire fifo_3_wen = wr_road_3 || wr_bitmap_3;
wire fifo_3_ren = (!empty_3) && (empty_0) && (empty_1) && (empty_2) && (!rhold);

fifo_glue fifo_glue_3(	.clk				(clk),
								.din				(ladd3_reg),
								.rd_en			(fifo_3_ren),
								.rst				(init),
								.wr_en			(fifo_3_wen),   // ci posso scrivere se ho il dv e la fifo ha posto
								.almost_full	(almost_full_3),
								.dout				(data_out_fifo_3),
								.empty			(empty_3),
								.full				(full_3),
								.prog_full		(prog_full_3)
							);


//control if all fifo are empty
wire all_fifo_empty = (empty_0) && (empty_1) && (empty_2) && (empty_3);

// MULTIPLEXER
wire [3:0] mux_sel_temp = {fifo_3_ren, fifo_2_ren, fifo_1_ren, fifo_0_ren};

reg [3:0] mux_sel;
reg [22:0] mux_out;

always @(mux_sel or data_out_fifo_0 or data_out_fifo_1 or data_out_fifo_2 or data_out_fifo_3)
begin
  case (mux_sel)
  	4'b0001 : mux_out = {2'b00, data_out_fifo_0};
  	4'b0010 : mux_out = {2'b01, data_out_fifo_1};
  	4'b0100 : mux_out = {2'b10, data_out_fifo_2};
  	4'b1000 : mux_out = {2'b11, data_out_fifo_3};
  	default : mux_out = {23'b10101010101010101010101};
  endcase
end


// OUTPUT REGISTERs
wire out_dv = fifo_0_ren || fifo_1_ren || fifo_2_ren || fifo_3_ren;
always @(posedge clk or posedge init)
  if (init)
    begin
      oadd <= 23'b000000000000000000000;
      orout_temp <= 1'b0;
      dr <= 1'b0;
      mux_sel <= 4'b0000;
    end
  else
    begin
      oadd <= mux_out;
      orout_temp <= out_dv;
      dr <= orout_temp;
      mux_sel <= mux_sel_temp;
    end
    
//control the finish of road
wire data_ready = dr0 || dr1 || dr2 || dr3;

reg data_ready_d1;
always @(posedge clk)
begin
	data_ready_d1 <= data_ready;
end

wire finish_road_tmp =  (!data_ready) && (!data_ready_d1) && all_fifo_empty;
//far propagare per permettere all'ultima road impilata nella fifo di uscire
reg finish_road_d1;
reg finish_road_d2;
reg finish_road_d3;
always @(posedge clk)
begin
	finish_road_d1 <= finish_road_tmp;
	finish_road_d2 <= finish_road_d1;
	finish_road_d3 <= finish_road_d2;
end

wire finish_road = finish_road_d3;

endmodule
