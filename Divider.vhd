library IEEE;
use IEEE.std_logic_1164.all;
entity Divider is
	Port(
		A, B : in std_logic_vector(31 downto 0);
		quotient, residue : out std_logic_vector(31 downto 0);
		clock, reset : in std_logic
	);
end Divider;
architecture ArchDivider of Divider is
	signal counter : integer := 0;
	signal tempResult, quo, resi : std_logic_vector(31 downto 0) := (others => '0');
	signal tempSubstraction : std_logic_vector(31 downto 0) := A;
	signal tA : std_logic_vector(31 downto 0) := (others => '0');
	function Substraction (A : std_logic_vector(31 downto 0); B : std_logic_vector(31 downto 0)) return std_logic_vector is
		variable cout : std_logic_vector(32 downto 0);
		variable result : std_logic_vector(31 downto 0);
		constant X : std_logic := '1';
		--constant empty : std_logic_vector := (others => '0');
	begin
		cout := (others => '0');
		result := (others => '0');
		for i in 0 to 31 loop
			result(i) := A(i) XOR (B(i) XOR X) XOR cout(i);
			cout(i + 1) := (A(i) AND (B(i) XOR X)) OR ((B(i) XOR X) AND cout(i)) OR (A(i) AND cout(i));
		end loop;
		return result;
	end Substraction;
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
	function ConvertFromCA2(A : std_logic_vector(31 downto 0)) return std_logic_vector is
		variable tempA, result : std_logic_vector(31 downto 0);
	begin
		result := (others => '0');
		tempA := (others => '0');
		tempA := not A;
		result := Adder(tempA, "00000000000000000000000000000001");
		return result;
	end ConvertFromCA2;
begin
	process(clock, reset)
		variable tquo : std_logic_vector(31 downto 0);
		variable aux : std_logic_vector(0 downto 0);
	begin
		
		if reset = '0' then
			tempResult <= (others => '0');
			counter <= 0;
			quo <= (others => '0');
			resi <= (others => '0');
			tempSubstraction <= A;
		elsif rising_edge(clock) then
			tA(1 downto 0) <= "01";
			tquo := (others => '0');
			aux := resi(31 downto 31);
			if aux = "1" then
				residue <= ConvertFromCA2(resi);
				quotient <= quo;
			else
				resi <= Substraction(tempSubstraction, B);
				tquo := Adder(quo, tA);
				quo <= tquo;
			end if;
		end if;
	end process;
end ArchDivider;
		