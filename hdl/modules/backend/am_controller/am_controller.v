`timescale 1ns/1ps

module am_controller(	
            phi,
            z,
            clk,						// (I) System clock, 40 Mhz
						init,						// (O) Reset genrato a partire da back_init e da vme

// **** VME PORTS ****

						vme_data,			// (IO) VME data bus (32 bits)

						vadd,						// (I) Valid Address bits (identifies the internal chip of the board)

						am,						// (I) Address mode signal

						geadd,					// (I) geographical address

						as_b,						// (I) address strobe

						ds0_b,						// (I) data strobe		
						ds1_b,						// (I) data strobe		

						berr_b,					// (O) Bus error signal. Asserted when address is wrong

						iack_b,					// (I) Interrupt aknowledge

						lword_b,					// (I) Long word signal

						write_b,					// (I) States the direction of data flow

						dtack_b,					// (O) Data aknowledge signal

// From/To Stub FIFOs

						lay0_p0_in,				      // (I) Input from the Stub FIFO (Layer_0 - Port_0)
						lay1_p0_in,				      // (I) Input from the Stub FIFO (Layer_1 - Port_0)
						lay2_p0_in,				      // (I) Input from the Stub FIFO (Layer_2 - Port_0)
						lay3_p0_in,				      // (I) Input from the Stub FIFO (Layer_3 - Port_0)
						lay4_p0_in,				      // (I) Input from the Stub FIFO (Layer_4 - Port_0)
						lay5_p0_in,				      // (I) Input from the Stub FIFO (Layer_5 - Port_0)
						
						p0_ef_b,						       // (I) Stub FIFO empty flags
						p0_rden_b,					      // (O) Stub FIFO read enables

						lay0_p1_in,				      // (I) Input from the Stub FIFO (Layer_0 - Port_1)
						lay1_p1_in,				      // (I) Input from the Stub FIFO (Layer_1 - Port_1)
						lay2_p1_in,				      // (I) Input from the Stub FIFO (Layer_2 - Port_1)
						lay3_p1_in,				      // (I) Input from the Stub FIFO (Layer_3 - Port_1)
						lay4_p1_in,				      // (I) Input from the Stub FIFO (Layer_4 - Port_1)
						lay5_p1_in,				      // (I) Input from the Stub FIFO (Layer_5 - Port_1)
						
						p1_ef_b,						       // (I) Stub FIFO empty flags
						p1_rden_b,					      // (O) Stub FIFO read enables

						lay0_p2_in,				      // (I) Input from the Stub FIFO (Layer_0 - Port_2)
						lay1_p2_in,				      // (I) Input from the Stub FIFO (Layer_1 - Port_2)
						lay2_p2_in,				      // (I) Input from the Stub FIFO (Layer_2 - Port_2)
						lay3_p2_in,				      // (I) Input from the Stub FIFO (Layer_3 - Port_2)
						lay4_p2_in,				      // (I) Input from the Stub FIFO (Layer_4 - Port_2)
						lay5_p2_in,				      // (I) Input from the Stub FIFO (Layer_5 - Port_2)
						
						p2_ef_b,						       // (I) Stub FIFO empty flags
						p2_rden_b,					      // (O) Stub FIFO read enables

						lay0_p3_in,				      // (I) Input from the Stub FIFO (Layer_0 - Port_3)
						lay1_p3_in,				      // (I) Input from the Stub FIFO (Layer_1 - Port_3)
						lay2_p3_in,				      // (I) Input from the Stub FIFO (Layer_2 - Port_3)
						lay3_p3_in,				      // (I) Input from the Stub FIFO (Layer_3 - Port_3)
						lay4_p3_in,				      // (I) Input from the Stub FIFO (Layer_4 - Port_3)
						lay5_p3_in,				      // (I) Input from the Stub FIFO (Layer_5 - Port_3)
						
						p3_ef_b,						       // (I) Stub FIFO empty flags
						p3_rden_b,					      // (O) Stub FIFO read enables

						resfifo0_b,				      // (O) Hit fifos reset
						resfifo1_b,				      // (O) Hit fifos reset
									

// From/To LAMB_A

						A0_HIT,					      // (O) Bus for lamb A
						A1_HIT,					      // (O) Bus for lamb A
						A2_HIT,					      // (O) Bus for lamb A
						A3_HIT,					      // (O) Bus for lamb A
						A4_HIT,					      // (O) Bus for lamb A
						A5_HIT, 				      // (O) Bus for lamb A
						enA_wr,					      // (O) Enable for the 6 buses at each of 4 lambs
						init_ev0_lamb0, 		// (O) Lamb0 init. From main FSM
						init_ev1_lamb0, 		// (O) Lamb0 init. From main FSM
						init_ev2_lamb0, 		// (O) Lamb0 init. From main FSM
						sel0_b,					      // (O) data acknowledge for lamb0
						opcode0_out,			   // (O) OPCODE lamb0
						dr0_b,						      // (I) Valid data from lamb0
						ladd0,					       // (I) data (road) form lamb0
						tck_am_lamb0,			  // (O) tck signal to LAMB0 board

// From/To LAMB_B

						B0_HIT,					      // (O) Bus for lamb B
						B1_HIT,					      // (O) Bus for lamb B
						B2_HIT,					      // (O) Bus for lamb B
						B3_HIT,					      // (O) Bus for lamb B
						B4_HIT,				       // (O) Bus for lamb B // non lo usiamo questo bus (commented)
						B5_HIT,					      // (O) Bus for lamb B
						enB_wr,					      // (O) Enable for the 6 buses at each of 4 lambs
						init_ev0_lamb1, 		// (O) Lamb1 init. From main FSM
						init_ev1_lamb1, 		// (O) Lamb1 init. From main FSM
						init_ev2_lamb1, 		// (O) Lamb1 init. From main FSM
						sel1_b,					      // (O) data acknowledge for lamb1
						opcode1_out,			   // (O) OPCODE lamb1
						dr1_b,						      // (I) Valid data from lamb1
						ladd1,					       // (I) data (road) form lamb1
						tck_am_lamb1,			  // (O) tck signal to LAMB1 board

// From/To LAMB_C

						C0_HIT,					      // (O) Bus for lamb C
						C1_HIT,					      // (O) Bus for lamb C
						C2_HIT,					      // (O) Bus for lamb C
						C3_HIT,					      // (O) Bus for lamb C
						C4_HIT,					      // (O) Bus for lamb C
						C5_HIT,					      // (O) Bus for lamb C
						enC_wr,					      // (O) Enable for the 6 buses at each of 4 lambs
						init_ev0_lamb2, 		// (O) Lamb2 init. From main FSM
						init_ev1_lamb2, 		// (O) Lamb2 init. From main FSM
						init_ev2_lamb2, 		// (O) Lamb2 init. From main FSM
						sel2_b,					      // (O) data acknowledge for lamb2
						opcode2_out,			   // (O) OPCODE lamb2
						dr2_b,						      // (I) Valid data from lamb2
						ladd2,					       // (I) data (road) form lamb2
						tck_am_lamb2,			  // (O) tck signal to LAMB2 board

// From/To LAMB_D

						D0_HIT,					      // (O) Bus for lamb D
						D1_HIT,					      // (O) Bus for lamb D
						D2_HIT,					      // (O) Bus for lamb D 
						D3_HIT,					      // (O) Bus for lamb D
						D4_HIT,				       // (O) Bus for lamb D  // non lo usiamo questo bus (commented)
						D5_HIT,					      // (O) Bus for lamb D
						enD_wr,					      // (O) Enable for the 6 buses at each of 4 lambs
						init_ev0_lamb3, 		// (O) Lamb3 init. From main FSM
						init_ev1_lamb3, 		// (O) Lamb3 init. From main FSM
						init_ev2_lamb3, 		// (O) Lamb3 init. From main FSM
						sel3_b,   				    // (O) data acknowledge for lamb3
						opcode3_out,			   // (O) OPCODE lamb3
						dr3_b,						      // (I) Valid data from lamb3
						ladd3,					       // (I) data (road) form lamb3
						tck_am_lamb3,			  // (O) tck signal to LAMB3 board
						
// Other signals

						p0_odata,					// (O) Roads (only from lamb in SLIM)
						p1_odata,					// (O) Roads (only from lamb in SLIM)
						p2_odata,					// (O) Roads (only from lamb in SLIM)
						p3_odata,					// (O) Roads (only from lamb in SLIM)
						wr_road,					// (O) Data valid for the roads
						push,						// (O) sends the hit to P3 output. Only for debug in SLIM (?????????)
						bitmap_status,			// (O) indicates road or road+bitmap at lambs
						wrpam,					// (O) write enable signal on PAM register via TDI
						rdbscan,					// (O) read enable of the output of boundary scan chip
						enb_b,						// (O) Data flow direction on the bscan registers
						dirw_b,					// (O) Data flow direction on the bscan registers
						add,						// (O) VME address subset sent to bscan chip on lamb
						lamb_spare,    		// 
						road_end,      		//
						rhold_b,					// (I) Hold delle fifo delle schede a valle. Noi non li abbiamo ????????
						backhold_b,				// (I)  (?????????????????????????????????????????)
						en_back,					// (I) Enable road output on P2 (for debug)
					  back_init				// (I) Init From P2 (backplane init)
						
						
						//init_iam0,			// al posto loro generare 12 segnali di reset (3 per lamb)
						//init_iam1,			// al posto loro generare 12 segnali di reset (3 per lamb)
						
						
						
						
						//roadend0_in,			// (I) dalle lamb: sostituiti da una parola di end_event
						//roadend1_in,			// (I) dalle lamb: sostituiti da una parola di end_event
						//roadend2_in,			// (I) dalle lamb: sostituiti da una parola di end_event
						//roadend3_in,			// (I) dalle lamb: sostituiti da una parola di end_event
			);





////////////////////////
//// I N P U T /////////
////////////////////////
input  [3:0] phi,z;
input  clk;
input  dr0_b, dr1_b, dr2_b, dr3_b;
input  [20:0] ladd0, ladd1,ladd2, ladd3;
input  [3:0] lamb_spare;
input  [3:0] road_end;
input  rhold_b;
input  backhold_b;
input  en_back;   	//(?????????????????????) NOT USED

//input  [20:0] lay0_in, lay1_in, lay2_in;
//input  [20:0] lay3_in, lay4_in, lay5_in;
input  [20:0] lay0_p0_in, lay0_p1_in, lay0_p2_in, lay0_p3_in;
input  [20:0] lay1_p0_in, lay1_p1_in, lay1_p2_in, lay1_p3_in;
input  [20:0] lay2_p0_in, lay2_p1_in, lay2_p2_in, lay2_p3_in;
input  [20:0] lay3_p0_in, lay3_p1_in, lay3_p2_in, lay3_p3_in;
input  [20:0] lay4_p0_in, lay4_p1_in, lay4_p2_in, lay4_p3_in;
input  [20:0] lay5_p0_in, lay5_p1_in, lay5_p2_in, lay5_p3_in;

inout  [31:0] vme_data;
input  back_init;					// Init From P2 (backplane init)
input  [4:0]geadd;				// geographical address
input  as_b;							// address strobe
input  ds0_b;						// data strobe		
input  ds1_b;						// data strobe		
input  [5:0]am;					// Address mode signal
input  lword_b;						// Long word signal
input  iack_b;						// Interrupt aknowledge
input  write_b;						// States the direction of data flow
input  [31:1]vadd;				// Valid Address bits (identifies the internal chip of the board)

//input [5:0] ef_b;
input [5:0] p0_ef_b, p1_ef_b, p2_ef_b, p3_ef_b;


////////////////////////
//// O U T P U T ///////
////////////////////////
output init;
output [5:0] push;
output [3:0] bitmap_status;
output sel0_b, sel1_b, sel2_b, sel3_b;
output [3:0] opcode0_out, opcode1_out, opcode2_out, opcode3_out;
output init_ev0_lamb0, init_ev1_lamb0, init_ev2_lamb0;
output init_ev0_lamb1, init_ev1_lamb1, init_ev2_lamb1;  
output init_ev0_lamb2, init_ev1_lamb2, init_ev2_lamb2;  
output init_ev0_lamb3, init_ev1_lamb3, init_ev2_lamb3;
output wrpam;							// write enable signal on PAM register via TDI
output rdbscan;						// read enable of the output of boundary scan chip
output berr_b;							// Bus error singnal. Asserted when address is wrong
output dtack_b;							// Data aknowledge signal
output enb_b;							// Data flow direction on the bscan registers
output dirw_b;							// Data flow direction on the bscan registers
output [2:0]add;						// VME address subset sent to bscan chip on lamb	
output tck_am_lamb0;					// tck signal to LAMB 0 board
output tck_am_lamb1;					// tck signal to LAMB 0 board
output tck_am_lamb2;					// tck signal to LAMB 0 board
output tck_am_lamb3;					// tck signal to LAMB 0 board
output [17:0] A0_HIT, A1_HIT, A2_HIT;			// 6 buses for LAMB A
output [17:0] A3_HIT, A4_HIT, A5_HIT;			
output [17:0] B0_HIT, B1_HIT, B2_HIT; 			// 6 buses for LAMB B
output [17:0] B3_HIT, B4_HIT, B5_HIT; 	//  B4_HIT non lo usiamo
output [17:0] C0_HIT, C1_HIT, C2_HIT; 			// 6 buses for LAMB C
output [17:0] C3_HIT, C4_HIT, C5_HIT; 
output [17:0] D0_HIT, D1_HIT, D2_HIT; 			// 6 buses for LAMB D
output [17:0] D3_HIT, D4_HIT, D5_HIT; 		//  D4_HIT non lo usiamo
output [5:0] enA_wr, enB_wr, enC_wr, enD_wr;		// enables for 6 buses at each of 4 Lambs
//output [29:0] odata;      								 // dati in uscita dalla scheda
output [29:0] p0_odata;      								 // dati in uscita dalla scheda
output [29:0] p1_odata;      								 // dati in uscita dalla scheda
output [29:0] p2_odata;      								 // dati in uscita dalla scheda
output [29:0] p3_odata;      								 // dati in uscita dalla scheda

//output [5:0] rden_b;
output [5:0] p0_rden_b, p1_rden_b, p2_rden_b, p3_rden_b;

output resfifo0_b, resfifo1_b;
// to be modified
output [3:0] wr_road;             	 // data strobe_ per la fifo della scheda successiva



//////////////////////////////
//// W I R E AND R E G ///////
//////////////////////////////
// inverto il layer0 perche' e' sbagliato il routing sulla scheda
wire clk;
wire init;
wire [3:0] road_end;
//wire [22:0] ladd;
wire [22:0] p0_ladd,p1_ladd,p2_ladd,p3_ladd;
wire [3:0] sel_loc_road;
wire [3:0] dr_;
// wire [29:0] odata_tmp;		// odata
wire [29:0] p0_odata_tmp,p1_odata_tmp,p2_odata_tmp,p3_odata_tmp;		// odata
// to be modified
wire [3:0] wr_road;
wire p0_init_ev,p1_init_ev,p2_init_ev,p3_init_ev;
wire [19:0] ivdata_input;
wire [31:0] ivdata_vme;
wire [26:2] ivadd;		// internal vme addr. From vme module
wire rd_input, wr_input;
wire rd_vme;
//wire [7:0] debug_am_glue;
wire [1:0] input_ctr_debug;
wire [5:0] p0_hee_reg,p1_hee_reg,p2_hee_reg,p3_hee_reg;
wire [2:0] p0_state;					// per debug li andiamo a rileggere via vme
wire [2:0] p1_state;					// per debug li andiamo a rileggere via vme
wire [2:0] p2_state;					// per debug li andiamo a rileggere via vme
wire [2:0] p3_state;					// per debug li andiamo a rileggere via vme
wire [5:0] p0_en,p1_en,p2_en,p3_en;		
wire [2:0] rwadd;
wire [17:0]hitmask;		// Maschera per gli hit che vanno alle lambs
wire [17:0]xxx_hitmask = 18'b0;		// Maschera per gli hit che vanno alle lambs
wire int_clk;
wire [5:0] p0_reg_en,p1_reg_en,p2_reg_en,p3_reg_en;
wire [5:0] p0_pok,p1_pok,p2_pok,p3_pok;	
wire [5:0] p0_pop,p1_pop,p2_pop,p3_pop;	
wire [15:0] p0_curr_tag,p1_curr_tag,p2_curr_tag,p3_curr_tag;
wire logic_0 = 1'b0;
//wire logic1 = 1'b1;


wire [31:0] count_patt;
wire [31:0] count_event;
wire [19:0] vme_input0_fifo;
wire [19:0] vme_input1_fifo;
wire [19:0] vme_input2_fifo;
wire [19:0] vme_input3_fifo;
wire [19:0] vme_input4_fifo;
wire [19:0] vme_input5_fifo;

wire [20:0] p0_data_ispy0,p1_data_ispy0,p2_data_ispy0,p3_data_ispy0;
wire [20:0] p0_data_ispy1,p1_data_ispy1,p2_data_ispy1,p3_data_ispy1;
wire [20:0] p0_data_ispy2,p1_data_ispy2,p2_data_ispy2,p3_data_ispy2;
wire [20:0] p0_data_ispy3,p1_data_ispy3,p2_data_ispy3,p3_data_ispy3;
wire [20:0] p0_data_ispy4,p1_data_ispy4,p2_data_ispy4,p3_data_ispy4;
wire [20:0] p0_data_ispy5,p1_data_ispy5,p2_data_ispy5,p3_data_ispy5;

wire [17:0] p0_HIT_lay0,p1_HIT_lay0,p2_HIT_lay0,p3_HIT_lay0;
wire [17:0] p0_HIT_lay1,p1_HIT_lay1,p2_HIT_lay1,p3_HIT_lay1;
wire [17:0] p0_HIT_lay2,p1_HIT_lay2,p2_HIT_lay2,p3_HIT_lay2;
wire [17:0] p0_HIT_lay3,p1_HIT_lay3,p2_HIT_lay3,p3_HIT_lay3;
wire [17:0] p0_HIT_lay4,p1_HIT_lay4,p2_HIT_lay4,p3_HIT_lay4;
wire [17:0] p0_HIT_lay5,p1_HIT_lay5,p2_HIT_lay5,p3_HIT_lay5;

wire [5:0] push_p0_data_ispy,push_p1_data_ispy,push_p2_data_ispy,push_p3_data_ispy;
wire [5:0] wr_fifo;
wire [5:0] push = 6'b0;
wire [5:0] p0_push,p1_push,p2_push,p3_push;

//wire [8:0] vme_block;
wire [14:0] vme_block;
reg [31:0] ivdata;


// SPYBUFFERS signals

wire freeze;

wire [29:0] ospy_data_out;
wire ospy_sel;
wire ospy_of;
wire [9:0] ospy_addr;
wire [11:0] ospy_status = {freeze, ospy_of, ospy_addr};	

wire [20:0] p0_ispy0_data_out,p1_ispy0_data_out,p2_ispy0_data_out,p3_ispy0_data_out;
wire ispy0_sel;
wire p0_ispy0_of,p1_ispy0_of,p2_ispy0_of,p3_ispy0_of;
wire [9:0] p0_ispy0_addr,p1_ispy0_addr,p2_ispy0_addr,p3_ispy0_addr;
wire [11:0] p0_ispy0_status = {freeze, p0_ispy0_of, p0_ispy0_addr};	
wire [11:0] p1_ispy0_status = {freeze, p1_ispy0_of, p1_ispy0_addr};	
wire [11:0] p2_ispy0_status = {freeze, p2_ispy0_of, p2_ispy0_addr};	
wire [11:0] p3_ispy0_status = {freeze, p3_ispy0_of, p3_ispy0_addr};	

wire [20:0] p0_ispy1_data_out,p1_ispy1_data_out,p2_ispy1_data_out,p3_ispy1_data_out;
wire ispy1_sel;
wire p0_ispy1_of,p1_ispy1_of,p2_ispy1_of,p3_ispy1_of;
wire [9:0] p0_ispy1_addr,p1_ispy1_addr,p2_ispy1_addr,p3_ispy1_addr;
wire [11:0] p0_ispy1_status = {freeze, p0_ispy1_of, p0_ispy1_addr};	
wire [11:0] p1_ispy1_status = {freeze, p1_ispy1_of, p1_ispy1_addr};	
wire [11:0] p2_ispy1_status = {freeze, p2_ispy1_of, p2_ispy1_addr};	
wire [11:0] p3_ispy1_status = {freeze, p3_ispy1_of, p3_ispy1_addr};	

wire [20:0] p0_ispy2_data_out,p1_ispy2_data_out,p2_ispy2_data_out,p3_ispy2_data_out;
wire ispy2_sel;
wire p0_ispy2_of,p1_ispy2_of,p2_ispy2_of,p3_ispy2_of;
wire [9:0] p0_ispy2_addr,p1_ispy2_addr,p2_ispy2_addr,p3_ispy2_addr;
wire [11:0] p0_ispy2_status = {freeze, p0_ispy2_of, p0_ispy2_addr};	
wire [11:0] p1_ispy2_status = {freeze, p1_ispy2_of, p1_ispy2_addr};	
wire [11:0] p2_ispy2_status = {freeze, p2_ispy2_of, p2_ispy2_addr};	
wire [11:0] p3_ispy2_status = {freeze, p3_ispy2_of, p3_ispy2_addr};	

wire [20:0] p0_ispy3_data_out,p1_ispy3_data_out,p2_ispy3_data_out,p3_ispy3_data_out;
wire ispy3_sel;
wire p0_ispy3_of,p1_ispy3_of,p2_ispy3_of,p3_ispy3_of;
wire [9:0] p0_ispy3_addr,p1_ispy3_addr,p2_ispy3_addr,p3_ispy3_addr;
wire [11:0] p0_ispy3_status = {freeze, p0_ispy3_of, p0_ispy3_addr};	
wire [11:0] p1_ispy3_status = {freeze, p1_ispy3_of, p1_ispy3_addr};	
wire [11:0] p2_ispy3_status = {freeze, p2_ispy3_of, p2_ispy3_addr};	
wire [11:0] p3_ispy3_status = {freeze, p3_ispy3_of, p3_ispy3_addr};	

wire [20:0] p0_ispy4_data_out,p1_ispy4_data_out,p2_ispy4_data_out,p3_ispy4_data_out;
wire ispy4_sel;
wire p0_ispy4_of,p1_ispy4_of,p2_ispy4_of,p3_ispy4_of;
wire [9:0] p0_ispy4_addr,p1_ispy4_addr,p2_ispy4_addr,p3_ispy4_addr;
wire [11:0] p0_ispy4_status = {freeze, p0_ispy4_of, p0_ispy4_addr};	
wire [11:0] p1_ispy4_status = {freeze, p1_ispy4_of, p1_ispy4_addr};	
wire [11:0] p2_ispy4_status = {freeze, p2_ispy4_of, p2_ispy4_addr};	
wire [11:0] p3_ispy4_status = {freeze, p3_ispy4_of, p3_ispy4_addr};	

wire [20:0] p0_ispy5_data_out,p1_ispy5_data_out,p2_ispy5_data_out,p3_ispy5_data_out;
wire ispy5_sel;
wire p0_ispy5_of,p1_ispy5_of,p2_ispy5_of,p3_ispy5_of;
wire [9:0] p0_ispy5_addr,p1_ispy5_addr,p2_ispy5_addr,p3_ispy5_addr;
wire [11:0] p0_ispy5_status = {freeze, p0_ispy5_of, p0_ispy5_addr};	
wire [11:0] p1_ispy5_status = {freeze, p1_ispy5_of, p1_ispy5_addr};	
wire [11:0] p2_ispy5_status = {freeze, p2_ispy5_of, p2_ispy5_addr};	
wire [11:0] p3_ispy5_status = {freeze, p3_ispy5_of, p3_ispy5_addr};	

// end spybuffers signals -------------------

wire xxx_init;

assign init = back_init;

`define rd_total {rd_vme, rd_input }
always @ (rd_vme or rd_input or ivdata_vme or ivdata_input)
case (`rd_total)
	2'b01: ivdata = {12'b0, ivdata_input}; 
  2'b10: ivdata = ivdata_vme; 
	default: ivdata = 32'b0;
endcase 

assign vme_data[31:0] = (rd_vme || rd_input)? ivdata[31:0] : 32'bz;

// output bologna 31.07.08 per usare ambslim con u n solo serializzatore sulle roads (mp 31.07.08)
assign p0_odata[0] = p0_odata_tmp[28];		// ee;  odata[0] va al bit 1 del serializzatore
assign p0_odata[29:1] = p0_odata_tmp[28:0];	// odata[26] va al bit27 del serializzatore	
assign p1_odata[0] = p1_odata_tmp[28];		// ee;  odata[0] va al bit 1 del serializzatore
assign p1_odata[29:1] = p1_odata_tmp[28:0];	// odata[26] va al bit27 del serializzatore	
assign p2_odata[0] = p2_odata_tmp[28];		// ee;  odata[0] va al bit 1 del serializzatore
assign p2_odata[29:1] = p2_odata_tmp[28:0];	// odata[26] va al bit27 del serializzatore	
assign p3_odata[0] = p3_odata_tmp[28];		// ee;  odata[0] va al bit 1 del serializzatore
assign p3_odata[29:1] = p3_odata_tmp[28:0];	// odata[26] va al bit27 del serializzatore	

assign bitmap_status = lamb_spare;

assign init_ev0_lamb0 = p0_init_ev;
assign	init_ev1_lamb0 = p0_init_ev;
assign	init_ev2_lamb0 = p0_init_ev;
assign	init_ev0_lamb1 = p1_init_ev;
assign	init_ev1_lamb1 = p1_init_ev;
assign	init_ev2_lamb1 = p1_init_ev;
assign	init_ev0_lamb2 = p2_init_ev;
assign	init_ev1_lamb2 = p2_init_ev;
assign	init_ev2_lamb2 = p2_init_ev;
assign	init_ev0_lamb3 = p3_init_ev;
assign	init_ev1_lamb3 = p3_init_ev;
assign	init_ev2_lamb3 = p3_init_ev;

assign resfifo0_ = 1'b1;
assign resfifo1_ = 1'b1;

/****************************************************************************
GLOBAL CLOCK BUFFER
*****************************************************************************/
BUFGP clk_buf(.O(int_clk),
				  .I(clk) 			//definisco il clock interno su un BUFG
				  );	

				
// *******************************************
// Fifo controllers for the 4x6 Stub FIFOs
// *******************************************

x6_fifo_controller fifoctr_p0(int_clk,p0_ef_b,init,p0_pop,p0_rden_b,p0_reg_en,p0_pok);
x6_fifo_controller fifoctr_p1(int_clk,p1_ef_b,init,p1_pop,p1_rden_b,p1_reg_en,p1_pok);
x6_fifo_controller fifoctr_p2(int_clk,p2_ef_b,init,p2_pop,p2_rden_b,p2_reg_en,p2_pok);
x6_fifo_controller fifoctr_p3(int_clk,p3_ef_b,init,p3_pop,p3_rden_b,p3_reg_en,p3_pok);

// *******************************************
// VME control module
// *******************************************

vme vme_inst(		.clk(int_clk),
								.back_init(back_init),
								.geadd(geadd),
								.as_(as_b),
								.ds0_(ds0_b),
								.ds1_(ds1_b),
								.am(am),				// Address Mode
								.lword_(lword_b),
								.iack_(iack_b),
								.write_(write_b),
								.vadd(vadd),
								.vmedata(vme_data[31:0]),		// mp 27.11.2006
								.am_init(xxx_init), 		// init va in uscita dal chippone per resettare la scheda
								.tmode(tmode),  
								.edro_mode(edro_mode), 
								.start_rd_fifo(start_rd_fifo), 
								.hit_loop(hit_loop),
								.en_tck(),	 		// diventara' un segnale interno
								.tck_am_lamb0(tck_am_lamb0),
								.tck_am_lamb1(tck_am_lamb1),
								.tck_am_lamb2(tck_am_lamb2),
								.tck_am_lamb3(tck_am_lamb3),
								.wrpam(wrpam),
								.rdbscan(rdbscan),
								.wr_nloop(wr_nloop),
								.wr_input(wr_input),		// segnale interno: read/write registri di input delle 6 fifos
								.rd_input(rd_input),		// segnale interno: read/write registri di input delle 6 fifos
								.berr_(berr_b),
								.dtack_(dtack_b),
								.enb_(enb_b),
								.dirw_(dirw_b),
								.add(add),
								.rwadd(rwadd),
								.rd_vme(rd_vme),
		  					.ivdata(ivdata_vme),
		  					.ivadd(ivadd),		// latched vme signals. Out
		  					.ladd(ladd),
		  					.dr_(dr_),
		  					.hee_reg(p0_hee_reg),
		  					.last_hreg_ee(last_hreg_ee),			// DEBUG
		  					.state(p0_state),								// DEBUG
		  					.input_ctr_debug(input_ctr_debug), 	// DEBUG
		  					.freeze(freeze),
		  					.ospy_status(ospy_status),
		  					.ospy_sel(ospy_sel),
		  					.ospy_data_out(ospy_data_out),		//input for vme
		  					
		  					.ispy0_status(p0_ispy0_status),
		  					.ispy0_sel(ispy0_sel),
		  					.ispy0_data_out(p0_ispy0_data_out),
		  					
		  					.ispy1_status(p0_ispy1_status),
		  					.ispy1_sel(ispy1_sel),
		  					.ispy1_data_out(p0_ispy1_data_out),
		  					
		  					.ispy2_status(p0_ispy2_status),
		  					.ispy2_sel(ispy2_sel),
		  					.ispy2_data_out(p0_ispy2_data_out),
		  					
		  					.ispy3_status(p0_ispy3_status),
		  					.ispy3_sel(ispy3_sel),
		  					.ispy3_data_out(p0_ispy3_data_out),
		  					
		  					.ispy4_status(p0_ispy4_status),
		  					.ispy4_sel(ispy4_sel),
		  					.ispy4_data_out(p0_ispy4_data_out),
		  					
		  					.ispy5_status(p0_ispy5_status),
		  					.ispy5_sel(ispy5_sel),
		  					.ispy5_data_out(p0_ispy5_data_out),
		  					.hitmask(hitmask),
							
							.err_flag(err_flag),
							.err_critical(err_critical),
		  					
		  					.vme_block(vme_block),
							.count_patt(count_patt),
							.count_event(count_event),
							.init_stat_count(init_stat_count),
	
							.bitmap_en(bitmap_en),
							//for opcode
							//.addr_opcode(addr_opcode),
							.wr_opcode(wr_opcode)
							);
								

// *************************************
// Main Finite State Machine
// *************************************

wire [5:0] p0_rd_fifo,p1_rd_fifo,p2_rd_fifo,p3_rd_fifo;
wire [4:0] addr_rd_opc;
wire [4:0] addr_wr_opc;

wire [3:0] finish_road;
wire [3:0] rpush;

main_fsm mainFSM_p0  (.clk(int_clk),
							.init(init),
							.pok(p0_pok),		
           			.dr(~dr_[0]),  
							.rhold(logic_0),		
          				.init_iam(p0_init_ev),
          				.rd_fifo(p0_rd_fifo),
          				.rpush(rpush[0]),
            		.sel_IAM(sel_loc_road[0]),
							.need_opc_data(need_opc_data),
							.addr_wr_opc(addr_wr_opc),
							.addr_rd_opc(addr_rd_opc),
							.rd_opc_ram(rd_opc_ram),
          				.en(p0_en),
          				.pop(p0_pop),
          				.curr_state(p0_state),
          				.last_hreg_ee(last_hreg_ee),
							.hee_reg(p0_hee_reg), 
							.finish_road(finish_road[0]),
							.count_patt(count_patt),
							.count_event(count_event),
							.init_stat_count(init_stat_count)
          		); 
	
main_fsm mainFSM_p1  (.clk(int_clk),
							.init(init),
							.pok(p1_pok),	
          				.dr(~dr_[1]),  
							.rhold(logic_0),		
          				.init_iam(p1_init_ev),
          				.rd_fifo(p1_rd_fifo),
          				.rpush(rpush[1]),
            		.sel_IAM(sel_loc_road[1]),
							.need_opc_data(need_opc_data),
							.addr_wr_opc(addr_wr_opc),
							.addr_rd_opc(addr_rd_opc),
							.rd_opc_ram(rd_opc_ram),
          				.en(p1_en),
          				.pop(p1_pop),
          				.curr_state(p1_state),
          				.last_hreg_ee(last_hreg_ee),
							.hee_reg(p1_hee_reg),
							.finish_road(finish_road[1]),
							.count_patt(count_patt),
							.count_event(count_event),
							.init_stat_count(init_stat_count)
          		); 
	
main_fsm mainFSM_p2  (.clk(int_clk),
							.init(init),
							.pok(p2_pok),		
          				.dr(~dr_[2]),  
							.rhold(logic_0),	
          				.init_iam(p2_init_ev),
          				.rd_fifo(p2_rd_fifo),
          				.rpush(rpush[2]),
            		.sel_IAM(sel_loc_road[2]),
							.need_opc_data(need_opc_data),
							.addr_wr_opc(addr_wr_opc),
							.addr_rd_opc(addr_rd_opc),
							.rd_opc_ram(rd_opc_ram),
          				.en(p2_en),
          				.pop(p2_pop),
          				.curr_state(p2_state),
          				.last_hreg_ee(last_hreg_ee),
							.hee_reg(p2_hee_reg),  
							.finish_road(finish_road[2]),
							.count_patt(count_patt),
							.count_event(count_event),
							.init_stat_count(init_stat_count)
          		); 
	
main_fsm mainFSM_p3  (.clk(int_clk),
							.init(init),
							.pok(p3_pok),		
          				.dr(~dr_[3]),  
							.rhold(logic_0),		
          				.init_iam(p3_init_ev),
          				.rd_fifo(p3_rd_fifo),
          				.rpush(rpush[3]),
            		.sel_IAM(sel_loc_road[3]),
							.need_opc_data(need_opc_data),
							.addr_wr_opc(addr_wr_opc),
							.addr_rd_opc(addr_rd_opc),
							.rd_opc_ram(rd_opc_ram),
          				.en(p3_en),
          				.pop(p3_pop),
          				.curr_state(p3_state),
          				.last_hreg_ee(last_hreg_ee),
							.hee_reg(p3_hee_reg),  
							.finish_road(finish_road[3]),
							.count_patt(count_patt),
							.count_event(count_event),
							.init_stat_count(init_stat_count)
          		); 
	
// ****************************************************************************
// Input Controllers
// *****************************************************************************/									

x6_input_controller  hitctr_p0(.clk(int_clk),
											.init(init),
											.init_ev(p0_init_ev), 
											.lay0_in(lay0_p0_in[17:0]),
											.lay1_in(lay1_p0_in[17:0]),
											.lay2_in(lay2_p0_in[17:0]),
											.lay3_in(lay3_p0_in[17:0]),
											.lay4_in(lay4_p0_in[17:0]),
											.lay5_in(lay5_p0_in[17:0]),
											.new_hit(p0_reg_en),
											.wr_hit_lamb(p0_en), 
											.enA_wr(enA_wr),
											.A0_HIT(A0_HIT),
											.A1_HIT(A1_HIT),
											.A2_HIT(A2_HIT),
											.A3_HIT(A3_HIT),
											.A4_HIT(A4_HIT),
											.A5_HIT(A5_HIT), 
											.state(p0_state),
											.tmode(tmode),
											.edro_mode(edro_mode),
											.start_rd_fifo(start_rd_fifo),
											.hit_loop(hit_loop),
											.vmedata(vme_data),
											.wr_nloop(wr_nloop),
											.vme_input0_fifo(vme_input0_fifo), 
											.vme_input1_fifo(vme_input1_fifo),
											.vme_input2_fifo(vme_input2_fifo),
											.vme_input3_fifo(vme_input3_fifo),
											.vme_input4_fifo(vme_input4_fifo),
											.vme_input5_fifo(vme_input5_fifo),
											.data_ispy0(p0_data_ispy0),
											.data_ispy1(p0_data_ispy1),
											.data_ispy2(p0_data_ispy2),
											.data_ispy3(p0_data_ispy3),
											.data_ispy4(p0_data_ispy4),
											.data_ispy5(p0_data_ispy5),
											.push_data_ispy(push_p0_data_ispy),
											.wr_fifo(wr_fifo),
											.hitmask(xxx_hitmask), 
											.hee_reg(p0_hee_reg),
											.HIT_lay0(p0_HIT_lay0),
											.HIT_lay1(p0_HIT_lay1),
											.HIT_lay2(p0_HIT_lay2),
											.HIT_lay3(p0_HIT_lay3),
											.HIT_lay4(p0_HIT_lay4),
											.HIT_lay5(p0_HIT_lay5),
											.push_hit(p0_push), 
											.rd_fifo(p0_rd_fifo),
											.tag_ee_word(p0_curr_tag),		
											.err_flag(p0_err_flag),
											.err_critical(p0_err_critical)
									);

x6_input_controller  hitctr_p1(.clk(int_clk),
											.init(init),
											.init_ev(p1_init_ev), 
											.lay0_in(lay0_p1_in[17:0]),
											.lay1_in(lay1_p1_in[17:0]),
											.lay2_in(lay2_p1_in[17:0]),
											.lay3_in(lay3_p1_in[17:0]),
											.lay4_in(lay4_p1_in[17:0]),
											.lay5_in(lay5_p1_in[17:0]),
											.new_hit(p1_reg_en),
											.wr_hit_lamb(p1_en), 
											.enA_wr(enB_wr),
											.A0_HIT(B0_HIT),
											.A1_HIT(B1_HIT),
											.A2_HIT(B2_HIT),
											.A3_HIT(B3_HIT),
											.A4_HIT(B4_HIT),
											.A5_HIT(B5_HIT), 
											.state(p1_state),
											.tmode(tmode),
											.edro_mode(edro_mode),
											.start_rd_fifo(start_rd_fifo),
											.hit_loop(hit_loop),
											.vmedata(vme_data),
											.wr_nloop(wr_nloop),
											.vme_input0_fifo(vme_input0_fifo), 
											.vme_input1_fifo(vme_input1_fifo),
											.vme_input2_fifo(vme_input2_fifo),
											.vme_input3_fifo(vme_input3_fifo),
											.vme_input4_fifo(vme_input4_fifo),
											.vme_input5_fifo(vme_input5_fifo),
											.data_ispy0(p1_data_ispy0),
											.data_ispy1(p1_data_ispy1),
											.data_ispy2(p1_data_ispy2),
											.data_ispy3(p1_data_ispy3),
											.data_ispy4(p1_data_ispy4),
											.data_ispy5(p1_data_ispy5),
											.push_data_ispy(push_p1_data_ispy),
											.wr_fifo(wr_fifo),
											.hitmask(xxx_hitmask), 
											.hee_reg(p1_hee_reg),
											.HIT_lay0(p1_HIT_lay0),
											.HIT_lay1(p1_HIT_lay1),
											.HIT_lay2(p1_HIT_lay2),
											.HIT_lay3(p1_HIT_lay3),
											.HIT_lay4(p1_HIT_lay4),
											.HIT_lay5(p1_HIT_lay5),
											.push_hit(p1_push),  
											.rd_fifo(p1_rd_fifo),
											.tag_ee_word(p1_curr_tag),		
											.err_flag(p1_err_flag),
											.err_critical(p1_err_critical)
									);

x6_input_controller  hitctr_p2(.clk(int_clk),
											.init(init),
											.init_ev(p2_init_ev), 
											.lay0_in(lay0_p2_in[17:0]),
											.lay1_in(lay1_p2_in[17:0]),
											.lay2_in(lay2_p2_in[17:0]),
											.lay3_in(lay3_p2_in[17:0]),
											.lay4_in(lay4_p2_in[17:0]),
											.lay5_in(lay5_p2_in[17:0]),
											.new_hit(p2_reg_en),
											.wr_hit_lamb(p2_en), 
											.enA_wr(enC_wr),
											.A0_HIT(C0_HIT),
											.A1_HIT(C1_HIT),
											.A2_HIT(C2_HIT),
											.A3_HIT(C3_HIT),
											.A4_HIT(C4_HIT),
											.A5_HIT(C5_HIT), 
											.state(p2_state),
											.tmode(tmode),
											.edro_mode(edro_mode),
											.start_rd_fifo(start_rd_fifo),
											.hit_loop(hit_loop),
											.vmedata(vme_data),
											.wr_nloop(wr_nloop),
											.vme_input0_fifo(vme_input0_fifo), 
											.vme_input1_fifo(vme_input1_fifo),
											.vme_input2_fifo(vme_input2_fifo),
											.vme_input3_fifo(vme_input3_fifo),
											.vme_input4_fifo(vme_input4_fifo),
											.vme_input5_fifo(vme_input5_fifo),
											.data_ispy0(p2_data_ispy0),
											.data_ispy1(p2_data_ispy1),
											.data_ispy2(p2_data_ispy2),
											.data_ispy3(p2_data_ispy3),
											.data_ispy4(p2_data_ispy4),
											.data_ispy5(p2_data_ispy5),
											.push_data_ispy(push_p2_data_ispy),
											.wr_fifo(wr_fifo),
											.hitmask(xxx_hitmask), 
											.hee_reg(p2_hee_reg),
											.HIT_lay0(p2_HIT_lay0),
											.HIT_lay1(p2_HIT_lay1),
											.HIT_lay2(p2_HIT_lay2),
											.HIT_lay3(p2_HIT_lay3),
											.HIT_lay4(p2_HIT_lay4),
											.HIT_lay5(p2_HIT_lay5),
											.push_hit(p2_push),  
											.rd_fifo(p2_rd_fifo),
											.tag_ee_word(p2_curr_tag),	
											.err_flag(p2_err_flag),
											.err_critical(p2_err_critical)
									);

x6_input_controller  hitctr_p3(.clk(int_clk),
											.init(init),
											.init_ev(p3_init_ev), 
											.lay0_in(lay0_p3_in[17:0]),
											.lay1_in(lay1_p3_in[17:0]),
											.lay2_in(lay2_p3_in[17:0]),
											.lay3_in(lay3_p3_in[17:0]),
											.lay4_in(lay4_p3_in[17:0]),
											.lay5_in(lay5_p3_in[17:0]),
											.new_hit(p3_reg_en),
											.wr_hit_lamb(p3_en), 
											.enA_wr(enD_wr),
											.A0_HIT(D0_HIT),
											.A1_HIT(D1_HIT),
											.A2_HIT(D2_HIT),
											.A3_HIT(D3_HIT),
											.A4_HIT(D4_HIT),
											.A5_HIT(D5_HIT), 
											.state(p3_state),
											.tmode(tmode),
											.edro_mode(edro_mode),
											.start_rd_fifo(start_rd_fifo),
											.hit_loop(hit_loop),
											.vmedata(vme_data),
											.wr_nloop(wr_nloop),
											.vme_input0_fifo(vme_input0_fifo), 
											.vme_input1_fifo(vme_input1_fifo),
											.vme_input2_fifo(vme_input2_fifo),
											.vme_input3_fifo(vme_input3_fifo),
											.vme_input4_fifo(vme_input4_fifo),
											.vme_input5_fifo(vme_input5_fifo),
											.data_ispy0(p3_data_ispy0),
											.data_ispy1(p3_data_ispy1),
											.data_ispy2(p3_data_ispy2),
											.data_ispy3(p3_data_ispy3),
											.data_ispy4(p3_data_ispy4),
											.data_ispy5(p3_data_ispy5),
											.push_data_ispy(push_p3_data_ispy),
											.wr_fifo(wr_fifo),
											.hitmask(xxx_hitmask), 
											.hee_reg(p3_hee_reg),
											.HIT_lay0(p3_HIT_lay0),
											.HIT_lay1(p3_HIT_lay1),
											.HIT_lay2(p3_HIT_lay2),
											.HIT_lay3(p3_HIT_lay3),
											.HIT_lay4(p3_HIT_lay4),
											.HIT_lay5(p3_HIT_lay5),
											.push_hit(p3_push),  //cambiare con il push in output
											.rd_fifo(p3_rd_fifo),
											.tag_ee_word(p3_curr_tag),		//generate tag for test VME or normal test
											.err_flag(p3_err_flag),
											.err_critical(p3_err_critical)
									);

// *******************************************************************************
// Road Controller
// *******************************************************************************

road_controller p0_rd_ctrl(.phi(phi),
                        .z(z),
                        .clk(int_clk),			
												.init(init),
												.rhold(logic_0),
												.bitmap_en(bitmap_en),
												.dr_b_in(dr0_b),
												.ladd(ladd0),
												.sel_b(sel0_b),  //output: e' un aknowledge per le lamb
												.dr_b_out(dr_[0]),  		// e' presente un road locale (proveniente dalle lamb)
												.finish_road(finish_road[0]),
							          .tag_event(p0_curr_tag),		                 
							          .sel_word(sel_loc_road[0]),            
							          .rpush(rpush[0]),                                
							          .road_out(p0_odata_tmp),             
							          .road_wr(wr_road[0]),
							          .port_addr(0)                                 
												);

road_controller p1_rd_ctrl(.phi(phi),
                        .z(z),
                        .clk(int_clk),			
												.init(init),
												.rhold(logic_0),
												.bitmap_en(bitmap_en),
												.dr_b_in(dr1_b),
												.ladd(ladd1),
												.sel_b(sel1_b),  //output: e' un aknowledge per le lamb
												.dr_b_out(dr_[1]),  		// e' presente un road locale (proveniente dalle lamb)
												.finish_road(finish_road[1]),
							          .tag_event(p1_curr_tag),		                 
							          .sel_word(sel_loc_road[1]),            
							          .rpush(rpush[1]),                                
							          .road_out(p1_odata_tmp),             
							          .road_wr(wr_road[1]),
							          .port_addr(1)                                 
												);

road_controller p2_rd_ctrl(.phi(phi),
                        .z(z),
                        .clk(int_clk),			
												.init(init),
												.rhold(logic_0),
												.bitmap_en(bitmap_en),
												.dr_b_in(dr2_b),
												.ladd(ladd2),
												.sel_b(sel2_b),  //output: e' un aknowledge per le lamb
												.dr_b_out(dr_[2]),  		// e' presente un road locale (proveniente dalle lamb)
												.finish_road(finish_road[2]),
							          .tag_event(p2_curr_tag),		                 
							          .sel_word(sel_loc_road[2]),            
							          .rpush(rpush[2]),                                
							          .road_out(p2_odata_tmp),             
							          .road_wr(wr_road[2]),
							          .port_addr(2)                                 
												);

road_controller p3_rd_ctrl(.phi(phi),
                        .z(z),
                        .clk(int_clk),			
												.init(init),
												.rhold(logic_0),
												.bitmap_en(bitmap_en),
												.dr_b_in(dr3_b),
												.ladd(ladd3),
												.sel_b(sel3_b),  //output: e' un aknowledge per le lamb
												.dr_b_out(dr_[3]),  		// e' presente un road locale (proveniente dalle lamb)
												.finish_road(finish_road[3]),
							          .tag_event(p3_curr_tag),		                 
							          .sel_word(sel_loc_road[3]),            
							          .rpush(rpush[3]),                                
							          .road_out(p3_odata_tmp),             
							          .road_wr(wr_road[3]),
							          .port_addr(3)                                 
												);
	

//*******************************************************************************
// WRITE HIT VME
//*******************************************************************************

wr_fifo_hit		wr_fifo_hit_inst(	.clk(int_clk),
											.init(init),
											.vmedata(vme_data[19:0]),		
											.ivdata(ivdata_input),
											.wr_input(wr_input),
											.rwadd(rwadd),
											.vme_input0_fifo(vme_input0_fifo), 
											.vme_input1_fifo(vme_input1_fifo),
											.vme_input2_fifo(vme_input2_fifo),
											.vme_input3_fifo(vme_input3_fifo),
											.vme_input4_fifo(vme_input4_fifo),
											.vme_input5_fifo(vme_input5_fifo),
											.wr_fifo(wr_fifo),
											.input_ctr_debug(input_ctr_debug) 
										  );
										  
										  
//*******************************************************************************
// OPCODE RAM
//*******************************************************************************


opcode_storage		opcode_storage_inst( .clk(int_clk),
													.init(init),
													.opcode_in(vme_data[3:0]),
													.addr_wr_opc(addr_wr_opc),
													.addr_rd_opc(addr_rd_opc),
													.wr_opcode(wr_opcode),
													.rd_opc_ram(rd_opc_ram),
													.need_opc_data(need_opc_data),
													.opcode0_out(opcode0_out),
													.opcode1_out(opcode1_out),
													.opcode2_out(opcode2_out),
													.opcode3_out(opcode3_out)
													);
									

// ********************
//   OUTPUT SPYBUFFER
// ********************
ospy ospy_inst		(	.clk(int_clk),
							.ospy_data_in(p0_odata_tmp),		// spybuffer input data
							.reset_ospy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
							.push(wr_road[0]),			// spybuffer write enable *****************
							.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
							.ospy_addr_sel(ospy_sel),	
							.freeze(freeze),
							.ospy_data_out(ospy_data_out),		// data out to vme
							.ospy_of(ospy_of),	// for ospy status
							.ospy_addr(ospy_addr)		// for ospy status
						);



// ********************
//   INPUT SPYBUFFER
// ********************

// Port 0

ispy p0_ispy0_inst		(	.clk(int_clk),
								//.data_in(lay0_in_neg),
								.ispy_data_in(p0_data_ispy0),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[0]),			// spybuffer write enable
								.push(push_p0_data_ispy[0]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy0_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy0_data_out),		// data out to vme
								.ispy_of(p0_ispy0_of),	// for ospy status
								.ispy_addr(p0_ispy0_addr)		// for ospy status
						);			
						
ispy p0_ispy1_inst		(	.clk(int_clk),
								//.data_in(lay1_in),
								.ispy_data_in(p0_data_ispy1),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[1]),			// spybuffer write enable
								.push(push_p0_data_ispy[1]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy1_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy1_data_out),		// data out to vme
								.ispy_of(p0_ispy1_of),	// for ospy status
								.ispy_addr(p0_ispy1_addr)		// for ospy status
						);												
		
ispy p0_ispy2_inst		(	.clk(int_clk),
								//.data_in(lay2_in),
								.ispy_data_in(p0_data_ispy2),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[2]),			// spybuffer write enable
								.push(push_p0_data_ispy[2]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy2_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy2_data_out),		// data out to vme
								.ispy_of(p0_ispy2_of),	// for ospy status
								.ispy_addr(p0_ispy2_addr)		// for ospy status
							);			
						
ispy p0_ispy3_inst		(	.clk(int_clk),
								//.data_in(lay3_in),
								.ispy_data_in(p0_data_ispy3),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[3]),			// spybuffer write enable
								.push(push_p0_data_ispy[3]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy3_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy3_data_out),		// data out to vme
								.ispy_of(p0_ispy3_of),	// for ospy status
								.ispy_addr(p0_ispy3_addr)		// for ospy status
						);									
						
ispy p0_ispy4_inst		(	.clk(int_clk),
								//.data_in(lay4_in),
								.ispy_data_in(p0_data_ispy4),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[4]),			// spybuffer write enable
								.push(push_p0_data_ispy[4]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy4_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy4_data_out),		// data out to vme
								.ispy_of(p0_ispy4_of),	// for ospy status
								.ispy_addr(p0_ispy4_addr)		// for ospy status
						);			
						
ispy p0_ispy5_inst		(	.clk(int_clk),
								//.data_in(lay5_in),
								.ispy_data_in(p0_data_ispy5),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[5]),			// spybuffer write enable
								.push(push_p0_data_ispy[5]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy5_sel),	
								.freeze(freeze),
								.ispy_data_out(p0_ispy5_data_out),		// data out to vme
								.ispy_of(p0_ispy5_of),	// for ospy status
								.ispy_addr(p0_ispy5_addr)		// for ospy status
						);									
						
// Port 1

ispy p1_ispy0_inst		(	.clk(int_clk),
								//.data_in(lay0_in_neg),
								.ispy_data_in(p1_data_ispy0),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[0]),			// spybuffer write enable
								.push(push_p1_data_ispy[0]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy0_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy0_data_out),		// data out to vme
								.ispy_of(p1_ispy0_of),	// for ospy status
								.ispy_addr(p1_ispy0_addr)		// for ospy status
						);			
						
ispy p1_ispy1_inst		(	.clk(int_clk),
								//.data_in(lay1_in),
								.ispy_data_in(p1_data_ispy1),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[1]),			// spybuffer write enable
								.push(push_p1_data_ispy[1]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy1_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy1_data_out),		// data out to vme
								.ispy_of(p1_ispy1_of),	// for ospy status
								.ispy_addr(p1_ispy1_addr)		// for ospy status
						);												
		
ispy p1_ispy2_inst		(	.clk(int_clk),
								//.data_in(lay2_in),
								.ispy_data_in(p1_data_ispy2),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[2]),			// spybuffer write enable
								.push(push_p1_data_ispy[2]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy2_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy2_data_out),		// data out to vme
								.ispy_of(p1_ispy2_of),	// for ospy status
								.ispy_addr(p1_ispy2_addr)		// for ospy status
							);			
						
ispy p1_ispy3_inst		(	.clk(int_clk),
								//.data_in(lay3_in),
								.ispy_data_in(p1_data_ispy3),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[3]),			// spybuffer write enable
								.push(push_p1_data_ispy[3]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy3_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy3_data_out),		// data out to vme
								.ispy_of(p1_ispy3_of),	// for ospy status
								.ispy_addr(p1_ispy3_addr)		// for ospy status
						);									
						
ispy p1_ispy4_inst		(	.clk(int_clk),
								//.data_in(lay4_in),
								.ispy_data_in(p1_data_ispy4),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[4]),			// spybuffer write enable
								.push(push_p1_data_ispy[4]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy4_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy4_data_out),		// data out to vme
								.ispy_of(p1_ispy4_of),	// for ospy status
								.ispy_addr(p1_ispy4_addr)		// for ospy status
						);			
						
ispy p1_ispy5_inst		(	.clk(int_clk),
								//.data_in(lay5_in),
								.ispy_data_in(p1_data_ispy5),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[5]),			// spybuffer write enable
								.push(push_p1_data_ispy[5]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy5_sel),	
								.freeze(freeze),
								.ispy_data_out(p1_ispy5_data_out),		// data out to vme
								.ispy_of(p1_ispy5_of),	// for ospy status
								.ispy_addr(p1_ispy5_addr)		// for ospy status
						);									
						
// Port 2

ispy p2_ispy0_inst		(	.clk(int_clk),
								//.data_in(lay0_in_neg),
								.ispy_data_in(p2_data_ispy0),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[0]),			// spybuffer write enable
								.push(push_p2_data_ispy[0]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy0_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy0_data_out),		// data out to vme
								.ispy_of(p2_ispy0_of),	// for ospy status
								.ispy_addr(p2_ispy0_addr)		// for ospy status
						);			
						
ispy p2_ispy1_inst		(	.clk(int_clk),
								//.data_in(lay1_in),
								.ispy_data_in(p2_data_ispy1),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[1]),			// spybuffer write enable
								.push(push_p2_data_ispy[1]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy1_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy1_data_out),		// data out to vme
								.ispy_of(p2_ispy1_of),	// for ospy status
								.ispy_addr(p2_ispy1_addr)		// for ospy status
						);												
		
ispy p2_ispy2_inst		(	.clk(int_clk),
								//.data_in(lay2_in),
								.ispy_data_in(p2_data_ispy2),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[2]),			// spybuffer write enable
								.push(push_p2_data_ispy[2]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy2_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy2_data_out),		// data out to vme
								.ispy_of(p2_ispy2_of),	// for ospy status
								.ispy_addr(p2_ispy2_addr)		// for ospy status
							);			
						
ispy p2_ispy3_inst		(	.clk(int_clk),
								//.data_in(lay3_in),
								.ispy_data_in(p2_data_ispy3),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[3]),			// spybuffer write enable
								.push(push_p2_data_ispy[3]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy3_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy3_data_out),		// data out to vme
								.ispy_of(p2_ispy3_of),	// for ospy status
								.ispy_addr(p2_ispy3_addr)		// for ospy status
						);									
						
ispy p2_ispy4_inst		(	.clk(int_clk),
								//.data_in(lay4_in),
								.ispy_data_in(p2_data_ispy4),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[4]),			// spybuffer write enable
								.push(push_p2_data_ispy[4]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy4_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy4_data_out),		// data out to vme
								.ispy_of(p2_ispy4_of),	// for ospy status
								.ispy_addr(p2_ispy4_addr)		// for ospy status
						);			
						
ispy p2_ispy5_inst		(	.clk(int_clk),
								//.data_in(lay5_in),
								.ispy_data_in(p2_data_ispy5),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[5]),			// spybuffer write enable
								.push(push_p2_data_ispy[5]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy5_sel),	
								.freeze(freeze),
								.ispy_data_out(p2_ispy5_data_out),		// data out to vme
								.ispy_of(p2_ispy5_of),	// for ospy status
								.ispy_addr(p2_ispy5_addr)		// for ospy status
						);									

// Port 3

ispy p3_ispy0_inst		(	.clk(int_clk),
								//.data_in(lay0_in_neg),
								.ispy_data_in(p3_data_ispy0),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[0]),			// spybuffer write enable
								.push(push_p3_data_ispy[0]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy0_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy0_data_out),		// data out to vme
								.ispy_of(p3_ispy0_of),	// for ospy status
								.ispy_addr(p3_ispy0_addr)		// for ospy status
						);			
						
ispy p3_ispy1_inst		(	.clk(int_clk),
								//.data_in(lay1_in),
								.ispy_data_in(p3_data_ispy1),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[1]),			// spybuffer write enable
								.push(push_p3_data_ispy[1]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy1_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy1_data_out),		// data out to vme
								.ispy_of(p3_ispy1_of),	// for ospy status
								.ispy_addr(p3_ispy1_addr)		// for ospy status
						);												
		
ispy p3_ispy2_inst		(	.clk(int_clk),
								//.data_in(lay2_in),
								.ispy_data_in(p3_data_ispy2),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[2]),			// spybuffer write enable
								.push(push_p3_data_ispy[2]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy2_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy2_data_out),		// data out to vme
								.ispy_of(p3_ispy2_of),	// for ospy status
								.ispy_addr(p3_ispy2_addr)		// for ospy status
							);			
						
ispy p3_ispy3_inst		(	.clk(int_clk),
								//.data_in(lay3_in),
								.ispy_data_in(p3_data_ispy3),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[3]),			// spybuffer write enable
								.push(push_p3_data_ispy[3]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy3_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy3_data_out),		// data out to vme
								.ispy_of(p3_ispy3_of),	// for ospy status
								.ispy_addr(p3_ispy3_addr)		// for ospy status
						);									
						
ispy p3_ispy4_inst		(	.clk(int_clk),
								//.data_in(lay4_in),
								.ispy_data_in(p3_data_ispy4),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[4]),			// spybuffer write enable
								.push(push_p3_data_ispy[4]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy4_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy4_data_out),		// data out to vme
								.ispy_of(p3_ispy4_of),	// for ospy status
								.ispy_addr(p3_ispy4_addr)		// for ospy status
						);			
						
ispy p3_ispy5_inst		(	.clk(int_clk),
								//.data_in(lay5_in),
								.ispy_data_in(p3_data_ispy5),		// spybuffer input data
								.reset_ispy_data(init),		// provvisorio. forse serve un reset ad hoc. Vedere svt
								//.push(reg_en[5]),			// spybuffer write enable
								.push(push_p3_data_ispy[5]),
								.VMEaddr(ivadd[11:2]),				// spybuffer vme read address
								.ispy_addr_sel(ispy5_sel),	
								.freeze(freeze),
								.ispy_data_out(p3_ispy5_data_out),		// data out to vme
								.ispy_of(p3_ispy5_of),	// for ospy status
								.ispy_addr(p3_ispy5_addr)		// for ospy status
						);									
					
endmodule

