library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl1 is
  port (
    x_en, y_en, x_sel, y_sel, output_en, done : out std_logic;
    x_lt_y, x_ne_y, go, clk, rst              : in std_logic
  );
end entity;

architecture ctrl1 of ctrl1 is
  type STATE_TYPE is (STATE_START, STATE_INIT, STATE_LOOP, STATE_DONE, STATE_CHECK, STATE_WAIT, STATE_RESET);
  signal state, next_state : STATE_TYPE;
begin
    sequential : process(clk, rst)
    begin
      if rst = '1' then
        state <= STATE_RESET;
      elsif rising_edge(clk) then
        state <= next_state;
      end if;
    end process;

    combinational : process (x_lt_y, x_ne_y, state, go)
    begin
      -- Default values will be 0
      x_sel <= '0';
      y_sel <= '0';
      x_en <= '0';
      y_en <= '0';
      done <= '0';
      output_en <= '0';

      -- Unless otherwise stated the next state is the current state
      next_state <= state;

      -- Do all your state stuff
      case state is
        -- We enter this state by resetting or by starting the algorithm
        -- Here we are resetting and waiting for go to become true so we can do stuff
        when STATE_RESET =>
          if go = '1' then
  					next_state <= STATE_INIT;
            -- There is an implicit else statement that the next state is the present state
  				end if;

        -- We enter this state by reaching the done state and then setting go to 0
        -- Then we wait for go to become 1
        when STATE_START =>
          done <= '1';
          if go = '1' then
            next_state <= STATE_INIT;
            -- There is an implicit else statement that the next state is the present state
          end if;

        -- Here we set the enables to true so that the registers can output a value that we will then use for subtraction
        -- The next state from here will always be to check if we should loop back or if we are done
        when STATE_INIT =>
          x_en <= '1';
          y_en <= '1';
          next_state <= STATE_CHECK;

        -- This is where we decide if we should loop or if we are done
        when STATE_CHECK =>
          if x_ne_y = '1' then
            next_state <= STATE_LOOP;
          else
            next_state <= STATE_DONE;
          end if;

        -- In this state we have decided we need to loop
        when STATE_LOOP =>
          -- If x is less than y then we want to assign a new value to y so we enable the y select and enable
          if x_lt_y = '1' then
            y_en  <= '1';
            y_sel <= '1';
          -- If x is greater than y then we want to assign a new value to x so we enable the x select and enable
          else
            x_en  <= '1';
            x_sel <= '1';
          end if;
          -- Our next state will always be to check if we should re enter the loop or exit
          next_state <= STATE_CHECK;

        -- This state is reached when we have found the GCD
        when STATE_DONE =>
          -- By setting output enable to true we change the output from 0 to the GCD
          output_en <= '1';
          -- Once we have done that wait for go to equal 0
          next_state <= STATE_WAIT;

        -- Here we are done but waiting for go to equal 0 so that we can possibly start again
        when STATE_WAIT =>
          done <= '1';
          -- If go does equal 0 then we can go to the state where we wait for go to be set to 1 again
          if go = '0' then
            next_state <= STATE_START;
          end if;

        when others => null;

      end case;
    end process;
end architecture;
