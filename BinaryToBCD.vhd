library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinaryToBCD is
    Port (
		input : in  STD_LOGIC_VECTOR (31 downto 0);
		clock, reset : in  STD_LOGIC;
		indexBegin, indexEnd, divider : integer;
		output : out  STD_LOGIC_VECTOR (63 downto 0)
    );
end BinaryToBCD;

architecture Behavioral of BinaryToBCD is
    signal  err :  STD_LOGIC;
begin
	process (clock)
		variable temp : integer ;
	begin
		if rising_edge(clock) then
			--output(127 downto 64) <= (others => '0');
			temp := conv_integer(input);
			if divider = 1 then
				output(indexBegin downto indexEnd) <= "0011" & conv_std_logic_vector(temp MOD 10,4);
			else
				output(indexBegin downto indexEnd) <= "0011" & conv_std_logic_vector(temp / divider,4);
			end if;
		end if;
	end process;
end Behavioral;