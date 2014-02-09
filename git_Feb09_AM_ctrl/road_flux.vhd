----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Daniel Magalotti, Marco Piendibene
-- 
-- Create Date:    11:02:28 12/10/2010 
-- Design Name: 
-- Module Name:    road_flux - road_flux_behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: This module manage the road flux from the LAMB. 
--					 It have to select, depending to the state of FSM the address of road or the word of ee.
--				    This is a signal of write enable with the out road.
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity road_flux is
    Port ( clk : 	in  STD_LOGIC;
           init : 		in  STD_LOGIC;
           add : 			in  STD_LOGIC_VECTOR (22 downto 0);		--address of the road from LAMB
           tag_event : 	in  STD_LOGIC_VECTOR (15 downto 0);		--word of end event 
           sel_word : 	in  STD_LOGIC;									--select road or ee
           rpush : 		in  STD_LOGIC;									--enable the out register 
           
			  road_out : 	out  STD_LOGIC_VECTOR (29 downto 0);	--address out of the road
           wr_road : 	out  STD_LOGIC									--data strobe for the next board
			  );
end road_flux;

architecture road_flux_behavioral of road_flux is
	
	--end event word of road
	signal ee_word: STD_LOGIC_VECTOR(29 downto 0);
	
	--internal address of road
	signal int_add: STD_LOGIC_VECTOR(29 downto 0);
	
	--out signal of the mux
	signal mux_road: STD_LOGIC_VECTOR(29 downto 0);
	
	--constant signal 
	--signal logic1: STD_LOGIC;
	signal logic0: STD_LOGIC;
	signal logic0_x9: STD_LOGIC_VECTOR(8 downto 0);
	
	--number of board
	signal board_add : STD_LOGIC_VECTOR (3 downto 0);	
	
begin
	
	--assign zero to number of board. It is not used
	board_add <= (others => '0');
	
	--constant
	--logic1 <= '1';
	logic0 <= '0';
	logic0_x9 <= (others => '0');

	--insert three bit of tag, the number of the board and the road address
	--the three first bit is: rse_flag & ree_flag & rpe_flag (for normal road 0 0 1)
	int_add <= ("001" & board_add & add);
	
	--create the word of end event considering the tag_event of input
	--the three first bit is: rse_flag & ree_flag & rpe_flag (for ee word 1 1 1)
	ee_word <= ("1110" & tag_event(15 downto 11) & logic0_x9 & logic0 & tag_event(10 downto 0));
	
	--the select signal is the output of the FSM (sel_word)
	--insert a mux with two input: road from LAMB or EE_word
	mux_road <= int_add when sel_word='1' else ee_word;
	
	--register of the output road the clock enable signal is the output of FSM (rpush)
	register_road: process(clk, init)
	begin
		if(init = '1') then
			road_out <= (others => '0');
		elsif(clk'EVENT and clk = '1') then
			if(rpush='1') then
				road_out <= mux_road;
			end if;
		end if;
	end process;

	--signal of data strobe for the next board 
	data_stobe_proc: process(clk, init)
	begin
		if(init = '1') then
			wr_road <= '0';
		elsif(clk'EVENT and clk = '1') then
				wr_road <= rpush;
		end if;
	end process;
		
end road_flux_behavioral;

