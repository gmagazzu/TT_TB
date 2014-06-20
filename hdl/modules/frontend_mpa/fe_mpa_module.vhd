library work;
library ieee;
library std;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
library unimacro;
library unisim;
use unimacro.vcomponents.all;
use unisim.vcomponents.all;

entity fe_mpa_module is
  generic (
    NLAYER : integer range 1 to 8 := 6;  -- Number of layers
    NFE : integer range 1 to 16 := 8  -- Number of fe_mpa_chip in fe_module
    );  
  port
    (clk      : in  std_logic;
     rst      : in  std_logic;
     en       : in  std_logic;
     layer    : in  std_logic_vector(3 downto 0);
     phi      : in  std_logic_vector(3 downto 0);
     z        : in  std_logic_vector(3 downto 0);
     fe_data  : out std_logic_vector(31 downto 0));

end fe_mpa_module;


architecture fe_mpa_module_arch of fe_mpa_module is

component fe_mpa_chip is
    port (
      clk      : in  std_logic;
      en       : in  std_logic;
      layer    : in  std_logic_vector(3 downto 0);
      phi      : in  std_logic_vector(3 downto 0);
      z        : in  std_logic_vector(3 downto 0);
      fe       : in  std_logic_vector(3 downto 0);
      hit1_dv 		: out std_logic;
      hit1_data : out  std_logic_vector(16 downto 0);
      hit2_dv 		: out std_logic;
      hit2_data : out  std_logic_vector(16 downto 0);
      hit3_dv 		: out std_logic;
      hit3_data : out  std_logic_vector(16 downto 0);
      hit4_dv 		: out std_logic;
      hit4_data : out  std_logic_vector(16 downto 0));

end component;

component dc1_mpa_chip is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   fe_stub_dv : in std_logic_vector(3 downto 0);
   fe_stub_d0 : in std_logic_vector(16 downto 0);
   fe_stub_d1 : in std_logic_vector(16 downto 0);
   fe_stub_d2 : in std_logic_vector(16 downto 0);
   fe_stub_d3 : in std_logic_vector(16 downto 0);
	 dc_out : out std_logic_vector(39 downto 0)
	
	);
  end component;

component dc2_mpa_chip is
    port(
  
      clk   : in std_logic;
      rst   : in std_logic;

      fe0_stub_dv : in std_logic_vector(1 downto 0);
      fe0_stub_d0 : in std_logic_vector(17 downto 0);
      fe0_stub_d1 : in std_logic_vector(17 downto 0);
      fe1_stub_dv : in std_logic_vector(1 downto 0);
      fe1_stub_d0 : in std_logic_vector(17 downto 0);
      fe1_stub_d1 : in std_logic_vector(17 downto 0);
      fe2_stub_dv : in std_logic_vector(1 downto 0);
      fe2_stub_d0 : in std_logic_vector(17 downto 0);
      fe2_stub_d1 : in std_logic_vector(17 downto 0);
      fe3_stub_dv : in std_logic_vector(1 downto 0);
      fe3_stub_d0 : in std_logic_vector(17 downto 0);
      fe3_stub_d1 : in std_logic_vector(17 downto 0);
      fe4_stub_dv : in std_logic_vector(1 downto 0);
      fe4_stub_d0 : in std_logic_vector(17 downto 0);
      fe4_stub_d1 : in std_logic_vector(17 downto 0);
      fe5_stub_dv : in std_logic_vector(1 downto 0);
      fe5_stub_d0 : in std_logic_vector(17 downto 0);
      fe5_stub_d1 : in std_logic_vector(17 downto 0);
      fe6_stub_dv : in std_logic_vector(1 downto 0);
      fe6_stub_d0 : in std_logic_vector(17 downto 0);
      fe6_stub_d1 : in std_logic_vector(17 downto 0);
      fe7_stub_dv : in std_logic_vector(1 downto 0);
      fe7_stub_d0 : in std_logic_vector(17 downto 0);
      fe7_stub_d1 : in std_logic_vector(17 downto 0);
	    dc_out : out std_logic_vector(31 downto 0)
	
	);
  end component;

type fe_array is array (NFE-1 downto 0) of std_logic_vector(3 downto 0);
signal fe : fe_array;

type stub_data_vector is array (3 downto 0) of std_logic_vector(16 downto 0);
type stub_data_array is array (NFE-1 downto 0) of stub_data_vector;
signal stub_data : stub_data_array;

type stub_dv_array is array (NFE-1 downto 0) of std_logic_vector(3 downto 0);
signal stub_dv : stub_dv_array;

type dc1_data_array is array (NFE-1 downto 0) of std_logic_vector(39 downto 0);
signal dc1_data : dc1_data_array;

type dc1_dv_array is array (NFE-1 downto 0) of std_logic_vector(1 downto 0);
signal dc1_dv : dc1_dv_array;

begin

--  fe(0) <= "0001";
--  fe(1) <= "0010";
--  fe(2) <= "0011";
--  fe(3) <= "0100";
--  fe(4) <= "0101";
--  fe(5) <= "0110";
--  fe(6) <= "0111";
--  fe(7) <= "1000";
  fe(0) <= "0000";
  fe(1) <= "0001";
  fe(2) <= "0010";
  fe(3) <= "0011";
  fe(4) <= "0100";
  fe(5) <= "0101";
  fe(6) <= "0110";
  fe(7) <= "0111";
  
  GEN_FE : for J in NFE-1 downto 0 generate
  begin

  FE_M : fe_mpa_chip
    port map(
      clk => clk,
      en => en,
      layer => layer,
      phi => phi,
      z => z,
      fe => fe(J),
      hit1_dv => stub_dv(J)(0),
      hit1_data => stub_data(J)(0),
      hit2_dv => stub_dv(J)(1),
      hit2_data => stub_data(J)(1),
      hit3_dv => stub_dv(J)(2),
      hit3_data => stub_data(J)(2),
      hit4_dv => stub_dv(J)(3),
      hit4_data => stub_data(J)(3)
      );

  DC1_M : dc1_mpa_chip
    port map(
      clk => clk,
      rst => rst,
      fe_stub_dv => stub_dv(J),
      fe_stub_d0 => stub_data(J)(0),
      fe_stub_d1 => stub_data(J)(1),
      fe_stub_d2 => stub_data(J)(2),
      fe_stub_d3 => stub_data(J)(3),
	    dc_out => dc1_data(J)
      	);

  end generate GEN_FE;

dv_gen_proc: process (dc1_data)

begin

  for I in 0 to 7 loop
    dc1_dv(I)(0) <= dc1_data(I)(18);
    dc1_dv(I)(1) <= dc1_data(I)(37);
  end loop;

end process;

  DC2_M : dc2_mpa_chip
    port map(
      clk => clk,
      rst => rst,
      fe0_stub_dv => dc1_dv(0),
      fe0_stub_d0 => dc1_data(0)(17 downto 0),
      fe0_stub_d1 => dc1_data(0)(36 downto 19),
      fe1_stub_dv => dc1_dv(1),
      fe1_stub_d0 => dc1_data(1)(17 downto 0),
      fe1_stub_d1 => dc1_data(1)(36 downto 19),
      fe2_stub_dv => dc1_dv(2),
      fe2_stub_d0 => dc1_data(2)(17 downto 0),
      fe2_stub_d1 => dc1_data(2)(36 downto 19),
      fe3_stub_dv => dc1_dv(3),
      fe3_stub_d0 => dc1_data(3)(17 downto 0),
      fe3_stub_d1 => dc1_data(3)(36 downto 19),
      fe4_stub_dv => dc1_dv(4),
      fe4_stub_d0 => dc1_data(4)(17 downto 0),
      fe4_stub_d1 => dc1_data(4)(36 downto 19),
      fe5_stub_dv => dc1_dv(5),
      fe5_stub_d0 => dc1_data(5)(17 downto 0),
      fe5_stub_d1 => dc1_data(5)(36 downto 19),
      fe6_stub_dv => dc1_dv(6),
      fe6_stub_d0 => dc1_data(6)(17 downto 0),
      fe6_stub_d1 => dc1_data(6)(36 downto 19),
      fe7_stub_dv => dc1_dv(7),
      fe7_stub_d0 => dc1_data(7)(17 downto 0),
      fe7_stub_d1 => dc1_data(7)(36 downto 19),
	    dc_out => fe_data);

end fe_mpa_module_arch;
