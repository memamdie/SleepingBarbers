-- Greg Stitt
-- University of Florida

-- The following testbench generates inputs for the counter4bit entity. Make
-- sure to change the architecture that is instantiated to test each
-- implementation.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_tb is
end counter_tb;


architecture TB of counter_tb is
    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal up     : std_logic := '1';
    signal ld     : std_logic := '1';
    signal input  : std_logic_vector(3 downto 0) := "0000";
    signal output : std_logic_vector(3 downto 0);

    signal done : std_logic := '0';

begin

    -- Change the architecture to test the different implementations
    UUT : entity work.counter
        port map (
            clk    => clk,
            rst    => rst,
            up_n     => up,
            load_n => ld,
            input => input,
            output => output);

    -- create the clock (and not done ensure that the simulation will finish)
    clk <= not clk after 10 ns;

    -- toggle the up input every 500 ns;
    -- up <= not up after 500 ns;

    -- stop the simulation after 5000 ns;
    done <= '1' after 400 ns;

    process
    begin
        -- reset the counter for 4 cycles
        rst <= '1';
        ld <= '1';
        up <= '1';
        for i in 0 to 3 loop
            wait until rising_edge(clk);
        end loop;

        report "Reset is now false. Should be counting down";
        rst <= '0';
        wait for 100 ns;


        report "Up is now true. Should be counting up";
        up <= '0';
        wait for 100 ns;

        up <= '1';
        input <= "1101";
        ld <= '0';
        report "Load is now true. Should hold input in output";
        wait for 100 ns;
        assert(output = "1101") report "Error load did not work";

        ld <= '1';

        report "SIMULATION FINISHED";
        -- wait until done is asserted
        wait;

    end process;


end TB;
