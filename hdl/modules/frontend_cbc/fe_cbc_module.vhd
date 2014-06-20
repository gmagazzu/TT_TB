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

entity fe_cbc_module is
  generic (
    NLAYER : integer range 1 to 8 := 6;  -- Number of layers
    NFE : integer range 1 to 16 := 8  -- Number of fe_cbc_chip in fe_module
    );  
  port
    (clk      : in  std_logic;
     rst      : in  std_logic;
     en       : in  std_logic;
     layer    : in  std_logic_vector(3 downto 0);
     phi      : in  std_logic_vector(3 downto 0);
     z        : in  std_logic_vector(3 downto 0);
     fe_data  : out std_logic_vector(31 downto 0));

end fe_cbc_module;


architecture fe_cbc_module_arch of fe_cbc_module is

component fe_cbc_chip is
    port (
      clk      : in  std_logic;
      en       : in  std_logic;
      layer    : in  std_logic_vector(3 downto 0);
      phi      : in  std_logic_vector(3 downto 0);
      z        : in  std_logic_vector(3 downto 0);
      fe       : in  std_logic_vector(3 downto 0);
      hit1_dv 		: out std_logic;
      hit1_data : out  std_logic_vector(12 downto 0);
      hit2_dv 		: out std_logic;
      hit2_data : out  std_logic_vector(12 downto 0);
      hit3_dv 		: out std_logic;
      hit3_data : out  std_logic_vector(12 downto 0));

end component;

component dc_cbc_chip is
    port(
  
      clk   : in std_logic;
      rst   : in std_logic;

      fe0_stub_dv : in std_logic_vector(2 downto 0);
      fe0_stub_d0 : in std_logic_vector(12 downto 0);
      fe0_stub_d1 : in std_logic_vector(12 downto 0);
      fe0_stub_d2 : in std_logic_vector(12 downto 0);
      fe1_stub_dv : in std_logic_vector(2 downto 0);
      fe1_stub_d0 : in std_logic_vector(12 downto 0);
      fe1_stub_d1 : in std_logic_vector(12 downto 0);
      fe1_stub_d2 : in std_logic_vector(12 downto 0);
      fe2_stub_dv : in std_logic_vector(2 downto 0);
      fe2_stub_d0 : in std_logic_vector(12 downto 0);
      fe2_stub_d1 : in std_logic_vector(12 downto 0);
      fe2_stub_d2 : in std_logic_vector(12 downto 0);
      fe3_stub_dv : in std_logic_vector(2 downto 0);
      fe3_stub_d0 : in std_logic_vector(12 downto 0);
      fe3_stub_d1 : in std_logic_vector(12 downto 0);
      fe3_stub_d2 : in std_logic_vector(12 downto 0);
      fe4_stub_dv : in std_logic_vector(2 downto 0);
      fe4_stub_d0 : in std_logic_vector(12 downto 0);
      fe4_stub_d1 : in std_logic_vector(12 downto 0);
      fe4_stub_d2 : in std_logic_vector(12 downto 0);
      fe5_stub_dv : in std_logic_vector(2 downto 0);
      fe5_stub_d0 : in std_logic_vector(12 downto 0);
      fe5_stub_d1 : in std_logic_vector(12 downto 0);
      fe5_stub_d2 : in std_logic_vector(12 downto 0);
      fe6_stub_dv : in std_logic_vector(2 downto 0);
      fe6_stub_d0 : in std_logic_vector(12 downto 0);
      fe6_stub_d1 : in std_logic_vector(12 downto 0);
      fe6_stub_d2 : in std_logic_vector(12 downto 0);
      fe7_stub_dv : in std_logic_vector(2 downto 0);
      fe7_stub_d0 : in std_logic_vector(12 downto 0);
      fe7_stub_d1 : in std_logic_vector(12 downto 0);
      fe7_stub_d2 : in std_logic_vector(12 downto 0);
	    dc_out : out std_logic_vector(31 downto 0)
	
	);
  end component;

type fe_array is array (NFE-1 downto 0) of std_logic_vector(3 downto 0);
signal fe : fe_array;

type stub_data_vector is array (2 downto 0) of std_logic_vector(12 downto 0);
type stub_data_array is array (NFE-1 downto 0) of stub_data_vector;
signal stub_data : stub_data_array;

type stub_dv_array is array (NFE-1 downto 0) of std_logic_vector(2 downto 0);
signal stub_dv : stub_dv_array;

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

  FE_M : fe_cbc_chip
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
      hit3_data => stub_data(J)(2));

  end generate GEN_FE;

  DC_M : dc_cbc_chip
    port map(
      clk => clk,
      rst => rst,
      fe0_stub_dv => stub_dv(0),
      fe0_stub_d0 => stub_data(0)(0),
      fe0_stub_d1 => stub_data(0)(1),
      fe0_stub_d2 => stub_data(0)(2),
      fe1_stub_dv => stub_dv(1),
      fe1_stub_d0 => stub_data(1)(0),
      fe1_stub_d1 => stub_data(1)(1),
      fe1_stub_d2 => stub_data(1)(2),
      fe2_stub_dv => stub_dv(2),
      fe2_stub_d0 => stub_data(2)(0),
      fe2_stub_d1 => stub_data(2)(1),
      fe2_stub_d2 => stub_data(2)(2),
      fe3_stub_dv => stub_dv(3),
      fe3_stub_d0 => stub_data(3)(0),
      fe3_stub_d1 => stub_data(3)(1),
      fe3_stub_d2 => stub_data(3)(2),
      fe4_stub_dv => stub_dv(4),
      fe4_stub_d0 => stub_data(4)(0),
      fe4_stub_d1 => stub_data(4)(1),
      fe4_stub_d2 => stub_data(4)(2),
      fe5_stub_dv => stub_dv(5),
      fe5_stub_d0 => stub_data(5)(0),
      fe5_stub_d1 => stub_data(5)(1),
      fe5_stub_d2 => stub_data(5)(2),
      fe6_stub_dv => stub_dv(6),
      fe6_stub_d0 => stub_data(6)(0),
      fe6_stub_d1 => stub_data(6)(1),
      fe6_stub_d2 => stub_data(6)(2),
      fe7_stub_dv => stub_dv(7),
      fe7_stub_d0 => stub_data(7)(0),
      fe7_stub_d1 => stub_data(7)(1),
      fe7_stub_d2 => stub_data(7)(2),
	    dc_out => fe_data);

end fe_cbc_module_arch;
