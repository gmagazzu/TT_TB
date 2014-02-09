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

entity am_glue is
  port (
    clk : in std_logic;
    init : in std_logic;
    dr0_b : in std_logic;
    dr1_b : in std_logic;
    dr2_b : in std_logic;
    dr3_b : in std_logic;
    ladd0 : in std_logic_vector(20 downto 0);
    ladd1 : in std_logic_vector(20 downto 0);
    ladd2 : in std_logic_vector(20 downto 0);
    ladd3 : in std_logic_vector(20 downto 0);
    sel0_b : out std_logic;
    sel1_b : out std_logic;
    sel2_b : out std_logic;
    sel3_b : out std_logic;
    oadd : out std_logic_vector(22 downto 0);
    dr_b : out std_logic;
    bitmap_en : in std_logic;
    finish_road : out std_logic;
    rhold : in std_logic);

end am_glue;


architecture am_glue_arch of am_glue is

-- Beginning of the Test Bench Section

type ladd_array is array (3 downto 0) of std_logic_vector(20 downto 0);
signal ladd, ladd_reg, fifo_in, fifo_out : ladd_array;

signal dr_in, sel, sel_d1, sel_d2 : std_logic_vector(3 downto 0);     

signal wr_road, wr_bitmap : std_logic_vector(3 downto 0);     

signal prog_full : std_logic_vector(3 downto 0) := "0000";     

signal fifo_wren, fifo_rden : std_logic_vector(3 downto 0);     
signal fifo_wrck, fifo_rdck : std_logic_vector(3 downto 0);     
signal fifo_empty, fifo_aempty, fifo_afull, fifo_full : std_logic_vector(3 downto 0);     
signal fifo_rst : std_logic_vector(3 downto 0);     

type cnt_array is array (3 downto 0) of std_logic_vector(9 downto 0);
signal fifo_wr_cnt, fifo_rd_cnt : cnt_array;

begin

  ladd(0) <= ladd0;
  ladd(1) <= ladd1;
  ladd(2) <= ladd2;
  ladd(3) <= ladd3;
  
  ireg_proc : process (ladd, init, clk)

  begin

    for I in 0 to 3 loop
      if (init = '1') then
        ladd_reg(I) <= (others => '0');
      elsif rising_edge(clk) then
        ladd_reg(I) <= ladd(I);
      end if;
    end loop;

  end process;

  dr_in(0) <= not dr0_b;
  dr_in(1) <= not dr1_b;
  dr_in(2) <= not dr2_b;
  dr_in(3) <= not dr3_b;
  
  fifo_ctrl_proc : process (dr_in, prog_full, sel_d1, sel_d2, bitmap_en, wr_road, wr_bitmap, fifo_empty, rhold, clk)

  begin
  for I in 0 to 3 loop
    sel(I) <= dr_in(I) and (not prog_full(I));
    if rising_edge(clk) then
      sel_d1(I) <= sel(I);
      sel_d2(I) <= sel_d1(I);
    end if;
  
  wr_road(I) <= sel_d1(I);
  wr_bitmap(I) <= bitmap_en and sel_d2(I);
  fifo_wren(I) <= wr_road(I) or wr_bitmap(I);

  end loop;

  fifo_rden(0) <= (not fifo_empty(0)) and (not rhold);
  fifo_rden(1) <= (not fifo_empty(1)) and fifo_empty(0) and (not rhold);
  fifo_rden(2) <= (not fifo_empty(2)) and fifo_empty(1) and fifo_empty(0) and (not rhold);
  fifo_rden(3) <= (not fifo_empty(3)) and fifo_empty(2) and fifo_empty(1) and fifo_empty(0) and (not rhold);

  end process;


  sel0_b <= not sel(0);
  sel1_b <= not sel(1);
  sel2_b <= not sel(2);
  sel3_b <= not sel(3);
  
  
  GEN_FIFO : for I in 3 downto 0 generate
  begin

  fifo_in(I) <= ladd_reg(I);
  fifo_wrck(I) <= clk;
  fifo_rdck(I) <= clk;
  fifo_rst(I) <= init;
  
  FIFO_M : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 21,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "36Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => true)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => fifo_aempty(I),  		-- Output almost empty 
      ALMOSTFULL  => fifo_afull(I),   		-- Output almost full
      DO          => fifo_out(I),     		-- Output data
      EMPTY       => fifo_empty(I),   		-- Output empty
      FULL        => fifo_full(I),    		-- Output full
      RDCOUNT     => fifo_rd_cnt(I),  		-- Output read count
      RDERR       => open,                -- Output read error
      WRCOUNT     => fifo_wr_cnt(I),  		-- Output write count
      WRERR       => open,                -- Output write error
      DI          => fifo_in(I),      		-- Input data
      RDCLK       => fifo_rdck(I),    				-- Input read clock
      RDEN        => fifo_rden(I),    		-- Input read enable
      RST         => fifo_rst(I),                 -- Input reset
      WRCLK       => fifo_wrck(I),    				-- Input write clock
      WREN        => fifo_wren(I)     -- Input write enable
      );

end generate GEN_FIFO;

omux_proc : process (fifo_out, fifo_empty, fifo_rden, init, clk)

variable  dv_d0, dv_d1, dv_d2 : std_logic;
variable  mux_sel : std_logic_vector (3 downto 0);
variable  mux_out : std_logic_vector (22 downto 0);
variable  dr_d0, dr_d1 : std_logic;
variable  all_fifo_empty : std_logic;
variable  finish_road_d0,finish_road_d1,finish_road_d2,finish_road_d3 : std_logic;

  begin

    dv_d0 := fifo_rden(0) or fifo_rden(1) or fifo_rden(2) or fifo_rden(3);

    if (init = '1') then
      dv_d1 := '0';
      dv_d2 := '0';
      oadd <= (others => '0');
    elsif rising_edge(clk) then
      dv_d1 := dv_d0;
      dv_d2 := dv_d1;
      oadd <= mux_out;
    end if;
    
    mux_sel := fifo_rden;

    dr_b <= not dv_d2;
    
    case (mux_sel) is
      when "0001" => mux_out := "00" & fifo_out(0);
      when "0010" => mux_out := "01" & fifo_out(1);
      when "0100" => mux_out := "10" & fifo_out(2);
      when "1000" => mux_out := "11" & fifo_out(3);
      when others => mux_out := "10101010101010101010101";
    end case;
  
    dr_d0 := dr_in(0) or dr_in(1) or dr_in(2) or dr_in(3);
    
    if rising_edge(clk) then
      dr_d1 := dr_d0;
    end if;

    all_fifo_empty := fifo_empty(0) and fifo_empty(1) and fifo_empty(2) and fifo_empty(3);
    
    finish_road_d0 := (not dr_d0) and (not dr_d1) and (all_fifo_empty);
 
    if rising_edge(clk) then
      finish_road_d1 := finish_road_d0;
      finish_road_d2 := finish_road_d1;
      finish_road_d3 := finish_road_d2;
    end if;

    finish_road <= finish_road_d3;
    
  end process;

end am_glue_arch;