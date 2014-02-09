-- FD_Decoder
--
-- Decoder for the FD field


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use work.interfaces_pkg.all;


entity FD_Decoder is
	 port(
		 FDC : in std_logic_vector(N_FDC-1 downto 0);
		 FD : out STD_LOGIC_VECTOR(N_FD-1 downto 0);
		 FD_SEU : out std_logic; -- signals a single bit error detected
		 FD_DEU : out std_logic	-- signals a double bit error detected
	     );
end FD_Decoder;


architecture H12_7 of FD_Decoder is	-- (12,7) SECDED Hamming Decoder 

	signal y : std_logic_vector(1 to 12); -- received vector (FDC)
	signal s : std_logic_vector(1 to 5); -- vector of 4 syndrome bits plus the overall parity bit s(5)
	signal e : std_logic_vector(1 to 7); -- error vector
	
	signal FD_DEU_int : std_logic;
    
begin  -- here FDC is supposed to be 12 bits long for the H(12,7) decoding
		
	y(1 to 12) <= FDC (11 downto 0);
	
	-- syndrome calculation
	s(1) <= y(1) XOR y(2) XOR y(4) XOR y(5) XOR y(7) XOR y(8);	
	s(2) <= y(1) XOR y(3) XOR y(4) XOR y(6) XOR y(7) XOR y(9);
	s(3) <= y(2) XOR y(3) XOR y(4) XOR y(10);
	s(4) <= y(5) XOR y(6) XOR y(7) XOR y(11);
	
	-- overall parity bit calculation
	s(5) <= y(1) XOR y(2) XOR y(3) XOR y(4) XOR y(5) XOR y(6) 
	XOR y(7) XOR y(8) XOR y(9) XOR y(10) XOR y(11) XOR y(12);
	
	-- error vector calculation
	e(1) <= '1' when s(1 to 4) = "1100" else '0';
	e(2) <= '1' when s(1 to 4) = "1010" else '0';
	e(3) <= '1' when s(1 to 4) = "0110" else '0';
	e(4) <= '1' when s(1 to 4) = "1110" else '0';
	e(5) <= '1' when s(1 to 4) = "1001" else '0';
	e(6) <= '1' when s(1 to 4) = "0101" else '0';
	e(7) <= '1' when s(1 to 4) = "1101" else '0';
		
    FD_SEU <= OR_REDUCE(s) and not(FD_DEU_int);
    
	-- correction logic
	FD(6 downto 0) <=  y(1 to 7) XOR e(1 to 7);
	FD_DEU_int <=  '1' when (s(1 to 4) /= "0000") AND (s(5) = '0') else '0';
    FD_DEU <= FD_DEU_int;
    
end H12_7;
