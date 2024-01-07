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

architecture Behavioral of Display is
    signal counter : integer := 0;
    signal digit : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal display_data : STD_LOGIC_VECTOR(7 downto 0);

begin
    process(clk, reset)
    begin
        if reset = '0' then
            counter <= 0;
            digit <= "0000";
        elsif rising_edge(clk) then
            if counter = 0 then
                digit <= number;
            end if;
            counter <= counter + 1;
            if counter = 4 then
                counter <= 0;
            end if;
        end if;
    end process;

    process(digit)
    begin
        case digit is
            when not "0001" =>
                display_data <= "11000000";
            when not "0010" =>
                display_data <= "11111001";
            when not "0100" =>
                display_data <= "10100100";
            when not "1000" =>
                display_data <= "10110000";
            when others =>
                display_data <= "11111111";
        end case;
    end process;

    segments <= display_data;
    anodes <= not "0001" when counter = 0 else
              not "0010" when counter = 1 else
              not "0100" when counter = 2 else
              not "1000" when counter = 3 else
              not "1111"; -- Apaga todos los dígitos
              
end Behavioral;
