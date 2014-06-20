`timescale 1ns / 1ps
module fe_cbc_chip(clk, en, layer, phi, z, fe, hit1_dv, hit1_data, hit2_dv, hit2_data, hit3_dv, hit3_data);

input wire clk;
input wire en;
input wire [3:0] layer;
input wire [3:0] phi;
input wire [3:0] z;
input wire [3:0] fe;
output reg hit1_dv;
output reg [12:0] hit1_data;
output reg hit2_dv;
output reg [12:0] hit2_data;
output reg hit3_dv;
output reg [12:0] hit3_data;

reg [31:0] ts_cnt;
reg [31:0] ts_in;
reg [3:0] layer_in;
reg [3:0] phi_in;
reg [3:0] z_in;
reg [3:0] fe_in;
reg [7:0] stub_in;
reg [4:0] bend_in;

reg event_rd;

reg hit1_done;
reg hit2_done;
reg hit3_done;

integer infile, r;

initial #0.001
  begin
    ts_cnt = 32'h00000000;
    hit1_done = 1'b0;
    hit1_dv = 1'b0;
    hit1_data = 13'b0;
    hit2_done = 1'b0;
    hit2_dv = 1'b0;
    hit2_data = 13'b0;
    hit3_done = 1'b0;
    hit3_dv = 1'b0;
    hit3_data = 13'b0;
  end

always @(posedge clk) #0.001
    if ((en == 1'b1) && (ts_cnt < ts_in))
      begin
        ts_cnt = ts_cnt + 1'b1;
    hit1_done = 1'b0;
    hit1_dv = 1'b0;
    hit1_data = 13'b0;
    hit2_done = 1'b0;
    hit2_dv = 1'b0;
    hit2_data = 13'b0;
    hit3_done = 1'b0;
    hit3_dv = 1'b0;
    hit3_data = 13'b0;
end
always #0.001
  if (ts_cnt == ts_in)
  begin 
    event_rd = 1'b1; #0.001 event_rd = 1'b0; 
  end
  else
    event_rd = 1'b0;

always #0.001
  if (event_rd)
    begin
      if ((hit1_done == 1'b0) && (layer_in == layer) && (phi_in == phi) && (z_in == z) && (fe_in == fe) && (ts_cnt == ts_in))
        begin
        hit1_done = 1'b1;
        hit1_dv = 1'b1;
        hit1_data = {stub_in,bend_in};
      end
    else if ((hit2_done == 1'b0) && (layer_in == layer) && (phi_in == phi) && (z_in == z) && (fe_in == fe) && (ts_cnt == ts_in)) 
        begin
        hit2_done = 1'b1;
        hit2_dv = 1'b1;
        hit2_data = {stub_in,bend_in};
      end
    else if ((hit3_done == 1'b0) && (layer_in == layer) && (phi_in == phi) && (z_in == z) && (fe_in == fe) && (ts_cnt == ts_in))
        begin
        hit3_done = 1'b1;
        hit3_dv = 1'b1;
        hit3_data = {stub_in,bend_in};
      end
    end

initial #0.001
  begin
		infile=$fopen("data\\hits.txt","r");
	 end

initial #0.001
  begin
    r = $fscanf(infile,"%h %h %h %h %h %h %h\n",ts_in,layer_in,phi_in,z_in,fe_in,stub_in,bend_in);
    while (!$feof(infile))
      begin
//        @(posedge clk) #1
//          if (event_rd)
        @(posedge event_rd) #0.001
            r = $fscanf(infile,"%h %h %h %h %h %h %h\n",ts_in,layer_in,phi_in,z_in,fe_in,stub_in,bend_in);
          end
    $fclose(infile);
//    $stop;
 end
endmodule
