-- ciccio: Handles which data packets are expected and which have arrived. It
-- is a content addressed memory with 3 fields (L1A_CNT, L1A_MATCH, BX_CNT)
-- synchronous with ciccio_PUSH (L1A), and the DAVs being filled when the
-- packets have finished arriving.

library ieee;
library unisim;
library unimacro;
library hdlmacro;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use unisim.vcomponents.all;
use unimacro.vcomponents.all;
use hdlmacro.hdlmacro.all;

entity ciccio is
  generic (
    NP      : integer range 1 to 8  := 4;  -- Number of ports, 4 in the current design
    SIZE    : integer range 1 to 1024  := 1024;  -- Number of memorylocations
    NR      : integer range 1 to 16 := 16  -- Maximum number of roads for each event words
    );  

  port(

    clk        : in std_logic;
    rst        : in std_logic;

    p0_dv   : in std_logic;
    p0_data : in std_logic_vector(29 downto 0);
    p1_dv   : in std_logic;
    p1_data : in std_logic_vector(29 downto 0);
    p2_dv   : in std_logic;
    p2_data : in std_logic_vector(29 downto 0);
    p3_dv   : in std_logic;
    p3_data : in std_logic_vector(29 downto 0);

    data_0_out : out std_logic_vector(29 downto 0);
    data_1_out : out std_logic_vector(29 downto 0);
    data_2_out : out std_logic_vector(29 downto 0);
    data_3_out : out std_logic_vector(29 downto 0);
    data_4_out : out std_logic_vector(29 downto 0);
    data_5_out : out std_logic_vector(29 downto 0);
    data_6_out : out std_logic_vector(29 downto 0);
    data_7_out : out std_logic_vector(29 downto 0);
    data_8_out : out std_logic_vector(29 downto 0);
    data_9_out : out std_logic_vector(29 downto 0);
    data_a_out : out std_logic_vector(29 downto 0);
    data_b_out : out std_logic_vector(29 downto 0);
    data_c_out : out std_logic_vector(29 downto 0);
    data_d_out : out std_logic_vector(29 downto 0);
    data_e_out : out std_logic_vector(29 downto 0);
    data_f_out : out std_logic_vector(29 downto 0);
    dv_out : out std_logic_vector(15 downto 0));

end ciccio;


architecture ciccio_architecture of ciccio is

  type data_in_vector is array (NP-1 downto 0) of std_logic_vector(29 downto 0);
  signal data_in : data_in_vector;

  signal dv_in : std_logic_vector(NP-1 downto 0);
  
  type rx_state_type is (RX_IDLE, RX_DATA, RX_END);
  type rx_state_array_type is array (NP-1 downto 0) of rx_state_type;
  signal rx_next_state, rx_current_state : rx_state_array_type;

  type cnt_out_vector is array (NP-1 downto 0) of integer;
  signal cnt_out : cnt_out_vector;

  signal cnt_rst, cnt_en, ts_we : std_logic_vector(3 downto 0);     

  type ts_vector is array (NP-1 downto 0) of integer;
  signal ts : ts_vector;

  type data_vector is array (NR-1 downto 0) of std_logic_vector(29 downto 0);
  type data_array is array (SIZE-1 downto 0) of data_vector;
  signal ciccio : data_array;

  type we_array is array (SIZE-1 downto 0) of std_logic_vector(NR downto 0);
  signal we : we_array;

  type wsel_array is array (SIZE-1 downto 0) of integer;
  signal wsel : wsel_array;

  type nw_array is array (SIZE-1 downto 0) of integer;
  signal nw : nw_array;

  signal rd_addr_sig : std_logic_vector(9 downto 0) := (others => '0');
  signal rd_addr : integer := 0;
  
begin

-- Initial assignments

  dv_in(0) <= p0_dv;
  dv_in(1) <= p1_dv;
  dv_in(2) <= p2_dv;
  dv_in(3) <= p3_dv;
 
  data_in(0) <= p0_data;
  data_in(1) <= p1_data;
  data_in(2) <= p2_data;
  data_in(3) <= p3_data;
 
-------------------- TS Register --------------------

ts_reg : process (data_in, ts_we, clk, rst)

  begin
    for I in 0 to NP-1 loop
      if (rst = '1') then
        ts(I) <= 0;
      elsif (rising_edge(clk)) then
        if (ts_we(I) = '1') then
          ts(I) <= to_integer(unsigned(data_in(I)));
        end if;
      end if;
  end loop;
  
end process;

-------------------- NW Counter --------------------

nw_counter : process (clk, cnt_rst, cnt_en)

variable cnt_data : cnt_out_vector;

  begin
    for I in 0 to NP-1 loop
      if (rst <= '1') then
        cnt_data(I) := 0;
      elsif (rising_edge(clk)) then
        if (cnt_rst(I) = '1') then
          cnt_data(I) := 0;
        elsif (cnt_en(I) = '1') then
          cnt_data(I) := cnt_data(I) + 1;
        end if;
      end if;
      cnt_out(I) <= cnt_data(I);
  end loop;
  
end process;

-- RX FSMs 

  rx_fsm_regs : process (rx_next_state, rst, clk)
  begin
    for I in 0 to NP-1 loop
      if (rst = '1') then
        rx_current_state(I) <= RX_IDLE;
      elsif rising_edge(clk) then
        rx_current_state(I) <= rx_next_state(I);
      end if;
    end loop;
  end process;

  rx_fsm_logic : process (rx_current_state, dv_in)
  begin
    for I in 0 to NP-1 loop
      case rx_current_state(I) is
        when RX_IDLE =>
          cnt_rst(I) <= '0';
          cnt_en(I) <= '0';
          for J in 0 to SIZE-1 loop
            wsel(J) <= 0;
            for K in 0 to NR loop
              we(J)(K) <= '0';
            end loop;
          end loop;   
          if (dv_in(I) = '1') then
            ts_we(I) <= '1';
            rx_next_state(I) <= RX_DATA;
          else
            ts_we(I) <= '0';
            rx_next_state(I) <= RX_IDLE;
          end if;
          
        when RX_DATA =>
          cnt_rst(I) <= '0';
          cnt_en(I) <= '1';
          wsel(ts(I)) <= I;
          for K in 0 to NR-1 loop
            if (K = cnt_out(I)) then
              we(ts(I))(K) <= '1';
            else
              we(ts(I))(K) <= '0';
            end if;
          end loop;   
          ts_we(I) <= '0';
          if (dv_in(I) = '1') then
            rx_next_state(I) <= RX_DATA;
          else
            rx_next_state(I) <= RX_END;
          end if;
          
        when RX_END =>
          cnt_rst(I) <= '1';
          cnt_en(I) <= '0';
          wsel(ts(I)) <= 0;
          for K in 0 to NR-1 loop
            we(ts(I))(K) <= '0';
          end loop;
          we(ts(I))(NR) <= '1';
          ts_we(I) <= '0';
          rx_next_state(I) <= RX_IDLE;
          
        when others =>
          cnt_rst(I) <= '0';
          cnt_en(I) <= '0';
          wsel(ts(I)) <= 0;
          for J in 0 to SIZE-1 loop
            for K in 0 to NR loop
              we(J)(K) <= '0';
            end loop;
          end loop;   
          ts_we(I) <= '0';
          rx_next_state(I) <= RX_IDLE;
          
      end case;
    end loop;
  end process;

---------------------- Memory ----------------------

  ciccio_proc : process (data_in,we, rst, clk)
  begin
    if (rst = '1') then
      for J in 0 to SIZE-1 loop
        for K in 0 to NR-1 loop
          ciccio(J)(K) <= (others => '1');
        end loop;
      end loop;
    elsif rising_edge(clk) then
      for J in 0 to SIZE-1 loop
        for K in 0 to NR-1 loop
          if (we(J)(K) <= '1') then
            ciccio(J)(K) <= data_in(wsel(J));
          end if;
        end loop;
      end loop;
    end if;
  end process;

-------------------- RD_ADDR Counter --------------------

rd_addr_counter : process (clk,rst)

  begin
    if (rst <= '1') then
      rd_addr_sig <= (others => '0');
    elsif (rising_edge(clk)) then
      rd_addr_sig <= rd_addr_sig + 1;
    end if;

    rd_addr <= to_integer(unsigned(rd_addr_sig));

    data_0_out <= ciccio(rd_addr)(0);
    data_1_out <= ciccio(rd_addr)(1);
    data_2_out <= ciccio(rd_addr)(2);
    data_3_out <= ciccio(rd_addr)(3);
    data_4_out <= ciccio(rd_addr)(4);
    data_5_out <= ciccio(rd_addr)(5);
    data_6_out <= ciccio(rd_addr)(6);
    data_7_out <= ciccio(rd_addr)(7);
    data_8_out <= ciccio(rd_addr)(8);
    data_9_out <= ciccio(rd_addr)(9);
    data_a_out <= ciccio(rd_addr)(10);
    data_b_out <= ciccio(rd_addr)(11);
    data_c_out <= ciccio(rd_addr)(12);
    data_d_out <= ciccio(rd_addr)(13);
    data_e_out <= ciccio(rd_addr)(14);
    data_f_out <= ciccio(rd_addr)(15);

end process;


end ciccio_architecture;
