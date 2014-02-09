//this module simulate the vme_smart chip designed by Antonio Bardi
//and it was written to be used by Foundation 2.1i
//Author A. Bardi & M. Pietri 
//Date 20-10-1999
//
//Revision: Marco Piendibene 2008

`timescale 1ns/1ps
module vme (clk,
					back_init,
					geadd,
					as_,
					ds0_,
					ds1_,
					am,
					lword_, 
         		iack_,
         		write_,
         		vadd,
         		vmedata,
//         		VMEIDPROM,
         		tmode,
					edro_mode,
					hit_loop,
					start_rd_fifo,
         		en_tck,
					tck_am_lamb0,
					tck_am_lamb1,
					tck_am_lamb2,
					tck_am_lamb3,
		  			wrpam,
		  			rdbscan,
					wr_nloop,
		  			wr_input,				// abilita la scrittura nei registri di input (saranno fifo)
		  			rd_input,
		  			berr_,
		  			dtack_,
		  			enb_,
		  			dirw_,
		  			add,
		  			rwadd,
		  			rd_vme,
		  			ivdata,
		  			ivadd,
					am_init,
		  			ladd,						// roads che arrivano dalla lamb (tramite amglue)
		  			dr_,						// sono presenti roads provenienti dalle lams (tramite amglue)
		  			hee_reg,				// DEBUG
		  			last_hreg_ee,		// DEBUG
		  			state,					// DEBUG
		  			input_ctr_debug, // debug
		  			freeze,
		  			ospy_status,
		  			ospy_sel,
		  			ospy_data_out,
		  			
		  			ispy0_status,
		  			ispy0_sel,
		  			ispy0_data_out,
		  			
		  			ispy1_status,
		  			ispy1_sel,
		  			ispy1_data_out,
		  			
		  			ispy2_status,
		  			ispy2_sel,
		  			ispy2_data_out,
		  			
		  			ispy3_status,
		  			ispy3_sel,
		  			ispy3_data_out,
		  			
		  			ispy4_status,
		  			ispy4_sel,
		  			ispy4_data_out,
		  			
		  			ispy5_status,
		  			ispy5_sel,
		  			ispy5_data_out,
		  			
					err_flag,
					err_critical,
					
		  			hitmask,
		  			vme_block,
					count_patt,
					count_event,
					init_stat_count,
					
					bitmap_en,
					
					//for opcode
					//addr_opcode,
					wr_opcode
		  			//ladd2_debug			// SOLO PER DEBUG: roads dirette dall'ingresso (bypassando amglue)
		  			
		  			);
		  			
		  			
		
/*********************************************/
//PARAMETR TO AM CODE FOR VME  		  
/*********************************************/
parameter DA_CODE = 6'b001001;  //External User Data Access mode code (Data Access mode)
parameter BT_CODE = 6'b001011;  //External User Data Access mode code (Block Transfer mode)


/*********************************************/
//INPUT 		  
/*********************************************/
input [31:0] vmedata;		
input clk;
input back_init;   // from P2
input [4:0] geadd; // LOW ACTIVE !!!!!!!  (mp 26.02.08)
input as_;         // address strobe 
input ds0_,ds1_;   // data strobe 
input [5:0]am;     // Address Mode signal
input lword_;      // long word signal
input iack_;       // interrupt acknowledge signal
input write_;      // states the direction of data flow 
input [31:1]vadd;  // valid address bits which identify the internal chip of the board
input last_hreg_ee;		
input [5:0] hee_reg;
input [2:0] state;					
input [22:0] ladd;
input dr_;
input [1:0] input_ctr_debug;
input [11:0] ospy_status;
input [29:0] ospy_data_out;
input [11:0] ispy0_status;
input [11:0] ispy1_status;
input [11:0] ispy2_status;
input [11:0] ispy3_status;
input [11:0] ispy4_status;
input [11:0] ispy5_status;
input [20:0] ispy0_data_out;
input [20:0] ispy1_data_out;
input [20:0] ispy2_data_out;
input [20:0] ispy3_data_out;
input [20:0] ispy4_data_out;
input [20:0] ispy5_data_out;
input err_flag;
input err_critical;

input [31:0] count_patt;
input [31:0] count_event;



/*********************************************/
//OUTPUT 		  
/*********************************************/
output hit_loop; 			// hit loop in the input FIFO
output tmode;       // test mode: active when in/out managed by VME   
output edro_mode;       // test edro mode
output start_rd_fifo;       // start the read of fifo
output en_tck;      // enables tck to PAMboard
//output tck_am;      // tck signal to PAMboard 
output tck_am_lamb0;
output tck_am_lamb1;
output tck_am_lamb2;
output tck_am_lamb3;
output wrpam;       // write enable signal on PAM registers via TDI
output rdbscan;     // read enable of the output of boundary scan chip 
output berr_;       // Bus error signal, it's stated when addresses are wrong
output dtack_;      // Data ACKnowledge signal
output enb_;        // this signal states data flow direction on the bscan registers
output dirw_;       // this signal states data flow direction on the bscan registers
output am_init;	  //  combination of P2 Init and VME init
output [2:0] add;   //  VME address subset sent to bscan chip on LAMB.
output wr_input, rd_input;				// write to input/output registers  
output wr_nloop;
output [2:0] rwadd;
output rd_vme;
output [31:0]ivdata;
output [26:2] ivadd;
output freeze;
output ospy_sel;
output ispy0_sel;
output ispy1_sel;
output ispy2_sel;
output ispy3_sel;
output ispy4_sel;
output ispy5_sel;
output [17:0]hitmask;
output [14:0] vme_block;

output init_stat_count;

output wr_opcode;
//output [3:0] addr_opcode;
output bitmap_en;

/*********************************************/
//WIRE AND REG		  
/*********************************************/
wire clk;
wire i_gaddok; // Modifica dimensioni fifo VME in out alle lamb a 16384=2^14 locazioni 26.07.10 V.B.
wire vme_out_fifo_empty;
wire vme_out_fifo_full;
wire [13:0] data_count;	
reg tck_am_lamb0;
reg tck_am_lamb1;
reg tck_am_lamb2;
reg tck_am_lamb3;
reg berr_;
reg enb_;
reg dirw_;
reg [26:2] ivadd;
reg ilword_;
reg iiack_;
reg euda;
reg eubt;
reg gaddok;      // geographical address
// internal vme vmedata
reg [31:0] ivdata;

//Save test signals;
wire regs = (ivadd[23:6]==0);		// mp 14.03.2008



// Latch the geographical address comparison and the invalid address equation

//compare the geographical address encoding the number of slot of crate
//occupied by VME slave with the bit of VME address
assign i_gaddok = (~geadd==vadd[31:27]);

//the line of VME are all latched by the AddressStrobe signal
always @ (as_ or i_gaddok)
	begin
	   if (as_)
	   gaddok <= i_gaddok;	    
	end

//genera invalid address se alcuni bit non sono zero quando il geo addr e' riconosciuto	
wire zero =   (ivadd[26:24]==0);
wire inv_add = (~zero && i_gaddok);

//as the all line of VME also the address are latched
always @ (as_ or vadd[26:2]) 
	begin
		if (as_)								// quando va giu' as_ (attivo basso) il latch conserva l'indirizzo 
			ivadd[26:2] <= vadd[26:2];		// ivadd is internal vadd
	end

// latch of line lword
always @ (as_ or lword_) 
	begin
	if (as_)
		ilword_ <= lword_;
	end

// latch of line iack	
always @ (as_ or iack_) 
	begin
	if (as_)
		iiack_ <= iack_;
	end

// the address mode line are decoded to select the two mode Data Access o Block Transfer		
// and are latched
always @ (as_ or am)
	if (as_)
		begin
		if (am == DA_CODE) 
			euda <= 1'b1;		//Data Access
		else 
			euda <= 1'b0;
		if (am == BT_CODE) 
			eubt <= 1'b1;		//Block Transfer
		else 
			eubt <= 1'b0;		
		end

reg sync_selb;
//reg pre_selb;
reg selb;
reg preqselb;
reg qselb;
reg ppdtack;
reg pdtack;
reg dtack;
reg dtack_copy;

// generated the signal of SELect Board (line of VME must be all zero)
//MD 02/05/2011 per far funzionare il block transfer
//wire pre_sync_selb = (!(ilword_ || as_ || vadd[1] || ds0_ || ds1_ || dtack_copy) && iiack_ && gaddok && (euda || eubt));
wire pre_sync_selb = (!(ilword_ || as_ || vadd[1] || ds0_ || ds1_ || dtack) && iiack_ && gaddok && (euda || eubt));


// catena di flip flop per far scorrere la attivazione e la disattivazione di SELB
wire d_cycle_end = (ds0_ && ds1_ && !enb_);

//wire vme_cycle_end = (ds0_ && ds1_ && as_);
wire vme_cycle_end = (ds0_ && ds1_); //02.05.2011 per allinearci con il block transfer

always @ (posedge clk or posedge vme_cycle_end) 
	if (vme_cycle_end) 
		sync_selb <= 0;
	else 
		sync_selb <= pre_sync_selb;

always @ (posedge clk or posedge vme_cycle_end) 
	if (vme_cycle_end) 
		selb <= 0;
	else 
		selb <= sync_selb;
		
always @ (posedge clk or posedge vme_cycle_end) 
	if (vme_cycle_end) 
		preqselb <= 0;
	else 
		preqselb <= selb;		
	
always @ (posedge clk or posedge vme_cycle_end)
	if (vme_cycle_end) 
		qselb <= 0;
	else 
		qselb <= preqselb;

always @ (posedge clk or posedge vme_cycle_end)
	if (vme_cycle_end) 
		ppdtack <= 0;
	else 
		ppdtack <= qselb;

always @ (posedge clk or posedge vme_cycle_end)
	if(vme_cycle_end) 
		pdtack <= 0;
	else if (qselb)
		pdtack <= ppdtack;
	
always @ (posedge clk or posedge vme_cycle_end)
	if(vme_cycle_end) 
		dtack <= 0;
	else if (qselb && berr_) 
		dtack <= pdtack;	
		
always @ (posedge clk or posedge as_)
	if(as_) 
		dtack_copy <= 0;
	else if (qselb && berr_) 
		dtack_copy <= pdtack;	


// Block Transfer
reg load;
//wire cntclk = preqselb & load | ~load & eubt & gaddok & iiack_ & ds0_ & ds1_ ;
// is the clock that incremente the counter
//wire cntclk = (selb & load) | (~load & eubt & gaddok & iiack_ & ds0_ & ds1_) ;  // mp 18.03.2008
wire cntclk = (~load & eubt & gaddok & iiack_ & ds0_ & ds1_) ;  // mp 18.03.2008

// generete the LOAD signal that is active for the first cycle and stay inactive untile as_ go high
always @ (posedge dtack or posedge as_)
	if (as_)
		load <= 'b1;
	else
		load <= 'b0;

//INSERISCO IL CONTATORE PER INCREMENTARE LA MEMORIA E SCRIVERE LE LOCAZIONI
//Incremento del contatore
//reg [3:0] addr_opcode;
//
//always @(posedge cntclk or posedge load)
//    if (load)
//      addr_opcode <= 'b0;
//    else 
//      addr_opcode <= addr_opcode + 1;


//INSERIRE ANCHE IL SEGNALE DI SCRITTURA ALL'INTERNO  DEL CICLO BLOCK TRANSFER
//ADDRESS 0XC0
wire wr_opcode = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1100) && !write_ && selb && !preqselb;



// IDPROM  xx100000 - xx1000FC
//wire d_IDPROMR = ivadd[20]&&(ivadd[19:7]==0)&&(ivadd[23:21]==0)&&write_&&selb;

wire [29:0] AM_error =  {err_critical, err_flag, input_ctr_debug[1], hee_reg, input_ctr_debug[0], last_hreg_ee, state, data_count, vme_out_fifo_full, vme_out_fifo_empty};// Modifica dimensione fifo VME in out alle lamb (data_count) a 14 bit 26.07.10 V.B.

// registri implementati all'interno del chip che sono inidrizzati
//e viene generato il segnale di abilitazione alla scrittura o lettura
//Registro dove memorizzo la versione del firmware [23:12]==8
wire d_rd_version_firmware = (ivadd[23:12]== 'h8) && write_ && selb;

//REG0: status register, read only
wire d_rd_reg0   = regs && (ivadd[5:2]=='h0) && write_ && selb;

//soft_init's address is XX000004;
wire soft_init   =  (ivadd[23:11]==0) && (ivadd[10:2]=='h001) && !write_ && selb;

//TMODE      address is XX000008;
wire wr_tmode    = regs && (ivadd[5:2]=='h2) && !write_ && selb && !preqselb;
wire d_rd_tmode  = regs && (ivadd[5:2]=='h2) &&  write_ && selb;

//FREEZE (to read spybuffers)
wire wr_freeze    = regs && (ivadd[5:2]=='hA) && !write_ && selb && !preqselb;
wire d_rd_freeze  = regs && (ivadd[5:2]=='hA) &&  write_ && selb;

//ospy_status: information about output spybuffer; status register, read only
wire d_rd_ospy_status   = regs && (ivadd[5:2]=='hB) && write_ && selb;

// OSPY selected
wire d_rd_ospy_sel = (ivadd[23:12]== 'h7) && write_ && selb;

//ispy0_status: information about input0 spybuffer; status register, read only
wire d_rd_ispy0_status   = regs && (ivadd[5:2]=='hC) && write_ && selb;		// controllare indir (mp10.07.2008)
// ISPY0 selected
wire d_rd_ispy0_sel = (ivadd[23:12]== 'h1) && write_ && selb;

// ISPY1 selected
wire d_rd_ispy1_sel = (ivadd[23:12]== 'h2) && write_ && selb;

// ISPY2 selected
wire d_rd_ispy2_sel = (ivadd[23:12]== 'h3) && write_ && selb;

// ISPY3 selected
wire d_rd_ispy3_sel = (ivadd[23:12]== 'h4) && write_ && selb;

// ISPY4 selected
wire d_rd_ispy4_sel = (ivadd[23:12]== 'h5) && write_ && selb;

// ISPY5 selected
wire d_rd_ispy5_sel = (ivadd[23:12]== 'h6) && write_ && selb;

// HIT MASK
wire wr_hitmask    = regs && (ivadd[5:2]=='hF) && !write_ && selb && !preqselb;
wire d_rd_hitmask  = regs && (ivadd[5:2]=='hF) &&  write_ && selb;

//TCK enable	  
wire wr_tcken   = regs && (ivadd[5:2]=='h3) && !write_ && selb && !preqselb;
wire d_rd_tcken = regs && (ivadd[5:2]=='h3) &&  write_ && selb;

//input register address 
wire wr_input    = regs && ((ivadd[5:4]== 2'b01) || (ivadd[5:3]== 3'b100)) && !write_ && selb;
//wire wr_input    = regs && ((ivadd[5:4]== 2'b01) || (ivadd[5:3]== 3'b100)) && !write_ && selb;  // md 15.03.2011
wire d_rd_input  = regs && ((ivadd[5:4]== 2'b01) || (ivadd[5:3]== 3'b100)) &&  write_ && selb;

//inseriamo il registro per la lettura della fifo
wire regs_zero = (ivadd[23:7]==0);	
//ADDRESS 0X0000050
wire wr_start_rd_fifo    = regs_zero && (ivadd[6:4]== 3'b101) && !write_ && selb && !preqselb;
wire d_rd_start_rd_fifo    = regs_zero && (ivadd[6:4]== 3'b101) && write_ && selb;

//inseriamo il registro per impostare la modalità edro
//ADDRESS 0X0000060
wire wr_edro_mode    = regs_zero && (ivadd[6:4]== 3'b110) && !write_ && selb && !preqselb;
wire d_rd_edro_mode    = regs_zero && (ivadd[6:4]== 3'b110) && write_ && selb;

//inseriamo il registro per il loop della FIFO
//ADDRESS 0X0000070
wire wr_hit_loop    = regs_zero && (ivadd[6:4]== 3'b111) && !write_ && selb && !preqselb;
wire d_rd_hit_loop    = regs_zero && (ivadd[6:4]== 3'b111) && write_ && selb;

//ADDRESS 0X0000080
wire d_rd_stat1    = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1000) && write_ && selb;
//ADDRESS 0X0000090
wire d_rd_stat2    = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1001) && write_ && selb;

//ADDRESS 0X00000A0
wire d_rd_timer    = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1010) && write_ && selb;

//ADDRESS 0X00000B0
wire wr_nloop = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1011) && !write_ && selb;

////inseriamo il registro per abilitare la bitmap
////ADDRESS 0X00000D0
wire wr_bitmap    = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1101) && !write_ && selb && !preqselb;
wire d_rd_bitmap  = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1101) && write_ && selb;

// DEBUG REGISTER Indirizzi da sistemare meglio!!! (mp 10.04.2008)
// registro per leggere da vme la fifo che contiene le roads uscite dalla lamb (che arrivano dalla amglue)
wire d_rd_ladd_fifo = (ivadd[23:10]==0) && (ivadd[9:2]=='hFF) && write_ && selb;

// registri nel chip Bousca nella LAMB
//WRPAM IN UN REGISTRO CON CLK DI SISTEMA (tolto selb)
reg wrpam;
//wire init_wrpam = ppdtack;
wire init_wrpam = qselb;
wire en_wrpam = !write_ && selb && !preqselb;
always @ (posedge clk or posedge init_wrpam)
	if(init_wrpam) 
		wrpam <= 0;
	else if (en_wrpam)
		wrpam <= ivadd[23];
		
//RDBSCAM IN UN REGISTRO CON CLOCK DI SISTEMA
reg rdbscan;
wire en_rdpam = write_ && selb && !preqselb;
always @ (posedge clk or posedge vme_cycle_end)
	if(vme_cycle_end) 
		rdbscan <= 0;
	else if (en_rdpam)
		rdbscan <= ivadd[23];
		
// generate final read signals
reg rd_tmode, rd_reg0, rd_tcken, rd_input, rd_ladd_fifo,
		rd_freeze, rd_ospy_status, rd_ospy_sel, rd_ispy0_status,
		rd_ispy0_sel, rd_ispy1_sel, rd_ispy2_sel, rd_ispy3_sel, rd_ispy4_sel, rd_ispy5_sel,
		rd_hitmask, rd_version_firmware, rd_edro_mode, rd_start_rd_fifo, rd_hit_loop,
		rd_stat1, rd_stat2, rd_timer, rd_bitmap;

// output spy 
assign ospy_sel = rd_ospy_sel;
//input spy
assign ispy0_sel = rd_ispy0_sel;
assign ispy1_sel = rd_ispy1_sel;
assign ispy2_sel = rd_ispy2_sel;
assign ispy3_sel = rd_ispy3_sel;
assign ispy4_sel = rd_ispy4_sel;
assign ispy5_sel = rd_ispy5_sel;


always @ (posedge qselb or posedge vme_cycle_end)
	if (vme_cycle_end) 
	  begin
	   rd_bitmap <= 'b0;
	   rd_timer <= 'b0;
	   rd_stat1 <= 'b0;
		rd_stat2 <= 'b0;
	   rd_hit_loop <= 'b0;
		rd_edro_mode <= 'b0;
		rd_start_rd_fifo <= 'b0;
		rd_tmode <= 'b0;
		rd_reg0  <= 'b0;
		rd_version_firmware <= 'b0;
		rd_tcken <= 'b0;
		rd_input <= 'b0;
		rd_ladd_fifo <= 'b0;
		rd_freeze <= 'b0;
		rd_ospy_status <= 'b0;
		rd_ospy_sel	<= 'b0;
		rd_ispy0_status <= 'b0;
		rd_ispy0_sel	<= 'b0;
		rd_ispy1_sel	<= 'b0;
		rd_ispy2_sel	<= 'b0;
		rd_ispy3_sel	<= 'b0;
		rd_ispy4_sel	<= 'b0;
		rd_ispy5_sel	<= 'b0;
		rd_hitmask <= 'b0;
	  end
	else 
	  begin
	   rd_bitmap <= d_rd_bitmap;
	   rd_timer <= d_rd_timer;
	   rd_stat1 <= d_rd_stat1;
		rd_stat2 <= d_rd_stat2;
	   rd_hit_loop <= d_rd_hit_loop;
		rd_edro_mode <= d_rd_edro_mode;
		rd_start_rd_fifo <= d_rd_start_rd_fifo;
		rd_tmode   <= d_rd_tmode;
		rd_reg0    <= d_rd_reg0;
		rd_version_firmware <= d_rd_version_firmware;
		rd_tcken   <= d_rd_tcken;
		rd_input   <= d_rd_input;
		rd_ladd_fifo <= d_rd_ladd_fifo;
		rd_freeze	<= d_rd_freeze;
		rd_ospy_status <= d_rd_ospy_status;
		rd_ospy_sel	<= d_rd_ospy_sel;
		rd_ispy0_status <= d_rd_ispy0_status;
		rd_ispy0_sel <= d_rd_ispy0_sel;
		rd_ispy1_sel <= d_rd_ispy1_sel;
		rd_ispy2_sel <= d_rd_ispy2_sel;
		rd_ispy3_sel <= d_rd_ispy3_sel;
		rd_ispy4_sel <= d_rd_ispy4_sel;
		rd_ispy5_sel <= d_rd_ispy5_sel;
		rd_hitmask <= d_rd_hitmask; 
	  end

// generate the address lines to be sent to LAMB's bousca chips for local registers
wire [2:0] add = {3{gaddok & ivadd[23]}} & {ivadd[22], ivadd[21], ivadd[20]};

// gli indirizzi sono stati presi dagli indirizzi di ctramb (mp 2008)								
assign rwadd = {3{gaddok & ((ivadd[5:4]== 2'b01) || (ivadd[5:3]== 3'b100))}} & {ivadd[4], ivadd[3], ivadd[2]};

//  Internal Registers	write
// back_init is active low: 
wire init_active_high= ~back_init;

init_gen ini (.back_init(init_active_high),.soft_init(soft_init),.clk(clk), .am_init(am_init));

//DFF per disalitazione del DFF a valle del counter
wire renable = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1010) && d_cycle_end; //abilita dopo la lettura del clock
//wire renable = (ivadd[23:8]==0) && (ivadd[7:4]== 4'b1001) && vme_cycle_end;

//generiamo il segnale di reset per i contatori
wire init_stat_count = (!rd_stat1) && d_rd_stat1; //resetta i contatori dopo la lettura del primo registro

//segnale di reset dell'overflow
wire reset_owf = renable || am_init;

reg en_reg_count;
always @ (posedge clk or posedge renable)
	if(renable)	
		en_reg_count <= 1'b1;
	else if (d_rd_stat1)
		en_reg_count <= 1'b0;


//registro per creare il timer
reg [31:0] count_clk;
wire init_count_clk = init_stat_count || am_init;
always @ (posedge clk)
	if(init_count_clk)
		count_clk <= 0;
	else 
		count_clk <= count_clk + 1;
		
//registro per memorizzare numbero di patter
reg [30:0] count_clk_reg;
always @ (posedge clk )
	if(am_init)
		count_clk_reg <= 0;
	else if (en_reg_count)
		count_clk_reg <= count_clk [30:0];	

//registri di overflow per contatori pattern 
reg overflow_count_clk;
always @ (posedge clk or posedge reset_owf)
	if(reset_owf)
		overflow_count_clk <= 1'b0;
	else if (count_clk[31])
		overflow_count_clk <= 1'b1;


//registro per memorizzare numbero di patter
reg [30:0] count_patt_reg;
always @ (posedge clk )
	if(am_init)
		count_patt_reg <= 0;
	else if (en_reg_count)
		count_patt_reg <= count_patt [30:0];

//registri di overflow per contatori pattern 
reg overflow_count_patt;
always @ (posedge clk or posedge reset_owf)
	if(reset_owf)
		overflow_count_patt <= 1'b0;
	else if (count_patt[31])
		overflow_count_patt <= 1'b1;

//registro per memorizzare numbero di eventi
reg [30:0] count_event_reg;
always @ (posedge clk)
	if(am_init)
		count_event_reg <= 0;
	else if (en_reg_count)
		count_event_reg <= count_event [30:0];
		
//registri di overflow per contatori event
reg overflow_count_event;
always @ (posedge clk or posedge reset_owf)
	if(reset_owf)
		overflow_count_event <= 1'b0;
	else if (count_event[31])
		overflow_count_event <= 1'b1;



//REGISTRI WRITE 
//registro di hit loop
reg hit_loop;
always @ (posedge clk)
	if(am_init)
		hit_loop <= 0;
	else if (wr_hit_loop)
		hit_loop <= vmedata[0];

//registro di edro mode
reg edro_mode;
always @ (posedge clk)
	if(am_init)
		edro_mode <= 0;
	else if (wr_edro_mode)
		edro_mode <= vmedata[0];

//registro di edro mode
reg start_rd_fifo;
always @ (posedge clk)
	if(am_init)
		start_rd_fifo <= 0;
	else if (wr_start_rd_fifo)
		start_rd_fifo <= vmedata[0];

//registro di bitmap
reg bitmap_en;
always @ (posedge clk)
	if(am_init)
		bitmap_en <= 0;
	else if (wr_bitmap)
		bitmap_en <= vmedata[0];


//registro di tmode
reg tmode;
always @ (posedge clk)
	if(am_init)
		tmode <= 0;
	else if (wr_tmode)
		tmode <= vmedata[0];

//registro per il freeze degli spy buffer
reg freeze;
always @ (posedge clk)
	if(am_init) freeze <= 0;
	else if (wr_freeze)
		freeze <= vmedata[0];
		
//registro per abilitazione del tck
reg en_tck;
always @ (posedge clk)
	if(am_init) en_tck <= 0;
	else if (wr_tcken)
		en_tck <= vmedata[0];
			
//registro per scrivere la hitmask
reg [17:0] hitmask;
always @ (posedge clk)  // senza reset; deve essere scritto ad ogni accensione del sistema
 if (wr_hitmask)
  hitmask <= vmedata[17:0];

// registro a valle della fifo (il registro e' istanzaiato piu' avanti)
reg [22:0] ladd_fifo_out_reg;
		
`define rd_switch {rd_tcken, rd_tmode, rd_reg0, rd_ladd_fifo, rd_freeze, rd_ospy_status,rd_ospy_sel, rd_ispy0_status, rd_ispy0_sel, rd_ispy1_sel, rd_ispy2_sel, rd_ispy3_sel, 				rd_ispy4_sel, rd_ispy5_sel,rd_hitmask,rd_version_firmware, rd_edro_mode, rd_start_rd_fifo,  rd_hit_loop, rd_stat1, rd_stat2, rd_timer, rd_bitmap}
wire rd_vme = (rd_tcken || rd_tmode || rd_reg0 || rd_version_firmware 
							 || rd_ladd_fifo || rd_freeze || rd_ospy_status || rd_ospy_sel
							 || rd_ispy0_status || rd_ispy0_sel
							 || rd_ispy1_sel || rd_edro_mode || rd_start_rd_fifo 
							 || rd_ispy2_sel || rd_hit_loop || rd_timer 
							 || rd_ispy3_sel || rd_stat1 || rd_stat2 
							 || rd_ispy4_sel || rd_bitmap
							 || rd_ispy5_sel
							 || rd_hitmask);  	// segnala una lettura del modulo vme

//versione firmware
wire [4:0] day;
wire [3:0] month;
wire [3:0] year;
wire [3:0] version;
assign day [4:0] = 5'b01110;
assign month [3:0] = 4'b0111;
assign year [3:0] = 4'b1011;
assign version [3:0] = 4'b0001;

always @ (rd_tcken or rd_tmode or rd_reg0 or rd_version_firmware or en_tck or tmode
				 or AM_error or rd_ladd_fifo or ladd_fifo_out_reg or freeze or rd_freeze or
				 rd_ospy_status or rd_ospy_sel or ospy_status or ospy_data_out or ispy0_status or
				 rd_ispy0_status or rd_ispy0_sel or ispy0_data_out or ispy1_data_out or ispy2_data_out or 
				 rd_ispy1_sel or ispy3_data_out or ispy4_data_out or ispy5_data_out or
				 rd_ispy2_sel or hitmask or day or month or year or version or overflow_count_patt or count_patt_reg or
				 rd_ispy3_sel or edro_mode or start_rd_fifo or rd_stat1 or rd_stat2 or 
				 rd_ispy4_sel or rd_edro_mode or rd_start_rd_fifo or overflow_count_event or count_event_reg or
				 rd_ispy5_sel or hit_loop or rd_hit_loop or rd_timer or overflow_count_clk or count_clk_reg or
				 rd_hitmask or bitmap_en or rd_bitmap)

case (`rd_switch)
  'b10000000000000000000000: ivdata = {31'b0, en_tck}; 
  'b01000000000000000000000: ivdata = {31'b0, tmode}; 
  'b00100000000000000000000: ivdata = {3'b0, AM_error};		// am_error = reg0 // Modifica dimensioni di AM_error a 26 bit 26.07.10 V.B.
  'b00010000000000000000000: ivdata = {9'b0, ladd_fifo_out_reg}; // uscita registrata della fifo di debug delle roads
  'b00001000000000000000000: ivdata = {31'b0, freeze};
  'b00000100000000000000000: ivdata = {20'b0, ospy_status};  //
  'b00000010000000000000000: ivdata = {2'b0, ospy_data_out};  //
  'b00000001000000000000000: ivdata = {20'b0, ispy0_status};  //
  'b00000000100000000000000: ivdata = {11'b0, ispy0_data_out};  //
  'b00000000010000000000000: ivdata = {11'b0, ispy1_data_out};  //
  'b00000000001000000000000: ivdata = {11'b0, ispy2_data_out};  //
  'b00000000000100000000000: ivdata = {11'b0, ispy3_data_out};  //
  'b00000000000010000000000: ivdata = {11'b0, ispy4_data_out};  //
  'b00000000000001000000000: ivdata = {11'b0, ispy5_data_out};  //
  'b00000000000000100000000: ivdata = {14'b0, hitmask};  //
  'b00000000000000010000000: ivdata = {15'b0, day,month,year,version};  //
  'b00000000000000001000000: ivdata = {31'b0, edro_mode};
  'b00000000000000000100000: ivdata = {31'b0, start_rd_fifo};
  'b00000000000000000010000: ivdata = {31'b0, hit_loop};
  'b00000000000000000001000: ivdata = {overflow_count_patt, count_patt_reg};
  'b00000000000000000000100: ivdata = {overflow_count_event, count_event_reg};
  'b00000000000000000000010: ivdata = {overflow_count_clk, count_clk_reg};
	'b00000000000000000000001: ivdata = {31'b0, bitmap_en}; 	
default: ivdata = 32'b0;
endcase 



wire bad_add = inv_add ; 

wire dtack_ = !dtack;

	
// generazione di tck_am, tck_glid
// AM_TMS			xx800000		tck_am only during WR
// AM_TDI			xx900000		tck_am only during WR
// AM_PROG_TDO		xxA00000		tck_am only during RD (AM_TDO)
// AM_INIT			xxB00000	
	
//registro con abilitazione
//wire en_d_tck = en_tck && pdtack && !dtack_copy;
wire en_d_tck = en_tck && ppdtack & !dtack_copy;
wire en_tck_am = ivadd[23] && en_d_tck && ((!write_ && !ivadd[21]) || (write_ && ivadd[21:20]=='h2));
always @ (posedge clk)	
	tck_am_lamb0 <= en_tck_am;		 
always @ (posedge clk)	
	tck_am_lamb1 <= en_tck_am;		 
always @ (posedge clk)	
	tck_am_lamb2 <= en_tck_am;		 
always @ (posedge clk)	
	tck_am_lamb3 <= en_tck_am;		 


//*********************************************************************
//generazione di enb_ e dirw_ per il controllo dei dati ai tranceivers
//il DIRW_ in linea di principio ha la durate di as_
wire dirw_clk = (gaddok && !as_);
wire dirw_preset = (as_ && !dirw_);
always @ (posedge dirw_clk or posedge dirw_preset)
	begin
	if (dirw_preset) 
		dirw_ <= 1'b1;
	else 
		dirw_ <= write_;
	end

//ENB_ ha la durata dei ds_ è quindi è compreso all'interno di DIRW_
//all'inizio del ciclo impostiamo la direzione ed abilitiamo i tranceiver 
//allla fine del ciclo disabilitiamo i transceiver e presettiamo la direzione
always @ (posedge pre_sync_selb or posedge d_cycle_end)  
	begin
	if (d_cycle_end) enb_ <= 1'b1;
	else enb_ <= 1'b0;
	end
	
//errore dul bus
always @ (posedge pre_sync_selb or posedge vme_cycle_end)
	begin
	if (vme_cycle_end) 
		berr_ <= 1'b1;
	else 
		berr_ <= !bad_add;
	end

// ********************************************************************************
// generazione del read enable alla fifo
// questo e' generato a partire dalla maschera che riconosce l'indirizzamento della fifo

// ritardo
reg d_rd_ladd_fifo_delayed1, d_rd_ladd_fifo_delayed2;
always @ (posedge clk)
	if(am_init) 
		begin
		d_rd_ladd_fifo_delayed1 <= 0;
		d_rd_ladd_fifo_delayed2 <= 0;
		end
	else
		begin
		d_rd_ladd_fifo_delayed1 <= d_rd_ladd_fifo;
		d_rd_ladd_fifo_delayed2 <= d_rd_ladd_fifo_delayed1;
		end
		

// read alla fifo		
wire rd_vme_out_fifo = d_rd_ladd_fifo_delayed1 && !d_rd_ladd_fifo_delayed2;

wire [22:0] ladd_fifo_out;

// FIFO contenente le roads provenienti dalle lambs e rileggibile via VME.
vme_out_fifo vme_out_fifo_inst(
																.clk(clk),
																.din(ladd),
																.rd_en(rd_vme_out_fifo),
																.rst(am_init),
																.wr_en(!dr_),
																.data_count(data_count),  //per la sim funzionale va commentata questa linea (non so perche'...) mp 27.05.2008
																.dout(ladd_fifo_out),
																.empty(vme_out_fifo_empty),
																.full(vme_out_fifo_full)
																);
		
// ritardo
reg rd_vme_out_fifo_delayed;  // serve per scrivere nel registro a valle della fifo
always @ (posedge clk)
	if(am_init) 
		rd_vme_out_fifo_delayed <= 0;
	else
		rd_vme_out_fifo_delayed <= rd_vme_out_fifo;

// registro a valle della fifo
always @ (posedge clk)
	if(am_init) ladd_fifo_out_reg <= 0;
	else if (rd_vme_out_fifo_delayed)	// read enable della fifo ritardato
		ladd_fifo_out_reg <= ladd_fifo_out;
   else 
		ladd_fifo_out_reg <= ladd_fifo_out_reg;				
		
		
//////////////////		
//    DEBUG  ////
////////////////

assign vme_block[0] = as_;
assign vme_block[1] = ds0_;
assign vme_block[2] = ds1_;
assign vme_block[3] = dtack;
assign vme_block[4] = load;
assign vme_block[5] = cntclk;
assign vme_block[6] = eubt;
assign vme_block[7] = enb_;
assign vme_block[8] = dirw_;
//
assign vme_block[9] = wr_opcode;
assign vme_block[10] = 'b0;
assign vme_block[14:11] = 'b0;
//



		
endmodule
