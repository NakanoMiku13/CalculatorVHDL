library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
	Port(
		A, B : in std_logic_vector(31 downto 0);
		X, clock, reset: in std_logic;
		overflow, negative : out std_logic;
		result: out std_logic_vector(31 downto 0)
	);
end FullAdder;
architecture ArchFullAdder of FullAdder is
	signal cin : std_logic_vector(32 downto 0) := (others => '0');
	signal tempResult : std_logic_vector(31 downto 0) := (others => '0');
	signal count : integer := 0;
begin
	process(clock, reset)
	begin
		if reset = '0' then
			cin <= (others => '0');
			tempResult <= (others => '0');
			count <= 0;
		elsif rising_edge(clock) then
			if count = 32 then
				result <= tempResult;
				overflow <= cin(32);
				negative <= tempResult(31);
			else
				tempResult(count) <= A(count) XOR (B(count) XOR X) XOR cin(count);
				cin(count + 1) <= (A(count) AND (B(count) XOR X)) OR ((B(count) XOR X) AND cin(count)) OR (A(count) AND cin(count));
				count <= count + 1;
			end if;
		end if;
	end process;
end ArchFullAdder;