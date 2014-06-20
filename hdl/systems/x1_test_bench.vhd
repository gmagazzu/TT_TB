library work;
library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
library unimacro;
library unisim;
use unimacro.vcomponents.all;
use unisim.vcomponents.all;

entity x1_test_bench is
  generic (
    NL : integer range 1 to 8 := 6  -- Number of layers
    );  
  port
    (error : out std_logic);

end x1_test_bench;


architecture x1_test_bench_arch of x1_test_bench is

component slice is
  generic (
    NLAYER : integer range 1 to 8 := 6  -- Number of layers
    );  
  port (

    clk40MHz : in std_logic;
    clk100MHz : in std_logic;
    clk160MHz : in std_logic;
    reset : in std_logic;
    enable : in std_logic;

    phi : in std_logic_vector(3 downto 0);
    z : in std_logic_vector(3 downto 0);

    l0_n_stub_in_dv : in std_logic;
    l0_n_stub_in_data : in std_logic_vector(15 downto 0);
    l0_p_stub_in_dv : in std_logic;
    l0_p_stub_in_data : in std_logic_vector(15 downto 0);
    l0_n_stub_out_dv : out std_logic;
    l0_n_stub_out_data : out std_logic_vector(15 downto 0);
    l0_p_stub_out_dv : out std_logic;
    l0_p_stub_out_data : out std_logic_vector(15 downto 0);

    l1_n_stub_in_dv : in std_logic;
    l1_n_stub_in_data : in std_logic_vector(15 downto 0);
    l1_p_stub_in_dv : in std_logic;
    l1_p_stub_in_data : in std_logic_vector(15 downto 0);
    l1_n_stub_out_dv : out std_logic;
    l1_n_stub_out_data : out std_logic_vector(15 downto 0);
    l1_p_stub_out_dv : out std_logic;
    l1_p_stub_out_data : out std_logic_vector(15 downto 0);

    l2_n_stub_in_dv : in std_logic;
    l2_n_stub_in_data : in std_logic_vector(15 downto 0);
    l2_p_stub_in_dv : in std_logic;
    l2_p_stub_in_data : in std_logic_vector(15 downto 0);
    l2_n_stub_out_dv : out std_logic;
    l2_n_stub_out_data : out std_logic_vector(15 downto 0);
    l2_p_stub_out_dv : out std_logic;
    l2_p_stub_out_data : out std_logic_vector(15 downto 0);

    l3_n_stub_in_dv : in std_logic;
    l3_n_stub_in_data : in std_logic_vector(15 downto 0);
    l3_p_stub_in_dv : in std_logic;
    l3_p_stub_in_data : in std_logic_vector(15 downto 0);
    l3_n_stub_out_dv : out std_logic;
    l3_n_stub_out_data : out std_logic_vector(15 downto 0);
    l3_p_stub_out_dv : out std_logic;
    l3_p_stub_out_data : out std_logic_vector(15 downto 0);

    l4_n_stub_in_dv : in std_logic;
    l4_n_stub_in_data : in std_logic_vector(15 downto 0);
    l4_p_stub_in_dv : in std_logic;
    l4_p_stub_in_data : in std_logic_vector(15 downto 0);
    l4_n_stub_out_dv : out std_logic;
    l4_n_stub_out_data : out std_logic_vector(15 downto 0);
    l4_p_stub_out_dv : out std_logic;
    l4_p_stub_out_data : out std_logic_vector(15 downto 0);

    l5_n_stub_in_dv : in std_logic;
    l5_n_stub_in_data : in std_logic_vector(15 downto 0);
    l5_p_stub_in_dv : in std_logic;
    l5_p_stub_in_data : in std_logic_vector(15 downto 0);
    l5_n_stub_out_dv : out std_logic;
    l5_n_stub_out_data : out std_logic_vector(15 downto 0);
    l5_p_stub_out_dv : out std_logic;
    l5_p_stub_out_data : out std_logic_vector(15 downto 0));

end component;

signal clk40MHz : std_logic := '0';
signal clk100MHz : std_logic := '0';
signal clk160MHz : std_logic := '0';
signal reset : std_logic := '0';
signal enable : std_logic := '0';

type np_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(15 downto 0);
signal n_stub_in_data, n_stub_out_data : np_stub_data_vector;
signal p_stub_in_data, p_stub_out_data : np_stub_data_vector;

signal n_stub_in_dv, n_stub_out_dv : std_logic_vector(NL-1 downto 0) := (others => '0');
signal p_stub_in_dv, p_stub_out_dv : std_logic_vector(NL-1 downto 0) := (others => '0');

begin

  clk40MHz  <= not clk40MHz  after 12.50 ns;

  clk100MHz  <= not clk100MHz  after 5.000 ns;

  clk160MHz  <= not clk160MHz  after 3.125 ns;

  reset <= '0', '1' after 100 ns, '0' after 200 ns;

  enable    <= '1' after 1 us;

  x6_np_stub_proc : process (n_stub_out_dv,n_stub_out_data,p_stub_out_dv,p_stub_out_data)

  begin

    for I in 0 to 5 loop
      n_stub_in_dv(I) <= p_stub_out_dv(I);
      n_stub_in_data(I) <= p_stub_out_data(I);
      p_stub_in_dv(I) <= n_stub_out_dv(I);
      p_stub_in_data(I) <= n_stub_out_data(I);
    end loop;
  
  end process;

  SL_M : slice
    generic map (
      NLAYER => 6)  
    port map (

      clk40MHz => clk40MHz,
      clk100MHz => clk100MHz,
      clk160MHz => clk160MHz,
      reset => reset,
      enable => enable,

      phi => "0000",
      z => "0000",

      l0_n_stub_in_dv => n_stub_in_dv(0),
      l0_n_stub_in_data => n_stub_in_data(0),
      l0_p_stub_in_dv => p_stub_in_dv(0),
      l0_p_stub_in_data => p_stub_in_data(0),
      l0_n_stub_out_dv => n_stub_out_dv(0),
      l0_n_stub_out_data => n_stub_out_data(0),
      l0_p_stub_out_dv => p_stub_out_dv(0),
      l0_p_stub_out_data => p_stub_out_data(0),

      l1_n_stub_in_dv => n_stub_in_dv(1),
      l1_n_stub_in_data => n_stub_in_data(1),
      l1_p_stub_in_dv => p_stub_in_dv(1),
      l1_p_stub_in_data => p_stub_in_data(1),
      l1_n_stub_out_dv => n_stub_out_dv(1),
      l1_n_stub_out_data => n_stub_out_data(1),
      l1_p_stub_out_dv => p_stub_out_dv(1),
      l1_p_stub_out_data => p_stub_out_data(1),

      l2_n_stub_in_dv => n_stub_in_dv(2),
      l2_n_stub_in_data => n_stub_in_data(2),
      l2_p_stub_in_dv => p_stub_in_dv(2),
      l2_p_stub_in_data => p_stub_in_data(2),
      l2_n_stub_out_dv => n_stub_out_dv(2),
      l2_n_stub_out_data => n_stub_out_data(2),
      l2_p_stub_out_dv => p_stub_out_dv(2),
      l2_p_stub_out_data => p_stub_out_data(2),

      l3_n_stub_in_dv => n_stub_in_dv(3),
      l3_n_stub_in_data => n_stub_in_data(3),
      l3_p_stub_in_dv => p_stub_in_dv(3),
      l3_p_stub_in_data => p_stub_in_data(3),
      l3_n_stub_out_dv => n_stub_out_dv(3),
      l3_n_stub_out_data => n_stub_out_data(3),
      l3_p_stub_out_dv => p_stub_out_dv(3),
      l3_p_stub_out_data => p_stub_out_data(3),

      l4_n_stub_in_dv => n_stub_in_dv(4),
      l4_n_stub_in_data => n_stub_in_data(4),
      l4_p_stub_in_dv => p_stub_in_dv(4),
      l4_p_stub_in_data => p_stub_in_data(4),
      l4_n_stub_out_dv => n_stub_out_dv(4),
      l4_n_stub_out_data => n_stub_out_data(4),
      l4_p_stub_out_dv => p_stub_out_dv(4),
      l4_p_stub_out_data => p_stub_out_data(4),

      l5_n_stub_in_dv => n_stub_in_dv(5),
      l5_n_stub_in_data => n_stub_in_data(5),
      l5_p_stub_in_dv => p_stub_in_dv(5),
      l5_p_stub_in_data => p_stub_in_data(5),
      l5_n_stub_out_dv => n_stub_out_dv(5),
      l5_n_stub_out_data => n_stub_out_data(5),
      l5_p_stub_out_dv => p_stub_out_dv(5),
      l5_p_stub_out_data => p_stub_out_data(5));
 
end x1_test_bench_arch;
