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

entity FM_fpga is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   stub_in_dv : in std_logic_vector(11 downto 0);

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
   stub_in_10 : in std_logic_vector(15 downto 0);
   stub_in_11 : in std_logic_vector(15 downto 0);

   stub_out_dv : out std_logic_vector(3 downto 0);

   stub_out_0 : out std_logic_vector(15 downto 0);
   stub_out_1 : out std_logic_vector(15 downto 0);
   stub_out_2 : out std_logic_vector(15 downto 0);
   stub_out_3 : out std_logic_vector(15 downto 0)
	
	);

end FM_fpga;

architecture FM_fpga_architecture of FM_fpga is

constant NL : integer := 6;
constant NFE : integer := 8;

type state_type is (S0_0,S0_1,S0_2,S0_3,S1_0,S1_1,S1_2,S1_3,S2_0,S2_1,S2_2,S2_3,S3_0,S3_1,S3_2,S3_3);

signal next_state, current_state : state_type;

type stub_in_vec is array (11 downto 0) of std_logic_vector(15 downto 0);
signal stub_in : stub_in_vec;

type stub_out_vec is array (3 downto 0) of std_logic_vector(15 downto 0);
signal stub_out : stub_out_vec;

--type fifo_array is array (11 downto 0) of std_logic_vector(15 downto 0);
type fifo_array is array (11 downto 0) of std_logic_vector(16 downto 0);
type fifo_arrays is array (3 downto 0) of fifo_array;
signal fifo : fifo_arrays;

type fifo_rden_array is array (3 downto 0) of std_logic_vector(11 downto 0);
signal fifo_rden : fifo_rden_array;

signal fifo_wren : std_logic_vector(3 downto 0);


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
stub_in(10) <= stub_in_10;
stub_in(11) <= stub_in_11;

case (stub_in_dv) is
  when "000000000001" => last_stub <= "0000000000010";
  when "000000000011" => last_stub <= "0000000000100";
  when "000000000111" => last_stub <= "0000000001000";
  when "000000001111" => last_stub <= "0000000010000";
  when "000000011111" => last_stub <= "0000000100000";
  when "000000111111" => last_stub <= "0000001000000";
  when "000001111111" => last_stub <= "0000010000000";
  when "000011111111" => last_stub <= "0000100000000";
  when "000111111111" => last_stub <= "0001000000000";
  when "001111111111" => last_stub <= "0010000000000";
  when "011111111111" => last_stub <= "0100000000000";
  when "111111111111" => last_stub <= "1000000000000";
  when others => last_stub <= "0000000000000";
end case;

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
        fifo_wren <= "0001";
        fifo_rden(0) <= "000000000000"; -- 0x000
        fifo_rden(1) <= "000100000000"; -- 0x100
        fifo_rden(2) <= "000000010000"; -- 0x010
        fifo_rden(3) <= "000000000001"; -- 0x001
        next_state <= S0_1;

      when S0_1 =>
        fifo_wren <= "0001";
        fifo_rden(0) <= "000000000000"; -- 0x000
        fifo_rden(1) <= "001000000000"; -- 0x200
        fifo_rden(2) <= "000000100000"; -- 0x020
        fifo_rden(3) <= "000000000010"; -- 0x002
        next_state <= S0_2;

      when S0_2 =>
        fifo_wren <= "0001";
        fifo_rden(0) <= "000000000000"; -- 0x000
        fifo_rden(1) <= "010000000000"; -- 0x400
        fifo_rden(2) <= "000001000000"; -- 0x040
        fifo_rden(3) <= "000000000100"; -- 0x004
        next_state <= S0_3;

      when S0_3 =>
        fifo_wren <= "0001";
        fifo_rden(0) <= "000000000000"; -- 0x000
        fifo_rden(1) <= "100000000000"; -- 0x800
        fifo_rden(2) <= "000010000000"; -- 0x080
        fifo_rden(3) <= "000000001000"; -- 0x008
        next_state <= S1_0;

      when S1_0 =>
        fifo_wren <= "0010";
        fifo_rden(0) <= "000000000001"; -- 0x001
        fifo_rden(1) <= "000000000000"; -- 0x000
        fifo_rden(2) <= "000100000000"; -- 0x100
        fifo_rden(3) <= "000000010000"; -- 0x010
        next_state <= S1_1;

      when S1_1 =>
        fifo_wren <= "0010";
        fifo_rden(0) <= "000000000010"; -- 0x002
        fifo_rden(1) <= "000000000000"; -- 0x000
        fifo_rden(2) <= "001000000000"; -- 0x200
        fifo_rden(3) <= "000000100000"; -- 0x020
        next_state <= S1_2;

      when S1_2 =>
        fifo_wren <= "0010";
        fifo_rden(0) <= "000000000100"; -- 0x004
        fifo_rden(1) <= "000000000000"; -- 0x000
        fifo_rden(2) <= "010000000000"; -- 0x400
        fifo_rden(3) <= "000001000000"; -- 0x040
        next_state <= S1_3;

      when S1_3 =>
        fifo_wren <= "0010";
        fifo_rden(0) <= "000000001000"; -- 0x008
        fifo_rden(1) <= "000000000000"; -- 0x000
        fifo_rden(2) <= "100000000000"; -- 0x800
        fifo_rden(3) <= "000010000000"; -- 0x080
        next_state <= S2_0;

      when S2_0 =>
        fifo_wren <= "0100";
        fifo_rden(0) <= "000000010000"; -- 0x010
        fifo_rden(1) <= "000000000001"; -- 0x001
        fifo_rden(2) <= "000000000000"; -- 0x000
        fifo_rden(3) <= "000100000000"; -- 0x100
        next_state <= S2_1;

      when S2_1 =>
        fifo_wren <= "0100";
        fifo_rden(0) <= "000000100000"; -- 0x020
        fifo_rden(1) <= "000000000010"; -- 0x002
        fifo_rden(2) <= "000000000000"; -- 0x000
        fifo_rden(3) <= "001000000000"; -- 0x200
        next_state <= S2_2;

      when S2_2 =>
        fifo_wren <= "0100";
        fifo_rden(0) <= "000001000000"; -- 0x040
        fifo_rden(1) <= "000000000100"; -- 0x004
        fifo_rden(2) <= "000000000000"; -- 0x000
        fifo_rden(3) <= "010000000000"; -- 0x400
        next_state <= S2_3;

      when S2_3 =>
        fifo_wren <= "0100";
        fifo_rden(0) <= "000010000000"; -- 0x080
        fifo_rden(1) <= "000000001000"; -- 0x008
        fifo_rden(2) <= "000000000000"; -- 0x000
        fifo_rden(3) <= "100000000000"; -- 0x800
        next_state <= S3_0;

      when S3_0 =>
        fifo_wren <= "1000";
        fifo_rden(0) <= "000100000000"; -- 0x100
        fifo_rden(1) <= "000000010000"; -- 0x010
        fifo_rden(2) <= "000000000001"; -- 0x001
        fifo_rden(3) <= "000000000000"; -- 0x000
        next_state <= S3_1;

      when S3_1 =>
        fifo_wren <= "1000";
        fifo_rden(0) <= "001000000000"; -- 0x200
        fifo_rden(1) <= "000000100000"; -- 0x020
        fifo_rden(2) <= "000000000010"; -- 0x002
        fifo_rden(3) <= "000000000000"; -- 0x000
        next_state <= S3_2;

      when S3_2 =>
        fifo_wren <= "1000";
        fifo_rden(0) <= "010000000000"; -- 0x400
        fifo_rden(1) <= "000001000000"; -- 0x040
        fifo_rden(2) <= "000000000100"; -- 0x004
        fifo_rden(3) <= "000000000000"; -- 0x000
        next_state <= S3_3;

      when S3_3 =>
        fifo_wren <= "1000";
        fifo_rden(0) <= "100000000000"; -- 0x800
        fifo_rden(1) <= "000010000000"; -- 0x080
        fifo_rden(2) <= "000000001000"; -- 0x008
        fifo_rden(3) <= "000000000000"; -- 0x000
        next_state <= S0_0;

      when others =>
        fifo_wren <= "0000";
        fifo_rden(0) <= "000000000000"; -- 0x000
        fifo_rden(1) <= "000000000000"; -- 0x000
        fifo_rden(2) <= "000000000000"; -- 0x000
        fifo_rden(3) <= "000000000000"; -- 0x000
        next_state <= S0_0;

    end case;
    
  end process;


fifo_proc: process (fifo_wren,fifo_rden,clk)

begin

	if (rising_edge(clk)) then
    for I in 0 to 3 loop
      if (fifo_wren(I) = '1') then
        for J in 0 to 11 loop
          fifo(I)(J) <= stub_in_dv(J) & stub_in(J);
        end loop;
      end if;
      case (fifo_rden(I)) is
--        when "000000000001" => stub_out(I) <= fifo(I)(0);
--        when "000000000010" => stub_out(I) <= fifo(I)(1);
--        when "000000000100" => stub_out(I) <= fifo(I)(2);
--        when "000000001000" => stub_out(I) <= fifo(I)(3);
--        when "000000010000" => stub_out(I) <= fifo(I)(4);
--        when "000000100000" => stub_out(I) <= fifo(I)(5);
--        when "000001000000" => stub_out(I) <= fifo(I)(6);
--        when "000010000000" => stub_out(I) <= fifo(I)(7);
--        when "000100000000" => stub_out(I) <= fifo(I)(8);
--        when "001000000000" => stub_out(I) <= fifo(I)(9);
--        when "010000000000" => stub_out(I) <= fifo(I)(10);
--        when "100000000000" => stub_out(I) <= fifo(I)(11);
--        when others => stub_out(I) <= (others => '0');
        when "000000000001" => stub_out_dv(I) <= fifo(I)(0)(16); stub_out(I) <= fifo(I)(0)(15 downto 0);
        when "000000000010" => stub_out_dv(I) <= fifo(I)(1)(16); stub_out(I) <= fifo(I)(1)(15 downto 0);
        when "000000000100" => stub_out_dv(I) <= fifo(I)(2)(16); stub_out(I) <= fifo(I)(2)(15 downto 0);
        when "000000001000" => stub_out_dv(I) <= fifo(I)(3)(16); stub_out(I) <= fifo(I)(3)(15 downto 0);
        when "000000010000" => stub_out_dv(I) <= fifo(I)(4)(16); stub_out(I) <= fifo(I)(4)(15 downto 0);
        when "000000100000" => stub_out_dv(I) <= fifo(I)(5)(16); stub_out(I) <= fifo(I)(5)(15 downto 0);
        when "000001000000" => stub_out_dv(I) <= fifo(I)(6)(16); stub_out(I) <= fifo(I)(6)(15 downto 0);
        when "000010000000" => stub_out_dv(I) <= fifo(I)(7)(16); stub_out(I) <= fifo(I)(7)(15 downto 0);
        when "000100000000" => stub_out_dv(I) <= fifo(I)(8)(16); stub_out(I) <= fifo(I)(8)(15 downto 0);
        when "001000000000" => stub_out_dv(I) <= fifo(I)(9)(16); stub_out(I) <= fifo(I)(9)(15 downto 0);
        when "010000000000" => stub_out_dv(I) <= fifo(I)(10)(16); stub_out(I) <= fifo(I)(10)(15 downto 0);
        when "100000000000" => stub_out_dv(I) <= fifo(I)(11)(16); stub_out(I) <= fifo(I)(11)(15 downto 0);
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
