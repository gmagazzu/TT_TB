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

entity x6_fifo_manager is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

-- Layer 0   

   l0_stub_in_dv : in std_logic_vector(11 downto 0);

   l0_stub_in_0 : in std_logic_vector(15 downto 0);
   l0_stub_in_1 : in std_logic_vector(15 downto 0);
   l0_stub_in_2 : in std_logic_vector(15 downto 0);
   l0_stub_in_3 : in std_logic_vector(15 downto 0);
   l0_stub_in_4 : in std_logic_vector(15 downto 0);
   l0_stub_in_5 : in std_logic_vector(15 downto 0);
   l0_stub_in_6 : in std_logic_vector(15 downto 0);
   l0_stub_in_7 : in std_logic_vector(15 downto 0);
   l0_stub_in_8 : in std_logic_vector(15 downto 0);
   l0_stub_in_9 : in std_logic_vector(15 downto 0);
   l0_stub_in_10 : in std_logic_vector(15 downto 0);
   l0_stub_in_11 : in std_logic_vector(15 downto 0);

   l0_stub_out_dv : out std_logic_vector(3 downto 0);

   l0_stub_out_0 : out std_logic_vector(16 downto 0);
   l0_stub_out_1 : out std_logic_vector(16 downto 0);
   l0_stub_out_2 : out std_logic_vector(16 downto 0);
   l0_stub_out_3 : out std_logic_vector(16 downto 0);

   l0_n_stub_in_dv : in std_logic;
   l0_n_stub_in_data : in std_logic_vector(15 downto 0);
   l0_p_stub_in_dv : in std_logic;
   l0_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l0_n_stub_out_dv : out std_logic;
   l0_n_stub_out_data : out std_logic_vector(15 downto 0);
   l0_p_stub_out_dv : out std_logic;
   l0_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 1   

   l1_stub_in_dv : in std_logic_vector(11 downto 0);

   l1_stub_in_0 : in std_logic_vector(15 downto 0);
   l1_stub_in_1 : in std_logic_vector(15 downto 0);
   l1_stub_in_2 : in std_logic_vector(15 downto 0);
   l1_stub_in_3 : in std_logic_vector(15 downto 0);
   l1_stub_in_4 : in std_logic_vector(15 downto 0);
   l1_stub_in_5 : in std_logic_vector(15 downto 0);
   l1_stub_in_6 : in std_logic_vector(15 downto 0);
   l1_stub_in_7 : in std_logic_vector(15 downto 0);
   l1_stub_in_8 : in std_logic_vector(15 downto 0);
   l1_stub_in_9 : in std_logic_vector(15 downto 0);
   l1_stub_in_10 : in std_logic_vector(15 downto 0);
   l1_stub_in_11 : in std_logic_vector(15 downto 0);

   l1_stub_out_dv : out std_logic_vector(3 downto 0);

   l1_stub_out_0 : out std_logic_vector(16 downto 0);
   l1_stub_out_1 : out std_logic_vector(16 downto 0);
   l1_stub_out_2 : out std_logic_vector(16 downto 0);
   l1_stub_out_3 : out std_logic_vector(16 downto 0);
   
   l1_n_stub_in_dv : in std_logic;
   l1_n_stub_in_data : in std_logic_vector(15 downto 0);
   l1_p_stub_in_dv : in std_logic;
   l1_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l1_n_stub_out_dv : out std_logic;
   l1_n_stub_out_data : out std_logic_vector(15 downto 0);
   l1_p_stub_out_dv : out std_logic;
   l1_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 2   

   l2_stub_in_dv : in std_logic_vector(11 downto 0);

   l2_stub_in_0 : in std_logic_vector(15 downto 0);
   l2_stub_in_1 : in std_logic_vector(15 downto 0);
   l2_stub_in_2 : in std_logic_vector(15 downto 0);
   l2_stub_in_3 : in std_logic_vector(15 downto 0);
   l2_stub_in_4 : in std_logic_vector(15 downto 0);
   l2_stub_in_5 : in std_logic_vector(15 downto 0);
   l2_stub_in_6 : in std_logic_vector(15 downto 0);
   l2_stub_in_7 : in std_logic_vector(15 downto 0);
   l2_stub_in_8 : in std_logic_vector(15 downto 0);
   l2_stub_in_9 : in std_logic_vector(15 downto 0);
   l2_stub_in_10 : in std_logic_vector(15 downto 0);
   l2_stub_in_11 : in std_logic_vector(15 downto 0);

   l2_stub_out_dv : out std_logic_vector(3 downto 0);

   l2_stub_out_0 : out std_logic_vector(16 downto 0);
   l2_stub_out_1 : out std_logic_vector(16 downto 0);
   l2_stub_out_2 : out std_logic_vector(16 downto 0);
   l2_stub_out_3 : out std_logic_vector(16 downto 0);
	
   l2_n_stub_in_dv : in std_logic;
   l2_n_stub_in_data : in std_logic_vector(15 downto 0);
   l2_p_stub_in_dv : in std_logic;
   l2_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l2_n_stub_out_dv : out std_logic;
   l2_n_stub_out_data : out std_logic_vector(15 downto 0);
   l2_p_stub_out_dv : out std_logic;
   l2_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 3   

   l3_stub_in_dv : in std_logic_vector(11 downto 0);

   l3_stub_in_0 : in std_logic_vector(15 downto 0);
   l3_stub_in_1 : in std_logic_vector(15 downto 0);
   l3_stub_in_2 : in std_logic_vector(15 downto 0);
   l3_stub_in_3 : in std_logic_vector(15 downto 0);
   l3_stub_in_4 : in std_logic_vector(15 downto 0);
   l3_stub_in_5 : in std_logic_vector(15 downto 0);
   l3_stub_in_6 : in std_logic_vector(15 downto 0);
   l3_stub_in_7 : in std_logic_vector(15 downto 0);
   l3_stub_in_8 : in std_logic_vector(15 downto 0);
   l3_stub_in_9 : in std_logic_vector(15 downto 0);
   l3_stub_in_10 : in std_logic_vector(15 downto 0);
   l3_stub_in_11 : in std_logic_vector(15 downto 0);

   l3_stub_out_dv : out std_logic_vector(3 downto 0);

   l3_stub_out_0 : out std_logic_vector(16 downto 0);
   l3_stub_out_1 : out std_logic_vector(16 downto 0);
   l3_stub_out_2 : out std_logic_vector(16 downto 0);
   l3_stub_out_3 : out std_logic_vector(16 downto 0);
	
   l3_n_stub_in_dv : in std_logic;
   l3_n_stub_in_data : in std_logic_vector(15 downto 0);
   l3_p_stub_in_dv : in std_logic;
   l3_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l3_n_stub_out_dv : out std_logic;
   l3_n_stub_out_data : out std_logic_vector(15 downto 0);
   l3_p_stub_out_dv : out std_logic;
   l3_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 4   

   l4_stub_in_dv : in std_logic_vector(11 downto 0);

   l4_stub_in_0 : in std_logic_vector(15 downto 0);
   l4_stub_in_1 : in std_logic_vector(15 downto 0);
   l4_stub_in_2 : in std_logic_vector(15 downto 0);
   l4_stub_in_3 : in std_logic_vector(15 downto 0);
   l4_stub_in_4 : in std_logic_vector(15 downto 0);
   l4_stub_in_5 : in std_logic_vector(15 downto 0);
   l4_stub_in_6 : in std_logic_vector(15 downto 0);
   l4_stub_in_7 : in std_logic_vector(15 downto 0);
   l4_stub_in_8 : in std_logic_vector(15 downto 0);
   l4_stub_in_9 : in std_logic_vector(15 downto 0);
   l4_stub_in_10 : in std_logic_vector(15 downto 0);
   l4_stub_in_11 : in std_logic_vector(15 downto 0);

   l4_stub_out_dv : out std_logic_vector(3 downto 0);

   l4_stub_out_0 : out std_logic_vector(16 downto 0);
   l4_stub_out_1 : out std_logic_vector(16 downto 0);
   l4_stub_out_2 : out std_logic_vector(16 downto 0);
   l4_stub_out_3 : out std_logic_vector(16 downto 0);
	
   l4_n_stub_in_dv : in std_logic;
   l4_n_stub_in_data : in std_logic_vector(15 downto 0);
   l4_p_stub_in_dv : in std_logic;
   l4_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l4_n_stub_out_dv : out std_logic;
   l4_n_stub_out_data : out std_logic_vector(15 downto 0);
   l4_p_stub_out_dv : out std_logic;
   l4_p_stub_out_data : out std_logic_vector(15 downto 0);
  
-- Layer 5   

   l5_stub_in_dv : in std_logic_vector(11 downto 0);

   l5_stub_in_0 : in std_logic_vector(15 downto 0);
   l5_stub_in_1 : in std_logic_vector(15 downto 0);
   l5_stub_in_2 : in std_logic_vector(15 downto 0);
   l5_stub_in_3 : in std_logic_vector(15 downto 0);
   l5_stub_in_4 : in std_logic_vector(15 downto 0);
   l5_stub_in_5 : in std_logic_vector(15 downto 0);
   l5_stub_in_6 : in std_logic_vector(15 downto 0);
   l5_stub_in_7 : in std_logic_vector(15 downto 0);
   l5_stub_in_8 : in std_logic_vector(15 downto 0);
   l5_stub_in_9 : in std_logic_vector(15 downto 0);
   l5_stub_in_10 : in std_logic_vector(15 downto 0);
   l5_stub_in_11 : in std_logic_vector(15 downto 0);

   l5_stub_out_dv : out std_logic_vector(3 downto 0);

   l5_stub_out_0 : out std_logic_vector(16 downto 0);
   l5_stub_out_1 : out std_logic_vector(16 downto 0);
   l5_stub_out_2 : out std_logic_vector(16 downto 0);
   l5_stub_out_3 : out std_logic_vector(16 downto 0);

   l5_n_stub_in_dv : in std_logic;
   l5_n_stub_in_data : in std_logic_vector(15 downto 0);
   l5_p_stub_in_dv : in std_logic;
   l5_p_stub_in_data : in std_logic_vector(15 downto 0);
  
   l5_n_stub_out_dv : out std_logic;
   l5_n_stub_out_data : out std_logic_vector(15 downto 0);
   l5_p_stub_out_dv : out std_logic;
   l5_p_stub_out_data : out std_logic_vector(15 downto 0)
  	
	);

end x6_fifo_manager;

architecture x6_fifo_manager_architecture of x6_fifo_manager is

component fifo_manager is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   x6_stub_in_dv : in std_logic;
   
   n_stub_in_dv : in std_logic;

   n_stub_in : in std_logic_vector(15 downto 0);

   p_stub_in_dv : in std_logic;

   p_stub_in : in std_logic_vector(15 downto 0);

   stub_in_dv : in std_logic_vector(11 downto 0);

   stub_in_0 : in std_logic_vector(15 downto 0);
   stub_in_1 : in std_logic_vector(15 downto 0);
   stub_in_2 : in std_logic_vector(15 downto 0);
   stub_in_3 : in std_logic_vector(15 downto 0);
   stub_in_4 : in std_logic_vector(15 downto 0);
   stub_in_5 : in std_logic_vector(15 downto 0);
   stub_in_6 : in std_logic_vector(15 downto 0);
   stub_in_7 : in std_logic_vector(15 downto 0);
   stub_in_8 : in std_logic_vector(15 downto 0);
   stub_in_9 : in std_logic_vector(15 downto 0);
   stub_in_10 : in std_logic_vector(15 downto 0);
   stub_in_11 : in std_logic_vector(15 downto 0);

   stub_out_dv : out std_logic_vector(3 downto 0);

   stub_out_0 : out std_logic_vector(16 downto 0);
   stub_out_1 : out std_logic_vector(16 downto 0);
   stub_out_2 : out std_logic_vector(16 downto 0);
   stub_out_3 : out std_logic_vector(16 downto 0)
	
	);

end component;

constant NL : integer := 6;

type do_stub_data_vector is array (11 downto 0) of std_logic_vector(15 downto 0);
type do_stub_data_array is array (NL-1 downto 0) of do_stub_data_vector;
signal do_stub_data : do_stub_data_array;

type do_stub_dv_array is array (NL-1 downto 0) of std_logic_vector(11 downto 0);
signal do_stub_dv : do_stub_dv_array;

type fm_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(16 downto 0);
type fm_stub_data_array is array (3 downto 0) of fm_stub_data_vector;
signal fm_stub_data : fm_stub_data_array;

type fm_stub_dv_array is array (NL-1 downto 0) of std_logic_vector(3 downto 0);
signal fm_stub_dv : fm_stub_dv_array;

signal x6_stub_dv : std_logic;

type np_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(15 downto 0);
signal n_stub_in_data, n_stub_out_data : np_stub_data_vector;
signal p_stub_in_data, p_stub_out_data : np_stub_data_vector;

signal n_stub_in_dv, n_stub_out_dv : std_logic_vector(NL-1 downto 0);
signal p_stub_in_dv, p_stub_out_dv : std_logic_vector(NL-1 downto 0);

begin

  x6_np_stub_proc : process (do_stub_dv)

  begin

      for I in 0 to 5 loop
        for J in 0 to 11 loop
          if (do_stub_dv(I)(J) = '1') and (do_stub_data(I)(J)(7 downto 0) = "11111111") then
            n_stub_out_dv(I) <= '1';
            n_stub_out_data(I) <= do_stub_data(I)(J);
          else
            n_stub_out_dv(I) <= '0';
            n_stub_out_data(I) <= (others => '0');
         end if;
          if (do_stub_dv(I)(J) = '1') and (do_stub_data(I)(J)(7 downto 0) = "00000000") then
            p_stub_out_dv(I) <= '1';
            p_stub_out_data(I) <= do_stub_data(I)(J);
          else
            p_stub_out_dv(I) <= '0';
            p_stub_out_data(I) <= (others => '0');
         end if;
      end loop;
  end loop;
  
  end process;

  l0_n_stub_out_dv <= n_stub_out_dv(0);
  l0_n_stub_out_data <= n_stub_out_data(0);
  l0_p_stub_out_dv <= p_stub_out_dv(0);
  l0_p_stub_out_data <= p_stub_out_data(0);
  
  l1_n_stub_out_dv <= n_stub_out_dv(1);
  l1_n_stub_out_data <= n_stub_out_data(1);
  l1_p_stub_out_dv <= p_stub_out_dv(1);
  l1_p_stub_out_data <= p_stub_out_data(1);
  
  l2_n_stub_out_dv <= n_stub_out_dv(2);
  l2_n_stub_out_data <= n_stub_out_data(2);
  l2_p_stub_out_dv <= p_stub_out_dv(2);
  l2_p_stub_out_data <= p_stub_out_data(2);
  
  l3_n_stub_out_dv <= n_stub_out_dv(3);
  l3_n_stub_out_data <= n_stub_out_data(3);
  l3_p_stub_out_dv <= p_stub_out_dv(3);
  l3_p_stub_out_data <= p_stub_out_data(3);
  
  l4_n_stub_out_dv <= n_stub_out_dv(4);
  l4_n_stub_out_data <= n_stub_out_data(4);
  l4_p_stub_out_dv <= p_stub_out_dv(4);
  l4_p_stub_out_data <= p_stub_out_data(4);
  
  l5_n_stub_out_dv <= n_stub_out_dv(5);
  l5_n_stub_out_data <= n_stub_out_data(5);
  l5_p_stub_out_dv <= p_stub_out_dv(5);
  l5_p_stub_out_data <= p_stub_out_data(5);
  
  x6_stub_dv_proc : process (do_stub_dv)

  begin

        if (do_stub_dv(0) = "000000000000") and (do_stub_dv(1) = "000000000000") 
           and (do_stub_dv(2) = "000000000000") and (do_stub_dv(3) = "000000000000") 
           and (do_stub_dv(4) = "000000000000") and (do_stub_dv(5) = "000000000000") then
          x6_stub_dv <= '0';
        else
          x6_stub_dv <= '1';
         end if;
 
  end process;

  do_stub_dv(0) <= l0_stub_in_dv;
  
  do_stub_data(0)(0) <= l0_stub_in_0;
  do_stub_data(0)(1) <= l0_stub_in_1;
  do_stub_data(0)(2) <= l0_stub_in_2;
  do_stub_data(0)(3) <= l0_stub_in_3;
  do_stub_data(0)(4) <= l0_stub_in_4;
  do_stub_data(0)(5) <= l0_stub_in_5;
  do_stub_data(0)(6) <= l0_stub_in_6;
  do_stub_data(0)(7) <= l0_stub_in_7;
  do_stub_data(0)(8) <= l0_stub_in_8;
  do_stub_data(0)(9) <= l0_stub_in_9;
  do_stub_data(0)(10) <= l0_stub_in_10;
  do_stub_data(0)(11) <= l0_stub_in_11;

  n_stub_in_dv(0) <= l0_n_stub_in_dv;
  n_stub_in_data(0) <= l0_n_stub_in_data;
  p_stub_in_dv(0) <= l0_p_stub_in_dv;
  p_stub_in_data(0) <= l0_p_stub_in_data;
  
  do_stub_dv(1) <= l1_stub_in_dv;
  
  do_stub_data(1)(0) <= l1_stub_in_0;
  do_stub_data(1)(1) <= l1_stub_in_1;
  do_stub_data(1)(2) <= l1_stub_in_2;
  do_stub_data(1)(3) <= l1_stub_in_3;
  do_stub_data(1)(4) <= l1_stub_in_4;
  do_stub_data(1)(5) <= l1_stub_in_5;
  do_stub_data(1)(6) <= l1_stub_in_6;
  do_stub_data(1)(7) <= l1_stub_in_7;
  do_stub_data(1)(8) <= l1_stub_in_8;
  do_stub_data(1)(9) <= l1_stub_in_9;
  do_stub_data(1)(10) <= l1_stub_in_10;
  do_stub_data(1)(11) <= l1_stub_in_11;

  n_stub_in_dv(1) <= l1_n_stub_in_dv;
  n_stub_in_data(1) <= l1_n_stub_in_data;
  p_stub_in_dv(1) <= l1_p_stub_in_dv;
  p_stub_in_data(1) <= l1_p_stub_in_data;
  
  do_stub_dv(2) <= l2_stub_in_dv;
  
  do_stub_data(2)(0) <= l2_stub_in_0;
  do_stub_data(2)(1) <= l2_stub_in_1;
  do_stub_data(2)(2) <= l2_stub_in_2;
  do_stub_data(2)(3) <= l2_stub_in_3;
  do_stub_data(2)(4) <= l2_stub_in_4;
  do_stub_data(2)(5) <= l2_stub_in_5;
  do_stub_data(2)(6) <= l2_stub_in_6;
  do_stub_data(2)(7) <= l2_stub_in_7;
  do_stub_data(2)(8) <= l2_stub_in_8;
  do_stub_data(2)(9) <= l2_stub_in_9;
  do_stub_data(2)(10) <= l2_stub_in_10;
  do_stub_data(2)(11) <= l2_stub_in_11;

  n_stub_in_dv(2) <= l2_n_stub_in_dv;
  n_stub_in_data(2) <= l2_n_stub_in_data;
  p_stub_in_dv(2) <= l2_p_stub_in_dv;
  p_stub_in_data(2) <= l2_p_stub_in_data;
  
  do_stub_dv(3) <= l3_stub_in_dv;
  
  do_stub_data(3)(0) <= l3_stub_in_0;
  do_stub_data(3)(1) <= l3_stub_in_1;
  do_stub_data(3)(2) <= l3_stub_in_2;
  do_stub_data(3)(3) <= l3_stub_in_3;
  do_stub_data(3)(4) <= l3_stub_in_4;
  do_stub_data(3)(5) <= l3_stub_in_5;
  do_stub_data(3)(6) <= l3_stub_in_6;
  do_stub_data(3)(7) <= l3_stub_in_7;
  do_stub_data(3)(8) <= l3_stub_in_8;
  do_stub_data(3)(9) <= l3_stub_in_9;
  do_stub_data(3)(10) <= l3_stub_in_10;
  do_stub_data(3)(11) <= l3_stub_in_11;

  n_stub_in_dv(3) <= l3_n_stub_in_dv;
  n_stub_in_data(3) <= l3_n_stub_in_data;
  p_stub_in_dv(3) <= l3_p_stub_in_dv;
  p_stub_in_data(3) <= l3_p_stub_in_data;
  
  do_stub_dv(4) <= l4_stub_in_dv;
  
  do_stub_data(4)(0) <= l4_stub_in_0;
  do_stub_data(4)(1) <= l4_stub_in_1;
  do_stub_data(4)(2) <= l4_stub_in_2;
  do_stub_data(4)(3) <= l4_stub_in_3;
  do_stub_data(4)(4) <= l4_stub_in_4;
  do_stub_data(4)(5) <= l4_stub_in_5;
  do_stub_data(4)(6) <= l4_stub_in_6;
  do_stub_data(4)(7) <= l4_stub_in_7;
  do_stub_data(4)(8) <= l4_stub_in_8;
  do_stub_data(4)(9) <= l4_stub_in_9;
  do_stub_data(4)(10) <= l4_stub_in_10;
  do_stub_data(4)(11) <= l4_stub_in_11;

  n_stub_in_dv(4) <= l4_n_stub_in_dv;
  n_stub_in_data(4) <= l4_n_stub_in_data;
  p_stub_in_dv(4) <= l4_p_stub_in_dv;
  p_stub_in_data(4) <= l4_p_stub_in_data;
  
  do_stub_dv(5) <= l5_stub_in_dv;
  
  do_stub_data(5)(0) <= l5_stub_in_0;
  do_stub_data(5)(1) <= l5_stub_in_1;
  do_stub_data(5)(2) <= l5_stub_in_2;
  do_stub_data(5)(3) <= l5_stub_in_3;
  do_stub_data(5)(4) <= l5_stub_in_4;
  do_stub_data(5)(5) <= l5_stub_in_5;
  do_stub_data(5)(6) <= l5_stub_in_6;
  do_stub_data(5)(7) <= l5_stub_in_7;
  do_stub_data(5)(8) <= l5_stub_in_8;
  do_stub_data(5)(9) <= l5_stub_in_9;
  do_stub_data(5)(10) <= l5_stub_in_10;
  do_stub_data(5)(11) <= l5_stub_in_11;

  n_stub_in_dv(5) <= l5_n_stub_in_dv;
  n_stub_in_data(5) <= l5_n_stub_in_data;
  p_stub_in_dv(5) <= l5_p_stub_in_dv;
  p_stub_in_data(5) <= l5_p_stub_in_data;
  
  GEN_FM_FPGA : for I in 5 downto 0 generate
  begin

  FM_M : fifo_manager
    port map(

      clk => clk,
      rst => rst,

      x6_stub_in_dv => x6_stub_dv,

      n_stub_in_dv => n_stub_in_dv(I),

      n_stub_in => n_stub_in_data(I),

      p_stub_in_dv => p_stub_in_dv(I),

      p_stub_in => p_stub_in_data(I),

      stub_in_dv => do_stub_dv(I),
      stub_in_0 => do_stub_data(I)(0),
      stub_in_1 => do_stub_data(I)(1),
      stub_in_2 => do_stub_data(I)(2),
      stub_in_3 => do_stub_data(I)(3),
      stub_in_4 => do_stub_data(I)(4),
      stub_in_5 => do_stub_data(I)(5),
      stub_in_6 => do_stub_data(I)(6),
      stub_in_7 => do_stub_data(I)(7),
      stub_in_8 => do_stub_data(I)(8),
      stub_in_9 => do_stub_data(I)(9),
      stub_in_10 => do_stub_data(I)(10),
      stub_in_11 => do_stub_data(I)(11),
      stub_out_dv => fm_stub_dv(I),
      stub_out_0 => fm_stub_data(0)(I),
      stub_out_1 => fm_stub_data(1)(I),
      stub_out_2 => fm_stub_data(2)(I),
      stub_out_3 => fm_stub_data(3)(I));
	
  end generate GEN_FM_FPGA;

  l0_stub_out_dv <= fm_stub_dv(0);
  
  l0_stub_out_0 <= fm_stub_data(0)(0);
  l0_stub_out_1 <= fm_stub_data(1)(0);
  l0_stub_out_2 <= fm_stub_data(2)(0);
  l0_stub_out_3 <= fm_stub_data(3)(0);
	
  l1_stub_out_dv <= fm_stub_dv(1);
  
  l1_stub_out_0 <= fm_stub_data(0)(1);
  l1_stub_out_1 <= fm_stub_data(1)(1);
  l1_stub_out_2 <= fm_stub_data(2)(1);
  l1_stub_out_3 <= fm_stub_data(3)(1);
	
  l2_stub_out_dv <= fm_stub_dv(2);
  
  l2_stub_out_0 <= fm_stub_data(0)(2);
  l2_stub_out_1 <= fm_stub_data(1)(2);
  l2_stub_out_2 <= fm_stub_data(2)(2);
  l2_stub_out_3 <= fm_stub_data(3)(2);
	
  l3_stub_out_dv <= fm_stub_dv(3);
  
  l3_stub_out_0 <= fm_stub_data(0)(3);
  l3_stub_out_1 <= fm_stub_data(1)(3);
  l3_stub_out_2 <= fm_stub_data(2)(3);
  l3_stub_out_3 <= fm_stub_data(3)(3);
	
  l4_stub_out_dv <= fm_stub_dv(4);
  
  l4_stub_out_0 <= fm_stub_data(0)(4);
  l4_stub_out_1 <= fm_stub_data(1)(4);
  l4_stub_out_2 <= fm_stub_data(2)(4);
  l4_stub_out_3 <= fm_stub_data(3)(4);
	
  l5_stub_out_dv <= fm_stub_dv(5);
  
  l5_stub_out_0 <= fm_stub_data(0)(5);
  l5_stub_out_1 <= fm_stub_data(1)(5);
  l5_stub_out_2 <= fm_stub_data(2)(5);
  l5_stub_out_3 <= fm_stub_data(3)(5);
	
end x6_fifo_manager_architecture;
