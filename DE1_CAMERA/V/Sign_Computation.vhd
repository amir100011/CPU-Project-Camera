library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Sign_Computation is
port(
	S1,S2,FS,sign_tag,sign: in std_logic;
	Sr,Sub: out std_logic
	);
end Sign_Computation;
architecture Sign_Computation_Arch of Sign_Computation is

begin
	Sub <= S1 xor S2 xor FS;
	Sr <= (not(S2) and FS and sign) or (S1 and not(sign) and not(sign_tag)) or ( S2 and not(FS) and  sign) or (S2 and not(FS) and sign_tag) or (not(S2) and FS and sign_tag);
	end Sign_Computation_Arch;
	
