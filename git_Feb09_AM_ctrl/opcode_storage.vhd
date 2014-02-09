----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:08:25 05/03/2011 
-- Design Name: 
-- Module Name:    opcode_storage - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity opcode_storage is
    Port ( clk : in  STD_LOGIC;
           init : in  STD_LOGIC;
           opcode_in : in  STD_LOGIC_VECTOR (3 downto 0);		--Input from VME
			  
           addr_rd_opc : in  STD_LOGIC_VECTOR (4 downto 0);		--Control and increment by the FSM
           
			  wr_opcode : in  STD_LOGIC;									--Write Ram enable generate in the cycle VME
           rd_opc_ram : in  STD_LOGIC;									--Control by FSM
			  
			  need_opc_data : out STD_LOGIC;								--to FSM for control the state send opcode
			  
			  addr_wr_opc : buffer STD_LOGIC_VECTOR (4 downto 0);	--Increment counter to write RAM
			  
           opcode0_out : out  STD_LOGIC_VECTOR (3 downto 0);
			  opcode1_out : out  STD_LOGIC_VECTOR (3 downto 0);
			  opcode2_out : out  STD_LOGIC_VECTOR (3 downto 0);
			  opcode3_out : out  STD_LOGIC_VECTOR (3 downto 0)
			  );
end opcode_storage;

architecture Behavioral of opcode_storage is

	component opcode_ram is
		port (
			addra: in std_logic_VECTOR(4 downto 0);
			addrb: in std_logic_VECTOR(4 downto 0);
			clka: in std_logic;
			clkb: in std_logic;
			dina: in std_logic_VECTOR(3 downto 0);
			doutb: out std_logic_VECTOR(3 downto 0);
			enb: in std_logic;
			sinita: in std_logic;
			wea: in std_logic);
	end component opcode_ram;
	
	--tmp signal to opcode
	signal opc_out_ram : STD_LOGIC_VECTOR (3 downto 0);
	signal opc_tmp : STD_LOGIC_VECTOR (3 downto 0);
	
	--Constant opcode to define NO OPERATION
	CONSTANT NO_OPERATION : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	
	--signal to control mux
	signal sel_opc : STD_LOGIC;
	
begin
	
	--memory that storage the opcode
	opcode_ram_inst: opcode_ram port map(
														addra => addr_wr_opc,
														addrb => addr_rd_opc,
														clka => clk,
														clkb => clk,
														dina => opcode_in,
														doutb => opc_out_ram,
														enb => rd_opc_ram,
														sinita => init,
														wea => wr_opcode
														);
														
	--counter to increment the address to write opcode
	addr_proc: process(clk, init)
	begin
		if(init = '1') then
			addr_wr_opc <= (others => '0');
		elsif(clk'event and clk = '1') then
			if(wr_opcode = '1') then
				addr_wr_opc <= addr_wr_opc + 1;
			end if;
		end if;
	end process;
	
	--control if the opcode need data (OPCODE = 0x8 or OPCODE = 0xD)
	need_opc_data <= '1' when (opc_out_ram = "1000" or opc_out_ram = "1101") else '0';
	
	--generate the signal to selct the mux only delay the signal thata control the read of RAM
	reg_proc: process(clk)
	begin
		if(clk'event and clk  = '1') then
			sel_opc <= rd_opc_ram;
		end if;
	end process;
	
	--mux that select the opcode from RAM or NO OPERATION
	mux_proc: process(sel_opc, opc_out_ram)
	begin
		case sel_opc is
			when '0' =>
				opc_tmp <= NO_OPERATION;
			when '1' =>
				opc_tmp <= opc_out_ram;
			when others =>
				opc_tmp <= (others => '0');
		end case;
	end process;
	
	--register the opcode before to go out of AMboard
	opc_reg_proc: process(clk, init)
	begin
		if(init = '1') then
			opcode0_out <= (others => '0');
			opcode1_out <= (others => '0');
			opcode2_out <= (others => '0');
			opcode3_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			opcode0_out <= opc_tmp;
			opcode1_out <= opc_tmp;
			opcode2_out <= opc_tmp;
			opcode3_out <= opc_tmp;
		end if;
	end process;
	
		

end Behavioral;

