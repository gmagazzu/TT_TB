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

entity road_controller is
  port (
    phi : in std_logic_vector(3 downto 0);
    z : in std_logic_vector(3 downto 0);
    clk : in std_logic;
    init : in std_logic;
    rhold : in std_logic;                             -- to am_glue (from outside)
    bitmap_en : in std_logic;                         -- to am_glue (from vme_interface)
    dr_b_in : in std_logic;		                            -- to am_glue (from am_chip)
    ladd : in std_logic_vector(20 downto 0);          -- to am_glue (from am_chip)
    sel_b : out std_logic;                            -- from am_glue (to am_chip)
    dr_b_out : out std_logic;                         -- from am_glue (to main_fsm)
    finish_road : out std_logic;		                    -- from am_glue (to main_fsm) 
    tag_event : 	in  STD_LOGIC_VECTOR (15 downto 0);		-- to road_flux (from hit_ctrl) 
    sel_word : 	in  STD_LOGIC;									               -- to road_flux (from main_fsm) 
    rpush : 		in  STD_LOGIC;									                 -- to road_flux (from main_fsm)  
		road_out : 	out  STD_LOGIC_VECTOR (29 downto 0);	 -- from road_flux (to outside)
		road_wr : 	out  STD_LOGIC;									               -- from road_flux (to outside)
    port_addr : integer                                -- new (to road_flux)
    );                           

end road_controller;


architecture road_controller_arch of road_controller is

-- signals originally defined in the am_ctrl module

signal ladd_reg : std_logic_vector(20 downto 0);
signal fifo_in, fifo_out : std_logic_vector(21 downto 0);

signal dr_in, dr_in_reg, sel, sel_d1, sel_d2 : std_logic;     

signal wr_road, wr_bitmap : std_logic;     

signal prog_full : std_logic := '0';     

signal fifo_wren, fifo_rden : std_logic;     
signal fifo_wrck, fifo_rdck : std_logic;     
signal fifo_empty, fifo_aempty, fifo_afull, fifo_full : std_logic;     
signal fifo_rst : std_logic;     

signal fifo_wr_cnt, fifo_rd_cnt : std_logic_vector(9 downto 0);

signal temp_oadd : std_logic_vector(20 downto 0);

signal oadd : std_logic_vector(22 downto 0);

-- signals originally defined in the road_flux module

	--end event word of road
	signal ee_word: STD_LOGIC_VECTOR(29 downto 0);
	
	--internal address of road
	signal int_add: STD_LOGIC_VECTOR(29 downto 0);
	
	--out signal of the mux
	signal mux_road: STD_LOGIC_VECTOR(29 downto 0);
	
	-- constants
	signal logic1: STD_LOGIC := '1';
	signal logic0: STD_LOGIC := '0';
	signal logic0_x9: STD_LOGIC_VECTOR(8 downto 0) := "000000000";
	
	-- board address
	signal board_addr : STD_LOGIC_VECTOR (3 downto 0);	

begin

-- code originally in the am_ctrl module
 
  ireg_proc : process (ladd, init, clk)

  begin

  dr_in <= not dr_b_in;

    if (init = '1') then
      ladd_reg <= (others => '0');
      dr_in_reg <= '0';
    elsif rising_edge(clk) then
      ladd_reg <= ladd;
      dr_in_reg <= dr_in;
    end if;

  end process;

  dr_in <= not dr_b_in;
  
  fifo_ctrl_proc : process (dr_in, dr_in_reg, ladd_reg, prog_full, sel, sel_d1, sel_d2, bitmap_en, wr_road, wr_bitmap, fifo_empty, rhold, clk)

  begin

    sel <= dr_in and (not prog_full);

    if rising_edge(clk) then
      sel_d1 <= sel;
      sel_d2 <= sel_d1;
    end if;
  
    wr_road <= sel_d1;
    wr_bitmap <= bitmap_en and sel_d2;
    fifo_wren <= wr_road or wr_bitmap;
    fifo_rden <= (not fifo_empty) and (not rhold);

  end process;


  sel_b <= not sel;
  
  
  fifo_in(21) <= dr_in_reg and (not(dr_in));
  fifo_in(20 downto 0) <= ladd_reg;
  fifo_wrck <= clk;
  fifo_rdck <= clk;
  fifo_rst <= init;
  
  FIFO_M : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 22,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "36Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => true)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => fifo_aempty,  		-- Output almost empty 
      ALMOSTFULL  => fifo_afull,   		-- Output almost full
      DO          => fifo_out,     		-- Output data
      EMPTY       => fifo_empty,   		-- Output empty
      FULL        => fifo_full,    		-- Output full
      RDCOUNT     => fifo_rd_cnt,  		-- Output read count
      RDERR       => open,                -- Output read error
      WRCOUNT     => fifo_wr_cnt,  		-- Output write count
      WRERR       => open,                -- Output write error
      DI          => fifo_in,      		-- Input data
      RDCLK       => fifo_rdck,    				-- Input read clock
      RDEN        => fifo_rden,    		-- Input read enable
      RST         => fifo_rst,                 -- Input reset
      WRCLK       => fifo_wrck,    				-- Input write clock
      WREN        => fifo_wren     -- Input write enable
      );

omux_proc : process (dr_in,fifo_out, fifo_empty, fifo_rden, init, clk)

variable  dv_d0, dv_d1, dv_d2 : std_logic;
variable  dr_d0, dr_d1, dr_d2 : std_logic;
variable  finish_road_d0,finish_road_d1,finish_road_d2,finish_road_d3 : std_logic;

  begin

    dv_d0 := fifo_rden;

    if (init = '1') then
      dv_d1 := '0';
      dv_d2 := '0';
      temp_oadd <= (others => '0');
    elsif rising_edge(clk) then
      dv_d1 := dv_d0;
      dv_d2 := dv_d1;
      temp_oadd <= fifo_out(20 downto 0);
    end if;
    
    dr_b_out <= not dv_d2;
    
    dr_d0 := dr_in;
    
    if rising_edge(clk) then
      dr_d1 := dr_d0;
      dr_d2 := dr_d1;
    end if;

--    finish_road_d0 := (not dr_d0) and (not dr_d1) and (not dr_d2) and (fifo_empty);
    finish_road_d0 := fifo_rden and fifo_out(21);
 
    if rising_edge(clk) then
      finish_road_d1 := finish_road_d0;
      finish_road_d2 := finish_road_d1;
      finish_road_d3 := finish_road_d2;
    end if;

    finish_road <= finish_road_d3;
    
  end process;

  oadd <= std_logic_vector(to_unsigned(port_addr, 2)) & temp_oadd;

-- code originally in the road_flux module

	-- board address (not used)
	-- board_addr <= (others => '0');
  board_addr <= z(1 downto 0) & phi(1 downto 0);
	
	--insert three bit of tag, the number of the board and the road address
	--the three first bit is: rse_flag & ree_flag & rpe_flag (for normal road 0 0 1)

	int_add <= ("001" & board_addr & oadd);
	
	--create the word of end event considering the tag_event of input
	--the three first bit is: rse_flag & ree_flag & rpe_flag (for ee word 1 1 1)
	ee_word <= ("1110" & tag_event(15 downto 11) & logic0_x9 & logic0 & tag_event(10 downto 0));
	
	--the select signal is the output of the FSM (sel_word)
	--insert a mux with two input: road from LAMB or EE_word
	mux_road <= int_add when sel_word='1' else ee_word;
	
	--register of the output road the clock enable signal is the output of FSM (rpush)
	register_road: process(clk, init)
	begin
		if(init = '1') then
			road_out <= (others => '0');
		elsif(clk'EVENT and clk = '1') then
			if(rpush='1') then
				road_out <= mux_road;
			end if;
		end if;
	end process;

	--signal of data strobe for the next board 
	data_stobe_proc: process(clk, init)
	begin
		if(init = '1') then
			road_wr <= '0';
		elsif(clk'EVENT and clk = '1') then
				road_wr <= rpush;
		end if;
	end process;
  
end road_controller_arch;