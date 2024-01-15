library IEEE;
use IEEE.std_logic_1164.all;
entity Comparison is
	Port(
		A, B: in std_logic_vector(31 downto 0);
		Higher, Lower, Equal : out std_logic;
		clock, reset : in std_logic
	);
end Comparison;
architecture ArchComparison of Comparison is
	signal eq : std_logic;
	signal H, L, E : std_logic_vector(32 downto 0);
begin
	process(clock, reset)
	begin
		if reset = '0' then
			H <= (others => '0');
			E <= (others => '0');
			L <= (others => '0');
		elsif rising_edge(clock) then
			for i in 0 to 31 loop
				H(i + 1) <= (A(i) AND NOT B(i)) OR (A(i) AND H(i)) OR (NOT B(i) AND H(i));
				L(i + 1) <= (NOT A(i) AND B(i)) OR (NOT B(i) AND L(i)) OR (B(i) AND L(i));
				eq <= (NOT A(i) AND NOT B(i)) AND (NOT H(i) AND NOT L(i));
				E(i + 1) <=  eq OR ((A(i) AND B(i)) AND (NOT H(i) AND NOT L(i)));
			end loop;
			Higher <= H(32);
			Lower <= L(32);
			Equal <= E(32);
		end if;
	end process;
end ArchComparison;