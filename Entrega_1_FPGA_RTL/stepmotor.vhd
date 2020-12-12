--
-- Rafael C.
-- ref:
--   - https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vhdl/vhdl_pro_state_machines.htm
--   - https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--   - https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4096117

library IEEE;
use IEEE.std_logic_1164.all;

entity stepmotor is
    generic (
        steps_range : integer := 2000
    );
    port (
        -- Globals
        clk     : in  std_logic;

        -- Controls
        en      : in std_logic;                     -- 1 on/ 0 off
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast

        -- I/Os
        phases  : out std_logic_vector(3 downto 0)
    );
end entity stepmotor;

architecture rtl of stepmotor is

TYPE STATE_TYPE IS (s0, s1, s2, s3);
SIGNAL state       : STATE_TYPE := s0;
signal timer_done  : std_logic  := '0';
signal top_counter : integer range 0 to 50000000;
signal steps_max   : integer := 2000;

begin

process(clk)
    variable steps_counter : integer range 0 to steps_range := 0;
begin
    if ((rising_edge(clk)) and (timer_done = '1') and (steps_counter < steps_max)) then
        steps_counter := steps_counter + 1;
        case state is
            when s0 =>
              state <= s1;
            when s1 =>
              state <= s2;
            when s2 =>
              state <= s3;
            when s3 =>
              state <= s0;
        end case;
    end if;
end process;

process (state)
begin
    if dir = '0' then
        case state is
            when s0 =>
                phases <= "0001";
            when s1 =>
                phases <= "0010";
            when s2 =>
                phases <= "0100";
            when s3 =>
                phases <= "1000";
        end case;
    else
        case state is
            when s3 =>
                phases <= "0001";
            when s2 =>
                phases <= "0010";
            when s1 =>
                phases <= "0100";
            when s0 =>
                phases <= "1000";
        end case;
    end if;
end process;

process (vel)
begin
    case vel is
        when "00" =>
            top_counter <= 1000000;
        when "01" =>
            top_counter <= 500000;
        when "10" =>
            top_counter <= 250000;
        when "11" =>
            top_counter <= 100000;
    end case;
end process;

-- top_counter <= 10000000 when vel = "00" else 100000;

process(clk)
variable counter : integer range 0 to 50000000 := 0;
begin
    if (rising_edge(clk)) then
        if (en = '1') then
            if (counter < top_counter) then
                counter := counter + 1;
                timer_done <= '0';
            else
                counter := 0;
                timer_done <= '1';
            end if;
        end if;
    end if;
end process;

end rtl;
