library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --+

entity LED is

	  port (
	    dot			: in  std_logic := '0';
		counter		: in  std_logic_vector(3 downto 0) := (others => '0');
	    led_out		: out std_logic_vector(7 downto 0) := (others => '0')
		);

end LED;

architecture rtl of LED is

begin

	led_out(0) <= not dot;
	
	process (counter)
	begin
		case counter is
			when "0000" =>
				led_out(7 downto 1) <= "0000001";
			when "0001" =>
				led_out(7 downto 1) <= "1001111";
			when "0010" =>
				led_out(7 downto 1) <= "0010010";
			when "0011" =>
				led_out(7 downto 1) <= "0000110";
			when "0100" =>
				led_out(7 downto 1) <= "1001100";
			when "0101" =>
				led_out(7 downto 1) <= "0100100";
			when "0110" =>
				led_out(7 downto 1) <= "0100000";
			when "0111" =>
				led_out(7 downto 1) <= "0001111";
			when "1000" =>
				led_out(7 downto 1) <= "0000000";
			when "1001" =>
				led_out(7 downto 1) <= "0000100";
			when "1010" =>
				led_out(7 downto 1) <= "0001000";
			when "1011" =>
				led_out(7 downto 1) <= "1100000";
			when "1100" =>
				led_out(7 downto 1) <= "1110010";
			when "1101" =>
				led_out(7 downto 1) <= "1000010";
			when "1110" =>
				led_out(7 downto 1) <= "0110000";
			when "1111" =>
				led_out(7 downto 1) <= "0111000";
			when others => null;
		end case;
	end process;
end rtl; 