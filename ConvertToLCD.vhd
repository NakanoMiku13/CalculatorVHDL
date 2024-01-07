library IEEE;
use IEEE.std_logic_1164.all;
entity ConvertToLCD is
	Port(
		input : in std_logic_vector(31 downto 0);
		lcd_data : out std_logic_vector(127 downto 0);
		clock, reset : in std_logic
	);
end ConvertToLCD;
architecture ArchConvertToLCD of ConvertToLCD is
	signal tempResult, other : std_logic_vector(63 downto 0) := (others => '0');
begin
	process(clock, reset)
		--variable resPointer, inPointer, auxPointer1, auxPointer2 : integer := 0;
	begin
		if reset = '0' then
			tempResult <= (others => '0');
			--resPointer := 0;
			--inPointer := 0;
			--auxPointer1 := 0;
			--auxPointer2 := 0;
		elsif rising_edge(clock) then
			--tempResult(79 downto 72) <= GetHex(input(39 downto 36));
			--tempResult(71 downto 64) <= GetHex(input(35 downto 32));
			--if resPointer = 63 and inPointer = 31 then
			--	resPointer := 0;
			--	inPointer := 0;
			--	auxPointer1 := 0;
			--	auxPointer2 := 0;
			--else
			--	tempResult(7 + resPointer downto 0 + auxPointer1) <= GetHex(input(3 + inPointer downto 0 + auxPointer2));
			--	resPointer := resPointer + 8;
			--	auxPointer1 := auxPointer1 + 8;
			--	inPointer := inPointer + 8;
			--	auxPointer2 := auxPointer2 + 8;
				tempResult <= "0011" & input(31 downto 28) & "0011" & input(27 downto 24) & "0011" & input(23 downto 20) & "0011" & input(19 downto 16) & "0011" & input(15 downto 12) & "0011" & input(11 downto 8) &"0011" & input(7 downto 4) & "0011" & input(3 downto 0);
			--end if;
		end if;
		lcd_data <= other & tempResult;
	end process;
end ArchConvertToLCD;