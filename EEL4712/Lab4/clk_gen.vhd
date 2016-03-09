library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_gen is
    generic (
        ms_period : positive);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
    port (
        clk50MHz : in  std_logic;
        rst      : in  std_logic;
        button_n : in  std_logic;
        clk_out  : out std_logic);
end clk_gen;

architecture behavior of clk_gen is
  component clk_div
    generic(clk_in_freq  : natural;
            clk_out_freq : natural);
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic
        );
  end component;

    signal kilo, clk_sig : std_logic;
    signal counter : integer range 0 to ms_period := 0;
    begin
    U_DIV : clk_div
      generic map (
          clk_in_freq => 50000,
          clk_out_freq => 1
      )
      port map (
        clk_in => clk50MHz,
        rst => rst,
        clk_out => kilo
      );
      process(kilo, rst)
      begin
        if (rst = '1') then
            counter <= 0;
            clk_sig <= '0';
        elsif rising_edge(kilo) then
          if button_n = '0' then
            if counter = ms_period then
              clk_sig <= '1';
              counter <= 1;
            else
                clk_sig <= '0';
                counter <= counter + 1;
            end if;
          else
              clk_sig <='0';
              counter <= 0;
            end if;
        end if;
      end process;
      clk_out <= clk_sig;
end behavior;
