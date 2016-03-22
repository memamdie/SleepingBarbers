library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VGA_LIB.all;

entity vga_tb is
end vga_tb;

architecture TB of vga_tb is

  -- MODIFY TO MATCH YOUR TOP LEVEL
  component vga
    port ( clk50MHz         : in  std_logic;
           rst              : in  std_logic;
           option           : in std_logic;
           buttons          : in  std_logic_vector(2 downto 0);
           red, green, blue : out std_logic_vector(3 downto 0);
           hsync, vsync   : out std_logic);
  end component;

  signal clk, option      : std_logic := '0';
  signal rst              : std_logic := '1';
  signal buttons_n        : std_logic_vector(2 downto 0);
  signal red, green, blue : std_logic_vector(3 downto 0);
  signal h_sync, v_sync   : std_logic;

begin  -- TB

  -- MODIFY TO MATCH YOUR TOP LEVEL
  UUT : vga port map (
    clk50MHz  => clk,
    rst       => rst,
    buttons   => buttons_n,
    option    => option,
    red       => red,
    green     => green,
    blue      => blue,
    hsync     => h_sync,
    vsync     => v_sync);


  clk <= not clk after 10 ns;

  process
  begin

    buttons_n <= (others => '1');
    report ("Resetting");
    rst       <= '1';
    wait for 200 ns;

    rst     <= '0';
    report ("Reset is now 0.\n Testing the center button for the first image.\n");
    wait for 40 ns;

    buttons_n <= "110";
    report ("\n Testing the top left button for the first image.\n");
    wait for 40 ms;

    buttons_n <= "101";
    report ("\n Testing the top right button for the first image.\n");
    wait for 40 ms;

    buttons_n <= "100";
    report ("\n Testing the bottom left button for the first image.\n");
    wait for 40 ms;

    buttons_n <= "011";
    report ("\n Testing the bottom right button for the first image.\n");
    wait for 40 ms;


    option <= '1';

    buttons_n <= "111";
    report ("\n Testing the center button for the second image.\n");
    wait for 100 ns;

    buttons_n <= "110";
    report ("\n Testing the top left button for the second image.\n");
    wait for 40 ms;

    buttons_n <= "101";
    report ("\n Testing the top right button for the second image.\n");
    wait for 40 ms;

    buttons_n <= "100";
    report ("\n Testing the bottom left button for the second image.\n");
    wait for 40 ms;

    buttons_n <= "011";
    report ("\n Testing the bottom right button for the second image.\n");
    wait for 40 ms;

    report "DONE";
    wait;

  end process;

end TB;
