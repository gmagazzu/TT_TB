//-- AMBSLIM: spybuffer
//-- Author: Marco Piendibene (INFN Pisa)
//-- Created: 25.06.2008 (che caldo)
//-- Revision:
//-------------------------------------------------------------------------------

`timescale 1 ns / 100 ps	
module ospy	(	clk,
					data_in,
					reset_ospy_data,
					push,
					VMEaddr,
					ospy_addr_sel,
					freeze,
					ospy_data_out,
					ospy_of,
					ospy_addr
				);		


// port declaration   
input clk;
input [29:0] data_in;
input reset_ospy_data;
input push;
input [11:2] VMEaddr;		// controllare !!!!!!!!!!
input ospy_addr_sel;
input freeze;

output [29:0] ospy_data_out;  //
output ospy_of;
output [9:0] ospy_addr;

//______________________________________________________


// wire and reg declaration
wire [9:0] ospy_addr_sig, ospy_addr_sig_tmp;  // address to read/write spybuffer


// concurrent assignment
assign ospy_addr_sig = (freeze && ospy_addr_sel) ? VMEaddr[11:2] : ospy_addr_sig_tmp;
assign ospy_addr = ospy_addr_sig;		// spybuffer address out


// RAM INSTANTIATION

ospy_ram ospy_ram_inst (	.addra(ospy_addr_sig),
									.addrb(ospy_addr_sig),
									.clka(clk),
									.clkb(clk),
									.dina(data_in), // ram input data
									.doutb(ospy_data_out),	// ram output data
									.enb(freeze),		// abilito la lettura quando sono in freeze
									.sinita(reset_ospy_data),		// ram reset
									.wea(!freeze && push)		// write enable port "a"
								);
													


// spybuffer address generator

spybuf_addr_gen spybuf_addr_gen_inst (	.clk(clk),
																				.reset(reset_ospy_data),
																				.incr(!freeze && push),	// counter increments only while not in freeze mode
																				.addr(ospy_addr_sig_tmp),
																				.overflow(ospy_of)
																			);
																				




endmodule