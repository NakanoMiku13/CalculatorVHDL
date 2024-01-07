library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        number : in STD_LOGIC_VECTOR(3 downto 0);
        segments : out STD_LOGIC_VECTOR(7 downto 0);
        anodes : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Display;

architecture ArchDisplay of Display is
    signal counter : integer := 0;
    signal digit : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal display_data : STD_LOGIC_VECTOR(6 downto 0);

begin
    process(clk, reset)
    begin
        if reset = '0' then
            counter <= 0;
        elsif rising_edge(clk) then
            counter <= counter + 1;
            if counter = 4 then
                counter <= 0;
            end if;
        end if;
    end process;

    process(number)
    begin
        case number is							--abcdefg dp
				when "0100" => display_data <= "1111110";
				when "1010" => display_data <= "0110000";
				when "1011" => display_data <= "1101101";
				when "1100" => display_data <= "1111001";
				when "0011" => display_data <= "0110011";
				when "0110" => display_data <= "1011011";
				when "1001" => display_data <= "1011111";
				when "0010" => display_data <= "1110000";
				when "0101" => display_data <= "1111111";
				when "1000" => display_data <= "1110011";
				when "1101" => display_data <= "1110111";
				when "1111" => display_data <= "0011111";
				when "0000" => display_data <= "1001110";
				when "1110" => display_data <= "0111101";
				when "0001" => display_data <= "1001111";
				when "0111" => display_data <= "1000111";
        end case;
		  segments <= not (display_data & '0');
		  anodes <= not "0001";
    end process;
              
end ArchDisplay;
