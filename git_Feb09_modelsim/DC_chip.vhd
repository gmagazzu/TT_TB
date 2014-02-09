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

entity DC_chip is
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

end DC_chip;

architecture DC_chip_architecture of DC_chip is

constant NL : integer := 6;
constant NFE : integer := 8;

type fe_stub_array is array (2 downto 0) of std_logic_vector(12 downto 0);
type stub_array is array (NFE-1 downto 0) of fe_stub_array;
signal stub : stub_array;

type stub_dv_array is array (NFE-1 downto 0) of std_logic_vector(2 downto 0);
signal stub_dv : stub_dv_array;

type state_type is (S0_0,S0_1,S0_2,S0_3,S0_4,S0_5,S0_6,S0_7,S1_0,S1_1,S1_2,S1_3,S1_4,S1_5,S1_6,S1_7);

signal next_state, current_state : state_type;

signal data_0_en, data_0_rst, data_0_ld : std_logic;
signal data_1_en, data_1_rst, data_1_ld : std_logic;
signal out_sel : std_logic;

signal ts, reg_ts : integer := 0;

type data_array is array (11 downto 0) of std_logic_vector(19 downto 0);
signal data_0, data_1 : data_array;

type data_out_array is array (7 downto 0) of std_logic_vector(29 downto 0);
signal dc_out_0, reg_dc_out_0, dc_out_1, reg_dc_out_1 : data_out_array;

begin

  stub_dv(0) <=  fe0_stub_dv;
  stub(0)(0) <=  fe0_stub_d0;
  stub(0)(1) <=  fe0_stub_d1;
  stub(0)(2) <=  fe0_stub_d2;
  stub_dv(1) <=  fe1_stub_dv;
  stub(1)(0) <=  fe1_stub_d0;
  stub(1)(1) <=  fe1_stub_d1;
  stub(1)(2) <=  fe1_stub_d2;
  stub_dv(2) <=  fe2_stub_dv;
  stub(2)(0) <=  fe2_stub_d0;
  stub(2)(1) <=  fe2_stub_d1;
  stub(2)(2) <=  fe2_stub_d2;
  stub_dv(3) <=  fe3_stub_dv;
  stub(3)(0) <=  fe3_stub_d0;
  stub(3)(1) <=  fe3_stub_d1;
  stub(3)(2) <=  fe3_stub_d2;
  stub_dv(4) <=  fe4_stub_dv;
  stub(4)(0) <=  fe4_stub_d0;
  stub(4)(1) <=  fe4_stub_d1;
  stub(4)(2) <=  fe4_stub_d2;
  stub_dv(5) <=  fe5_stub_dv;
  stub(5)(0) <=  fe5_stub_d0;
  stub(5)(1) <=  fe5_stub_d1;
  stub(5)(2) <=  fe5_stub_d2;
  stub_dv(6) <=  fe6_stub_dv;
  stub(6)(0) <=  fe6_stub_d0;
  stub(6)(1) <=  fe6_stub_d1;
  stub(6)(2) <=  fe6_stub_d2;
  stub_dv(7) <=  fe7_stub_dv;
  stub(7)(0) <=  fe7_stub_d0;
  stub(7)(1) <=  fe7_stub_d1;
  stub(7)(2) <=  fe7_stub_d2;

fsm_state_regs : process (next_state, rst, clk)

  begin
    if (rst = '1') then
      current_state <= S0_0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

end process;

fsm_comb_logic : process(current_state)

  begin
    
    case current_state is

      when S0_0 =>
        ts <= 0; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '1'; 
        data_1_ld <= '1'; 
        out_sel <= '0'; 
        next_state <= S0_1;

      when S0_1 =>
        ts <= 1; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_2;

      when S0_2 =>
        ts <= 2; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_3;

      when S0_3 =>
        ts <= 3; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_4;

      when S0_4 =>
        ts <= 4; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_5;

      when S0_5 =>
        ts <= 5; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_6;

      when S0_6 =>
        ts <= 6; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S0_7;

      when S0_7 =>
        ts <= 7; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S1_0;

      when S1_0 =>
        ts <= 0; 
        data_0_en <= '0'; 
        data_0_rst <= '1'; 
        data_0_ld <= '1'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S1_1;

      when S1_1 =>
        ts <= 1; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_2;

      when S1_2 =>
        ts <= 2; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_3;

      when S1_3 =>
        ts <= 3; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_4;

      when S1_4 =>
        ts <= 4; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_5;

      when S1_5 =>
        ts <= 5; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_6;

      when S1_6 =>
        ts <= 6; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_7;

      when S1_7 =>
        ts <= 7; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S0_0;


      when others =>
        ts <= 0; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S1_0;

    end case;
    
  end process;

data_0_gen_proc: process (data_0_en,data_0_rst,stub,stub_dv,ts,clk)

variable current_stub : integer;

begin

	if (rising_edge(clk)) then
    if (data_0_rst = '1') then
      for I in 0 to 11 loop
        data_0(I) <= (others => '0');
      end loop;
      current_stub := 0;
    elsif (data_0_en = '1') then
      for I in 0 to NFE-1 loop
        for J in 0 to 2 loop
          if (stub_dv(I)(J) = '1') then
            data_0(current_stub)(12 downto 0) <= stub(I)(J);
            data_0(current_stub)(15 downto 13) <= std_logic_vector(to_unsigned(I, 3));
            data_0(current_stub)(18 downto 16) <= std_logic_vector(to_unsigned(ts, 3));
            data_0(current_stub)(19) <= '1';
            current_stub := current_stub + 1;
          end if;
        end loop;
      end loop;
    end if;  
  end if;  

end process;

data_1_gen_proc: process (data_1_en,data_1_rst,stub,stub_dv,ts,clk)

variable current_stub : integer;

begin

	if (rising_edge(clk)) then
    if (data_1_rst = '1') then
      for I in 0 to 11 loop
        data_1(I) <= (others => '0');
      end loop;
      current_stub := 0;
    elsif (data_1_en = '1') then
      for I in 0 to NFE-1 loop
        for J in 0 to 2 loop
          if (stub_dv(I)(J) = '1') then
            data_1(current_stub)(12 downto 0) <= stub(I)(J);
            data_1(current_stub)(15 downto 13) <= std_logic_vector(to_unsigned(I, 3));
            data_1(current_stub)(18 downto 16) <= std_logic_vector(to_unsigned(ts, 3));
            data_1(current_stub)(19) <= '1';
            current_stub := current_stub + 1;
          end if;
        end loop;
      end loop;
    end if;  
  end if;  

end process;

out_reg_proc: process (data_0,data_0_ld,dc_out_0,data_1,data_1_ld,dc_out_1,ts,reg_ts,clk)

begin

  dc_out_0(0)(29 downto 10) <= data_0(0)(19 downto 0);
  dc_out_0(0)(9 downto 0)   <= data_0(1)(19 downto 10);
  dc_out_0(1)(29 downto 20) <= data_0(1)(9 downto 0);
  dc_out_0(1)(19 downto 0)  <= data_0(2)(19 downto 0);
  dc_out_0(2)(29 downto 10) <= data_0(3)(19 downto 0);
  dc_out_0(2)(9 downto 0)   <= data_0(4)(19 downto 10);
  dc_out_0(3)(29 downto 20) <= data_0(4)(9 downto 0);
  dc_out_0(3)(19 downto 0)  <= data_0(5)(19 downto 0);
  dc_out_0(4)(29 downto 10) <= data_0(6)(19 downto 0);
  dc_out_0(4)(9 downto 0)   <= data_0(7)(19 downto 10);
  dc_out_0(5)(29 downto 20) <= data_0(7)(9 downto 0);
  dc_out_0(5)(19 downto 0)  <= data_0(8)(19 downto 0);
  dc_out_0(6)(29 downto 10) <= data_0(9)(19 downto 0);
  dc_out_0(6)(9 downto 0)   <= data_0(10)(19 downto 10);
  dc_out_0(7)(29 downto 20) <= data_0(10)(9 downto 0);
  dc_out_0(7)(19 downto 0)  <= data_0(11)(19 downto 0);
  
	if (rising_edge(clk)) and (data_0_ld = '1') then
	  reg_dc_out_0 <= dc_out_0;
  end if;

  dc_out_1(0)(29 downto 10) <= data_1(0)(19 downto 0);
  dc_out_1(0)(9 downto 0)   <= data_1(1)(19 downto 10);
  dc_out_1(1)(29 downto 20) <= data_1(1)(9 downto 0);
  dc_out_1(1)(19 downto 0)  <= data_1(2)(19 downto 0);
  dc_out_1(2)(29 downto 10) <= data_1(3)(19 downto 0);
  dc_out_1(2)(9 downto 0)   <= data_1(4)(19 downto 10);
  dc_out_1(3)(29 downto 20) <= data_1(4)(9 downto 0);
  dc_out_1(3)(19 downto 0)  <= data_1(5)(19 downto 0);
  dc_out_1(4)(29 downto 10) <= data_1(6)(19 downto 0);
  dc_out_1(4)(9 downto 0)   <= data_1(7)(19 downto 10);
  dc_out_1(5)(29 downto 20) <= data_1(7)(9 downto 0);
  dc_out_1(5)(19 downto 0)  <= data_1(8)(19 downto 0);
  dc_out_1(6)(29 downto 10) <= data_1(9)(19 downto 0);
  dc_out_1(6)(9 downto 0)   <= data_1(10)(19 downto 10);
  dc_out_1(7)(29 downto 20) <= data_1(10)(9 downto 0);
  dc_out_1(7)(19 downto 0)  <= data_1(11)(19 downto 0);
  
	if (rising_edge(clk)) and (data_1_ld = '1') then
	  reg_dc_out_1 <= dc_out_1;
  end if;

	if (rising_edge(clk)) then
    reg_ts <= ts;
  end if;

  if (out_sel = '0') then
    if (reg_ts = 0) then 
      dc_out(31 downto 30) <= "10"; 
    else 
      dc_out(31 downto 30) <= "00";
  end if;
    dc_out(29 downto 0) <= reg_dc_out_0(reg_ts);
  elsif (out_sel = '1') then
    if (reg_ts = 0) then 
      dc_out(31 downto 30) <= "11"; 
    else 
      dc_out(31 downto 30) <= "01";
  end if;
    dc_out(29 downto 0) <= reg_dc_out_1(reg_ts);
  else
    dc_out <= (others => '0');
  end if;
 
end process;
		
end DC_chip_architecture;
