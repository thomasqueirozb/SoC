library IEEE;
use IEEE.std_logic_1164.all;

entity Lab3_FPGA_IP is
    port (
        -- Gloabals
        fpga_clk_50        : in  std_logic;             -- clock.clk

        -- I/Os
        fpga_led_pio  : out std_logic_vector(5 downto 0);
		  stepmotor_pio : out std_logic_vector(3 downto 0);
		  switch        : in  std_logic_vector(9 downto 0)
    );
  
end entity Lab3_FPGA_IP;

architecture rtl of Lab3_FPGA_IP is

component niosLab2 is port (
  clk_clk       : in  std_logic                    := 'X'; -- clk
  reset_reset_n : in  std_logic                    := 'X'; -- reset_n
  leds_name     : out std_logic_vector(5 downto 0);        -- name
  sw_export     : in  std_logic_vector(9 downto 0);        -- export
  vroomvroom_export : out std_logic_vector(3 downto 0)     -- export
);
end component niosLab2;

begin

u0 : component niosLab2 port map (
  clk_clk       => fpga_clk_50,    --  clk.clk
  reset_reset_n => '1',            --  reset.reset_n
  sw_export     => switch,
  vroomvroom_export => stepmotor_pio,
  leds_name   => fpga_led_pio      --  leds.name
);

end rtl;
