library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Power is
	Port(
		A, B : in std_logic_vector(7 downto 0);
		clock, reset : in std_logic;
		result : out std_logic_vector(31 downto 0)
	);
end Power;
architecture ArchPower of Power is
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
	signal tempResult, bufferResult : std_logic_vector(31 downto 0) := (others => '0');
	signal tempA : std_logic_vector(31 downto 0) := "000000000000000000000000" & A;
	signal tB, tA, counter, counter2 : integer := 0;
begin
	process(clock, reset)
	begin
		if reset = '0' then
			tempResult <= (others => '0');
			bufferResult <= (others => '0');
			counter <= 0;
			counter2 <= 0;
			tB <= conv_integer(B) - 1;
			tA <= conv_integer(A);
			tempA <= "000000000000000000000000" & A;
		elsif rising_edge(clock) then
			tB <= conv_integer(B) - 1;
			if counter < tB then
				if conv_integer(tempResult) = 0 then
					tA <= conv_integer(A);
				else
					tA <= conv_integer(tempResult);
				end if;
				if counter2 < tA then
					bufferResult <= Adder(tempA, bufferResult);
					counter2 <= counter2 + 1;
				else
					tempResult <= bufferResult;
					bufferResult <= (others => '0');
					counter <= counter + 1;
					counter2 <= 0;
				end if;
			else
				result <= tempResult;
			end if;
		end if;
	end process;
end ArchPower;