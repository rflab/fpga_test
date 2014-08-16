library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --+

entity LED10 is

	  port (
		clk			: in std_logic;
		sw_in		: in std_logic;
	    led_out		: out std_logic_vector(7 downto 0)
		);

end LED10;

architecture rtl of LED10 is

signal counter_curr, counter_next	: std_logic_vector(3 downto 0) := (others => '0'); --statemachine

begin

	--StateMachine
	process (clk)
	begin
		if clk'event and clk = '1' then
			if sw_in = '0' then
				counter_curr <= counter_next;
			end if;
		end if;
	end process;
	
	--State
	process (counter_curr)
	begin
		case counter_curr is
			when "0000" =>
				counter_next <= "0001";
			when "0001" =>
				counter_next <= "0010";
			when "0010" =>
				counter_next <= "0011";
			when "0011" =>
				counter_next <= "0100";
			when "0100" =>
				counter_next <= "0101";
			when "0101" =>
				counter_next <= "0110";
			when "0110" =>
				counter_next <= "0111";
			when "0111" =>
				counter_next <= "1000";
			when "1000" =>
				counter_next <= "1001";
			when "1001" =>
				counter_next <= "0000";
			when others => null;
		end case;
	end process;
	
	--disp
	process (counter_curr)
	begin
		case counter_curr is
			when "0000" =>
				led_out <= "00000011";
			when "0001" =>
				led_out <= "10011111";
			when "0010" =>
				led_out <= "00100101";
			when "0011" =>
				led_out <= "00001101";
			when "0100" =>
				led_out <= "10011001";
			when "0101" =>
				led_out <= "01001001";
			when "0110" =>
				led_out <= "01000001";
			when "0111" =>
				led_out <= "00011111";
			when "1000" =>
				led_out <= "00000001";
			when "1001" =>
				led_out <= "00001001";
			when "1010" =>
				led_out <= "00010001";
			when "1011" =>
				led_out <= "11000001";
			when "1100" =>
				led_out <= "11100101";
			when "1101" =>
				led_out <= "10000101";
			when "1110" =>
				led_out <= "01100001";
			when "1111" =>
				led_out <= "01110001";
			when others => null;
		end case;
	end process;
end rtl; 