----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Daniel Magalotti
-- 
-- Create Date:    16:37:53 11/10/2010 
-- Design Name: 
-- Module Name:    sync_module - sync_Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: The module control alignment and synchronization of the event in input.
--					 When there is an end event in input it storage the tag number of the event
--					 and compare this number with each tag number of event of all layer.
--              If the number is not equal it set a flag of error.
--					 If there are a number of consecutive error it set a flag of critical error.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Supervise: Marco Piendibene
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--MODULO LO INSERIAMO SIA DA VME CHE DA P3 DOPO IL MUX CHE SEGLIE I DUE FLUSSI
entity sync_module is
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
end sync_module;

architecture sync_Behavioral of sync_module is
		
	--instantiate the Comparator whit register
	component COMPARATOR is
		port(	clk : 		in STD_LOGIC;
				reset : 		in STD_LOGIC;
				enable : 	in STD_LOGIC;
				D1 :			in STD_LOGIC_VECTOR (7 downto 0);
				D2 :			in STD_LOGIC_VECTOR (7 downto 0);
				
				match :		out STD_LOGIC
			  );
	end component COMPARATOR;
	
	--bit of enable the register after the comparator
	signal en_comp: STD_LOGIC_VECTOR (5 downto 0); 
	
	--event number of the first end event hit in input is condidered as reference
	signal ref_event: STD_LOGIC_VECTOR (7 downto 0);
	
	--number event of each hit
	signal number_event0: STD_LOGIC_VECTOR (7 downto 0);
	signal number_event1: STD_LOGIC_VECTOR (7 downto 0);
	signal number_event2: STD_LOGIC_VECTOR (7 downto 0);
	signal number_event3: STD_LOGIC_VECTOR (7 downto 0);
	signal number_event4: STD_LOGIC_VECTOR (7 downto 0);
	signal number_event5: STD_LOGIC_VECTOR (7 downto 0);
	
	--match is the out signal of comparator that is active when there is a match with
	--the number of hit and the refernce number
	signal match: STD_LOGIC_VECTOR (5 downto 0);
	
	--all match 
	signal all_match: STD_LOGIC;
	
	--signal that enable the comparison of all match to create the error flag
	signal en_match: STD_LOGIC;
	signal en_match_d1: STD_LOGIC;
	signal en_match_d2: STD_LOGIC;
	signal en_match_d3: STD_LOGIC;
	signal en_match_d4: STD_LOGIC;
	signal en_match_pulse: STD_LOGIC;
	
	--constant of the counter the indentify the consecutive flag of error
	--that active the critical error
	constant COUNTER_MAX: integer:= 2#101#;
	signal count: STD_LOGIC_VECTOR (2 downto 0);
	
	--signal that enable the counter of consecutive error flag
	signal en_counter_match: STD_LOGIC;
	
begin
	
	--enable the start match if there is all ee on all layer input
	en_match <= en_comp(5) and en_comp(4) and en_comp(3) 
								   and en_comp(2) and en_comp(1) and en_comp(0);
	
	--delay of the enable match 
	delay_process: process(clk)
	begin
		if(clk'event and clk='1') then
			en_match_d1 <= en_match;
			en_match_d2 <= en_match_d1;
			en_match_d3 <= en_match_d2;
			en_match_d4 <= en_match_d3;
		end if;
	end process;
	
	--enable pulse for control the match
	en_match_pulse <= (not en_match_d2) and en_match_d1;
	--enable pulse for decrease the counter
	en_counter_match <= (not en_match_d4) and en_match_d3;
	

	--assign the bit of tag [14:0] of the layer 0 to the reference number  
	ref_event <= lay0(7 downto 0);
	number_event0 <= lay0(7 downto 0);
	--create the enable of comparator delayed of a cycle of clock
	en_comp(0) <= lay0(16);
	
	number_event1 <= lay1(7 downto 0);
	en_comp(1) <= lay1(16);
															 
	number_event2 <= lay2(7 downto 0);
	en_comp(2) <= lay2(16);

	number_event3 <= lay3(7 downto 0);
	en_comp(3) <= lay3(16); 
	
	number_event4 <= lay4(7 downto 0);
	en_comp(4) <= lay4(16);	
	
	number_event5 <= lay5(7 downto 0);
	en_comp(5) <= lay5(16);	
	
	--create the comparator to compare the reference number of event with all event number on each layer
	--the bit of ee register enable the register before the comparator
	compare_hit_0: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(0),
																	D1 => ref_event,
																	D2 => number_event0,
																	match => match(0)
																);
																
	compare_hit_1: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(1),
																	D1 => ref_event,
																	D2 => number_event1,
																	match => match(1)
																);

	compare_hit_2: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(2),
																	D1 => ref_event,
																	D2 => number_event2,
																	match => match(2)
																);

	compare_hit_3: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(3),
																	D1 => ref_event,
																	D2 => number_event3,
																	match => match(3)
																);

	compare_hit_4: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(4),
																	D1 => ref_event,
																	D2 => number_event4,
																	match => match(4)
																);

	compare_hit_5: component COMPARATOR port map (	clk => clk,
																	reset => init_ev,
																	enable => en_comp(5),
																	D1 => ref_event,
																	D2 => number_event5,
																	match => match(5)
																);
																
	
	all_match <= (match(5) and match(4) and match(3) 
								  and match(2) and match(1) and match(0));
	--genarate the flag of error to ANDed the match in each layer
	--when there is the enable match pulse
	err_process: process(clk, init)
	begin
		if (init = '1') then
			err_flag <= '0';
		elsif(clk'event and clk='1') then
			if(en_match_pulse='1') then
				err_flag <= not (all_match);
			end if;
		end if;
	end process err_process;

	--create the counter to generate the flag of critical error
	counter_flag: process(clk, init)
	begin
		if(init='1') then
			count <= conv_std_logic_vector(COUNTER_MAX,3);
			err_critical <= '0';
		elsif(clk'event and clk='1') then
			if(en_counter_match='1' and err_flag='1' and count = 1) then
				err_critical <= '1';
			elsif(en_counter_match='1' and err_flag='1') then
				count <= count - 1;
			elsif(en_counter_match='1') then
				count <= conv_std_logic_vector(COUNTER_MAX,3);
			end if;
		end if;
	end process;
	
end sync_Behavioral;

