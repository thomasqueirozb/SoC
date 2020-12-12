library IEEE;
use IEEE.std_logic_1164.all;

entity Lab1_FPGA_RTL is
    port (
        -- Globals
        fpga_clk_50: in  std_logic;

        -- I/Os
        -- fpga_led_pio: out std_logic_vector(5 downto 0);
        fpga_slide: in std_logic_vector(9 downto 0); -- sw slide
        fpga_button: in std_logic_vector(3 downto 0); -- push button
        fpga_led: out std_logic_vector(9 downto 0) -- pin/pio led
  );
end entity Lab1_FPGA_RTL;

architecture rtl of Lab1_FPGA_RTL is

-- signal
signal blink : std_logic := '0';
signal pwm : std_logic := '0';

begin

process(fpga_clk_50)
    variable counter : integer range 0 to 25000000 := 0;
    variable counter_loop: integer range 0 to 25000000 := 50000;

   -- variable v: integer range 0 to 25000000 := 0;


    begin
        if (rising_edge(fpga_clk_50)) then

            counter_loop := 0; --+ (fpga_slide(0) + (fpga_slide(1) << 2) + (fpga_slide(2) << 4) + fpga_slide);
            for i in 0 to fpga_slide'length-1 loop
                if (fpga_slide(i) = '1') then
                   -- v := 1;
                   -- for j in 0 to i-1 loop
                   --     v := v * 2;
                   -- end loop;
                    counter_loop := counter_loop + 2**i;
                end if;
            end loop;

           -- for i in 0 to 10 loop
           --     counter_loop := counter_loop * 2;
           -- end loop;

            -- counter_loop max value = 2^10 - 1 ~= 2^10 = 1024
            -- counter_loop max value *= 10,000 = 10,240,000
            -- counter_loop max value + 10,000,000 = 10,240,000 + 10,000,000 < 25,000,000

            counter_loop := 10000000 + counter_loop * 10000;

            if (counter < counter_loop) then
                counter := counter + 1;
            else
                blink <= not blink and fpga_button(0);
                counter := 0;
            end if;
           -- blink <= blink
    end if;
end process;

process(fpga_clk_50)
    variable counter : integer range 0 to 25000000 := 0;
begin
    if (rising_edge(fpga_clk_50)) then
        if (counter < 25000000) then
            counter := counter + 1;
            pwm <= '0';
        else
            counter := 0;
            pwm <= '1';
        end if;
    end if;
end process;


fpga_led(0) <= blink; --  and pwm;
fpga_led(1) <= blink; --  and pwm;
fpga_led(2) <= blink; --  and pwm;
fpga_led(3) <= blink; --  and pwm;
fpga_led(4) <= blink; --  and pwm;
fpga_led(5) <= blink; --  and pwm;

fpga_led(7) <= fpga_button(1);


end rtl;
