library ieee;
library work;
use ieee.std_logic_1164.all;

entity FIFO_Encoder is
	port(
		 FIFO_din : in std_logic_vector(16 downto 0);
		 FIFO_enc_din : out STD_LOGIC_VECTOR(21 downto 0)
	     );
end FIFO_Encoder;


architecture FIFO_ENC of FIFO_Encoder is 

signal D : std_logic_vector(17 downto 1);   
signal P : std_logic_vector(6 downto 1);    
signal ENC_D : std_logic_vector(22 downto 1);    
	
begin  -- here FIFO_din is supposed to be 16 bits long for the H(22,16) encoding
		
	D(17 downto 1) <= FIFO_din(16 downto 0);

--                              P(1)    P(2)    P(4)    P(8)    P(16)
--                              xxxx1   xxx1x   xx1xx   x1xxx   1xxxx
--  Bit_01 (00001) => P(1)      -
--  Bit_02 (00010) => P(2)              -
--  Bit_03 (00011) => D(1)      x       x 
--  Bit_04 (00100) => P(4)                      - 
--  Bit_05 (00101) => D(2)      x               x    
--  Bit_06 (00110) => D(3)              x       x
--  Bit_07 (00111) => D(4)      x       x       x   
--  Bit_08 (01000) => P(8)                              - 
--  Bit_09 (01001) => D(5)      x                       x
--  Bit_10 (01010) => D(6)              x               x 
--  Bit_11 (01011) => D(7)      x       x               x   
--  Bit_12 (01100) => D(8)                      x       x 
--  Bit_13 (01101) => D(9)      x               x       x           
--  Bit_14 (01110) => D(10)             x       x       x  
--  Bit_15 (01111) => D(11)     x       x       x       x   
--  Bit_16 (10000) => P(16)                                     -                                     
--  Bit_17 (10001) => D(12)     x                               x
--  Bit_18 (10010) => D(13)             x                       x 
--  Bit_19 (10011) => D(14)     x       x                       x   
--  Bit_20 (10100) => D(15)                     x               x 
--  Bit_21 (10101) => D(16)     x               x               x   
--  Bit_22 (10110) => D(17)             x       x               x   

-- Parity Calculation 

  P(1) <= D(1) XOR D(2) XOR D(4) XOR D(5) XOR D(7) XOR D(9) XOR D(11) XOR D(12) XOR D(14) XOR D(16);	

  P(2) <= D(1) XOR D(3) XOR D(4) XOR D(6) XOR D(7) XOR D(10) XOR D(11) XOR D(13) XOR D(14) XOR D(17);	

  P(3) <= D(2) XOR D(3) XOR D(4) XOR D(8) XOR D(9) XOR D(10) XOR D(11) XOR D(15) XOR D(16) XOR D(17);

  P(4) <= D(5) XOR D(6) XOR D(7) XOR D(8) XOR D(9) XOR D(10) XOR D(11);

  P(5) <= D(12) XOR D(13) XOR D(14) XOR D(15) XOR D(16) XOR D(17);  
	
--	p(1) <= D(0) XOR D(1) XOR D(2) XOR D(3) XOR D(4) XOR D(5) XOR D(10) XOR D(14);	
--	p(2) <= D(0) XOR D(1) XOR D(2) XOR D(6) XOR D(7) XOR D(8) XOR D(9) XOR D(12);	
--	p(3) <= D(0) XOR D(4) XOR D(6) XOR D(7) XOR D(8) XOR D(13) XOR D(14) XOR D(15);
--	p(4) <= D(5) XOR D(6) XOR D(9) XOR D(10) XOR D(11) XOR D(13) XOR D(14) XOR D(15);
--	p(5) <= D(1) XOR D(3) XOR D(7) XOR D(9) XOR D(10) XOR D(11) XOR D(12) XOR D(13);  
--	p(6) <= D(3) XOR D(4) XOR D(5) XOR D(11) XOR D(12) XOR D(2) XOR D(8) XOR D(15);
	
  ENC_D(1) <= P(1);	
  ENC_D(2) <= P(2);	
  ENC_D(3) <= D(1);	
  ENC_D(4) <= P(3);	
  ENC_D(5) <= D(2);	
  ENC_D(6) <= D(3);	
  ENC_D(7) <= D(4);	
  ENC_D(8) <= P(4);	
  ENC_D(9) <= D(5);	
  ENC_D(10) <= D(6);	
  ENC_D(11) <= D(7);	
  ENC_D(12) <= D(8);	
  ENC_D(13) <= D(9);	
  ENC_D(14) <= D(10);	
  ENC_D(15) <= D(11);	
  ENC_D(16) <= P(5);	
  ENC_D(17) <= D(12);	
  ENC_D(18) <= D(13);	
  ENC_D(19) <= D(14);	
  ENC_D(20) <= D(15);	
  ENC_D(21) <= D(16);	
  ENC_D(22) <= D(17);	

	FIFO_enc_din(21 downto 0) <=  ENC_D(22 downto 1);

end FIFO_ENC;
