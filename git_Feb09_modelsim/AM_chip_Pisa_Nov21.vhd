library unisim;
library unimacro;
library hdlmacro;
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;
use unimacro.vcomponents.all;
use hdlmacro.hdlmacro.all;

entity AM_chip is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   l0_hit : in std_logic_vector(17 downto 0);
   l1_hit : in std_logic_vector(17 downto 0);
   l2_hit : in std_logic_vector(17 downto 0);
   l3_hit : in std_logic_vector(17 downto 0);
   l4_hit : in std_logic_vector(17 downto 0);
   l5_hit : in std_logic_vector(17 downto 0);
   en_wr : in std_logic;
   init_ev : in std_logic_vector(2 downto 0);
   sel_b : in std_logic;
   opcode : in std_logic_vector(3 downto 0);
   tck : in std_logic;
   dr_b : out std_logic;
	 ladd : out std_logic_vector(20 downto 0)
	
	);

end AM_chip;

architecture AM_chip_architecture of AM_chip is

constant NL : integer := 6;
constant NP : integer := 18;
constant NB : integer := 18;
constant NR : integer := 18;

constant ONE : std_logic_vector(NB-1 downto 0) := "000000000000000001";

type pattern is array (NL-1 downto 0) of std_logic_vector(NB-1 downto 0);
type pattern_array is array (NP-1 downto 0) of pattern;
signal input_pattern : pattern;
signal am : pattern_array;

signal add : integer;

type int_pipeline is array (NR downto 0) of integer;
signal padd : int_pipeline;

begin

pattern_gen_proc: process (rst)

begin

  if (rst = '1') then
    for I in 0 to NP-1 loop
      am(I)(0) <= ONE;
      for J in 1 to NL-1 loop
        am(I)(J)(NB-1 downto 0) <= am(I)(J-1)(NB-1 downto 1) & '0';
      end loop;
    end loop;
  end if;  
end process;

input_reg_proc: process (clk,en_wr,l0_hit,l1_hit,l2_hit,l3_hit,l4_hit,l5_hit)

begin

	if (rising_edge(clk)) then
    if (en_wr = '1') then
      input_pattern(0) <= l0_hit;
      input_pattern(1) <= l1_hit;
      input_pattern(2) <= l2_hit;
      input_pattern(3) <= l3_hit;
      input_pattern(4) <= l4_hit;
      input_pattern(5) <= l5_hit;
    end if;  
  end if;  

end process;

match_logic_proc: process (rst)

begin

  for I in 0 to NP-1 loop
    if (input_pattern = am(I)) then add <= I;
    end if;
  end loop;

end process;

output_reg_proc: process (clk,add)

begin

	if (rising_edge(clk)) then
      padd(0) <= add;
  end if;  
  for I in 1 to NR loop
	if (rising_edge(clk)) then
      padd(I) <= padd(I-1);
  end if;  
  end loop;
  ladd <= std_logic_vector(to_unsigned(padd(NR), 21));
end process;

		
end AM_chip_architecture;
