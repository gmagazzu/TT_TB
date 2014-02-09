// 20-1-03 by Giampiero Ferri
//written using Ise 5.1

`timescale 1ns/1ps
module init_gen(clk, soft_init, back_init, am_init);
//module init_gen(clk, soft_init, back_init, am_init, resfifon);

input clk, soft_init, back_init;
output am_init;
//output resfifon;

reg[3:0] sh_init;

always @(posedge clk)
       sh_init={sh_init[2], sh_init[1], sh_init[0], soft_init|back_init};

assign am_init = (sh_init[3] | sh_init[2] | sh_init[1] | sh_init[0]);

//assign resfifon = !(sh_init[2] & !sh_init[1] & !sh_init[0]);

endmodule
