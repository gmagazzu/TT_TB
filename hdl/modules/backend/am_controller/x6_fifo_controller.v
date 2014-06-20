`timescale 1 ns / 100 ps	
module x6_fifo_controller(clk,ef_b,init,pop,rden_b,reg_en, pok);
     
input clk;
input [5:0] ef_b;
input init;
input [5:0] pop;
output [5:0] rden_b,reg_en;
output [5:0] pok;

wire [5:0] ef_b;
wire init;
wire [5:0] pop;
wire [5:0] rden_b,reg_en;
wire [5:0] pok;

fifo_controller ffctr0(clk,init,pop[0],ef_b[0],pok[0],reg_en[0],rden_b[0]);
fifo_controller ffctr1(clk,init,pop[1],ef_b[1],pok[1],reg_en[1],rden_b[1]);
fifo_controller ffctr2(clk,init,pop[2],ef_b[2],pok[2],reg_en[2],rden_b[2]);
fifo_controller ffctr3(clk,init,pop[3],ef_b[3],pok[3],reg_en[3],rden_b[3]);
fifo_controller ffctr4(clk,init,pop[4],ef_b[4],pok[4],reg_en[4],rden_b[4]);
fifo_controller ffctr5(clk,init,pop[5],ef_b[5],pok[5],reg_en[5],rden_b[5]);

endmodule
