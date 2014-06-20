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

entity x6_mpa_data_organizer is
  generic (
    NL : integer range 1 to 8 := 6
    );  
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

-- Jan 4
	 phi : in std_logic_vector(3 downto 0);
	 z : in std_logic_vector(3 downto 0);

	 l0_fe_data : in std_logic_vector(31 downto 0);

   l0_stub_dv  : out std_logic_vector(9 downto 0);

   l0_stub_d00 : out std_logic_vector(15 downto 0);
   l0_stub_d01 : out std_logic_vector(15 downto 0);
   l0_stub_d02 : out std_logic_vector(15 downto 0);
   l0_stub_d03 : out std_logic_vector(15 downto 0);
   l0_stub_d04 : out std_logic_vector(15 downto 0);
   l0_stub_d05 : out std_logic_vector(15 downto 0);
   l0_stub_d06 : out std_logic_vector(15 downto 0);
   l0_stub_d07 : out std_logic_vector(15 downto 0);
   l0_stub_d08 : out std_logic_vector(15 downto 0);
   l0_stub_d09 : out std_logic_vector(15 downto 0);
   
	 l1_fe_data : in std_logic_vector(31 downto 0);

   l1_stub_dv  : out std_logic_vector(9 downto 0);

   l1_stub_d00 : out std_logic_vector(15 downto 0);
   l1_stub_d01 : out std_logic_vector(15 downto 0);
   l1_stub_d02 : out std_logic_vector(15 downto 0);
   l1_stub_d03 : out std_logic_vector(15 downto 0);
   l1_stub_d04 : out std_logic_vector(15 downto 0);
   l1_stub_d05 : out std_logic_vector(15 downto 0);
   l1_stub_d06 : out std_logic_vector(15 downto 0);
   l1_stub_d07 : out std_logic_vector(15 downto 0);
   l1_stub_d08 : out std_logic_vector(15 downto 0);
   l1_stub_d09 : out std_logic_vector(15 downto 0);
   
	 l2_fe_data : in std_logic_vector(31 downto 0);

   l2_stub_dv  : out std_logic_vector(9 downto 0);

   l2_stub_d00 : out std_logic_vector(15 downto 0);
   l2_stub_d01 : out std_logic_vector(15 downto 0);
   l2_stub_d02 : out std_logic_vector(15 downto 0);
   l2_stub_d03 : out std_logic_vector(15 downto 0);
   l2_stub_d04 : out std_logic_vector(15 downto 0);
   l2_stub_d05 : out std_logic_vector(15 downto 0);
   l2_stub_d06 : out std_logic_vector(15 downto 0);
   l2_stub_d07 : out std_logic_vector(15 downto 0);
   l2_stub_d08 : out std_logic_vector(15 downto 0);
   l2_stub_d09 : out std_logic_vector(15 downto 0);
   
	 l3_fe_data : in std_logic_vector(31 downto 0);

   l3_stub_dv  : out std_logic_vector(9 downto 0);

   l3_stub_d00 : out std_logic_vector(15 downto 0);
   l3_stub_d01 : out std_logic_vector(15 downto 0);
   l3_stub_d02 : out std_logic_vector(15 downto 0);
   l3_stub_d03 : out std_logic_vector(15 downto 0);
   l3_stub_d04 : out std_logic_vector(15 downto 0);
   l3_stub_d05 : out std_logic_vector(15 downto 0);
   l3_stub_d06 : out std_logic_vector(15 downto 0);
   l3_stub_d07 : out std_logic_vector(15 downto 0);
   l3_stub_d08 : out std_logic_vector(15 downto 0);
   l3_stub_d09 : out std_logic_vector(15 downto 0);
   
	 l4_fe_data : in std_logic_vector(31 downto 0);

   l4_stub_dv  : out std_logic_vector(9 downto 0);

   l4_stub_d00 : out std_logic_vector(15 downto 0);
   l4_stub_d01 : out std_logic_vector(15 downto 0);
   l4_stub_d02 : out std_logic_vector(15 downto 0);
   l4_stub_d03 : out std_logic_vector(15 downto 0);
   l4_stub_d04 : out std_logic_vector(15 downto 0);
   l4_stub_d05 : out std_logic_vector(15 downto 0);
   l4_stub_d06 : out std_logic_vector(15 downto 0);
   l4_stub_d07 : out std_logic_vector(15 downto 0);
   l4_stub_d08 : out std_logic_vector(15 downto 0);
   l4_stub_d09 : out std_logic_vector(15 downto 0);
   
	 l5_fe_data : in std_logic_vector(31 downto 0);

   l5_stub_dv  : out std_logic_vector(9 downto 0);

   l5_stub_d00 : out std_logic_vector(15 downto 0);
   l5_stub_d01 : out std_logic_vector(15 downto 0);
   l5_stub_d02 : out std_logic_vector(15 downto 0);
   l5_stub_d03 : out std_logic_vector(15 downto 0);
   l5_stub_d04 : out std_logic_vector(15 downto 0);
   l5_stub_d05 : out std_logic_vector(15 downto 0);
   l5_stub_d06 : out std_logic_vector(15 downto 0);
   l5_stub_d07 : out std_logic_vector(15 downto 0);
   l5_stub_d08 : out std_logic_vector(15 downto 0);
   l5_stub_d09 : out std_logic_vector(15 downto 0)
   
	);

end x6_mpa_data_organizer;

architecture x6_mpa_data_organizer_architecture of x6_mpa_data_organizer is

component mpa_data_organizer is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

	 phi : in std_logic_vector(3 downto 0);
	 z : in std_logic_vector(3 downto 0);

	 fe_data : in std_logic_vector(31 downto 0);

   stub_dv  : out std_logic_vector(9 downto 0);

   stub_d00 : out std_logic_vector(15 downto 0);
   stub_d01 : out std_logic_vector(15 downto 0);
   stub_d02 : out std_logic_vector(15 downto 0);
   stub_d03 : out std_logic_vector(15 downto 0);
   stub_d04 : out std_logic_vector(15 downto 0);
   stub_d05 : out std_logic_vector(15 downto 0);
   stub_d06 : out std_logic_vector(15 downto 0);
   stub_d07 : out std_logic_vector(15 downto 0);
   stub_d08 : out std_logic_vector(15 downto 0);
   stub_d09 : out std_logic_vector(15 downto 0)
	
	);

end component;

type fe_data_vector is array (NL-1 downto 0) of std_logic_vector(31 downto 0);
signal fe_data : fe_data_vector;

type do_stub_data_vector is array (9 downto 0) of std_logic_vector(15 downto 0);
type do_stub_data_array is array (NL-1 downto 0) of do_stub_data_vector;
signal do_stub_data : do_stub_data_array;

type do_stub_dv_array is array (NL-1 downto 0) of std_logic_vector(9 downto 0);
signal do_stub_dv : do_stub_dv_array;

begin

  fe_data(0) <= l0_fe_data;
  fe_data(1) <= l1_fe_data;
  fe_data(2) <= l2_fe_data;
  fe_data(3) <= l3_fe_data;
  fe_data(4) <= l4_fe_data;
  fe_data(5) <= l5_fe_data;
  
  GEN_DO : for I in NL-1 downto 0 generate

  begin

  DO_M : mpa_data_organizer
    port map(

      clk => clk,
      rst => rst,

      phi => phi,
      z => z,
      
      fe_data => fe_data(I),
      stub_dv => do_stub_dv(I),
      stub_d00 => do_stub_data(I)(0),
      stub_d01 => do_stub_data(I)(1),
      stub_d02 => do_stub_data(I)(2),
      stub_d03 => do_stub_data(I)(3),
      stub_d04 => do_stub_data(I)(4),
      stub_d05 => do_stub_data(I)(5),
      stub_d06 => do_stub_data(I)(6),
      stub_d07 => do_stub_data(I)(7),
      stub_d08 => do_stub_data(I)(8),
      stub_d09 => do_stub_data(I)(9));

  end generate GEN_DO;

  l0_stub_dv <= do_stub_dv(0);  
	l0_stub_d00 <= do_stub_data(0)(0);
	l0_stub_d01 <= do_stub_data(0)(1);
	l0_stub_d02 <= do_stub_data(0)(2);
	l0_stub_d03 <= do_stub_data(0)(3);
	l0_stub_d04 <= do_stub_data(0)(4);
	l0_stub_d05 <= do_stub_data(0)(5);
	l0_stub_d06 <= do_stub_data(0)(6);
	l0_stub_d07 <= do_stub_data(0)(7);
	l0_stub_d08 <= do_stub_data(0)(8);
	l0_stub_d09 <= do_stub_data(0)(9);
	
  l1_stub_dv <= do_stub_dv(1);  
	l1_stub_d00 <= do_stub_data(1)(0);
	l1_stub_d01 <= do_stub_data(1)(1);
	l1_stub_d02 <= do_stub_data(1)(2);
	l1_stub_d03 <= do_stub_data(1)(3);
	l1_stub_d04 <= do_stub_data(1)(4);
	l1_stub_d05 <= do_stub_data(1)(5);
	l1_stub_d06 <= do_stub_data(1)(6);
	l1_stub_d07 <= do_stub_data(1)(7);
	l1_stub_d08 <= do_stub_data(1)(8);
	l1_stub_d09 <= do_stub_data(1)(9);
	
  l2_stub_dv <= do_stub_dv(2);  
	l2_stub_d00 <= do_stub_data(2)(0);
	l2_stub_d01 <= do_stub_data(2)(1);
	l2_stub_d02 <= do_stub_data(2)(2);
	l2_stub_d03 <= do_stub_data(2)(3);
	l2_stub_d04 <= do_stub_data(2)(4);
	l2_stub_d05 <= do_stub_data(2)(5);
	l2_stub_d06 <= do_stub_data(2)(6);
	l2_stub_d07 <= do_stub_data(2)(7);
	l2_stub_d08 <= do_stub_data(2)(8);
	l2_stub_d09 <= do_stub_data(2)(9);
	
  l3_stub_dv <= do_stub_dv(3);  
	l3_stub_d00 <= do_stub_data(3)(0);
	l3_stub_d01 <= do_stub_data(3)(1);
	l3_stub_d02 <= do_stub_data(3)(2);
	l3_stub_d03 <= do_stub_data(3)(3);
	l3_stub_d04 <= do_stub_data(3)(4);
	l3_stub_d05 <= do_stub_data(3)(5);
	l3_stub_d06 <= do_stub_data(3)(6);
	l3_stub_d07 <= do_stub_data(3)(7);
	l3_stub_d08 <= do_stub_data(3)(8);
	l3_stub_d09 <= do_stub_data(3)(9);
	
  l4_stub_dv <= do_stub_dv(4);  
	l4_stub_d00 <= do_stub_data(4)(0);
	l4_stub_d01 <= do_stub_data(4)(1);
	l4_stub_d02 <= do_stub_data(4)(2);
	l4_stub_d03 <= do_stub_data(4)(3);
	l4_stub_d04 <= do_stub_data(4)(4);
	l4_stub_d05 <= do_stub_data(4)(5);
	l4_stub_d06 <= do_stub_data(4)(6);
	l4_stub_d07 <= do_stub_data(4)(7);
	l4_stub_d08 <= do_stub_data(4)(8);
	l4_stub_d09 <= do_stub_data(4)(9);

  l5_stub_dv <= do_stub_dv(5);  
	l5_stub_d00 <= do_stub_data(5)(0);
	l5_stub_d01 <= do_stub_data(5)(1);
	l5_stub_d02 <= do_stub_data(5)(2);
	l5_stub_d03 <= do_stub_data(5)(3);
	l5_stub_d04 <= do_stub_data(5)(4);
	l5_stub_d05 <= do_stub_data(5)(5);
	l5_stub_d06 <= do_stub_data(5)(6);
	l5_stub_d07 <= do_stub_data(5)(7);
	l5_stub_d08 <= do_stub_data(5)(8);
	l5_stub_d09 <= do_stub_data(5)(9);
	
end x6_mpa_data_organizer_architecture;
