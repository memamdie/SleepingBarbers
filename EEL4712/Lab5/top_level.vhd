library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk50MHz: in  std_logic;
        switch  : in  std_logic_vector(9 downto 0);
        -- gpio    : in  std_logic_vector(7 downto 0);
        button  : in  std_logic_vector(2 downto 0);
        led0    : out std_logic_vector(6 downto 0);
        led0_dp : out std_logic;
        led1    : out std_logic_vector(6 downto 0);
        led1_dp : out std_logic;
        led2    : out std_logic_vector(6 downto 0);
        led2_dp : out std_logic;
        led3    : out std_logic_vector(6 downto 0);
        led3_dp : out std_logic);
end top_level;

architecture STR of top_level is

    component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;

    component gcd
      generic (
          WIDTH : positive := 8);
      port (
          clk    : in  std_logic;
          rst    : in  std_logic;
          go     : in  std_logic;
          done   : out std_logic;
          x      : in  std_logic_vector(WIDTH-1 downto 0);
          y      : in  std_logic_vector(WIDTH-1 downto 0);
          output : out std_logic_vector(WIDTH-1 downto 0));
    end component;


    signal output1, output2, output3      : std_logic_vector(3 downto 0);
    signal done1, done2, done3            : std_logic;
    constant C0                           : std_logic_vector(3 downto 0) := "0000";
    constant C1                           : std_logic_vector(3 downto 0) := "1111";


begin  -- STR

    -- map GCD output to rightmost 7-segment LEDs
      U_LED0 : decoder7seg port map (
        input  => output1,
        output => led0);

	   U_LED1 : decoder7seg port map (
        input  => output2,
        output => led1);
    -- all other LEDs should display 0

    U_LED2 : decoder7seg port map (
        input  => output3,
        output => led2);

    U_LED3 : decoder7seg port map (
        input  => C0,
        output => led3);


    -- instantiate the GCD
    U_GCD : entity work.gcd(FSMD)
        generic map (
            WIDTH => 4)
        port map (
            clk       => clk50MHz,
            rst       => not button(2),
            go        => not button(0),
            done      => done1,
            x         => switch(3 downto 0),  -- map x to the leftmost 4 switches
            y         => switch(7 downto 4),  -- map y to the next 4 switches
            output    => output1);
    U_GCD1 : entity work.gcd(FSM_D1)
        generic map (
            WIDTH => 4)
        port map (
            clk       => clk50MHz,
            rst       => not button(2),
            go        => not button(0),
            done      => done2,
            x         => switch(3 downto 0),  -- map x to the leftmost 4 switches
            y         => switch(7 downto 4),  -- map y to the next 4 switches
            output    => output2);
    U_GCD2 : entity work.gcd(FSM_D2)
        generic map (
            WIDTH => 4)
        port map (
            clk       => clk50MHz,
            rst       => not button(2),
            go        => not button(0),
            done      => done3,
            x         => switch(3 downto 0),  -- map x to the leftmost 4 switches
            y         => switch(7 downto 4),  -- map y to the next 4 switches
            output    => output3);


    -- map done to the led0 decimal point, all others are off.
    led0_dp <= not done1;
    led1_dp <= not done2;
    led2_dp <= not done3;
    led3_dp <= '1';

end STR;

-- configuration top_level_cfg of top_level is
-- for STR
-- 	for U_GCD : gcd
--         use entity work.gcd(FSMD);
-- 	end for;
-- end for;
-- end top_level_cfg;
