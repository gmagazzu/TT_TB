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

entity mpa_fifo_manager is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   x6_stub_in_dv : in std_logic;
   
   n_stub_in_dv : in std_logic;

   n_stub_in : in std_logic_vector(15 downto 0);

   p_stub_in_dv : in std_logic;

   p_stub_in : in std_logic_vector(15 downto 0);

   stub_in_dv : in std_logic_vector(9 downto 0);

   stub_in_0 : in std_logic_vector(15 downto 0);
   stub_in_1 : in std_logic_vector(15 downto 0);
   stub_in_2 : in std_logic_vector(15 downto 0);
   stub_in_3 : in std_logic_vector(15 downto 0);
   stub_in_4 : in std_logic_vector(15 downto 0);
   stub_in_5 : in std_logic_vector(15 downto 0);
   stub_in_6 : in std_logic_vector(15 downto 0);
   stub_in_7 : in std_logic_vector(15 downto 0);
   stub_in_8 : in std_logic_vector(15 downto 0);
   stub_in_9 : in std_logic_vector(15 downto 0);

   stub_out_dv : out std_logic_vector(3 downto 0);

   stub_out_0 : out std_logic_vector(16 downto 0);
   stub_out_1 : out std_logic_vector(16 downto 0);
   stub_out_2 : out std_logic_vector(16 downto 0);
   stub_out_3 : out std_logic_vector(16 downto 0)
	
	);

end mpa_fifo_manager;

architecture FM_fpga_architecture of mpa_fifo_manager is

constant NL : integer := 6;
constant NFE : integer := 8;

type state_type is (S0_0,S0_1,S0_2,S0_3,S1_0,S1_1,S1_2,S1_3,S2_0,S2_1,S2_2,S2_3,S3_0,S3_1,S3_2,S3_3);

signal next_state, current_state : state_type;

type stub_in_vec is array (9 downto 0) of std_logic_vector(15 downto 0);
signal stub_in : stub_in_vec;

-- Jan 4
-- type stub_out_vec is array (3 downto 0) of std_logic_vector(15 downto 0);
type stub_out_vec is array (3 downto 0) of std_logic_vector(16 downto 0);
signal stub_out : stub_out_vec;

-- type fifo_array is array (11 downto 0) of std_logic_vector(15 downto 0);
-- Jan 4
-- type fifo_array is array (11 downto 0) of std_logic_vector(16 downto 0);
type fifo_array is array (14 downto 0) of std_logic_vector(17 downto 0);
type fifo_arrays is array (3 downto 0) of fifo_array;
signal fifo : fifo_arrays;

-- Jan 4
-- type fifo_rden_array is array (3 downto 0) of std_logic_vector(11 downto 0);
type fifo_rden_array is array (3 downto 0) of std_logic_vector(12 downto 0);
signal fifo_rden : fifo_rden_array;

signal fifo_wren : std_logic_vector(3 downto 0);

signal ts_cnt_en : std_logic;
signal ts_cnt : std_logic_vector(15 downto 0);
signal reg_ts_cnt : std_logic_vector(15 downto 0);

begin

stub_in(0) <= stub_in_0;
stub_in(1) <= stub_in_1;
stub_in(2) <= stub_in_2;
stub_in(3) <= stub_in_3;
stub_in(4) <= stub_in_4;
stub_in(5) <= stub_in_5;
stub_in(6) <= stub_in_6;
stub_in(7) <= stub_in_7;
stub_in(8) <= stub_in_8;
stub_in(9) <= stub_in_9;

ts_reg_proc : process (rst,clk,ts_cnt,x6_stub_in_dv)

  begin
    if (rst = '1') then
      reg_ts_cnt <= (others => '0');
    elsif rising_edge(clk) and (x6_stub_in_dv = '1') then
      reg_ts_cnt <= ts_cnt;
    end if;

end process;

ts_cnt_proc : process (rst,clk)

  begin
    if (rst = '1') then
      ts_cnt <= (others => '0');
    elsif rising_edge(clk) and (ts_cnt_en = '1') then
      ts_cnt <= ts_cnt + 1;
    end if;

end process;

fsm_state_regs : process (next_state,rst,clk)

  begin
    if (rst = '1') then
      current_state <= S0_0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

end process;

fsm_comb_logic : process(current_state,stub_in)

  begin
    
    case current_state is

      when S0_0 =>
        ts_cnt_en <= '1';
        fifo_wren <= "0001";
        fifo_rden(0) <= "1000000000000"; -- 0x1000
        fifo_rden(1) <= "0000100000000"; -- 0x0100
        fifo_rden(2) <= "0000000010000"; -- 0x0010
        fifo_rden(3) <= "0000000000001"; -- 0x0001
        next_state <= S0_1;

      when S0_1 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0001";
        fifo_rden(0) <= "0000000000000"; -- 0x0000
        fifo_rden(1) <= "0001000000000"; -- 0x0200
        fifo_rden(2) <= "0000000100000"; -- 0x0020
        fifo_rden(3) <= "0000000000010"; -- 0x0002
        next_state <= S0_2;

      when S0_2 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0001";
        fifo_rden(0) <= "0000000000000"; -- 0x0000
        fifo_rden(1) <= "0010000000000"; -- 0x0400
        fifo_rden(2) <= "0000001000000"; -- 0x0040
        fifo_rden(3) <= "0000000000100"; -- 0x0004
        next_state <= S0_3;

      when S0_3 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0001";
        fifo_rden(0) <= "0000000000000"; -- 0x0000
        fifo_rden(1) <= "0100000000000"; -- 0x0800
        fifo_rden(2) <= "0000010000000"; -- 0x0080
        fifo_rden(3) <= "0000000001000"; -- 0x0008
        next_state <= S1_0;

      when S1_0 =>
        ts_cnt_en <= '1';
        fifo_wren <= "0010";
        fifo_rden(0) <= "0000000000001"; -- 0x0001
        fifo_rden(1) <= "1000000000000"; -- 0x1000
        fifo_rden(2) <= "0000100000000"; -- 0x0100
        fifo_rden(3) <= "0000000010000"; -- 0x0010
        next_state <= S1_1;

      when S1_1 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0010";
        fifo_rden(0) <= "0000000000010"; -- 0x0002
        fifo_rden(1) <= "0000000000000"; -- 0x0000
        fifo_rden(2) <= "0001000000000"; -- 0x0200
        fifo_rden(3) <= "0000000100000"; -- 0x0020
        next_state <= S1_2;

      when S1_2 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0010";
        fifo_rden(0) <= "0000000000100"; -- 0x0040
        fifo_rden(1) <= "0000000000000"; -- 0x0001
        fifo_rden(2) <= "0010000000000"; -- 0x0400
        fifo_rden(3) <= "0000001000000"; -- 0x0040
        next_state <= S1_3;

      when S1_3 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0010";
        fifo_rden(0) <= "0000000001000"; -- 0x0008
        fifo_rden(1) <= "0000000000000"; -- 0x0000
        fifo_rden(2) <= "0100000000000"; -- 0x0800
        fifo_rden(3) <= "0000010000000"; -- 0x0080
        next_state <= S2_0;

      when S2_0 =>
        ts_cnt_en <= '1';
        fifo_wren <= "0100";
        fifo_rden(0) <= "0000000010000"; -- 0x0010
        fifo_rden(1) <= "0000000000001"; -- 0x0001
        fifo_rden(2) <= "1000000000000"; -- 0x1000
        fifo_rden(3) <= "0000100000000"; -- 0x0100
        next_state <= S2_1;

      when S2_1 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0100";
        fifo_rden(0) <= "0000000100000"; -- 0x0020
        fifo_rden(1) <= "0000000000010"; -- 0x0002
        fifo_rden(2) <= "0000000000000"; -- 0x0000
        fifo_rden(3) <= "0001000000000"; -- 0x0200
        next_state <= S2_2;

      when S2_2 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0100";
        fifo_rden(0) <= "0000001000000"; -- 0x0040
        fifo_rden(1) <= "0000000000100"; -- 0x0004
        fifo_rden(2) <= "0000000000000"; -- 0x0000
        fifo_rden(3) <= "0010000000000"; -- 0x0400
        next_state <= S2_3;

      when S2_3 =>
        ts_cnt_en <= '0';
        fifo_wren <= "0100";
        fifo_rden(0) <= "0000010000000"; -- 0x0080
        fifo_rden(1) <= "0000000001000"; -- 0x0008
        fifo_rden(2) <= "0000000000000"; -- 0x0000
        fifo_rden(3) <= "0100000000000"; -- 0x0800
        next_state <= S3_0;

      when S3_0 =>
        ts_cnt_en <= '1';
        fifo_wren <= "1000";
        fifo_rden(0) <= "0000100000000"; -- 0x0100
        fifo_rden(1) <= "0000000010000"; -- 0x0010
        fifo_rden(2) <= "0000000000001"; -- 0x0001
        fifo_rden(3) <= "1000000000000"; -- 0x1000
        next_state <= S3_1;

      when S3_1 =>
        ts_cnt_en <= '0';
        fifo_wren <= "1000";
        fifo_rden(0) <= "0001000000000"; -- 0x0200
        fifo_rden(1) <= "0000000100000"; -- 0x0020
        fifo_rden(2) <= "0000000000010"; -- 0x0002
        fifo_rden(3) <= "0000000000000"; -- 0x0000
        next_state <= S3_2;

      when S3_2 =>
        ts_cnt_en <= '0';
        fifo_wren <= "1000";
        fifo_rden(0) <= "0010000000000"; -- 0x0400
        fifo_rden(1) <= "0000001000000"; -- 0x0040
        fifo_rden(2) <= "0000000000100"; -- 0x0004
        fifo_rden(3) <= "0000000000000"; -- 0x0001
        next_state <= S3_3;

      when S3_3 =>
        ts_cnt_en <= '0';
        fifo_wren <= "1000";
        fifo_rden(0) <= "0100000000000"; -- 0x0800
        fifo_rden(1) <= "0000010000000"; -- 0x0080
        fifo_rden(2) <= "0000000001000"; -- 0x0008
        fifo_rden(3) <= "0000000000000"; -- 0x0002
        next_state <= S0_0;

      when others =>
        ts_cnt_en <= '0';
        fifo_wren <= "0000";
        fifo_rden(0) <= "0000000000000"; -- 0x0000
        fifo_rden(1) <= "0000000000000"; -- 0x0000
        fifo_rden(2) <= "0000000000000"; -- 0x0000
        fifo_rden(3) <= "0000000000000"; -- 0x0000
        next_state <= S0_0;

    end case;
    
  end process;


fifo_proc: process (fifo,stub_out,stub_in_dv,stub_in,fifo_wren,fifo_rden,ts_cnt,reg_ts_cnt,x6_stub_in_dv,n_stub_in_dv,n_stub_in,p_stub_in_dv,p_stub_in,clk)

begin

	if (rising_edge(clk)) then
    for I in 0 to 3 loop
--      if (fifo_wren(I) = '1') and (hits_somewhere = '1') then
--        if (stub_in_dv(0) = '1') then
--          fifo(I)(0) <= stub_in_dv(0) & '0' & stub_in(0);
--        else
--          fifo(I)(0) <= "11" & ts_cnt;
--        end if;
--      end if;

-- GM - May 27 - begin
--      if (fifo_wren(I) = '1') then
--        fifo(I)(0) <= stub_in_dv(0) & '0' & stub_in(0);
      if (rst = '1') then
        for J in 0 to 12 loop
          fifo(I)(J) <= (others => '0');
        end loop;
      elsif (fifo_wren(I) = '1') and (x6_stub_in_dv = '1') then
        if (stub_in_dv(0) = '1') then
          fifo(I)(0) <= stub_in_dv(0) & '0' & stub_in(0);
        elsif (n_stub_in_dv = '1') then
          fifo(I)(0) <= n_stub_in_dv & '0' & n_stub_in;
        elsif (p_stub_in_dv = '1') then
          fifo(I)(0) <= p_stub_in_dv & '0' & p_stub_in;
        else  
          fifo(I)(0) <= "11" & ts_cnt;
        end if;
-- GM - May 27 - end 
        for J in 1 to 9 loop
          if (stub_in_dv(J) = '1') then
            fifo(I)(J) <= stub_in_dv(J) & '0' & stub_in(J);
          elsif (stub_in_dv(J) = '0') and (stub_in_dv(J-1) = '1') and (n_stub_in_dv = '1') then
            fifo(I)(J) <= n_stub_in_dv & '0' & n_stub_in;
          elsif (stub_in_dv(J) = '0') and (stub_in_dv(J-1) = '1') and (n_stub_in_dv = '0') and (p_stub_in_dv = '1') then
            fifo(I)(J) <= p_stub_in_dv & '0' & p_stub_in;
          elsif (stub_in_dv(J) = '0') and (stub_in_dv(J-1) = '1') and (n_stub_in_dv = '0') and (p_stub_in_dv = '0') then
            fifo(I)(J) <= "11" & reg_ts_cnt;
          else
            fifo(I)(J) <= (others => '0');
          end if;
          if (stub_in_dv(9) = '1') and (n_stub_in_dv = '1') and (p_stub_in_dv = '1') then
            fifo(I)(12) <= n_stub_in_dv & '0' & n_stub_in;
            fifo(I)(13) <= p_stub_in_dv & '0' & p_stub_in;
            fifo(I)(14) <= "11" & reg_ts_cnt;
          elsif (stub_in_dv(9) = '1') and (n_stub_in_dv = '1') and (p_stub_in_dv = '0') then
            fifo(I)(12) <= n_stub_in_dv & '0' & n_stub_in;
            fifo(I)(13) <= "11" & reg_ts_cnt;
            fifo(I)(14) <= (others => '0');
          elsif (stub_in_dv(9) = '1') and (n_stub_in_dv = '0') and (p_stub_in_dv = '1') then
            fifo(I)(12) <= p_stub_in_dv & '0' & p_stub_in;
            fifo(I)(13) <= "11" & reg_ts_cnt;
            fifo(I)(14) <= (others => '0');
          elsif (stub_in_dv(9) = '1') and (n_stub_in_dv = '0') and (p_stub_in_dv = '0') then
            fifo(I)(12) <= "11" & reg_ts_cnt;
            fifo(I)(13) <= (others => '0');
            fifo(I)(14) <= (others => '0');
          else
            fifo(I)(12) <= (others => '0');
            fifo(I)(13) <= (others => '0');
            fifo(I)(14) <= (others => '0');
          end if;
        end loop;
      elsif (fifo_wren(I) = '1') and (x6_stub_in_dv = '0') then
        for J in 0 to 12 loop
          fifo(I)(J) <= (others => '0');
        end loop;
      end if;
      case (fifo_rden(I)) is
        when "0000000000001" => stub_out_dv(I) <= fifo(I)(0)(17); stub_out(I) <= fifo(I)(0)(16 downto 0);
        when "0000000000010" => stub_out_dv(I) <= fifo(I)(1)(17); stub_out(I) <= fifo(I)(1)(16 downto 0);
        when "0000000000100" => stub_out_dv(I) <= fifo(I)(2)(17); stub_out(I) <= fifo(I)(2)(16 downto 0);
        when "0000000001000" => stub_out_dv(I) <= fifo(I)(3)(17); stub_out(I) <= fifo(I)(3)(16 downto 0);
        when "0000000010000" => stub_out_dv(I) <= fifo(I)(4)(17); stub_out(I) <= fifo(I)(4)(16 downto 0);
        when "0000000100000" => stub_out_dv(I) <= fifo(I)(5)(17); stub_out(I) <= fifo(I)(5)(16 downto 0);
        when "0000001000000" => stub_out_dv(I) <= fifo(I)(6)(17); stub_out(I) <= fifo(I)(6)(16 downto 0);
        when "0000010000000" => stub_out_dv(I) <= fifo(I)(7)(17); stub_out(I) <= fifo(I)(7)(16 downto 0);
        when "0000100000000" => stub_out_dv(I) <= fifo(I)(8)(17); stub_out(I) <= fifo(I)(8)(16 downto 0);
        when "0001000000000" => stub_out_dv(I) <= fifo(I)(9)(17); stub_out(I) <= fifo(I)(9)(16 downto 0);
        when "0010000000000" => stub_out_dv(I) <= fifo(I)(10)(17); stub_out(I) <= fifo(I)(10)(16 downto 0);
        when "0100000000000" => stub_out_dv(I) <= fifo(I)(11)(17); stub_out(I) <= fifo(I)(11)(16 downto 0);
        when "1000000000000" => stub_out_dv(I) <= fifo(I)(12)(17); stub_out(I) <= fifo(I)(12)(16 downto 0);
        when others => stub_out_dv(I) <= '0'; stub_out(I) <= (others => '0');
      end case;
    end loop;
  end if;  
  
end process;

stub_out_0 <= stub_out(0);
stub_out_1 <= stub_out(1);
stub_out_2 <= stub_out(2);
stub_out_3 <= stub_out(3);
	
end FM_fpga_architecture;
