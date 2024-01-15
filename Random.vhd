library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Random is
	Port(
		A, B : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0);
		clock, reset : in std_logic
	);
end Random;
architecture ArchRandom of Random is
	signal secondClock, thirdClock, fourthClock : std_logic := '0';
	signal counter, counter2, counter3 : integer := 0;
	signal tr, empty : std_logic_vector(31 downto 0) := (others => '0');
	signal rand : integer := 0;
	signal flag : std_logic := '0';
begin
	process(clock, reset)
	begin
		if reset = '0' then
			counter <= 0;
		elsif rising_edge(clock) then
			if counter = conv_integer(B) + 1 then
				counter <= 0;
				secondClock <= not secondClock;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	process(clock, reset)
	begin
		if reset = '0' then
			counter2 <= 0;
		elsif rising_edge(clock) then
			if counter2 = conv_integer(A) + 1 then
				counter2 <= 0;
				thirdClock <= not thirdClock;
			else
				counter2 <= counter2 + 1;
			end if;
		end if;
	end process;
	process(thirdClock, reset)
		variable con : integer;
	begin
		if reset = '0' then
			con := 0;
			rand <= 0;
		elsif falling_edge(thirdClock) then
			con := (conv_integer(B) - conv_integer(A));
			if con < 0 then
				con := con * (0-1);
			end if;
			if rand > con then
				rand <= 0;
			end if;
			if flag = '0' then
				rand <= rand + 1;
			end if;
		end if;
	end process;
	process(clock, reset)
	begin
		if falling_edge(clock) then
			if clock = '1' and secondClock = '1' and thirdClock = '1' then
				flag <= not flag;
			end if;
		end if;
	end process;
	process(secondClock, reset)
	begin
		if reset = '0' then
			counter3 <= 0;
		elsif falling_edge(secondClock) then
			if counter3 = 5 then
				fourthClock <= not fourthClock;
				counter3 <= 0;
			else
				counter3 <= counter3 + 1;
			end if;
		end if;
	end process;
	process(fourthClock)
	begin
		if rising_edge(fourthClock) then
			if flag = '0' then
				tr <= empty;
			end if;
			if flag = '1' and tr = empty then
				tr <= conv_std_logic_vector(rand + conv_integer(A), 32);
			end if;
			if tr /= empty then
				result <= tr;
			end if;
		end if;
	end process;
end ArchRandom;