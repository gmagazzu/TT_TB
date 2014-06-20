----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:52 02/16/2011 
-- Design Name: 
-- Module Name:    input - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity x6_input_controller is
    Port ( clk : 				in  STD_LOGIC;
           init : 			in  STD_LOGIC;
           init_ev : 		in  STD_LOGIC;
           lay0_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
           lay1_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
           lay2_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
			  lay3_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
			  lay4_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
			  lay5_in : 		in  STD_LOGIC_VECTOR (17 downto 0);
			  new_hit  : 		in  STD_LOGIC_VECTOR (5 downto 0);	--new hit in input of the board
			  wr_hit_lamb : 	in  STD_LOGIC_VECTOR (5 downto 0);	--hit in input to lamb	
			  
			  state  : 			in  STD_LOGIC_VECTOR (2 downto 0);	--state of FSM
			  
			  wr_fifo : 		in  STD_LOGIC_VECTOR (5 downto 0);	--enable wr fifo of hit
           vme_input0_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);	--data in input from VME
			  vme_input1_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  vme_input2_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  vme_input3_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  vme_input4_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  vme_input5_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  
			  tmode : 			in  STD_LOGIC;		--test mode from VME
			  edro_mode : 		in  STD_LOGIC;		--edro mode
			  start_rd_fifo : in  STD_LOGIC;		--start the read from the fifo of hit
			  hit_loop :      in  STD_LOGIC;		--enable write hit in out of fifo
           hitmask : 		in  STD_LOGIC_VECTOR (17 downto 0);		
			  
			  vmedata : 		in  STD_LOGIC_VECTOR (31 downto 0);
			  wr_nloop : 		in  STD_LOGIC;
			  
			  tag_ee_word : 	out  STD_LOGIC_VECTOR (15 downto 0);	--word fo end event
			  hee_reg : 		buffer  STD_LOGIC_VECTOR (5 downto 0);		--signal of end event
			  rd_fifo : 		out  STD_LOGIC_VECTOR (5 downto 0);		--read from the fifo
			  
			  A0_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
			  A1_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
			  A2_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
        A3_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
        A4_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
			  A5_HIT : out  STD_LOGIC_VECTOR (17 downto 0);
			  enA_wr : out  STD_LOGIC_VECTOR (5 downto 0);
			  
			  data_ispy0 : 		buffer STD_LOGIC_VECTOR (20 downto 0);		--data of the input spy buffer
			  data_ispy1 : 		buffer STD_LOGIC_VECTOR (20 downto 0);
			  data_ispy2 : 		buffer STD_LOGIC_VECTOR (20 downto 0);
			  data_ispy3 : 		buffer STD_LOGIC_VECTOR (20 downto 0);
			  data_ispy4 : 		buffer STD_LOGIC_VECTOR (20 downto 0);
			  data_ispy5 : 		buffer STD_LOGIC_VECTOR (20 downto 0);
			  push_data_ispy :	 out STD_LOGIC_VECTOR (5 downto 0);
			  
			  HIT_lay0 : out STD_LOGIC_VECTOR (17 downto 0);		--copy of hit in output
			  HIT_lay1 : out STD_LOGIC_VECTOR (17 downto 0);
			  HIT_lay2 : out STD_LOGIC_VECTOR (17 downto 0);
			  HIT_lay3 : out STD_LOGIC_VECTOR (17 downto 0);
			  HIT_lay4 : out STD_LOGIC_VECTOR (17 downto 0);
			  HIT_lay5 : out STD_LOGIC_VECTOR (17 downto 0);
			  push_hit : out STD_LOGIC_VECTOR (5 downto 0);
			  
			  err_flag : buffer  STD_LOGIC;
			  err_critical : out  STD_LOGIC
			  );

end x6_input_controller;

architecture Behavioral of x6_input_controller is
	
	component input_controller is
    Port ( clk : 					in  STD_LOGIC;
           init : 				in  STD_LOGIC;
           init_ev : 			in  STD_LOGIC;
           wr_fifo_vme : 		in  STD_LOGIC;
			  vme_input_fifo : 	in  STD_LOGIC_VECTOR (19 downto 0);
			  lay_in :	 			in  STD_LOGIC_VECTOR (17 downto 0);
			  new_hit : 			in  STD_LOGIC;	  
			  wr_hit_lamb :		in  STD_LOGIC;
			  hitmask : 			in  STD_LOGIC_VECTOR (17 downto 0);
           tmode : 				in  STD_LOGIC;
           edro_mode : 			in  STD_LOGIC;
           start_rd_fifo : 	in  STD_LOGIC;
			  state  : 				in  STD_LOGIC_VECTOR (2 downto 0);
			  hit_loop : 			in  STD_LOGIC;
			  vmedata : 			in  STD_LOGIC_VECTOR (31 downto 0);
			  wr_nloop : 			in  STD_LOGIC;
			  
			  rd_fifo : 		out  STD_LOGIC;
			  hee_reg : 		buffer  STD_LOGIC; 	
			  tag_ee_word :	out  STD_LOGIC_VECTOR (15 downto 0);
        A_HIT : 			out  STD_LOGIC_VECTOR (17 downto 0);
			  enA_wr :			out  STD_LOGIC;			
			  
			  HIT_lay : 		out  STD_LOGIC_VECTOR (17 downto 0);
			  push_hit : 		out  STD_LOGIC;
			  
			  data_ispy : 			buffer STD_LOGIC_VECTOR (20 downto 0);
			  push_data_ispy : 	out STD_LOGIC
			  );
	end component input_controller;
	
	component sync_module is
		 Port ( clk :		in	 STD_LOGIC;	 
				  init :	   in	 STD_LOGIC;									--out of main FSM to initialize the event (init_ev)
				  init_ev : in  STD_LOGIC;									--global reset of board (init)
				  lay0 : in  STD_LOGIC_VECTOR (17 downto 0);
				  lay1 : in  STD_LOGIC_VECTOR (17 downto 0);
				  lay2 : in  STD_LOGIC_VECTOR (17 downto 0);
				  lay3 : in  STD_LOGIC_VECTOR (17 downto 0);
				  lay4 : in  STD_LOGIC_VECTOR (17 downto 0);
				  lay5 : in  STD_LOGIC_VECTOR (17 downto 0);

				  err_flag : 	buffer  STD_LOGIC;
				  
				  err_critical : 	out  STD_LOGIC
				 );
	end component sync_module;

type tag_ee_word_array is array (5 downto 0) of std_logic_vector(15 downto 0);
signal int_tag_ee_word : tag_ee_word_array;
		
begin
--***************************************************************
--MODULE INPUT FOR HIT BUS 0
--***************************************************************
	input0 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,	  
							  wr_fifo_vme => 	wr_fifo(0),
							  lay_in => 	lay0_in,
							  new_hit => 	new_hit(0),	
							  hitmask =>	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  start_rd_fifo => 	start_rd_fifo,
							  vme_input_fifo => 	vme_input0_fifo,		  
							  wr_hit_lamb => 		wr_hit_lamb(0),
							  			  
							  --output signal
							  hee_reg => 	hee_reg(0),
							  rd_fifo => 	rd_fifo(0),
							  tag_ee_word => int_tag_ee_word(0),
							  A_HIT => A0_HIT,
							  enA_wr => enA_wr(0),
							  
							  HIT_lay => HIT_lay0,
							  push_hit => push_hit(0),
							  
							  data_ispy => data_ispy0,
							  push_data_ispy => push_data_ispy(0)
							  );

--***************************************************************
--MODULE INPUT FOR HIT BUS 1
--***************************************************************
	input1 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,
							  wr_fifo_vme => 	wr_fifo(1),
							  lay_in => 	lay1_in,
							  new_hit => 	new_hit(1),							  
							  hitmask => 	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  vme_input_fifo => vme_input1_fifo,
							  start_rd_fifo => start_rd_fifo,
							  wr_hit_lamb => wr_hit_lamb(1),
								
							  --output signal
							  hee_reg => hee_reg(1),
							  rd_fifo => rd_fifo(1),
							  tag_ee_word => int_tag_ee_word(1),
							  A_HIT => A1_HIT,
							  enA_wr => enA_wr(1),
							  
							  HIT_lay => HIT_lay1,
							  push_hit => push_hit(1),
							  
							  data_ispy => data_ispy1,
							  push_data_ispy => push_data_ispy(1)
							  );
--***************************************************************
--MODULE INPUT FOR HIT BUS 2
--***************************************************************
	input2 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,
							  wr_fifo_vme => 	wr_fifo(2),
							  lay_in => 	lay2_in,
							  new_hit => 	new_hit(2),							  
							  hitmask => 	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  vme_input_fifo => vme_input2_fifo,
							  start_rd_fifo => start_rd_fifo,
							  wr_hit_lamb => wr_hit_lamb(2),
							  				  
							  --output signal
							  hee_reg => hee_reg(2),
							  rd_fifo => rd_fifo(2),
							  tag_ee_word => int_tag_ee_word(2),
							  A_HIT => A2_HIT,
							  enA_wr => enA_wr(2),
							  
							  HIT_lay => HIT_lay2,
							  push_hit => push_hit(2),
							  
							  data_ispy => data_ispy2,
							  push_data_ispy => push_data_ispy(2)
							  );
--***************************************************************
--MODULE INPUT FOR HIT BUS 3
--***************************************************************	
	input3 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,
							  wr_fifo_vme => 	wr_fifo(3),
							  lay_in => 	lay3_in,
							  new_hit => 	new_hit(3),							  
							  hitmask => 	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  vme_input_fifo => vme_input3_fifo,
							  start_rd_fifo => start_rd_fifo,
							  wr_hit_lamb => wr_hit_lamb(3),
							  
							  --output signal
							  hee_reg => hee_reg(3),
							  rd_fifo => rd_fifo(3),
							  tag_ee_word => int_tag_ee_word(3),
							  A_HIT => A3_HIT,
							  enA_wr => enA_wr(3),
							  
							  HIT_lay => HIT_lay3,
							  push_hit => push_hit(3),
							  
							  data_ispy => data_ispy3,
							  push_data_ispy => push_data_ispy(3)
							  );
--***************************************************************
--MODULE INPUT FOR HIT BUS 4
--***************************************************************
	input4 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,
							  wr_fifo_vme => 	wr_fifo(4),
							  lay_in => 	lay4_in,
							  new_hit => 	new_hit(4),							  
							  hitmask => 	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  wr_hit_lamb => wr_hit_lamb(4),
							  start_rd_fifo => start_rd_fifo,
							  vme_input_fifo => vme_input4_fifo,
							  
							  --output signal	
							  hee_reg => hee_reg(4),
							  rd_fifo => rd_fifo(4),
							  tag_ee_word => int_tag_ee_word(4),
							  A_HIT => A4_HIT,
							  enA_wr => enA_wr(4),
							  
							  HIT_lay => HIT_lay4,
							  push_hit => push_hit(4),
							  
							  data_ispy => data_ispy4,
							  push_data_ispy => push_data_ispy(4)
							  );
--***************************************************************
--MODULE INPUT FOR HIT BUS 4
--***************************************************************
	input5 : input_controller port map 
							(clk => 			clk,
							  init => 		init,
							  init_ev => 	init_ev,
							  wr_fifo_vme => 	wr_fifo(5),
							  lay_in => 	lay5_in,
							  new_hit => 	new_hit(5),							  
							  hitmask =>	hitmask,
							  state => 		state,
							  tmode => 		tmode,
							  hit_loop => 	hit_loop,
							  edro_mode => edro_mode,
							  vmedata => vmedata,
							  wr_nloop => wr_nloop,
							  
							  vme_input_fifo => 	vme_input5_fifo,
							  wr_hit_lamb => 		wr_hit_lamb(5),
							  start_rd_fifo => 	start_rd_fifo,

							  --output signal	
							  hee_reg => hee_reg(5),
							  rd_fifo => rd_fifo(5), 
							  tag_ee_word => int_tag_ee_word(5),
							  A_HIT => A5_HIT,
							  enA_wr => enA_wr(5),
							  
							  HIT_lay => HIT_lay5,
							  push_hit => push_hit(5),
							  
							  data_ispy => data_ispy5,
							  push_data_ispy => push_data_ispy(5)
							  );

  tag_ee_word <= int_tag_ee_word(0);
  
	sync: sync_module port map ( clk => clk,
										  init => init,
										  init_ev => init_ev,
										  lay0 => data_ispy0(17 downto 0),
										  lay1 => data_ispy1(17 downto 0),
										  lay2 => data_ispy2(17 downto 0),
										  lay3 => data_ispy3(17 downto 0),
										  lay4 => data_ispy4(17 downto 0),
										  lay5 => data_ispy5(17 downto 0),

										  err_flag => err_flag, 
										  err_critical => err_critical
										 );

end Behavioral;

