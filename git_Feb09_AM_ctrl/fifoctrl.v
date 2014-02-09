`timescale 1 ns / 100 ps	
module fifoctrl (clk, init, pop, ef_, pok, reg_en, rden_) ;

input clk ;
input init ;
input pop ;
input ef_ ;	// empy fifo (low active)

// this signal goes high when a new word is pushed to PAM
output pok ;

// this signal enables FF read new data
output reg_en ;

// this signal enables Fifo read new data
output rden_ ;

//**********************
// register declarations
//**********************

// state-bits
reg[1:0] FIFOC_State;
reg[1:0] Next_State;


//******************
// wire declarations
//******************
wire rden_;
wire pok;
wire reg_en; 

//wire rd1_,rd2_;

//assign rd1_ = ( (ef_ && (FIFOC_State==0)) ||
//		  (ef_ && (FIFOC_State==1)) ||
//		  (ef_ && (FIFOC_State==2)));
//assign rd2_ = (ef_ && pop && (FIFOC_State==3));
//assign rden_ = !(rd1_ || rd2_);

assign rden_ = !( (ef_ && !(FIFOC_State==3)) || (ef_ && pop && (FIFOC_State==3)));
//assign rden_ = !( (ef_ && (FIFOC_State==0)) || (ef_ && (FIFOC_State==1)) || (ef_ && (FIFOC_State==2)) || (ef_ && pop && (FIFOC_State==3)) ); 

//pok=(FIFOC_State==2)||(FIFOC_State==3);
assign pok = FIFOC_State[0];

assign reg_en = ( (FIFOC_State == 2) ||
		  (pop && (FIFOC_State == 3)));

always @ (FIFOC_State or pop or ef_ or init)
begin  

   case (FIFOC_State)
// se la macchina si trova nello stato 0: nessun dato nella FIFO, nessun dato nel FF
// la FIFO puo' passare i dati (rden_=!ef_) ma il FF perche' e' vuoto e non c'e' il pop
// reg_en=1'b0
   	0: begin
//   	      rden_=!ef_;
//   	      reg_en=1'b0;
//   	      pok=1'b0;
   	      if (ef_) Next_State =   2;
   	      else Next_State =   0;
   	   end
// se la macchina si trova nello stato 1: nessun dato nella FIFO, un dato nel FF
// la FIFO puo' prendere i dati (rden_=!ef) ma il FF deve aspettare il pop per leggere
// pok e' settato a 1 in modo che appena arriva il pop il FF butta fuori il dato
   	1: begin
//   	      rden_ = !ef_;
//   	      reg_en = pop;
//   	      pok = 1'b1;
   	      if (!ef_&&pop) Next_State =   0;
   	      else if (pop&&ef_) Next_State =   2;
   	      else if (ef_&&!pop) Next_State =   3;
   	      else Next_State =   1;
   	   end
// se la macchina si trova nello stato 2: ha la FIFO occupata e il FF vuoto
// la fifo puo' leggere e lo stesso il FF. pok=0 perche' il FF e' vuoto. 
   	2: begin
//   	      pok = 1'b0;
//   	      reg_en = 1'b1;
//   	      rden_ = !ef_;
   	      if (ef_) Next_State =   3;
   	      else if (!ef_) Next_State =   1;
   	      else Next_State =   2;
   	   end
// se la macchina si trova nello stato 3: sia la FIFO che il FF con dati.
// la fifo legge se c'e' il pop. Il registro e' abilitato se c'e' il pop. pok e' alto
   	3: begin
//   	      rden_=!(ef_&&pop);
//   	      reg_en = pop;
//   	      pok = 1'b1;
   	      if (pop && !ef_) Next_State =   1;
   	      else Next_State =   3;
   	   end
   endcase 
end


//assign #1 y[1]=ef_||((ef_||!pop)&&stato[1]&&stato[0]);
//assign #1 y[0]=stato[1]||(!stato[1]&&stato[0]&&!pop);
//assign #1 RD_=!(ef_&&(!stato[0]||!stato[1]&&stato[0]||pop&&stato[1]&&stato[0]));
//assign #1 reg_en=stato[1]&&!stato[0]||stato[0]&&pop;
//assign #1 pok=stato[0];

always @(posedge clk or posedge init)
begin

   if (init)	  //asynchronous RESET active High
      begin
      	FIFOC_State =   0;
      end
   else             //use CLK rising edge
      begin
      	FIFOC_State =   Next_State;
      end
end


// add your declarations here

// add your code here

endmodule 
