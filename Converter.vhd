library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Converter is
	Port(
		multiplier : in integer;
		clock : in std_logic;
		numberConvert : in std_logic_vector(3 downto 0);
		preNumber : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	);
end entity;
architecture ArchConverter of Converter is
	signal preResult, A, B : integer := 0;
begin
	process(clock)
	begin
		if rising_edge(clock) then
			-- 456
			-- 4 * 100 - 400
			-- 5 * 10 - 50
			-- 6 * 1 - 6 
			A <= conv_integer(preNumber);
			B <= conv_integer(numberConvert) * multiplier;
			result <= conv_std_logic_vector(A + B, 32);
		end if;
	end process;
end ArchConverter;