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

entity x4_mpa_test_bench is
  generic (
    NL : integer range 1 to 8 := 6;  -- Number of layers
    NSL_PHI : integer range 1 to 8 := 2;  -- Number of slices in the phi direction
    NSL_Z : integer range 1 to 8 := 2  -- Number of slices in the z direction
    );  
  port
    (error : out std_logic);

end x4_mpa_test_bench;


architecture x4_mpa_test_bench_arch of x4_mpa_test_bench is

component mpa_slice is
  generic (
    NLAYER : integer range 1 to 8 := 6  -- Number of layers
    );  
  port (

    clk40MHz : in std_logic;
    clk100MHz : in std_logic;
    clk160MHz : in std_logic;
    reset : in std_logic;
    enable : in std_logic;

--    phi : in std_logic_vector(3 downto 0);
--    z : in std_logic_vector(3 downto 0);
    phi_id : in integer;
    z_id : in integer;

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

type slice_np_stub_data_vector is array (NL-1 downto 0) of std_logic_vector(15 downto 0);
type phi_slice_np_stub_data_vector is array (NSL_PHI-1 downto 0) of slice_np_stub_data_vector;
type np_stub_data_vector is array (NSL_Z-1 downto 0) of phi_slice_np_stub_data_vector;
signal n_stub_in_data, n_stub_out_data : np_stub_data_vector;
signal p_stub_in_data, p_stub_out_data : np_stub_data_vector;

type phi_slice_np_stub_dv_vector is array (NSL_PHI-1 downto 0) of std_logic_vector(NL-1 downto 0);
type np_stub_dv_vector is array (NSL_Z-1 downto 0) of phi_slice_np_stub_dv_vector;
signal n_stub_in_dv, n_stub_out_dv : np_stub_dv_vector;
signal p_stub_in_dv, p_stub_out_dv : np_stub_dv_vector;

--type sl_addr_vector is array (NSL_PHI-1 downto 0) of std_logic_vector(3 downto 0);
--type sl_addr_array is array (NSL_Z-1 downto 0) of sl_addr_vector;
--signal phi,z : sl_addr_array;
type sl_addr_vector is array (NSL_PHI-1 downto 0) of integer;
type sl_addr_array is array (NSL_Z-1 downto 0) of sl_addr_vector;
signal phi_id,z_id : sl_addr_array;

begin

  clk40MHz  <= not clk40MHz  after 12.50 ns;

  clk100MHz  <= not clk100MHz  after 5.000 ns;

  clk160MHz  <= not clk160MHz  after 3.125 ns;

  reset <= '0', '1' after 100 ns, '0' after 200 ns;

  enable    <= '1' after 1 us;

  np_stub_proc : process (n_stub_out_dv,n_stub_out_data,p_stub_out_dv,p_stub_out_data)

  begin

    for K_Z in 0 to NSL_Z-1 loop
      for K_PHI in 0 to NSL_PHI-2 loop
        for I in 0 to 5 loop
          n_stub_in_dv(K_Z)(K_PHI)(I) <= p_stub_out_dv(K_Z)(K_PHI+1)(I);
          n_stub_in_data(K_Z)(K_PHI)(I) <= p_stub_out_data(K_Z)(K_PHI+1)(I);
        end loop;
      end loop;
      for I in 0 to 5 loop
        n_stub_in_dv(K_Z)(NSL_PHI-1)(I) <= p_stub_out_dv(K_Z)(0)(I);
        n_stub_in_data(K_Z)(NSL_PHI-1)(I) <= p_stub_out_data(K_Z)(0)(I);
      end loop;
      for K_PHI in 1 to NSL_PHI-1 loop
        for I in 0 to 5 loop
          p_stub_in_dv(K_Z)(K_PHI)(I) <= n_stub_out_dv(K_Z)(K_PHI-1)(I);
          p_stub_in_data(K_Z)(K_PHI)(I) <= n_stub_out_data(K_Z)(K_PHI-1)(I);
        end loop;
      end loop;
      for I in 0 to 5 loop
        p_stub_in_dv(K_Z)(0)(I) <= n_stub_out_dv(K_Z)(NSL_PHI-1)(I);
        p_stub_in_data(K_Z)(0)(I) <= n_stub_out_data(K_Z)(NSL_PHI-1)(I);
      end loop;
    end loop;
  
  end process;

  GEN_Z_SLICES : for K_Z in 0 to NSL_Z-1 generate
  
  begin

    GEN_PHI_SLICES : for K_PHI in 0 to NSL_PHI-1 generate
  
    begin

--      z(K_Z)(K_PHI) <= std_logic_vector(to_unsigned(K_Z, 4));
--      phi(K_Z)(K_PHI) <= std_logic_vector(to_unsigned(K_PHI, 4));
      z_id(K_Z)(K_PHI) <= K_Z;
      phi_id(K_Z)(K_PHI) <= K_PHI;
    
      SL_M : mpa_slice
        generic map (
          NLAYER => 6)  
        port map (

          clk40MHz => clk40MHz,
          clk100MHz => clk100MHz,
          clk160MHz => clk160MHz,
          reset => reset,
          enable => enable,

--          phi => phi(K_Z)(K_PHI),
--          z => z(K_Z)(K_PHI),
          phi_id => phi_id(K_Z)(K_PHI),
          z_id => z_id(K_Z)(K_PHI),

          l0_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(0),
          l0_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(0),
          l0_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(0),
          l0_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(0),
          l0_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(0),
          l0_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(0),
          l0_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(0),
          l0_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(0),

          l1_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(1),
          l1_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(1),
          l1_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(1),
          l1_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(1),
          l1_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(1),
          l1_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(1),
          l1_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(1),
          l1_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(1),

          l2_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(2),
          l2_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(2),
          l2_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(2),
          l2_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(2),
          l2_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(2),
          l2_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(2),
          l2_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(2),
          l2_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(2),

          l3_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(3),
          l3_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(3),
          l3_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(3),
          l3_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(3),
          l3_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(3),
          l3_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(3),
          l3_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(3),
          l3_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(3),

          l4_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(4),
          l4_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(4),
          l4_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(4),
          l4_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(4),
          l4_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(4),
          l4_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(4),
          l4_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(4),
          l4_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(4),

          l5_n_stub_in_dv => n_stub_in_dv(K_Z)(K_PHI)(5),
          l5_n_stub_in_data => n_stub_in_data(K_Z)(K_PHI)(5),
          l5_p_stub_in_dv => p_stub_in_dv(K_Z)(K_PHI)(5),
          l5_p_stub_in_data => p_stub_in_data(K_Z)(K_PHI)(5),
          l5_n_stub_out_dv => n_stub_out_dv(K_Z)(K_PHI)(5),
          l5_n_stub_out_data => n_stub_out_data(K_Z)(K_PHI)(5),
          l5_p_stub_out_dv => p_stub_out_dv(K_Z)(K_PHI)(5),
          l5_p_stub_out_data => p_stub_out_data(K_Z)(K_PHI)(5));

    end generate GEN_PHI_SLICES;

  end generate GEN_Z_SLICES;
 
end x4_mpa_test_bench_arch;
