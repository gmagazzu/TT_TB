library ieee;
library work;
use ieee.std_logic_1164.all;

entity FIFO_Decoder is
	port(
		 FIFO_enc_dout : in std_logic_vector(21 downto 0);
		 FIFO_dout : out STD_LOGIC_VECTOR(16 downto 0);
		 SER : out std_logic	
end FIFO_Decoder;


architecture FIFO_DEC of FIFO_Decoder is	-- (22,16) SECDED Hamming Decoder 

	signal ENC_D : std_logic_vector(21 downto 1); -- data vector received (except parity bits) 
	signal P : std_logic_vector(5 downto 1); -- parity vector received 
	signal S : std_logic_vector(5 downto 1); -- vector of 5 syndrome bits plus the overall parity bit s(6)
	signal E : std_logic_vector(16 downto 1); -- error vector
	signal D : std_logic_vector(15 downto 1); -- data vector received (except parity bits) 
	signal SER: std_logic; -- data vector received (except parity bits) 
	
begin  -- here FIFO_din is supposed to be 22 bits long for the H(22,16) decoding

  ENC_D(22 downto 1) <= FIFO_enc_dout(21 downto 0)
  
  P(1) <= ENC_D(1);	
  P(2) <= ENC_D(2);	
  D(1) <= ENC_D(3);	
  P(3) <= ENC_D(4);	
  D(2) <= ENC_D(5);	
  D(3) <= ENC_D(6);	
  D(4) <= ENC_D(7);	
  P(4) <= ENC_D(8);	
  D(5) <= ENC_D(9);	
  D(6) <= ENC_D(10);	
  D(7) <= ENC_D(11);	
  D(8) <= ENC_D(12);	
  D(9) <= ENC_D(13);	
  D(10) <= ENC_D(14);	
  D(11) <= ENC_D(15);	
  P(5) <= ENC_D(16);	
  D(12) <= ENC_D(17);	
  D(13) <= ENC_D(18);	
  D(14) <= ENC_D(19);	
  D(15) <= ENC_D(20);	
  D(16) <= ENC_D(21);	

	-- Syndrome Calculation

  S(1) <= P(1) XOR D(1) XOR D(2) XOR D(4) XOR D(5) XOR D(7) XOR D(9) XOR D(11) XOR D(12) XOR D(14) XOR D(16);	

  S(2) <= P(2) XOR D(1) XOR D(3) XOR D(4) XOR D(6) XOR D(7) XOR D(10) XOR D(11) XOR D(13) XOR D(14);	

  S(3) <= P(3) XOR D(2) XOR D(3) XOR D(4) XOR D(8) XOR D(9) XOR D(10) XOR D(11) XOR D(15) XOR D(16);

  S(4) <= P(4) XOR D(5) XOR D(6) XOR D(7) XOR D(8) XOR D(9) XOR D(10) XOR D(11);

  S(5) <= P(5) XOR D(12) XOR D(13) XOR D(14) XOR D(15) XOR D(16);  

--	s(1) <= y(0) XOR y(1) XOR y(2) XOR y(3) XOR y(4) XOR y(5) XOR y(10) XOR y(14) XOR p(1);	
--	s(2) <= y(0) XOR y(1) XOR y(2) XOR y(6) XOR y(7) XOR y(8) XOR y(9) XOR y(12) XOR p(2);	 
--	s(3) <= y(0) XOR y(4) XOR y(6) XOR y(7) XOR y(8) XOR y(13) XOR y(14) XOR y(15) XOR p(3);	
--	s(4) <=	y(5) XOR y(6) XOR y(9) XOR y(10) XOR y(11) XOR y(13) XOR y(14) XOR y(15) XOR p(4);		 
--	s(5) <=	y(1) XOR y(3) XOR y(7) XOR y(9) XOR y(10) XOR y(11) XOR y(12) XOR y(13) XOR p(5);
--	s(6) <=	y(2) XOR y(3) XOR y(4) XOR y(5) XOR y(8) XOR y(11) XOR y(12) XOR y(15) XOR p(6);
	
	-- Error Vector Calculation			 

	E(1) <= '1' when S = "00011" else '0';
	E(2) <= '1' when S = "00101" else '0';
	E(3) <= '1' when S = "00110" else '0';
	E(4) <= '1' when S = "00111" else '0';
	E(5) <= '1' when S = "01001" else '0';
	E(6) <= '1' when S = "01010" else '0';
	E(7) <= '1' when S = "01011" else '0';
	E(8) <= '1' when S = "01100" else '0';
	E(9) <= '1' when S = "01101" else '0';
	E(10) <= '1' when S = "01110" else '0';
	E(11) <= '1' when S = "01111" else '0';
	E(12) <= '1' when S = "10001" else '0';
	E(13) <= '1' when S = "10010" else '0';
	E(14) <= '1' when S = "10011" else '0';
	E(15) <= '1' when S = "10100" else '0';
	E(16) <= '1' when S = "10101" else '0';
		
		
-- Correction logic
	D(16 downto 1) <= D XOR E;
	SER_HAM <=  '1' when (E /= "0000000000000000")) else '0';
	
	D_MSB <= '1' when ((ENC_D_MSB = "111") or (ENC_D_MSB = "110") or (ENC_D_MSB = "101") or (ENC_D_MSB = "011")) else '0';;  
	SER_HAM <=  '0' when ((ENC_D_MSB = "111") or (ENC_D_MSB = "000")) else '1';

	FIFO_dout(15 downto 0) <=  DEC_D(16 downto 1);

	SER <= SER_HAM or SER_TMR;	

end FIFO_DEC;
