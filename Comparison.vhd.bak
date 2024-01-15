library IEEE;
use IEEE.std_logic_1164.all;
entity Comparison is
	Port(
		A, B, H, L : in std_logic;
		Higher, Lower, Equal : out std_logic
	);
end Comparison;
architecture ArchComparison of Comparison is
	signal eq : std_logic;
begin
	Higher <= (A AND NOT B) OR (A AND H) OR (NOT B AND H);
	Lower <= (NOT A AND B) OR (NOT B AND L) OR (B AND L);
	eq <= (NOT A AND NOT B) AND (NOT H AND NOT L);
	Equal <=  eq OR ((A AND B) AND (NOT H AND NOT L));
end ArchComparison;