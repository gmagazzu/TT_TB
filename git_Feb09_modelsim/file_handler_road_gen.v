`timescale 1ns / 1ps
module file_handler_road_gen(clk, eor, road_data, road_dv);

   input wire clk;
   input wire eor; 
   input wire [29:0] road_data;
   input wire road_dv;

   integer 	     outfile, r;

   initial
//     begin
		outfile=$fopen("commands\\test_ciccio.txt","w");  
//	while (enable)
//	  begin
     always         @(posedge clk) #1
               if (road_dv)
                      $fwrite(outfile, "%h \n", road_data);
 //    end
     always         @(posedge clk) #1
		    if (eor)
$fclose(outfile);
//	$stop;
//end
endmodule
