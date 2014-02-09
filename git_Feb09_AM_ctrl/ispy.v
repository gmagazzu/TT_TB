//-- AMBSLIM: input spybuffer
//-- Author: Marco Piendibene (INFN Pisa)
//-- Created: 10.07.2008 ()
//-- Revision:
//-------------------------------------------------------------------------------

`timescale 1 ns / 100 ps	
module ispy				(	clk,
										data_in,
										reset_ispy_data,
										push,
										VMEaddr,
										ispy_addr_sel,
										freeze,
										ispy_data_out,
										ispy_of,
										ispy_addr
						);		


// port declaration   
input clk;
input [20:0] data_in;
input reset_ispy_data;
input push;
input [11:2] VMEaddr;		// controllare !!!!!!!!!!
input ispy_addr_sel;
input freeze;

output [20:0] ispy_data_out;  //
output ispy_of;
output [9:0] ispy_addr;

//______________________________________________________


// wire and reg declaration
wire [9:0] ispy_addr_sig, ispy_addr_sig_tmp;  // address to read/write spybuffer


// concurrent assignment
assign ispy_addr_sig = (freeze && ispy_addr_sel) ? VMEaddr[11:2] : ispy_addr_sig_tmp;
assign ispy_addr = ispy_addr_sig;		// spybuffer address out


// RAM INSTANTIATION
ispy_ram ispy_ram_inst (	.addra(ispy_addr_sig),
													.addrb(ispy_addr_sig),
													.clka(clk),
													.clkb(clk),
													.dina(data_in), // ram input data
													.doutb(ispy_data_out),	// ram output data
													.enb(freeze),		// abilito la lettura quando sono in freeze
													.sinita(reset_ispy_data),		// ram reset
													.wea(!freeze && push)		// write enable port "a"
												);

// spybuffer address generator

spybuf_addr_gen spybuf_addr_gen_inst (	.clk(clk),
																				.reset(reset_ispy_data),
																				.incr(!freeze && push),	// counter increments only while not in freeze mode
																				.addr(ispy_addr_sig_tmp),
																				.overflow(ispy_of)
																			);
																				




endmodule
