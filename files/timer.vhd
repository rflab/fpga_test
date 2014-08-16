library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --+

entity RamenTimer is

	generic(
		n_div_clk_bit 	: integer := 15;
		n_clk_bit 		: integer := 19
		);  

 	port (
		clk			: in std_logic;
		sw_in0,
	    sw_in1,
	    sw_in2		: in std_logic;
	    sw_in_run	: in std_logic;
	    led_out0,
		led_out1,
		led_out2	: out std_logic_vector(7 downto 0);
		speaker_out : out std_logic := '0'
		);

end RamenTimer;

architecture rtl of RamenTimer is

	signal clk_counter			: std_logic_vector(n_clk_bit - 1 downto 0) := (others => '0');
	signal div_clk_sw			: std_logic := '0';
	signal is_run				: std_logic := '0';
	signal is_countdown			: std_logic := '0'; --[sec] base count down?
	
	signal dot0	: std_logic := '0';
	signal dot1	: std_logic := '0';
	signal dot2	: std_logic := '1';

	signal
		timer_clk0,
		timer_clk1,
		timer_clk2,
		timer_clk3,
		timer_clk4		: std_logic := '0';
	signal
		timer_counter0,
		timer_counter1,
		timer_counter2,
		timer_counter3,
		timer_counter4	: std_logic_vector(3 downto 0) := (others => '0');
	signal
		timer_out0,
		timer_out1,
		timer_out2		: std_logic_vector(3 downto 0) := (others => '0');
	signal
		sw_node0,
		sw_node1,
		sw_node2,
		sw_node_run		: std_logic := '0';
	signal
		sw_latch0,
		sw_latch1,
		sw_latch2,
		sw_latch_run 	: std_logic := '0';
	signal
		sw_pulse0,
		sw_pulse1,
		sw_pulse2,
		sw_pulse_run 	: std_logic := '0';

	component LED
 	port (
	    dot			: in  std_logic := '0';
		counter		: in  std_logic_vector(3 downto 0) := (others => '0');
	    led_out		: out std_logic_vector(7 downto 0) := (others => '0')
		);
	end component;

begin

------------------------------------------------------------
--port map
	segled_0 : LED 
	port map(
		dot => dot0,
		counter => timer_out0,
		led_out => led_out0
		);

	segled_1 : LED 
	port map(
		dot => dot1,
		counter => timer_out1,
		led_out => led_out1
		);
		
	segled_2 : LED 
	port map(
		dot => dot2,
		counter => timer_out2,
		led_out => led_out2
		);




------------------------------------------------------------
--Timer	clk

	------------------------------------------------------------
	--mode change
	process(clk)
	begin
		if clk'event and clk ='0' then
			if sw_pulse_run = '1' then
				is_run <= not is_run;
			end if;
			if 
				timer_counter0 = "0000" and
		 		timer_counter1 = "0000" and
		 		timer_counter2 = "0000" and
		 		timer_counter3 = "0000" and
		 		timer_counter4 = "0000" then
				speaker_out <= '1';
				is_run <= '0';
			else
				speaker_out <= '0';
			end if;	
		end if;
	end process;
	
	------------------------------------------------------------
	--original clk++
	process (clk)
	begin
		if clk'event and clk = '1' then
			if clk_counter = "1010000100100010000" then
				timer_clk0 <= '1';
				clk_counter <= "0000000000000000000";
			else
				timer_clk0 <= '0';
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process;

	------------------------------------------------------------
	--0.01[sec]		
		process (clk)
		begin
			if clk'event and clk = '1' then
				if is_run = '1' and timer_clk0 = '1' then
					timer_counter0 <= timer_counter0 - 1;
				end if;
				if timer_counter0 = "1111" then
					timer_counter0 <= "1001";
					timer_clk1 <= '1';
				else
					timer_clk1 <= '0';
				end if;
				if timer_counter0 = "1010" then
					timer_counter0 <= "0000";
				end if;
			end if;
		end process;
		
	------------------------------------------------------------
	--0.1[sec]
		process (clk)
		begin
			if clk'event and clk = '1' then
				if timer_clk1 = '1' then
					timer_counter1 <= timer_counter1 - 1;
				end if;
				if timer_counter1 = "1111" then
					timer_counter1 <= "1001";
					timer_clk2 <= '1';
				else
					timer_clk2 <= '0';
				end if;
				if timer_counter1 = "1010" then
					timer_counter1 <= "0000";
				end if;
			end if;
		end process;
		
	------------------------------------------------------------
	--1[sec]	
		process (clk)
		begin
			if clk'event and clk = '1' then
				if timer_clk2 = '1' then
					timer_counter2 <= timer_counter2 - 1;
				end if;
				if sw_pulse0 = '1' then
					timer_counter2 <= timer_counter2 + 1;
				end if;
				if timer_counter2 = "1111" then
					timer_counter2 <= "1001";
					timer_clk3 <= '1';
				else
					timer_clk3 <= '0';
				end if;
				if timer_counter2 = "1010" then
					timer_counter2 <= "0000";
				end if;
			end if;
		end process;
		
	------------------------------------------------------------
	--10[sec]
		process (clk)
		begin
			if clk'event and clk = '1' then
				if timer_clk3 = '1' then
					timer_counter3 <= timer_counter3 - 1;
				end if;
				if sw_pulse1 = '1' then
					timer_counter3 <= timer_counter3 + 1;
				end if;
				if timer_counter3 = "1111" then
					timer_counter3 <= "0101";
					timer_clk4 <= '1';
				else
					timer_clk4 <= '0';
				end if;
				if timer_counter3 = "0110" then
					timer_counter3 <= "0000";
				end if;
			end if;
		end process;
		
	------------------------------------------------------------
	--1[minute]	
		process (clk)
		begin
			if clk'event and clk = '1' then
				if timer_clk4 = '1' then
					timer_counter4 <= timer_counter4 - 1;
				end if;
				if sw_pulse2 = '1' then
					timer_counter4 <= timer_counter4 + 1;
				end if;
				if timer_counter4 = "1111" then
					timer_counter4 <= "1001";
				end if;
				if timer_counter4 = "1010" then
					timer_counter4 <= "0000";
				end if;
			end if;
		end process;
		
------------------------------------------------------------
--Switch

	------------------------------------------------------------
	--div_clk for chatterring
		div_clk_sw <= clk_counter(n_div_clk_bit - 1);

	------------------------------------------------------------
	--chattering
		process(div_clk_sw)
		begin
			if div_clk_sw'event and div_clk_sw = '1' then
				sw_node0 <= sw_in0;
				sw_node1 <= sw_in1;
				sw_node2 <= sw_in2;
				sw_node_run <= sw_in_run;
			end if;
		end process;	

	------------------------------------------------------------
	--switch on pulse
	--negative logic
		process (clk)
		begin
			if clk'event and clk = '1' then
				if sw_node0 = '0' and sw_latch0 = '0' then		--latch up
					sw_pulse0 <= '1';
					sw_latch0 <= '1';
				elsif sw_node0 = '1' and sw_latch0 = '1' then	--latch down
					sw_pulse0 <= '0';
					sw_latch0 <= '0';
				elsif sw_node0 = '0' and sw_latch0 = '1' then	--hold
					sw_pulse0 <= '0';
					sw_latch0 <= '1';
				end if;
				
				if sw_node1 = '0' and sw_latch1 = '0' then		--latch up
					sw_pulse1 <= '1';
					sw_latch1 <= '1';
				elsif sw_node1 = '1' and sw_latch1 = '1' then	--latch down
					sw_pulse1 <= '0';
					sw_latch1 <= '0';
				elsif sw_node1 = '0' and sw_latch1 = '1' then	--hold
					sw_pulse1 <= '0';
					sw_latch1 <= '1';
				end if;
				
				if sw_node2 = '0' and sw_latch2 = '0' then		--latch up
					sw_pulse2 <= '1';
					sw_latch2 <= '1';
				elsif sw_node2 = '1' and sw_latch2 = '1' then	--latch down
					sw_pulse2 <= '0';
					sw_latch2 <= '0';
				elsif sw_node2 = '0' and sw_latch2 = '1' then	--hold
					sw_pulse2 <= '0';
					sw_latch2 <= '1';
				end if;	
				
				if sw_node_run = '0' and sw_latch_run = '0' then		--latch up
					sw_pulse_run <= '1';
					sw_latch_run <= '1';
				elsif sw_node_run = '1' and sw_latch_run = '1' then	--latch down
					sw_pulse_run <= '0';
					sw_latch_run <= '0';
				elsif sw_node_run = '0' and sw_latch_run = '1' then	--hold
					sw_pulse_run <= '0';
					sw_latch_run <= '1';
				end if;	
			end if;
		end process;
		
	
------------------------------------------------------------
--Disp

	------------------------------------------------------------
	--mode judge 
	process(clk)
	begin
		if timer_counter4 = "0000" and timer_counter3 = "0000" then
			is_countdown <= '1';
		else
			is_countdown <= '0';
		end if;
	end process;
		
	------------------------------------------------------------
	--LED 
	process(clk)
	begin
		if clk'event and clk = '1' then
			if is_countdown = '0' then 
				timer_out0 <= timer_counter2;
				timer_out1 <= timer_counter3;
				timer_out2 <= timer_counter4;
			else
				timer_out0 <= timer_counter0;
				timer_out1 <= timer_counter1;
				timer_out2 <= timer_counter2;
			end if;
		end if;
	end process;
		

		
end rtl; 