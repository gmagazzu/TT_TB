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
   en_wr : in std_logic_vector(5 downto 0);
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
constant NP : integer := 64;
constant NB : integer := 18;
constant NR : integer := 17;

constant ONE : std_logic_vector(NB-1 downto 0) := "000000000000000001";

type pattern is array (NL-1 downto 0) of std_logic_vector(NB-1 downto 0);
type pattern_array is array (NP-1 downto 0) of pattern;
signal input_pattern : pattern;
signal am : pattern_array;

type match_array is array (NP-1 downto 0) of std_logic_vector(NL-1 downto 0);
signal match : match_array;

type state_type is (IDLE,RX_HIT,LD_ROAD,TX_WAIT,TX_ROAD);

signal next_state, current_state : state_type;

signal  scan_array, road_ld, road_tx, end_of_scan, output_reg_init, output_reg_init_d1 : std_logic;

signal current_pattern : integer := 0;

-- signal temp_dr_b : std_logic;
-- signal temp_ladd : std_logic_vector(20 downto 0);

signal pipe_dr_b : std_logic_vector(NR+7 downto 0);

type ladd_array8 is array (7 downto 0) of std_logic_vector(20 downto 0);
signal temp_ladd : ladd_array8;

signal temp_dr_b : std_logic_vector(7 downto 0);

type ladd_array is array (NR+7 downto 0) of std_logic_vector(20 downto 0);
signal pipe_ladd : ladd_array;

begin

pattern_gen_proc: process (rst,am)

begin

--  if (rst = '1') then
--    for J in 0 to NL-1 loop
--      am(0)(J) <= ONE;
--      for I in 1 to NP-1 loop
--        am(I)(J)(NB-1 downto 0) <= am(I-1)(J)(NB-2 downto 0) & '0';
--      end loop;
--    end loop;
--  end if;  

  if (rst = '1') then
    for J in 0 to NL-1 loop
      for I in 0 to NP-1 loop
        am(I)(J) <= std_logic_vector(to_unsigned(I, 18));
      end loop;
    end loop;
  end if;  

end process;

  

input_pattern_proc: process (l0_hit,l1_hit,l2_hit,l3_hit,l4_hit,l5_hit)

begin

  input_pattern(0) <= l0_hit;
  input_pattern(1) <= l1_hit;
  input_pattern(2) <= l2_hit;
  input_pattern(3) <= l3_hit;
  input_pattern(4) <= l4_hit;
  input_pattern(5) <= l5_hit;

end process;

match_logic_proc: process (input_pattern,en_wr,am,rst,clk)

begin

  for J in 0 to NL-1 loop
    for I in 0 to NP-1 loop
      if (rst = '1') then 
        match(I)(J) <= '0';
--      elsif(en_wr(J) = '1') and (am(I)(J) =  input_pattern(J)) then 
        elsif rising_edge(clk) and (en_wr(J) = '1') and (am(I)(J) =  input_pattern(J)) then 
        match(I)(J) <= '1';
      end if;
    end loop;
  end loop;

end process;

ori_reg : process (output_reg_init, rst, clk)

  begin
    if (rst = '1') then
      output_reg_init_d1 <= '1';
    elsif rising_edge(clk) then
      output_reg_init_d1 <= output_reg_init;
    end if;

end process;

fsm_state_regs : process (next_state, init_ev, rst, clk)

  begin
    if (rst = '1') then
      current_state <= IDLE;
    elsif rising_edge(clk) then
      if (init_ev = "111") then
        current_state <= IDLE;
      else  
        current_state <= next_state;
      end if;
    end if;

end process;

fsm_comb_logic : process(current_state,en_wr,pipe_dr_b)

  begin
    
    case current_state is

      when IDLE =>
        scan_array <= '0'; 
        road_ld <= '0'; 
        road_tx <= '0'; 
        output_reg_init <= '0'; 
        if (en_wr = "000000") then
          next_state <= IDLE;
        else
          next_state <= RX_HIT;
        end if;

      when RX_HIT =>
        road_ld <= '0'; 
        road_tx <= '0'; 
        output_reg_init <= '0'; 
        if (en_wr = "000000") then
          scan_array <= '1'; 
          next_state <= LD_ROAD;
        else
          scan_array <= '0'; 
          next_state <= RX_HIT;
        end if;

      when LD_ROAD =>
        scan_array <= '0'; 
        road_ld <= '1'; 
        road_tx <= '0'; 
        output_reg_init <= '1'; 
        next_state <= TX_WAIT;

      when TX_WAIT =>
        scan_array <= '0'; 
        road_ld <= '0'; 
        road_tx <= '1'; 
        output_reg_init <= '0'; 
        if (pipe_dr_b(1) = '0') then
          next_state <= TX_ROAD;
        else
          next_state <= TX_WAIT;
        end if;

      when TX_ROAD =>
        scan_array <= '0'; 
        road_ld <= '0'; 
        road_tx <= '1'; 
        if (pipe_dr_b(1) = '1') then
          output_reg_init <= '1'; 
          next_state <= IDLE;
        else
          output_reg_init <= '0'; 
          next_state <= TX_ROAD;
        end if;

      when others =>
        scan_array <= '0'; 
        road_ld <= '1'; 
        road_tx <= '0'; 
        output_reg_init <= '0'; 
        next_state <= IDLE;

    end case;
    
  end process;

output_reg_proc: process (clk,init_ev,output_reg_init_d1,scan_array)

variable current_road : integer;

begin

--	if (rising_edge(clk)) then
--	  if (init_ev = "111") or (output_reg_init_d1 = '1') then
--      end_of_scan <= '0';
--      temp_dr_b <= '1';
--      temp_ladd <= (others => '0');
--	    current_pattern <= 0;
--	  end if;
--	  if (scan_array = '1') then
--      for I in current_pattern to NP-1 loop
--        if (match(I) = "111111") then
--          temp_dr_b <= '0';
--          temp_ladd <= std_logic_vector(to_unsigned(current_pattern, 21));
--          current_pattern <= I;
--        end if;
--        if (I = NP-1) then
--          end_of_scan <= '1';
--        end if;  
--      end loop;
--	  end if;
--	end if;

	if (rising_edge(clk)) then
	  if (init_ev = "111") or (output_reg_init_d1 = '1') then
      for I in 0 to 7 loop
        temp_dr_b(I) <= '1';
        temp_ladd(I) <= (others => '0');
      end loop;
	    current_road := 0;
	  end if;
	  if (scan_array = '1') then
      for I in 0 to NP-1 loop
        if (match(I) = "111111") then
          temp_dr_b(current_road) <= '0';
          temp_ladd(current_road) <= std_logic_vector(to_unsigned(I, 21));
          current_road := current_road + 1;
        end if;
      end loop;
	  end if;
	end if;

end process;

output_pipeline: process (clk,temp_ladd,temp_dr_b,init_ev,road_ld,road_tx)

begin

	if (rising_edge(clk)) then
	  if (init_ev = "111") then
      for I in 0 to NR+7 loop
        pipe_dr_b(I) <= '1';
        pipe_ladd(I) <= (others => '0');
      end loop;
    elsif (road_ld = '1') then
      for I in 0 to 7 loop
        pipe_dr_b(I+NR) <= temp_dr_b(I);
        pipe_ladd(I+NR) <= temp_ladd(I);
      end loop;
	  elsif (road_tx = '1') then  
      for I in NR+7 downto 1 loop
        pipe_dr_b(I-1) <= pipe_dr_b(I);
        pipe_ladd(I-1) <= pipe_ladd(I);
      end loop;
	  end if;
	end if;

end process;

dr_b <= pipe_dr_b(0);
ladd <= pipe_ladd(0);

		
end AM_chip_architecture;
