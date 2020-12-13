library IEEE;
use IEEE.std_logic_1164.all;

entity Entrega_1_FPGA_RTL is
    port (
        -- Gloabals
        fpga_clk_50   : in  std_logic;

        -- I/Os
        stepmotor_en  : in  std_logic;
        stepmotor_dir : in  std_logic;
        stepmotor_vel : in  std_logic_vector(1 downto 0);
        stepmotor_pio : out std_logic_vector(3 downto 0)
);
end entity Entrega_1_FPGA_RTL;

architecture rtl of Entrega_1_FPGA_RTL is

component stepmotor is
    port (
        -- Globals
        clk   : in  std_logic;

        -- controls
        en      : in std_logic;                     -- 1 on/ 0 of
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast

        -- I/Os
        phases  : out std_logic_vector(3 downto 0)
    );
end component;

begin

u1 : stepmotor port map (fpga_clk_50, stepmotor_en, stepmotor_dir, stepmotor_vel, stepmotor_pio);

end rtl;
