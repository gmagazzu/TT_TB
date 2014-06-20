`timescale 1ns / 1ps
module file_handler_road_gen(clk, eor, p0_road_data, p0_road_dv, p1_road_data, p1_road_dv, p2_road_data, p2_road_dv, p3_road_data, p3_road_dv);

   input wire clk;
   input wire eor; 
   input wire [29:0] p0_road_data;
   input wire [29:0] p1_road_data;
   input wire [29:0] p2_road_data;
   input wire [29:0] p3_road_data;
   input wire p0_road_dv;
   input wire p1_road_dv;
   input wire p2_road_dv;
   input wire p3_road_dv;

   integer 	     p0_outfile, p1_outfile, p2_outfile, p3_outfile, r;

   initial
     begin
    $display($time);
		p0_outfile=$fopen("commands\\p0_roads.txt","w");
		p1_outfile=$fopen("commands\\p1_roads.txt","w");
		p2_outfile=$fopen("commands\\p2_roads.txt","w");
		p3_outfile=$fopen("commands\\p3_roads.txt","w");
end
//	while (enable)
//	  begin
     always         @(posedge clk) #1
               if (p0_road_dv)
                      $fwrite(p0_outfile, "%h \n", p0_road_data);
     always         @(posedge clk) #1
               if (p1_road_dv)
                      $fwrite(p1_outfile, "%h \n", p1_road_data);
     always         @(posedge clk) #1
               if (p2_road_dv)
                      $fwrite(p2_outfile, "%h \n", p2_road_data);
     always         @(posedge clk) #1
               if (p3_road_dv)
                      $fwrite(p3_outfile, "%h \n", p3_road_data);
 //    end
     always         @(posedge clk) #1
		    if (eor)
begin
$fclose(p0_outfile);
$fclose(p1_outfile);
$fclose(p2_outfile);
$fclose(p3_outfile);
    $display($time);

//	$stop;
end
endmodule
