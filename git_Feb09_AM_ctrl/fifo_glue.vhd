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

entity fifo_glue is
  port (
    clk : in std_logic;
    din : in std_logic_vector(20 downto 0);
    rd_en : in std_logic;
    rst : in std_logic;
    wr_en : in std_logic;
    almost_full : out std_logic;
    dout : out std_logic_vector(20 downto 0);
    empty : out std_logic;
    full : out std_logic;
    prog_full : out std_logic);

end fifo_glue;


architecture fifo_glue_arch of fifo_glue is

-- Beginning of the Test Bench Section

	signal almost_empty : std_logic;     
	signal wr_cnt, rd_cnt : std_logic_vector(9 downto 0);     

begin

  prog_full <= '0';
  
  FIFO_M : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 21,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "36Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => almost_empty,  		-- Output almost empty 
      ALMOSTFULL  => almost_full,   		-- Output almost full
      DO          => dout,     		-- Output data
      EMPTY       => empty,   		        -- Output empty
      FULL        => full,    		-- Output full
      RDCOUNT     => rd_cnt,  		-- Output read count
      RDERR       => open,                -- Output read error
      WRCOUNT     => wr_cnt,  		-- Output write count
      WRERR       => open,                -- Output write error
      DI          => din,      		-- Input data
      RDCLK       => clk,    				-- Input read clock
      RDEN        => rd_en,    		-- Input read enable
      RST         => rst,                 -- Input reset
      WRCLK       => clk,    				-- Input write clock
      WREN        => wr_en     -- Input write enable
      );

end fifo_glue_arch;