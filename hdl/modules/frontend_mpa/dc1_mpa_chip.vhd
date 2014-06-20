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

entity dc1_mpa_chip is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

   fe_stub_dv : in std_logic_vector(3 downto 0);
   fe_stub_d0 : in std_logic_vector(16 downto 0);
   fe_stub_d1 : in std_logic_vector(16 downto 0);
   fe_stub_d2 : in std_logic_vector(16 downto 0);
   fe_stub_d3 : in std_logic_vector(16 downto 0);
	 dc_out : out std_logic_vector(39 downto 0)
	);

end dc1_mpa_chip;

architecture dc1_mpa_chip_architecture of dc1_mpa_chip is

constant NL : integer := 6;
constant NFE : integer := 8;

type stub_array is array (3 downto 0) of std_logic_vector(16 downto 0);
signal stub : stub_array;

signal stub_dv : std_logic_vector(3 downto 0);

type state_type is (S0_0,S0_1,S1_0,S1_1);

signal next_state, current_state : state_type;

signal data_0_en, data_0_rst, data_0_ld : std_logic;
signal data_1_en, data_1_rst, data_1_ld : std_logic;
signal out_sel : std_logic;

signal ts, reg_ts : std_logic := '0';

type data_array is array (3 downto 0) of std_logic_vector(18 downto 0);
signal data_0, data_1 : data_array;

type data_out_array is array (1 downto 0) of std_logic_vector(37 downto 0);
signal dc_out_0, reg_dc_out_0, dc_out_1, reg_dc_out_1 : data_out_array;

begin

  stub_dv <=  fe_stub_dv;
  stub(0) <=  fe_stub_d0;
  stub(1) <=  fe_stub_d1;
  stub(2) <=  fe_stub_d2;
  stub(3) <=  fe_stub_d3;

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
        ts <= '0'; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '1'; 
        data_1_ld <= '1'; 
        out_sel <= '0'; 
        next_state <= S0_1;

      when S0_1 =>
        ts <= '1'; 
        data_0_en <= '1'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S1_0;

      when S1_0 =>
        ts <= '0'; 
        data_0_en <= '0'; 
        data_0_rst <= '1'; 
        data_0_ld <= '1'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '1'; 
        next_state <= S1_1;

      when S1_1 =>
        ts <= '1'; 
        data_0_en <= '0'; 
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_en <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        out_sel <= '0'; 
        next_state <= S0_0;

      when others =>
        ts <= '0'; 
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
      for I in 0 to 3 loop
        data_0(I) <= (others => '0');
      end loop;
      current_stub := 0;
    elsif (data_0_en = '1') then
      current_stub := 0;
      for I in 0 to 3 loop
        if (stub_dv(I) = '1') then
          data_0(current_stub)(16 downto 0) <= stub(I);
          data_0(current_stub)(17) <= ts;
          data_0(current_stub)(18) <= '1';
          current_stub := current_stub + 1;
        end if;
      end loop;
    end if;  
  end if;  

end process;

data_1_gen_proc: process (data_1_en,data_1_rst,stub,stub_dv,ts,clk)

variable current_stub : integer;

begin

	if (rising_edge(clk)) then
    if (data_1_rst = '1') then
      for I in 0 to 3 loop
        data_1(I) <= (others => '0');
      end loop;
      current_stub := 0;
    elsif (data_1_en = '1') then
      current_stub := 0;
      for I in 0 to 3 loop
        if (stub_dv(I) = '1') then
          data_1(current_stub)(16 downto 0) <= stub(I);
          data_1(current_stub)(17) <= ts;
          data_1(current_stub)(18) <= '1';
          current_stub := current_stub + 1;
        end if;
      end loop;
    end if;  
  end if;  

end process;

out_reg_proc: process (data_0,data_0_ld,dc_out_0,data_1,data_1_ld,dc_out_1,ts,reg_ts,clk)

begin

  dc_out_0(0)(18 downto 0)  <= data_0(0)(18 downto 0);
  dc_out_0(0)(37 downto 19) <= data_0(1)(18 downto 0);
  dc_out_0(1)(18 downto 0) <= data_0(2)(18 downto 0);
  dc_out_0(1)(37 downto 19)  <= data_0(3)(18 downto 0);
  
	if (rising_edge(clk)) and (data_0_ld = '1') then
	  reg_dc_out_0 <= dc_out_0;
  end if;

  dc_out_1(0)(18 downto 0)  <= data_1(0)(18 downto 0);
  dc_out_1(0)(37 downto 19) <= data_1(1)(18 downto 0);
  dc_out_1(1)(18 downto 0) <= data_1(2)(18 downto 0);
  dc_out_1(1)(37 downto 19)  <= data_1(3)(18 downto 0);
  
	if (rising_edge(clk)) and (data_1_ld = '1') then
	  reg_dc_out_1 <= dc_out_1;
  end if;

	if (rising_edge(clk)) then
    reg_ts <= ts;
  end if;

  if (out_sel = '0') then
    if (reg_ts = '0') then 
      dc_out(39 downto 38) <= "10"; 
      dc_out(37 downto 0) <= reg_dc_out_0(0);
    else 
      dc_out(39 downto 38) <= "00";
      dc_out(37 downto 0) <= reg_dc_out_0(1);
    end if;
  elsif (out_sel = '1') then
    if (reg_ts = '0') then 
      dc_out(39 downto 38) <= "11"; 
      dc_out(37 downto 0) <= reg_dc_out_1(0);
    else 
      dc_out(39 downto 38) <= "01";
      dc_out(37 downto 0) <= reg_dc_out_1(1);
    end if;
  else
    dc_out <= (others => '0');
  end if;
 
end process;
		
end dc1_mpa_chip_architecture;
