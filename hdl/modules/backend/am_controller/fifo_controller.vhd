-- VME_MASTER: Simulates the VME crate controller and bus

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

entity fifo_controller is
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

end fifo_controller;


architecture fifo_controller_architecture of fifo_controller is

  type state_type is (IDLE,RXDATA,STDBY);

  signal next_state, current_state : state_type;

  signal rden,rden_d1,rden_d2 : std_logic;

begin

  fsm_state_regs : process (next_state, init, clk)

  begin
    if (init = '1') then
      current_state <= IDLE;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

  end process;

  rden_regs : process (rden, rden_d1, rden_d2, init, clk)

  begin
    if (init = '1') then
      rden_d1 <= '0';
      rden_d2 <= '0';
    elsif rising_edge(clk) then
      rden_d1 <= rden;
      rden_d2 <= rden_d1;
    end if;

    rden_b <= rden;
--    reg_en <= rden_d1;
    pok <= rden_d2;

  end process;


  fsm_comb_logic : process(current_state, ef_b, pop, rden)

  begin
    
    case current_state is

-- IDLE (waiting for new event)
      when IDLE =>
        rden <= ef_b; 
        reg_en <= '0'; 
        if (ef_b = '1') then
          next_state <= RXDATA;
        else
          next_state <= IDLE;
        end if;

      when RXDATA =>
        if (pop = '0') then
          rden <= '0'; 
          reg_en <= '0'; 
          next_state <= STDBY;
        else
          rden <= ef_b; 
          reg_en <= '1'; 
          next_state <= RXDATA;
        end if;

      when STDBY =>
-- Guido June 10
--        rden <= '0'; 
        reg_en <= '0'; 
        if (pop = '1') and (ef_b = '1') then
          rden <= '1'; 
          next_state <= RXDATA;
        elsif (pop = '1') and (ef_b = '0') then
          rden <= '0'; 
          next_state <= IDLE;
        else
          rden <= '0'; 
          next_state <= STDBY;
        end if;

      when others =>
        rden <= '0'; 
        reg_en <= '0'; 
        next_state <= IDLE;

    end case;
    
    
  end process;

end fifo_controller_architecture;
