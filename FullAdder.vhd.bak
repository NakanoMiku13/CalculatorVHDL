library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FullAdder3 is
	Port(
		A, B, cin, X : in std_logic;
		result, cout: out std_logic
	);
end FullAdder3;
architecture ArchFullAdder of FullAdder3 is
begin
	result <= A XOR (B XOR X) XOR cin;
	cout <= (A AND (B XOR X)) OR ((B XOR X) AND cin) OR (A AND cin);
end ArchFullAdder;