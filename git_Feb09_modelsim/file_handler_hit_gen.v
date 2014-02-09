`timescale 1ns / 1ps
module file_handler_hit_gen(clk, en, layer, hit_dv, hit_data);

input wire clk;
input wire en;
input wire [5:0] layer;
output reg hit_dv;
output reg [23:0] hit_data;

reg [31:0] ts_cnt;
reg [31:0] ts_in;
reg [23:0] hit_in;

reg event_rd;

integer infile, r;

initial #1
  begin
    ts_cnt = 32'h00000000;
    hit_dv = 1'b0;
    hit_data = 24'b000000000000000000000000;
  end

always @(posedge clk) #1
    if (en)
        ts_cnt = ts_cnt + 1'b1;

always #1
  if (ts_cnt == ts_in) 
    event_rd = 1'b1;
  else
    event_rd = 1'b0;

always @(posedge clk) #1
  if (event_rd)
    begin
      hit_dv = 1'b1;
      hit_data = hit_in;
    end
  else
    begin
    hit_dv = 1'b0;
		hit_data = 24'b000000000000000000000000;
    end  

initial #1
  begin
    if (layer[0])
      begin
		infile=$fopen("commands\\layer0_hits.txt","r");
		  end
	 if (layer[1])
      begin
		infile=$fopen("commands\\layer1_hits.txt","r");
		  end
	 if (layer[2])
      begin
		infile=$fopen("commands\\layer2_hits.txt","r");
		  end
	 if (layer[3])
      begin
		infile=$fopen("commands\\layer3_hits.txt","r");
		  end
	 if (layer[4])
      begin
		infile=$fopen("commands\\layer4_hits.txt","r");
		  end
	 if (layer[5])
      begin
		infile=$fopen("commands\\layer5_hits.txt","r");
		  end
	 end

initial #2
  begin
    r = $fscanf(infile,"%h %b",ts_in,hit_in);
    while (!$feof(infile))
      begin
        @(posedge clk) #1
          if (event_rd)
            r = $fscanf(infile,"%h %b \n",ts_in,hit_in);
          end
    $fclose(infile);
//    $stop;
 end
endmodule
