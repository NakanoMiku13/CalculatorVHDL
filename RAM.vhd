library IEEE;
use IEEE.std_logic_1164.all;
entity RAM is
	Port(
		dataIn : in std_logic_vector(3 downto 0);
		direction : in integer;
		dataOut : out std_logic_vector(3 downto 0);
		we, clock, reset, resetLogic : in std_logic
	);
end RAM;
architecture ArchRAM of RAM is
	type ram_type is array (0 to 15) of std_logic_vector(3 downto 0);
	signal tempRAM : ram_type := (others => (others => '0'));
begin
	-- Write process
	process(clock)
	begin
		if reset = '0' or resetLogic = '1' then
			tempRam <= (others => (others => '0'));
		elsif rising_edge(clock) then
			if we = '1' then
				tempRAM(direction) <= dataIn;
			end if;
			dataOut <= tempRAM(direction);
		end if;
	end process;
end ArchRAM;