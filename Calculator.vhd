library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Calculator is
	Port(
		clock, reset : in std_logic;
		rows,  anodes, leds : out std_logic_vector(3 downto 0);
		cols : in std_logic_vector(3 downto 0);
		lcdData, segments : out std_logic_vector(7 downto 0);
		rw, rs, e : out std_logic
	);
end Calculator;
architecture ArchCalculator of Calculator is
	component Keyboard is
	GENERIC(
			FREQ_CLK : INTEGER := 50000000
	);
	port(
		CLK 		  : IN  STD_LOGIC;
		COLUMNAS   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		FILAS 	  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		BOTON_PRES : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		IND		  : OUT STD_LOGIC
	);
	end component;
	component CPU is
	Port(
		clock, reset : in std_logic;
		opCode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		negative : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);
	end component;
	component LCD IS
	PORT(
		clk        : IN    STD_LOGIC;
		reset    : IN    STD_LOGIC;
		rw, rs, e  : OUT   STD_LOGIC;
		lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
		line1_buffer : IN STD_LOGIC_VECTOR(127 downto 0);
		line2_buffer : IN STD_LOGIC_VECTOR(127 downto 0)
	);
	END component;
	component RAM is
	Port(
		dataIn : in std_logic_vector(3 downto 0);
		direction : in integer;
		dataOut : out std_logic_vector(3 downto 0);
		we, clock, reset, resetLogic : in std_logic
	);
	end component;
	component Display is
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		number : in STD_LOGIC_VECTOR(3 downto 0);
		segments : out STD_LOGIC_VECTOR(7 downto 0);
		anodes : out STD_LOGIC_VECTOR(3 downto 0)
	);
	end component;
	component Converter is
	Port(
		multiplier : in integer;
		clock : in std_logic;
		numberConvert : in std_logic_vector(3 downto 0);
		preNumber : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	);
	end component;
	component BinaryToBCD is
		Port (
			input : in  STD_LOGIC_VECTOR (15 downto 0);
			clock, reset : in  STD_LOGIC;
			output : out  STD_LOGIC_VECTOR (15 downto 0)
		);
	end component;
	component ConvertToLCD is
	Port(
		input : in std_logic_vector(31 downto 0);
		lcd_data : out std_logic_vector(127 downto 0);
		clock, reset : in std_logic
	);
	end component;
	--signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
	--signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	--signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000000101";
	--signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	-- Flags
	signal inputBuffer1, dataOut, selector, opCode, operationSelector : std_logic_vector(3 downto 0) := (others => '0');
	signal buttonPressFlag, enableRAM1_Flag, getRAM1_Flag, readingRam, resetRAM, inputAComplete, inputBComplete, negativeCPU : std_logic := '0';
	signal memoryDirection1, steps, globalSteps, counter, counter2, temp, indexEnd : integer := 0;
	signal indexBegin : integer := 7;
	signal multiplier, divider : integer := 1;
	signal writeRAM1_Flag, resetCPU : std_logic := '1';
	signal secondClock : std_logic;
	signal resultCPUBCD : std_logic_vector(15 downto 0);
	signal inputA, inputB, A, B, bufferConvert, bufferConvert2, resultCPU : std_logic_vector(31 downto 0) := (others => '0');
	signal line1, line2 : std_logic_vector(127 downto 0);
	function PrintCurrentOp(opCode : std_logic_vector(3 downto 0); selectorOp : std_logic_vector(3 downto 0)) return std_logic_vector is
		variable line1 : std_logic_vector(127 downto 0);
	begin
		case selectorOp is
		when "0000" => -- ops A
			case opCode is
			when "0000" => -- Adder
								line1 := x"53656c20413a2053756d612020202020";
			when "0001" => -- Substract
								line1 := x"53656c20413a20526573746120202020";
			when "0010" => -- Multiplier
								line1 := x"53656c20413a204d756c7469706c6920";
			when others => -- zzzz
								line1 := x"53656c20413a204e6f2076616c69646f";
			end case;
		when "0001" => -- ops B
			case opCode is
			when "0011" => -- Divider
								line1 := x"53656c20423a204469766973696f6e20";
			when "0100" => -- Power
								line1 := x"53656c20423a20506f74656e63696120";
			when "0101" => -- Factorial
								line1 := x"53656c20423a20466163746f7269616c";
			when others => -- zzzz
								line1 := x"53656c20423a204e6f2076616c69646f";
			end case;
		when "0010" => -- ops C
			case opCode is
			when "0110" => -- RAND
								line1 := x"53656c20433a2052616e646f6d202020";
			when "0111" => -- MCD
								line1 := x"53656c20433a204d4344202020202020";
			when "1000" => -- mcm
								line1 := x"53656c20433a206d636d202020202020";
			when others => -- zzzz
								line1 := x"53656c20433a204e6f2076616c69646f";
			end case;
		when "0011" => -- ops D
			case opCode is
			when "1001" => -- Compare
								line1 := x"53656c20443a20436f6d706172652020";
			when others => -- zzzz
								line1 := x"53656c20443a204e6f2076616c69646f";
			end case;
		when others =>
								line1 := x"2d2d204e6f2076616c69646f202d2d20";
		end case;
		return line1;
	end PrintCurrentOp;
begin
	Calculator : CPU Port Map(clock => clock, reset => resetCPU, opCode => opCode, A => A, B => B, result => resultCPU, negative => negativeCPU);
	InputKeyboard : Keyboard Generic Map (FREQ_CLK => 50000000) Port Map (CLK => clock, COLUMNAS => cols, FILAS => rows, BOTON_PRES => selector, IND => buttonPressFlag);
	process(clock, selector, buttonPressFlag, reset, writeRAM1_Flag)
	begin
		--leds <= not conv_std_logic_vector(memoryDirection1, 4);
		if rising_edge(clock) then
			
			--leds(1) <= not inputAComplete;
			--leds(0) <= not inputBComplete;
			leds <= not resultCPU(3 downto 0);
			A <= inputA;
			B <= inputB;
			if inputAComplete = '1' and inputBComplete = '1' then
				--line2(7 downto 0) <= "0011" & resultCPU(3 downto 0);
				--leds  <= not B(3 downto 0);
				resetCPU <= '1';
			end if;
			if writeRAM1_Flag = '0' then
				-- Dump all data into a buffer
				writeRAM1_Flag <= '0';
				if readingRam = '0' then
					--line1(63 downto 0) <= resultBCD;
					if inputAComplete = '0' then
						inputA <= bufferConvert2;
						inputAComplete <= '1';
						A <= inputA;
						--resetCPU <= '0';
					elsif inputBComplete = '0' then
						inputB <= bufferConvert2;
						inputBComplete <= '1';
						B <= inputB;
						--resetCPU <= '0';
					end if;
					bufferConvert <= (others => '0');
					multiplier <= 1;
					memoryDirection1 <= 0;
					writeRAM1_Flag <= '1';
					counter <= 0;
				else
				-- Dump out the RAM values
					if memoryDirection1 >= 0 then
						if counter > 0 then
							bufferConvert <= bufferConvert2;
							multiplier <= multiplier * 10;
						else
							counter <= counter + 1;
						end if;
						memoryDirection1 <= memoryDirection1 - 1;
					else
						readingRam <= '0';
					end if;
				end if;
			else
				writeRAM1_Flag <= '1';
				enableRAM1_Flag <= '1';
				resetRAM <= '0';
			-- Cases in order from 0 - 9, A - D, *, #
				if buttonPressFlag = '1' and selector = "0100" then -- 0
					inputBuffer1 <= "0000";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1010" then -- 1
					inputBuffer1 <= "0001";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1011" then -- 2
					inputBuffer1 <= "0010";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1100" then -- 3
					inputBuffer1 <= "0011";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "0011" then -- 4
					inputBuffer1 <= "0100";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "0110" then -- 5
					inputBuffer1 <= "0101";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1001" then -- 6
					inputBuffer1 <= "0110";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "0010" then -- 7
					inputBuffer1 <= "0111";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "0101" then -- 8
					inputBuffer1 <= "1000";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1000" then -- 9
					inputBuffer1 <= "1001";
					if memoryDirection1 < 10 then
						memoryDirection1 <= memoryDirection1 + 1;
					end if;
				elsif buttonPressFlag = '1' and selector = "1101" then -- A
					case operationSelector is
					when "0000" => opCode <= "0000"; -- Adder
					when "0001" => opCode <= "0011"; -- Divisor
					when "0010" => opCode <= "0110"; -- RAND
					when "0011" => opCode <= "1001"; -- Comparator
					when others => opCode <= "1010"; -- zzz
					end case;
				elsif buttonPressFlag = '1' and selector = "1111" then -- B
					case operationSelector is
					when "0000" => opCode <= "0001"; -- Substract
					when "0001" => opCode <= "0100"; -- Power
					when "0010" => opCode <= "0111"; -- MCM
					when others => opCode <= "1010"; -- zzz
					end case;
				elsif buttonPressFlag = '1' and selector = "0000" then -- C
					case operationSelector is
					when "0000" => opCode <= "0010"; -- Multiplier
					when "0001" => opCode <= "0101"; -- Factorial
					when "0010" => opCode <= "1000"; -- MCD
					when others => opCode <= "1010"; -- zzz
					end case;
				elsif buttonPressFlag = '1' and selector = "1110" then -- D
					case operationSelector is
					when "0000" => operationSelector <= "0001"; -- A
					when "0001" => operationSelector <= "0010"; -- B
					when "0010" => operationSelector <= "0011"; -- C
					when "0011" => operationSelector <= "0100"; -- D
					when others => operationSelector <= "0000"; -- Rolback
					end case;
				elsif buttonPressFlag = '1' and selector = "0001" then -- *
					-- Time to read the next number
					writeRAM1_Flag <= '0';
					readingRam <= '1';
				elsif buttonPressFlag = '1' and selector = "0111" then -- # reset
					line2 <= (others => '0');
					inputBuffer1 <= (others => '0');
					resetRAM <= '1';
					inputBComplete <= '0';
					inputAComplete <= '0';
					inputA <= (others => '0');
					inputB <= (others => '0');
					A <= (others => '0');
					B <= (others => '0');
					resetCPU <= '0';
				end if;
			end if;
			line1 <= PrintCurrentOp(opCode, operationSelector);
			if negativeCPU = '1' then
				--line2(37 downto 32)
			end if;
			line2(31 downto 0) <= "0011" & resultCPUBCD(15 downto 12) & "0011" & resultCPUBCD(11 downto 8) & "0011" & resultCPUBCD(7 downto 4) & "0011" & resultCPUBCD(3 downto 0);
		end if;
	end process;
	RAM_1 : RAM Port Map(dataIn => inputBuffer1, direction => memoryDirection1, dataOut => dataOut, we => writeRAM1_Flag, clock => clock, reset => reset, resetLogic => resetRAM);
	DisplayLCD : LCD Port Map (clk => clock, reset => reset, lcd_data => lcdData, line1_buffer => line1, line2_buffer => line2, rs => rs, rw => rw, e => e);
	Display4Dig : Display Port Map(clk => clock, reset => reset, number => selector, segments => segments, anodes => anodes);
	ConverterRAM : Converter Port Map(multiplier => multiplier, numberConvert => dataOut, preNumber => bufferConvert, result => bufferConvert2, clock => clock);
	BinaryBCD : BinaryToBCD Port Map(input => resultCPU(15 downto 0), reset => resetCPU, clock => clock, output => resultCPUBCD);
end ArchCalculator;