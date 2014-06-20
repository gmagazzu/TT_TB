`timescale 1ns / 1ps
module file_handler_mpa_road_gen(clk, eor, phi, z, p0_road_data, p0_road_dv, p1_road_data, p1_road_dv, p2_road_data, p2_road_dv, p3_road_data, p3_road_dv);

   input wire clk;
   input wire eor; 
   input wire [3:0] phi; 
   input wire [3:0] z; 
   input wire [29:0] p0_road_data;
   input wire [29:0] p1_road_data;
   input wire [29:0] p2_road_data;
   input wire [29:0] p3_road_data;
   input wire p0_road_dv;
   input wire p1_road_dv;
   input wire p2_road_dv;
   input wire p3_road_dv;

   integer 	     outfile [3:0];
   integer 	     r [3:0];

  integer i;
  integer k_z,k_phi;
  
//   initial
//     begin
//    $display($time);
//		outfile=$fopen("data\\roads.txt","w");
// end

   initial #2
     begin
//       for (k_z = 1'b0; k_z<4'b1111;k_z=k_z+1)
//       for (k_phi = 1'b0; k_phi<4'b1111;k_phi=k_phi+1)
//       if ((k_z == z) && (k_phi == phi))
       k_z=z;
       k_phi=phi; 
       for (i = 0; i<4;i=i+1)
       outfile[i]=$fopen($sformatf("data\\mpa_roads_z%0d_phi%0d_p%0d.txt",k_z,k_phi,i),"w");
     end
//		outfile=$fopen("data\\roads.txt","w");
// end

//	while (enable)
//	  begin
     always         @(posedge clk) #1
               if (p0_road_dv)
                      $fwrite(outfile[0], "%h \n", p0_road_data);
     always         @(posedge clk) #1
               if (p1_road_dv)
                      $fwrite(outfile[1], "%h \n", p1_road_data);
     always         @(posedge clk) #1
               if (p2_road_dv)
                      $fwrite(outfile[2], "%h \n", p2_road_data);
     always         @(posedge clk) #1
               if (p3_road_dv)
                      $fwrite(outfile[3], "%h \n", p3_road_data);
 //    end
     always         @(posedge clk) #1
		    if (eor)
begin
$fclose(outfile[0]);
$fclose(outfile[1]);
$fclose(outfile[2]);
$fclose(outfile[3]);
$display($time);

//	$stop;
end
endmodule
