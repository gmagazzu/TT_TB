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

entity DO_chip is
   port(
  
   clk   : in std_logic;
   rst   : in std_logic;

-- Jan 4
	 phi : in std_logic_vector(3 downto 0);
	 z : in std_logic_vector(3 downto 0);

	 do_in : in std_logic_vector(31 downto 0);

   stub_dv  : out std_logic_vector(11 downto 0);

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

end DO_chip;

architecture DO_chip_architecture of DO_chip is

constant NL : integer := 6;
constant NFE : integer := 8;

type state_type is (S0_0,S0_1,S0_2,S0_3,S0_4,S0_5,S0_6,S0_7,S1_0,S1_1,S1_2,S1_3,S1_4,S1_5,S1_6,S1_7);

signal next_state, current_state : state_type;

signal data_0_en, data_0_rst, data_0_ld, stub_0_rst, stub_0_ld, stubv_0_rst : std_logic;
signal data_1_en, data_1_rst, data_1_ld, stub_1_rst, stub_1_ld, stubv_1_rst : std_logic;
signal out_sel : std_logic;

signal ts, ts_d1, ts_d2 : integer := 0;

type data_array is array (7 downto 0) of std_logic_vector(29 downto 0);
signal data_0, data_1 : data_array;

type stub_array is array (11 downto 0) of std_logic_vector(19 downto 0);
signal stub_0, stub_1 : stub_array;

type stub_vec is array (11 downto 0) of std_logic_vector(15 downto 0);
type stub_vec_array is array (7 downto 0) of stub_vec;
signal stub_vec_0, stub_vec_1 : stub_vec_array;

type stub_dv_array is array (7 downto 0) of std_logic_vector(11 downto 0);
signal stub_dv_0, stub_dv_1 : stub_dv_array;

type stub_pointer is array (7 downto 0) of integer;
signal current_stub_0, current_stub_1 : stub_pointer;


begin

fsm_state_regs : process (next_state,ts,rst,clk)

  begin
    if (rst = '1') then
      ts_d1 <= 0;
      ts_d2 <= 0;
      current_state <= S0_0;
    elsif rising_edge(clk) then
      ts_d1 <= ts;
      ts_d2 <= ts_d1;
      current_state <= next_state;
    end if;

end process;

fsm_comb_logic : process(current_state,do_in)

  begin
    
    case current_state is

      when S0_0 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '1'; 
        stubv_0_rst <= '1'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 1; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_1;
        end if;   

      when S0_1 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 2; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_2;
        end if;   

      when S0_2 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 3; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_3;
        end if;   

      when S0_3 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 4; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_4;
        end if;   
 
      when S0_4 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 5; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_5;
        end if;   

      when S0_5 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 6; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_6;
        end if;   

      when S0_6 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 7; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_7;
        end if;   

      when S0_7 =>
        data_0_rst <= '1'; 
        data_0_ld <= '1'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '1'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S1_0;
        end if;   

      when S1_0 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '1'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '1'; 
        out_sel <= '1';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 1; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_1;
        end if;   

      when S1_1 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 2; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_2;
        end if;   
 
      when S1_2 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 3; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_3;
        end if;   

      when S1_3 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 4; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_4;
        end if;   

      when S1_4 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 5; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_5;
        end if;   

      when S1_5 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 6; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_6;
        end if;   

      when S1_6 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 7; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_7;
        end if;   

      when S1_7 =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '1'; 
        data_1_ld <= '1'; 
        stub_0_rst <= '1'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
          ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        else
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S0_0;
        end if;   

      when others =>
        data_0_rst <= '0'; 
        data_0_ld <= '0'; 
        data_1_rst <= '0'; 
        data_1_ld <= '0'; 
        stub_0_rst <= '0'; 
        stub_0_ld <= '0'; 
        stub_1_rst <= '0'; 
        stub_1_ld <= '0'; 
        stubv_0_rst <= '0'; 
        stubv_1_rst <= '0'; 
        out_sel <= '0';
        if (do_in(31 downto 30) = "10") then 
        ts <= 0; 
          data_0_en <= '1'; 
          data_1_en <= '0'; 
          next_state <= S0_0;
        elsif (do_in(31 downto 30) = "11") then 
          ts <= 0; 
          data_0_en <= '0'; 
          data_1_en <= '1'; 
          next_state <= S1_0;
        end if;   

    end case;
    
  end process;

data_0_gen_proc: process (data_0_en,data_0_rst,stub_0_rst,stub_0_ld,stubv_0_rst,do_in,data_0,current_stub_0,stub_0,ts,clk)

variable current_stub : stub_pointer;

begin

	if (rising_edge(clk)) then
    if (data_0_rst = '1') then
      for I in 0 to 7 loop
        data_0(I) <= (others => '0');
      end loop;
    elsif (data_0_en = '1') then
        data_0(ts) <= do_in(29 downto 0);
    end if;  
  end if;  
  
	if (rising_edge(clk)) then
    if (stub_0_rst = '1') then
      for I in 0 to 11 loop
        stub_0(I) <= (others => '0');
      end loop;
    elsif (data_0_ld = '1') then
        stub_0(0) <= data_0(0)(29 downto 10);
        stub_0(1) <= data_0(0)(9 downto 0) & data_0(1)(29 downto 20);
        stub_0(2) <= data_0(1)(19 downto 0);
        stub_0(3) <= data_0(2)(29 downto 10);
        stub_0(4) <= data_0(2)(9 downto 0) & data_0(3)(29 downto 20);
        stub_0(5) <= data_0(3)(19 downto 0);
        stub_0(6) <= data_0(4)(29 downto 10);
        stub_0(7) <= data_0(4)(9 downto 0) & data_0(5)(29 downto 20);
        stub_0(8) <= data_0(5)(19 downto 0);
        stub_0(9) <= data_0(6)(29 downto 10);
        stub_0(10) <= data_0(6)(9 downto 0) & data_0(7)(29 downto 20);
        stub_0(11) <= data_0(7)(19 downto 0);
    end if;  
  end if;  

	if (rising_edge(clk)) then
    if (stubv_0_rst = '1') then
      for I in 0 to 7 loop
--        current_stub_0(I) <= 0;
        current_stub(I) := 0;
        stub_dv_0(I) <= (others => '0');
        for J in 0 to 11 loop
          stub_vec_0(I)(J) <= (others => '0');
        end loop;
      end loop;
    elsif (stub_0_ld = '1') then
      for K in 0 to 11 loop
        for I in 0 to 7 loop
          if (stub_0(K)(19) = '1') and (stub_0(K)(18 downto 16) = std_logic_vector(to_unsigned(I, 3))) then
--            stub_vec_0(I)(current_stub_0(I)) <= stub_0(K)(15 downto 0);
--            current_stub_0(I) <= current_stub_0(I) + 1;
            stub_dv_0(I)(current_stub(I)) <= '1';
            stub_vec_0(I)(current_stub(I)) <= stub_0(K)(15 downto 0);
            current_stub(I) := current_stub(I) + 1;
          end if;
        end loop;
      end loop;
    end if;
  end if;
    
  
end process;

data_1_gen_proc: process (data_1_en,data_1_rst,stub_1_rst,stub_1_ld,stubv_1_rst,do_in,data_1,current_stub_1,stub_1,ts,clk)

variable current_stub : stub_pointer;

begin

	if (rising_edge(clk)) then
    if (data_1_rst = '1') then
      for I in 0 to 7 loop
        data_1(I) <= (others => '0');
      end loop;
    elsif (data_1_en = '1') then
        data_1(ts) <= do_in(29 downto 0);
    end if;  
  end if;  
  
	if (rising_edge(clk)) then
    if (stub_1_rst = '1') then
      for I in 0 to 11 loop
        stub_1(I) <= (others => '0');
      end loop;
    elsif (data_1_ld = '1') then
        stub_1(0) <= data_1(0)(29 downto 10);
        stub_1(1) <= data_1(0)(9 downto 0) & data_1(1)(29 downto 20);
        stub_1(2) <= data_1(1)(19 downto 0);
        stub_1(3) <= data_1(2)(29 downto 10);
        stub_1(4) <= data_1(2)(9 downto 0) & data_1(3)(29 downto 20);
        stub_1(5) <= data_1(3)(19 downto 0);
        stub_1(6) <= data_1(4)(29 downto 10);
        stub_1(7) <= data_1(4)(9 downto 0) & data_1(5)(29 downto 20);
        stub_1(8) <= data_1(5)(19 downto 0);
        stub_1(9) <= data_1(6)(29 downto 10);
        stub_1(10) <= data_1(6)(9 downto 0) & data_1(7)(29 downto 20);
        stub_1(11) <= data_1(7)(19 downto 0);
    end if;  
  end if;  
  
	if (rising_edge(clk)) then
    if (stubv_1_rst = '1') then
      for I in 0 to 7 loop
--          current_stub_1(I) <= 0;
          current_stub(I) := 0;
          stub_dv_1(I) <= (others => '0');
        for J in 0 to 11 loop
          stub_vec_1(I)(J) <= (others => '0');
        end loop;
      end loop;
    elsif (stub_1_ld = '1') then
      for K in 0 to 11 loop
        for I in 0 to 7 loop
          if (stub_1(K)(19) = '1') and (stub_1(K)(18 downto 16) = std_logic_vector(to_unsigned(I, 3))) then
--            stub_vec_1(I)(current_stub_1(I)) <= stub_1(K)(15 downto 0);
--            current_stub_1(I) <= current_stub_1(I) + 1;
            stub_dv_1(I)(current_stub(I)) <= '1';
            stub_vec_1(I)(current_stub(I)) <= stub_1(K)(15 downto 0);
            current_stub(I) := current_stub(I) + 1;
          end if;
        end loop;
      end loop;
    end if;
  end if;
    
end process;

out_mux: process (stub_vec_0,stub_vec_1,ts_d2,out_sel)

begin

-- Jan 4  
--  if (out_sel = '0') then
--    stub_dv  <= stub_dv_0(ts_d2);
--    stub_d00 <= stub_vec_0(ts_d2)(0);
--    stub_d01 <= stub_vec_0(ts_d2)(1);
--    stub_d02 <= stub_vec_0(ts_d2)(2);
--    stub_d03 <= stub_vec_0(ts_d2)(3);
--    stub_d04 <= stub_vec_0(ts_d2)(4);
--    stub_d05 <= stub_vec_0(ts_d2)(5);
--    stub_d06 <= stub_vec_0(ts_d2)(6);
--    stub_d07 <= stub_vec_0(ts_d2)(7);
--    stub_d08 <= stub_vec_0(ts_d2)(8);
--    stub_d09 <= stub_vec_0(ts_d2)(9);
--    stub_d10 <= stub_vec_0(ts_d2)(10);
--    stub_d11 <= stub_vec_0(ts_d2)(11);
--  elsif (out_sel = '1') then
--    stub_dv  <= stub_dv_1(ts_d2);
--    stub_d00 <= stub_vec_1(ts_d2)(0);
--    stub_d01 <= stub_vec_1(ts_d2)(1);
--    stub_d02 <= stub_vec_1(ts_d2)(2);
--    stub_d03 <= stub_vec_1(ts_d2)(3);
--    stub_d04 <= stub_vec_1(ts_d2)(4);
--    stub_d05 <= stub_vec_1(ts_d2)(5);
--    stub_d06 <= stub_vec_1(ts_d2)(6);
--    stub_d07 <= stub_vec_1(ts_d2)(7);
--    stub_d08 <= stub_vec_1(ts_d2)(8);
--    stub_d09 <= stub_vec_1(ts_d2)(9);
--    stub_d10 <= stub_vec_1(ts_d2)(10);
--    stub_d11 <= stub_vec_1(ts_d2)(11);
  if (out_sel = '0') then
    stub_dv  <= stub_dv_0(ts_d2);
    stub_d00 <= phi & z & stub_vec_0(ts_d2)(0)(15 downto 8);
    stub_d01 <= phi & z & stub_vec_0(ts_d2)(1)(15 downto 8);
    stub_d02 <= phi & z & stub_vec_0(ts_d2)(2)(15 downto 8);
    stub_d03 <= phi & z & stub_vec_0(ts_d2)(3)(15 downto 8);
    stub_d04 <= phi & z & stub_vec_0(ts_d2)(4)(15 downto 8);
    stub_d05 <= phi & z & stub_vec_0(ts_d2)(5)(15 downto 8);
    stub_d06 <= phi & z & stub_vec_0(ts_d2)(6)(15 downto 8);
    stub_d07 <= phi & z & stub_vec_0(ts_d2)(7)(15 downto 8);
    stub_d08 <= phi & z & stub_vec_0(ts_d2)(8)(15 downto 8);
    stub_d09 <= phi & z & stub_vec_0(ts_d2)(9)(15 downto 8);
    stub_d10 <= phi & z & stub_vec_0(ts_d2)(10)(15 downto 8);
    stub_d11 <= phi & z & stub_vec_0(ts_d2)(11)(15 downto 8);
  elsif (out_sel = '1') then
    stub_dv  <= stub_dv_1(ts_d2);
    stub_d00 <= phi & z & stub_vec_1(ts_d2)(0)(15 downto 8);
    stub_d01 <= phi & z & stub_vec_1(ts_d2)(1)(15 downto 8);
    stub_d02 <= phi & z & stub_vec_1(ts_d2)(2)(15 downto 8);
    stub_d03 <= phi & z & stub_vec_1(ts_d2)(3)(15 downto 8);
    stub_d04 <= phi & z & stub_vec_1(ts_d2)(4)(15 downto 8);
    stub_d05 <= phi & z & stub_vec_1(ts_d2)(5)(15 downto 8);
    stub_d06 <= phi & z & stub_vec_1(ts_d2)(6)(15 downto 8);
    stub_d07 <= phi & z & stub_vec_1(ts_d2)(7)(15 downto 8);
    stub_d08 <= phi & z & stub_vec_1(ts_d2)(8)(15 downto 8);
    stub_d09 <= phi & z & stub_vec_1(ts_d2)(9)(15 downto 8);
    stub_d10 <= phi & z & stub_vec_1(ts_d2)(10)(15 downto 8);
    stub_d11 <= phi & z & stub_vec_1(ts_d2)(11)(15 downto 8);
  else
    stub_dv  <= (others => '0');
    stub_d00 <= (others => 'Z');
    stub_d01 <= (others => 'Z');
    stub_d02 <= (others => 'Z');
    stub_d03 <= (others => 'Z');
    stub_d04 <= (others => 'Z');
    stub_d05 <= (others => 'Z');
    stub_d06 <= (others => 'Z');
    stub_d07 <= (others => 'Z');
    stub_d08 <= (others => 'Z');
    stub_d09 <= (others => 'Z');
    stub_d10 <= (others => 'Z');
    stub_d11 <= (others => 'Z');
  end if;

end process;
	
end DO_chip_architecture;
