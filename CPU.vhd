library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity CPU is
	Port(
		clock, reset : in std_logic;
		opCode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		negative : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);
end CPU;
architecture ArchCPU of CPU is
	component FullAdder is
	Port(
		A, B : in std_logic_vector(31 downto 0);
		X, clock, reset: in std_logic;
		overflow, negative: out std_logic;
		result: out std_logic_vector(31 downto 0)
	);
	end component;
	component Multiplier is
	Port(
		A, B : in std_logic_vector(15 downto 0);
		result : out std_logic_vector(31 downto 0);
		clock, reset : in std_logic;
		overflow, negative : out std_logic
	);
	end component;
	component ROM is
	Port(
		direction : in std_logic_vector(3 downto 0);
		memoryValue : out std_logic_vector(7 downto 0)
	);
	end component;
	component Divider is
	Port(
		A, B : in std_logic_vector(31 downto 0);
		quotient, residue : out std_logic_vector(31 downto 0);
		clock, reset : in std_logic
	);
	end component;
	signal setA, setB, AdderResult, SubstractionResult, MultiplierResult, DividerResult, DividerResidue : std_logic_vector(31 downto 0) := (others => '0');
	signal adderOverflow, subsOverflow, multiplierOverflow, adderNegative, subsNegative, multiNegative, pcOverflow, pcNegative : std_logic := '0';
	signal decodeValue : std_logic_vector(7 downto 0) := (others => '0');
	signal tempPC32, addPC, tempPC : std_logic_vector(31 downto 0) := (others => '0');
	signal pc : std_logic_vector(3 downto 0) := (others => '0');
	function Adder1 (A : std_logic_vector(31 downto 0); B : std_logic_vector(31 downto 0)) return std_logic_vector is
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
	end Adder1;
	function ConvertFromCA2(A : std_logic_vector(31 downto 0)) return std_logic_vector is
		variable tempA, result : std_logic_vector(31 downto 0);
	begin
		result := (others => '0');
		tempA := (others => '0');
		tempA := not A;
		result := not A; --Adder1(tempA, "00000000000000000000000000000001");
		return result;
	end ConvertFromCA2;
begin
	pc <= opCode;
	-- Fetch
	ROMAccess : ROM Port Map (direction => pc, memoryValue => decodeValue);
	-- Decode
	process(decodeValue)
		variable operation, nextStep : std_logic_vector(3 downto 0);
	begin
		operation := decodeValue(7 downto 4);
		nextStep := decodeValue(3 downto 0);
		-- Execute
		case operation is
			-- Adder
			--when "0000" =>
			when "0000" =>
				setA <= A;
				setB <= B;
				negative <= '0';
				result <= adderResult;
			when "0001" =>
				setA <= A;
				setB <= B;
				-- Negative
				if conv_integer(A) < conv_integer(B) then
					negative <= '1';
					result <= ConvertFromCA2(SubstractionResult);
				else
					result <= Adder1(SubstractionResult,"00000000000000000000000000000001");--ConvertFromCA2(SubstractionResult);
					negative <= '0';
				end if;
			when "0010" =>
				setA <= A;
				setB <= B;
				negative <= '0';
				result <= MultiplierResult;
			when "0011" =>
				setA <= A;
				setB <= B;
				negative <= '0';
				result <= DividerResult;
			when others =>
				result <= (others => '0');
		end case;
	end process;
	AdderPC : FullAdder Port Map (A => tempPC, B => addPC, clock => clock, reset => reset, X => '0', overflow => pcOverflow, result => tempPC32, negative => pcNegative);
	Adder : FullAdder Port Map (A => setA, B => setB, clock => clock, reset => reset, X => '0', overflow => adderOverflow, result => AdderResult, negative => adderNegative);
	Substract : FullAdder Port Map (A => setA, B => setB, clock => clock, reset => reset, X => '1', overflow => subsOverflow, result => SubstractionResult, negative => subsNegative);
	Multi : Multiplier Port Map (A => setA(15 downto 0), B => setB(15 downto 0), clock => clock, reset => reset, result => MultiplierResult, overflow => multiplierOverflow, negative => multiNegative);
	Divi : Divider Port Map(A => A, B => B, clock => clock, reset => reset, quotient => DividerResult, residue => DividerResidue);
end ArchCPU;