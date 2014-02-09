-- FD_Encoder
--
-- Encoder for the FD field


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use work.interfaces_pkg.all;


entity FD_Encoder is
	 port(
		 FD : in std_logic_vector(N_FD-1 downto 0);
		 FDC : out STD_LOGIC_VECTOR(N_FDC-1 downto 0)
	     );
end FD_Encoder;


architecture H12_7 of FD_Encoder is	-- (12,7) SECDED Hamming Encoder 

	signal x : std_logic_vector(1 to 7); -- message vector (FD)
	signal p : std_logic_vector(1 to 5); -- vector of parity bits
	
begin  -- here FD is supposed to be 7 bits long for the H(12,7) encoding
		
	x(1 to 7) <= FD (6 downto 0);
	
	p(1) <= x(1) XOR x(2) XOR x(4) XOR x(5) XOR x(7);	
	p(2) <= x(1) XOR x(3) XOR x(4) XOR x(6) XOR x(7);
	p(3) <= x(2) XOR x(3) XOR x(4);
	p(4) <= x(5) XOR x(6) XOR x(7);
	p(5) <= x(1) XOR x(2) XOR x(3) XOR x(5) XOR x(6);
	
	FDC(11 downto 5) <=  x(1 to 7);
	FDC(4 downto 0) <=  p(1 to 5);

end H12_7;
