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
        stepmotor_pio      : out std_logic_vector(LEN - 1 downto 0);

        -- Avalion Memmory Mapped Slave
        avs_address     : in  std_logic_vector(3 downto 0)  := (others => '0'); 
        avs_read        : in  std_logic                     := '0';             
        avs_readdata    : out std_logic_vector(31 downto 0) := (others => '0'); 
        avs_write       : in  std_logic                     := '0';             
        avs_writedata   : in  std_logic_vector(31 downto 0) := (others => '0')
    );
end entity peripheral_LED;

architecture rtl of peripheral_LED is
component stepmotor is
        port (
            clk : in std_logic;
            en     : in std_logic;                    -- 1 on / 0 off
            dir    : in std_logic;                    -- 1 clock wise
            vel    : in std_logic_vector(1 downto 0); -- 00: low / 11: fast
            phases : out std_logic_vector(3 downto 0)
        );
end component;
signal en  : std_logic;
signal dir : std_logic;
signal vel : std_logic_vector(1 downto 0);
begin

  sm: stepmotor port map(
        clk,
        en,
        dir,
        vel,
        stepmotor_pio(3 downto 0)
    );
  process(clk)
  begin
    if (reset = '1') then
      LEDs <= (others => '0');
    elsif(rising_edge(clk)) then
        if(avs_address = "0000") then                  -- REG_DATA
            if(avs_write = '1') then
              en <= avs_writedata(0);
            elsif (avs_read = '1') THEN
              avs_readdata(0) <= en;
            end if;
        elsif(avs_address = "0001") then                  -- REG_DATA
            if(avs_write = '1') then
              dir <= avs_writedata(0);
            elsif (avs_read = '1') THEN
              avs_readdata(0) <= dir;
            end if;
        elsif(avs_address = "0001") then                  -- REG_DATA
            if(avs_write = '1') then
              vel <= avs_writedata(1 downto 0);
            elsif (avs_read = '1') THEN
              avs_readdata(1 downto 0) <= vel;
            end if;
        end if;
    end if;
  end process;

end rtl;
