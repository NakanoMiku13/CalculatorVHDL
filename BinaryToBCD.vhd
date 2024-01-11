library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinaryToBCD is
    Port ( input : in  STD_LOGIC_VECTOR (15 downto 0);
           clock, reset : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0)
          );
end BinaryToBCD;

architecture Behavioral of BinaryToBCD is
    signal  err :  STD_LOGIC;
begin
	process (clock)
	begin
		if reset = '0' then
			output <= (others => '0');
		elsif rising_edge(clock) then
			output(15 downto 12) <= conv_std_logic_vector((conv_integer(input) / 1000),4);
			output(11 downto 8) <= conv_std_logic_vector((conv_integer(input) / 100)MOD 10,4);
			output(7 downto 4) <= conv_std_logic_vector((conv_integer(input) / 10)MOD 10,4);
			output(3 downto 0) <= conv_std_logic_vector((conv_integer(input))MOD 10,4);
		end if;
	end process;
end Behavioral;