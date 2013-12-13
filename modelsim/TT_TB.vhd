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

entity TT_TB is
  generic (
    NLAYER : integer range 1 to 8 := 6  -- Number of layers
    );  
  port
    (error : out std_logic);

end TT_TB;


architecture TT_TB_arch of TT_TB is

  component file_handler_hit_gen is
    port (
      clk      : in  std_logic;
      en       : in  std_logic;
      layer    : in  std_logic_vector(NLAYER-1 downto 0);
      hit_dv 		: out std_logic;
      hit_data : out  std_logic_vector(23 downto 0)
      );

  end component;


component FE_chip is
    port (
      clk      : in  std_logic;
      en       : in  std_logic;
      layer    : in  std_logic_vector(NLAYER-1 downto 0);
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

component DC_chip is
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

component DO_fpga is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

	 do_in : in std_logic_vector(31 downto 0);

   stub_d00 : out std_logic_vector(15 downto 0);
   stub_d01 : out std_logic_vector(15 downto 0);
   stub_d02 : out std_logic_vector(15 downto 0);
   stub_d03 : out std_logic_vector(15 downto 0);
   stub_d04 : out std_logic_vector(15 downto 0);
   stub_d05 : out std_logic_vector(15 downto 0);
   stub_d06 : out std_logic_vector(15 downto 0);
   stub_d07 : out std_logic_vector(15 downto 0);
   stub_d08 : out std_logic_vector(15 downto 0);
   stub_d09 : out std_logic_vector(15 downto 0);
   stub_d10 : out std_logic_vector(15 downto 0);
   stub_d11 : out std_logic_vector(15 downto 0)
		
	);
  end component;

-- enable, reset and clock signals

  signal enable : std_logic := '0';

  signal rst : std_logic := '0';
  signal rstn : std_logic := '1';

  signal clk40MHz : std_logic := '0';
  signal clk100MHz : std_logic := '0';
  signal clk160MHz : std_logic := '0';

-- signals to/from test_controller (from/to slv_mgt module)

  signal start           : std_logic;
  signal start_res       : std_logic;
  signal stop            : std_logic;
  signal stop_res        : std_logic;
  signal vme_cmd_reg     : std_logic_vector(31 downto 0);
  signal vme_dat_reg_in  : std_logic_vector(31 downto 0);
  signal vme_dat_reg_out : std_logic_vector(31 downto 0);
  signal mode            : std_logic                    := '1';  -- read commands from file
  signal cmd_n           : std_logic_vector(9 downto 0) := "0000000000";
  signal busy            : std_logic;

-- signals to/from test_controller (from/to cmd and dat memories)

  signal vme_mem_addr     : std_logic_vector(9 downto 0);
  signal vme_mem_rden     : std_logic;
  signal vme_cmd_mem_out  : std_logic_vector(31 downto 0);
  signal vme_dat_mem_out  : std_logic_vector(31 downto 0);
  signal vme_dat_mem_wren : std_logic;
  signal vme_dat_mem_in   : std_logic_vector(31 downto 0);

-- signals between test_controller and vme_master_fsm and command_module

  signal vme_cmd     : std_logic;
  signal vme_cmd_rd  : std_logic;
  signal vme_addr    : std_logic_vector(23 downto 1);
  signal vme_wr      : std_logic;
  signal vme_wr_data : std_logic_vector(15 downto 0);
  signal vme_rd      : std_logic;
  signal vme_rd_data : std_logic_vector(15 downto 0);
--  signal vme_data    : std_logic_vector(15 downto 0);
  signal vme_data    : std_logic_vector(31 downto 0);

-- signals between vme_master_fsm and command_module

  signal berr        : std_logic;
  signal berr_out    : std_logic;
  signal as          : std_logic;
-- signal ds0 : std_logic;
-- signal ds1 : std_logic;
  signal ds          : std_logic_vector(1 downto 0);
  signal lword       : std_logic;
  signal write_b     : std_logic;
  signal iack        : std_logic;
  signal sysfail     : std_logic;
  signal sysfail_out : std_logic;
  signal am          : std_logic_vector(5 downto 0);
  signal ga          : std_logic_vector(5 downto 0);
--  signal adr         : std_logic_vector(23 downto 1);
  signal adr         : std_logic_vector(31 downto 1);
  signal oe_b        : std_logic;

-- signals between vme_master_fsm and cfebjtag and lvdbmon modules

  signal dtack   : std_logic;
--  signal indata  : std_logic_vector(15 downto 0);
--  signal outdata : std_logic_vector(15 downto 0);
  signal indata  : std_logic_vector(31 downto 0);
  signal outdata : std_logic_vector(31 downto 0);

  signal tovme, doe_b : std_logic;

-- Signals From Hit Generators

  constant NL : integer := 6;
  constant NFE : integer := 8;

  type layer_data_in is array (NL-1 downto 0) of std_logic_vector(23 downto 0);
  signal hit_data : layer_data_in;

  signal hit_dv : std_logic_vector(NL-1 downto 0);

-- Signals To/From Hit FIFOs

	signal fifo_rst                 : std_logic_vector(NL-1 downto 0);
	signal fifo_aempty              : std_logic_vector(NL-1 downto 0);
	signal fifo_afull               : std_logic_vector(NL-1 downto 0);
	signal fifo_empty,fifo_empty_b  : std_logic_vector(NL-1 downto 0);
	signal fifo_full                : std_logic_vector(NL-1 downto 0);
	signal fifo_wren, fifo_wrck     : std_logic_vector(NL-1 downto 0);
	signal fifo_rden, fifo_rdck     : std_logic_vector(NL-1 downto 0);
  signal fifo_in, fifo_out : layer_data_in;
	type   fifo_cnt_type is array (NL-1 downto 0) of std_logic_vector(9 downto 0);
	signal fifo_wr_cnt, fifo_rd_cnt : fifo_cnt_type;

-- Signals From/To LAMBs

  type layer_data_out is array (NL-1 downto 0) of std_logic_vector(17 downto 0);
  type lamb_data_in is array (3 downto 0) of layer_data_out;
  signal lamb_data : lamb_data_in;

  type lamb_data_out is array (3 downto 0) of std_logic_vector(20 downto 0);
	signal lamb_ladd : lamb_data_out;

  signal lamb_dr_b : std_logic_vector(3 downto 0);

	type lamb_wren_type is array (3 downto 0) of std_logic_vector(NL-1 downto 0);
  signal lamb_wren : lamb_wren_type;

	type lamb_init_ev_type is array (3 downto 0) of std_logic_vector(2 downto 0);
  signal lamb_init_ev : lamb_init_ev_type;

  signal lamb_sel : std_logic_vector(3 downto 0);

	type lamb_opcode_type is array (3 downto 0) of std_logic_vector(3 downto 0);
  signal lamb_opcode : lamb_opcode_type;

  signal lamb_tck : std_logic_vector(3 downto 0);

	signal lamb0_dr_b : std_logic := '1';
	signal lamb0_ladd : std_logic_vector(20 downto 0) := (others => '0');

-- Other signals

	signal odata : std_logic_vector(29 downto 0); -- OUT
	signal resfifo_b : std_logic_vector(1 downto 0); -- OUT
	signal wr_road	: std_logic; -- OUT
	signal init : std_logic; -- OUT
	signal push : std_logic_vector(5 downto 0); -- OUT
	signal bitmap_status : std_logic_vector(3 downto 0); -- OUT
	signal wrpam : std_logic; -- OUT
	signal rdbscan	: std_logic; -- OUT
	signal enb_b : std_logic; -- OUT
	signal dirw_b : std_logic; -- OUT
	signal add : std_logic_vector(2 downto 0); -- OUT

	signal lamb_spare : std_logic_vector(3 downto 0) := "0000"; -- IN  
	signal road_end : std_logic_vector(3 downto 0) := "0000"; -- IN     
	signal rhold_b : std_logic := '1'; -- IN          
	signal backhold_b : std_logic := '1'; -- IN     
	signal en_back : std_logic := '0'; -- IN
	signal back_init : std_logic := '0'; -- IN

-- Logic Levels

	signal LOGIC0 : std_logic := '0';
	signal LOGIC1 : std_logic := '1';

	signal layer : std_logic_vector(5 downto 0) := "000000";     

signal  layer0_fe0_hit1_dv : std_logic;
signal  layer0_fe0_hit1_data : std_logic_vector(12 downto 0);
signal  layer0_fe0_hit2_dv : std_logic;
signal  layer0_fe0_hit2_data : std_logic_vector(12 downto 0);
signal  layer0_fe0_hit3_dv : std_logic;
signal  layer0_fe0_hit3_data : std_logic_vector(12 downto 0);

type layer_id_array is array (NL-1 downto 0) of std_logic_vector(3 downto 0);
signal layer_id : layer_id_array;

type fe_id_array is array (NFE-1 downto 0) of std_logic_vector(3 downto 0);
signal fe_id : fe_id_array;

type stub_data_vector is array (NFE-1 downto 0) of std_logic_vector(12 downto 0);
type stub_data_array is array (NL-1 downto 0) of stub_data_vector;
signal stub1_data, stub2_data, stub3_data : stub_data_array;

type do_stub_data_vector is array (11 downto 0) of std_logic_vector(15 downto 0);
type do_stub_data_array is array (NL-1 downto 0) of do_stub_data_vector;
signal do_stub_data : do_stub_data_array;

type stub_dv_vector is array (NFE-1 downto 0) of std_logic;
type stub_dv_array is array (NL-1 downto 0) of stub_dv_vector;
signal stub1_dv, stub2_dv, stub3_dv : stub_dv_array;

type stub_dv_vector1 is array (NFE-1 downto 0) of std_logic_vector(2 downto 0);
type stub_dv_array1 is array (NL-1 downto 0) of stub_dv_vector1;
signal stub_dv : stub_dv_array1;
signal do_stub_dv : stub_dv_array1;

type dc_data_vector is array (NL-1 downto 0) of std_logic_vector(31 downto 0);
signal dc_data : dc_data_vector;

begin

  enable    <= '1' after 5 us;

  clk100MHz  <= not clk100MHz  after 5.000 ns;

  clk160MHz  <= not clk160MHz  after 3.125 ns;

  clk40MHz  <= not clk40MHz  after 12.50 ns;

  rst <= '0', '1' after 100 ns, '0' after 200 ns;
  rstn <= not rst;
  
  dtack <= 'H';

--------------- Stub Generators and FE ASICs  ------------------------------
-----------------------------------------------------------------------------

  layer_id(0) <= "0001";
  layer_id(1) <= "0010";
  layer_id(2) <= "0011";
  layer_id(3) <= "0100";
  layer_id(4) <= "0101";
  layer_id(5) <= "0110";
  
  fe_id(0) <= "0001";
  fe_id(1) <= "0010";
  fe_id(2) <= "0011";
  fe_id(3) <= "0100";
  fe_id(4) <= "0101";
  fe_id(5) <= "0110";
  fe_id(6) <= "0111";
  fe_id(7) <= "1000";
  
  GEN_MODULE : for I in NL-1 downto 0 generate
  begin

  GEN_FE : for J in NFE-1 downto 0 generate
  begin

  FE_M : FE_chip
    port map(
      clk => clk40MHz,
      en => enable,
      layer => layer_id(I),
      phi => "0001",
      z => "0001",
      fe => fe_id(J),
      hit1_dv => stub1_dv(I)(J),
      hit1_data => stub1_data(I)(J),
      hit2_dv => stub2_dv(I)(J),
      hit2_data => stub2_data(I)(J),
      hit3_dv => stub3_dv(I)(J),
      hit3_data => stub3_data(I)(J));

  stub_dv(I)(J) <= stub3_dv(I)(J) & stub2_dv(I)(J) & stub1_dv(I)(J);

  end generate GEN_FE;

  DC_M : DC_chip
    port map(
      clk => clk40MHz,
      rst => rst,
      fe0_stub_dv => stub_dv(I)(0),
      fe0_stub_d0 => stub1_data(I)(0),
      fe0_stub_d1 => stub2_data(I)(0),
      fe0_stub_d2 => stub3_data(I)(0),
      fe1_stub_dv => stub_dv(I)(1),
      fe1_stub_d0 => stub1_data(I)(1),
      fe1_stub_d1 => stub2_data(I)(1),
      fe1_stub_d2 => stub3_data(I)(1),
      fe2_stub_dv => stub_dv(I)(2),
      fe2_stub_d0 => stub1_data(I)(2),
      fe2_stub_d1 => stub2_data(I)(2),
      fe2_stub_d2 => stub3_data(I)(2),
      fe3_stub_dv => stub_dv(I)(3),
      fe3_stub_d0 => stub1_data(I)(3),
      fe3_stub_d1 => stub2_data(I)(3),
      fe3_stub_d2 => stub3_data(I)(3),
      fe4_stub_dv => stub_dv(I)(4),
      fe4_stub_d0 => stub1_data(I)(4),
      fe4_stub_d1 => stub2_data(I)(4),
      fe4_stub_d2 => stub3_data(I)(4),
      fe5_stub_dv => stub_dv(I)(5),
      fe5_stub_d0 => stub1_data(I)(5),
      fe5_stub_d1 => stub2_data(I)(5),
      fe5_stub_d2 => stub3_data(I)(5),
      fe6_stub_dv => stub_dv(I)(6),
      fe6_stub_d0 => stub1_data(I)(6),
      fe6_stub_d1 => stub2_data(I)(6),
      fe6_stub_d2 => stub3_data(I)(6),
      fe7_stub_dv => stub_dv(I)(7),
      fe7_stub_d0 => stub1_data(I)(7),
      fe7_stub_d1 => stub2_data(I)(7),
      fe7_stub_d2 => stub3_data(I)(7),
	    dc_out => dc_data(I));

DO_M : DO_fpga
    port map(
      clk => clk40MHz,
      rst => rst,
      do_in => dc_data(I),
      stub_d00 => do_stub_data(I)(0),
      stub_d01 => do_stub_data(I)(1),
      stub_d02 => do_stub_data(I)(2),
      stub_d03 => do_stub_data(I)(3),
      stub_d04 => do_stub_data(I)(4),
      stub_d05 => do_stub_data(I)(5),
      stub_d06 => do_stub_data(I)(6),
      stub_d07 => do_stub_data(I)(7),
      stub_d08 => do_stub_data(I)(8),
      stub_d09 => do_stub_data(I)(9),
      stub_d10 => do_stub_data(I)(10),
      stub_d11 => do_stub_data(I)(11));
	
  end generate GEN_MODULE;
 
end TT_TB_arch;
