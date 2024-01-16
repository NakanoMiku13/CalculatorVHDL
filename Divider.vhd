library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Divider is
	Port(
		A, B : in std_logic_vector(15 downto 0);
		result : out std_logic_vector(31 downto 0);
		clock, reset : in std_logic
	);
end Divider;
architecture ArchMultiplier of Divider is
	signal tempResult, bufferResult, temp : std_logic_vector(31 downto 0) := (others => '0');
	signal tempA : std_logic_vector(31 downto 0) := "0000000000000000" & A;
	signal tB, counter : integer := 0;
	function Adder (A : std_logic_vector(31 downto 0); B : std_logic_vector(31 downto 0)) return std_logic_vector is
		variable cout : std_logic_vector(32 downto 0);
		variable result : std_logic_vector(31 downto 0);
		constant X : std_logic := '0';
		--constant empty : std_logic_vector := (others => '0');
	begin
		cout := (others => '0');
		result := (others => '0');
		for i in 0 to 31 loop
			result(i) := A(i) XOR (B(i) XOR X) XOR cout(i);
			cout(i + 1) := (A(i) AND (B(i) XOR X)) OR ((B(i) XOR X) AND cout(i)) OR (A(i) AND cout(i));
		end loop;
		return result;
	end Adder;
begin
	process(clock, reset, bufferResult, tempResult, tempA)
	begin
		temp(0 downto 0) <= "1";
		if reset = '0' then
			tempResult <= (others => '0');
			bufferResult <= (others => '0');
			counter <= 0;
			tB <= conv_integer(B);
		elsif rising_edge(clock) then
			tB <= conv_integer(B);
			if bufferResult < tB then
				bufferResult <= Adder(tempA, bufferResult);
				tempResult <= Adder(tempResult, temp);
			else
				--result <= conv_std_logic_vector(counter, 32);
				result <= tempResult;
			end if;
		end if;
	end process;
end ArchMultiplier;