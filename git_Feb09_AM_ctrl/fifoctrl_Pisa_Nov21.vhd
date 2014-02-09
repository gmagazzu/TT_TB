-- VME_MASTER: Simulates the VME crate controller and bus

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

entity fifoctrl is
  port
    (

      clk       : in std_logic;
      init      : in std_logic;
      pop       : in std_logic;
      ef_b      : in  std_logic;
      pok       : out std_logic;
      reg_en    : out std_logic;
      rden_b    : out std_logic
      );

end fifoctrl;


architecture fifoctrl_architecture of fifoctrl is

  type state_type is (S0,S1,S2,S3);

  signal next_state, current_state : state_type;

  signal rden : std_logic;

begin

  fsm_state_regs : process (next_state, init, clk)

  begin
    if (init = '1') then
      current_state <= S0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

  end process;


  fsm_comb_logic : process(current_state, ef_b, pop, rden)

  begin
    
    case current_state is

      when S0 =>
        pok <= '0';
        reg_en <= '0';
        if (ef_b = '1') then
          rden <= '1' 
          next_state <= S2;
        else
          rden <= '0' 
          next_state <= S0;
        end if;

      when S2 =>
        pok <= '0';
        reg_en <= '1';
        if (ef_b = '1') then
          rden <= '1'; 
          next_state <= S3;
        else
          rden <= '0'; 
          next_state <= S1;
        end if;

      when S3 =>
        pok <= '1';
        if (pop = '1') then
          reg_en <= '1'; 
        else
          reg_en <= '0'; 
        end if;
        if (pop = '1') and (ef_b = '1') then -- other hits in the fifo
          rden <= '1'; 
        else
          rden <= '0'; 
        end if;
        if (pop = '1') and (ef_b = '0') then -- other hits still to be written in the fifo
          next_state <= S1;
        else
          next_state <= S3;
        end if;

      when S1 =>
        pok <= '0';
        reg_en <= '0';
        if (ef_b = '1') then
          rden <= '1'; 
        else
          rden <= '0'; 
        end if;
        if (pop = '1') and (ef_b = '0') then 
          next_state <= S0;
        elsif (pop = '1') and (ef_b = '1') then 
          next_state <= S2;
        elsif (pop = '0') and (ef_b = '1') then
          next_state <= S3;
        else
          next_state <= S1;
        end if;

      when others =>
        next_state <= S0;

    end case;
    
    rden_b <= rden;
    
  end process;

end fifoctrl_architecture;
