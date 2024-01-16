library IEEE;
use IEEE.std_logic_1164.all;
entity RGBMatrix is
	Port(
		Rowss, Green, Red, Blue : out std_logic_vector(7 downto 0);
		clock, reset : in std_logic
	);
end RGBMatrix;
architecture ArchRGB of RGBMatrix is
	signal secondClock : std_logic;
	signal counter, counter2, counter3 : integer := 0;
	signal gr, rd, bue, cols : std_logic_vector(7 downto 0) := (others => '1');
	
begin
	process(clock, reset)
	begin
		if reset = '0' then
			counter <= 0;
		elsif rising_edge(clock) then
			if counter = 5000000 then
				counter <= 0;
				secondClock <= not secondClock;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	process(secondClock)
	begin
		if rising_edge(secondClock) then
			case counter2 is
			when 0 =>
				cols <= "01111111";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 1 =>
				cols <= "00111111";
				case counter3 is
				when 0 =>
					gr <= not "00000001";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "00000011";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "00000111";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "00001111";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "00000001";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "00000011";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "00000111";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "00001111";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 2 =>
				cols <= "00011111";
				case counter3 is
				when 0 =>
					bue <= not "10000000";
					rd <= not "00000000";
					gr <= not "00000000";
				when 1 =>
					bue <= not "11000000";
					rd <= not "00000000";
					gr <= not "00000000";
				when 2 =>
					bue <= not "11100000";
					rd <= not "00000000";
					gr <= not "00000000";
				when 3 =>
					bue <= not "11110000";
					rd <= not "00000000";
					gr <= not "00000000";
				when 4 =>
					gr <= not "11110000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "11110000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "11110000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "11110000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 3 =>
				cols <= "00001111";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 4 =>
				cols <= "00000111";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 5 =>
				cols <= "00000011";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 6 =>
				cols <= "00000001";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when 7 =>
				cols <= "00000000";
				case counter3 is
				when 0 =>
					gr <= not "10000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 1 =>
					gr <= not "11000000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 2 =>
					gr <= not "11100000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 3 =>
					gr <= not "11110000";
					rd <= not "00000000";
					bue <= not "00000000";
				when 4 =>
					gr <= not "00000000";
					rd <= not "10000000";
					bue <= not "00000000";
				when 5 =>
					gr <= not "00000000";
					rd <= not "11000000";
					bue <= not "00000000";
				when 6 =>
					gr <= not "00000000";
					rd <= not "11100000";
					bue <= not "00000000";
				when 7 =>
					gr <= not "00000000";
					rd <= not "11110000";
					bue <= not "00000000";
				when others => counter3 <= 0;
				end case;
			when others => counter2 <= 0;
			end case;
			counter3 <= counter3 + 1;
			counter2 <= counter2 + 1;
			if counter3 > 7 then
				counter3 <= 0;
			end if;
			if counter2 > 7 then
				counter2 <= 0;
			end if;
			Green <= gr;
			Red <= rd;
			Blue <= bue;
			Rowss <= cols;
		end if;
	end process;
end ArchRGB;