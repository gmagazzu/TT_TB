`timescale 1 ns / 100 ps	
module x6ffctr(clk,ef_,init,pop,rden_,reg_en, pok);
     
input clk;
input [5:0] ef_;
input init;
input [5:0] pop;
//input [5:0] ds_;
output [5:0] rden_, reg_en;

// two identical signals are generated. each of us is sent to 4 FIFOS
//output resfifo0_,resfifo1_, out_init;
output [5:0] pok;

//reg init_reg;
//reg [3:0] count;

wire [5:0] ef_;
wire init;
wire [5:0] pop;
wire [5:0] rden_,reg_en;
//wire resfifo1_;
//wire resfifo0_;
wire [5:0] pok;

//wire start_counter = init && !init_reg;


// Non serve piu', era usato per il livello2 ---------------
//*****************
//  WEN_ generation
//*****************

//assign wren_ = ds_ | {6{wren_gen}};
//assign wren_gen = count[2];
// ----------------------------------------------------------



//********************
// wire assignments
//********************

//assign resfifo0_ = !(!count[1] && count[0]);
//assign resfifo1_ = !(!count[1] && count[0]);
//assign out_init = count[2];


	 
//always @(posedge clk)
//begin
//    init_reg <=  init;
//end
//
////********************************************
//// 4-bit synchronous counter with count enable
////********************************************
// 
//always @(posedge clk or posedge start_counter)
//begin
//   if (start_counter)
//     count <=  4'b0100;
//   else 
//   begin
//   
//         if (count[2])
//               count <=  count + 1;
//   end
//end

//**************
//instantiations
//**************

fifoctrl ffctr0(clk,init,pop[0],ef_[0],pok[0],reg_en[0],rden_[0]);
fifoctrl ffctr1(clk,init,pop[1],ef_[1],pok[1],reg_en[1],rden_[1]);
fifoctrl ffctr2(clk,init,pop[2],ef_[2],pok[2],reg_en[2],rden_[2]);
fifoctrl ffctr3(clk,init,pop[3],ef_[3],pok[3],reg_en[3],rden_[3]);
fifoctrl ffctr4(clk,init,pop[4],ef_[4],pok[4],reg_en[4],rden_[4]);
fifoctrl ffctr5(clk,init,pop[5],ef_[5],pok[5],reg_en[5],rden_[5]);

//reset_gen  resetgen(clk,init,resfifo0_, resfifo1_, out_init);  // istruzioni gia' messe nel corpo di questo file
endmodule
