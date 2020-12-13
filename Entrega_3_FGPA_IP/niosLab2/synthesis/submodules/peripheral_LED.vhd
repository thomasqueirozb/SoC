library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.all;

entity peripheral_LED is
    generic (
        LEN  : natural := 4
    );
    port (
        -- Gloabals
        clk                : in  std_logic                     := '0';             
        reset              : in  std_logic                     := '0';             

        -- I/Os
        LEDs               : out std_logic_vector(LEN - 1 downto 0) := (others => '0');

        -- Avalion Memmory Mapped Slave
        avs_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); 
        avs_read        : in  std_logic                     := '0';             
        avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0'); 
        avs_write       : in  std_logic                     := '0';             
        avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0')
    );
end entity peripheral_LED;

architecture rtl of peripheral_LED is
begin

  process(clk)
  begin
    if (reset = '1') then
      LEDs <= (others => '0');
    elsif(rising_edge(clk)) then
        if(avs_address = "0001") then                  -- REG_DATA
            if(avs_write = '1') then
              LEDs <= avs_writedata(LEN - 1 downto 0);
            end if;
        end if;
    end if;
  end process;

end rtl;
