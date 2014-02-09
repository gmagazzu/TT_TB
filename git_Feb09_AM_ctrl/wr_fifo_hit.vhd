----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:35:04 02/16/2011 
-- Design Name: 
-- Module Name:    wr_fifo_hit - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wr_fifo_hit is
    Port ( clk : 			in  STD_LOGIC;
           init : 		in  STD_LOGIC;
           wr_input : 	in  STD_LOGIC;
           vmedata : 	in  STD_LOGIC_VECTOR (19 downto 0);
           rwadd : 		in  STD_LOGIC_VECTOR (2 downto 0);
			  			  
           vme_input0_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
           vme_input1_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
           vme_input2_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
           vme_input3_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
           vme_input4_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
           vme_input5_fifo : 	buffer  STD_LOGIC_VECTOR (19 downto 0);
			  
			  ivdata : 	out  STD_LOGIC_VECTOR (19 downto 0);
           wr_fifo : out  STD_LOGIC_VECTOR (5 downto 0);
			  
			  input_ctr_debug :  out  STD_LOGIC_VECTOR (1 downto 0)
			  );
end wr_fifo_hit;

architecture Behavioral of wr_fifo_hit is
	
	--component FFD with enable and data strobe
	component FFD_EN is
			Port (clk  :	in  STD_LOGIC;
					init : 	in  STD_LOGIC;
					D :	 	in  STD_LOGIC_VECTOR (19 downto 0);
					en : 		in  STD_LOGIC;
					
					Q :  buffer  STD_LOGIC_VECTOR (19 downto 0);
					
					en_wr_fifo : 	out  STD_LOGIC
					);
	end component;

	--sigal to generate the delay for the write enable of register
	signal wr_input_d1 : STD_LOGIC; 
	signal wr_input_d2 : STD_LOGIC;
	signal wr_input_d3 : STD_LOGIC;
	signal wr_input_pulse : STD_LOGIC;
	
	--enable register hit
	signal en_reg : STD_LOGIC_VECTOR (5 downto 0);
	
	--signal for debug
	signal en_debug : STD_LOGIC;
	
begin
	
	--delay the input write to generate the signal to enable the register
	process(clk, init)
	begin
		if (init = '1') then
			wr_input_d1 <= '0';
			wr_input_d2 <= '0';
			wr_input_d3 <= '0';
		elsif (clk'event and clk='1') then
			wr_input_d1 <= wr_input;
			wr_input_d2 <= wr_input_d1;
			wr_input_d3 <= wr_input_d2;
		end if;
	end process;
	
	wr_input_pulse <= wr_input_d2 and (not wr_input_d3);

	--mask of the enable at the register
	--REG0 100 | REG1 101 | REG2 110 | REG3 111 | REG4 000 | REG5 001  
	en_reg(0) <= wr_input_pulse and (	  rwadd(2)  and (not rwadd(1)) and (not rwadd(0)));
	en_reg(1) <= wr_input_pulse and (	  rwadd(2)  and (not rwadd(1)) and 	    rwadd(0) );
	en_reg(2) <= wr_input_pulse and (	  rwadd(2)  and      rwadd(1)  and (not rwadd(0)));
	en_reg(3) <= wr_input_pulse and (	  rwadd(2)  and      rwadd(1)  and      rwadd(0) );
	en_reg(4) <= wr_input_pulse and ((not rwadd(2)) and (not rwadd(1)) and (not rwadd(0)));
	en_reg(5) <= wr_input_pulse and ((not rwadd(2)) and (not rwadd(1)) and      rwadd(0) );

	--register the input hit from the VME
	reg_input0: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(0),
											Q => vme_input0_fifo,
											en_wr_fifo => wr_fifo(0)
											);

	--register the input hit from the VME
	reg_input1: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(1),
											Q => vme_input1_fifo,
											en_wr_fifo => wr_fifo(1)
											);
											
	--register the input hit from the VME
	reg_input2: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(2),
											Q => vme_input2_fifo,
											en_wr_fifo => wr_fifo(2)
											);
	
	
	--register the input hit from the VME
	reg_input3: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(3),
											Q => vme_input3_fifo,
											en_wr_fifo => wr_fifo(3)
											);
	
	--register the input hit from the VME
	reg_input4: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(4),
											Q => vme_input4_fifo,
											en_wr_fifo => wr_fifo(4)
											);
											
	--register the input hit from the VME
	reg_input5: FFD_EN port map (clk => clk, 
											init => init, 
											D => vmedata, 
											en => en_reg(5),
											Q => vme_input5_fifo,
											en_wr_fifo => wr_fifo(5)
											);
	
	
	
	--process to raed the hit that write in the fifo
	process (rwadd, vme_input0_fifo, vme_input1_fifo, vme_input2_fifo, 
				vme_input3_fifo, vme_input4_fifo, vme_input5_fifo)
	begin
		case rwadd is
				when "100" => 
						ivdata <= vme_input0_fifo;
				when "101" => 
						ivdata <= vme_input1_fifo;
				when "110" => 
						ivdata <= vme_input2_fifo;
				when "111" => 
						ivdata <= vme_input3_fifo;
				when "000" => 
						ivdata <= vme_input4_fifo;
				when "001" => 
						ivdata <= vme_input5_fifo;
				when others => 
						ivdata <= (others => '0');
			end case;
	end process;
	
	--register for debug
	en_debug <= vme_input4_fifo(0) and vme_input4_fifo(1) and vme_input4_fifo(2) and vme_input4_fifo(3) and
			vme_input4_fifo(4) and vme_input4_fifo(5) and vme_input4_fifo(6) and vme_input4_fifo(7) and vme_input4_fifo(8) and
			vme_input4_fifo(9) and vme_input4_fifo(10) and vme_input4_fifo(11) and vme_input4_fifo(12) and vme_input4_fifo(13) and
			vme_input4_fifo(14) and vme_input4_fifo(15) and vme_input4_fifo(16) and vme_input4_fifo(17) and vme_input4_fifo(18) and
			vme_input4_fifo(19);
			
	process(clk, init)
	begin	
		if(init = '1') then
			input_ctr_debug(0) <= '0';
		elsif(clk'event and clk = '1') then
			if(en_debug = '1') then
				input_ctr_debug(0) <= '1';
			end if;
		end if;
	end process;
			
	input_ctr_debug(1) <= en_reg(4);
		
end Behavioral;

