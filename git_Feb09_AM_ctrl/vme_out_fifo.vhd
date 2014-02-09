library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
library unimacro;
library unisim;
use unimacro.vcomponents.all;
use unisim.vcomponents.all;

entity vme_out_fifo is
    port (clk : in std_logic;
          din : in std_logic_vector(22 downto 0);
          rd_en : in std_logic;
          rst : in std_logic;
          wr_en : in std_logic;
          data_count : out std_logic_vector(13 downto 0);
          dout : out std_logic_vector(22 downto 0);
          empty : out std_logic;
          full : out std_logic);
end vme_out_fifo;

architecture vme_out_fifo_arch of vme_out_fifo is

-- original size = 16KWord - current size = 1KWord

signal wr_cnt : std_logic_vector(9 downto 0);
signal rd_cnt : std_logic_vector(9 downto 0);

begin

    data_count(13 downto 0) <= (others => '0');
    data_count(9 downto 0) <= (wr_cnt - rd_cnt) when (rd_cnt < wr_cnt) else (others => '0');
        
    FIFO_M : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 23,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "36Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => true)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => open,  		      -- Output almost empty 
      ALMOSTFULL  => open,   		     -- Output almost full
      DO          => dout,     	    -- Output data
      EMPTY       => empty,   		    -- Output empty
      FULL        => full,    		    -- Output full
      RDCOUNT     => rd_cnt,  		    -- Output read count
      RDERR       => open,          -- Output read error
      WRCOUNT     => wr_cnt,  		    -- Output write count
      WRERR       => open,          -- Output write error
      DI          => din,      		   -- Input data
      RDCLK       => clk,    				   -- Input read clock
      RDEN        => rd_en,    		   -- Input read enable
      RST         => rst,           -- Input reset
      WRCLK       => clk,    				   -- Input write clock
      WREN        => wr_en          -- Input write enable
      );
 
end vme_out_fifo_arch;

