library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ROM is
	Port(
		direction : in std_logic_vector(3 downto 0);
		memoryValue : out std_logic_vector(7 downto 0)
	);
end ROM;
architecture ArchROM of ROM is
	type Rom_instrucciones is array(0 to 31) of std_logic_vector(7 downto 0);
	constant TR : Rom_instrucciones := (
		-- Adder
		0 => "00001010",
		-- Substraction
		1 => "00011010",
		-- Multiplier
		2 => "00101010",
		-- Divisor
		3 => "00111010",
		-- Power
		4 => "01001010",
		-- Factorial
		5 => "01011010",
		-- RAND
		6 => "01101010",
		-- MCD
		7 => "01111010",
		-- MCM
		8 => "10001010",
		-- Comparison
		9 => "10011010",
		-- NOP
		10 => "10101010",
		others => "11111001"
	);
begin
	memoryValue <= TR(conv_integer(direction));
end ArchROM;