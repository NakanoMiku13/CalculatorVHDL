library IEEE;
use IEEE.std_logic_1164.all;
entity CPU is
	Port(
		clock, reset : in std_logic;
		opCode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
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
	signal setA, setB, AdderResult, MultiplierResult : std_logic_vector(31 downto 0) := (others => '0');
	signal adderOverflow, subsOverflow, multiplierOverflow, adderNegative, subsNegative, multiNegative, pcOverflow, pcNegative : std_logic := '0';
	signal decodeValue : std_logic_vector(7 downto 0) := (others => '0');
	signal tempPC32, addPC, tempPC : std_logic_vector(31 downto 0) := (others => '0');
	signal pc : std_logic_vector(3 downto 0) := (others => '0');
	
begin
	pc <= tempPC32(3 downto 0);
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
				--result <= MultiplierResult;
				result <= adderResult;
			when "0010" =>
				setA <= A;
				setB <= B;
				result <= MultiplierResult;
			when others =>
				result <= (others => '0');
		end case;
	end process;
	AdderPC : FullAdder Port Map (A => tempPC, B => addPC, clock => clock, reset => reset, X => '0', overflow => pcOverflow, result => tempPC32, negative => pcNegative);
	Adder : FullAdder Port Map (A => setA, B => setB, clock => clock, reset => reset, X => '0', overflow => adderOverflow, result => AdderResult, negative => adderNegative);
	Multi : Multiplier Port Map (A => setA(15 downto 0), B => setB(15 downto 0), clock => clock, reset => reset, result => MultiplierResult, overflow => multiplierOverflow, negative => multiNegative);
end ArchCPU;