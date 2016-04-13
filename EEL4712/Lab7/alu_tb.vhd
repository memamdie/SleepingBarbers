library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is


    constant WIDTH  : positive                           := 8;
    signal input1, input2, output   : std_logic_vector(WIDTH-1 downto 0);
    signal cin, c, z, v, s          : std_logic;
    signal sel                      : std_logic_vector(3 downto 0);


begin  -- TB
    UUT : entity work.ALU
        generic map (WIDTH => WIDTH)
        port map (
            a        => input1,
            d        => input2,
            cin      => cin,
            sel      => sel,
            output   => output,
            c        => c,
            z        => z,
            v        => v,
            s        => s);
    process
    begin
      cin <= '0';

        -- Cycle through all select values
        for selects in 0 to 15 loop
          sel <= conv_std_logic_vector(selects, sel'length);
        -- cycle through all possible values for input1
          for in1 in 0 to (2**width)- 1 loop
            input1 <= conv_std_logic_vector(in1, input1'length);
        -- cycle through all possible values for input2
            for in2 in 0 to (2**width)-1 loop
              input2 <= conv_std_logic_vector(in2, input2'length);


                -- Check that the right value is asserted at the end of the loop
                if selects = 0 then
                  wait for 10 ns;
                  -- cycle through possible cin if select is ADCR
                  assert(output = conv_std_logic_vector(in1+in2, output'length)) report "Error: " & integer'image(in1) & " + " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1+in2) severity warning;
                  cin <= '1';
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1+in2+1, output'length)) report "Error: " & integer'image(in1) & " + " & integer'image(in2) & " + 1 = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1+in2+1) severity warning;
                  cin <= '0';
                elsif selects = 1 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1-in2-1, output'length)) report "Error: " & integer'image(in1) & " - " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1-in2-1) severity warning;
                elsif selects = 2 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1-in2-1, output'length)) report "Error: " & integer'image(in1) & " - " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1-in2-1) severity warning;
                elsif selects = 3 then
                  wait for 10 ns;
                  assert(output = (conv_std_logic_vector(in1, output'length) and conv_std_logic_vector(in2, output'length))) report "Error: " & integer'image(in1) & " & " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(conv_integer(conv_std_logic_vector(in1, output'length) and conv_std_logic_vector(in2, output'length))) severity warning;
                elsif selects = 4 then
                  wait for 10 ns;
                  assert(output = (conv_std_logic_vector(in1, output'length) or conv_std_logic_vector(in2, output'length))) report "Error: " & integer'image(in1) & " & " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(conv_integer(conv_std_logic_vector(in1, output'length) or conv_std_logic_vector(in2, output'length))) severity warning;
                elsif selects = 5 then
                  wait for 10 ns;
                  assert(output = (conv_std_logic_vector(in1, output'length) xor conv_std_logic_vector(in2, output'length))) report "Error: " & integer'image(in1) & " & " & integer'image(in2) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(conv_integer(conv_std_logic_vector(in1, output'length) xor conv_std_logic_vector(in2, output'length))) severity warning;
                elsif selects = 6 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1 * 2, output'length)) report "Error: Shifting " & integer'image(in1) & " left = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1*2) severity warning;
                elsif selects = 7 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1 / 2, output'length)) report "Error: Shifting " & integer'image(in1) & " right = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1/2) severity warning;
                elsif selects = 8 then
                  wait for 10 ns;
                  assert(output = (conv_std_logic_vector(in1, output'length)(WIDTH-2 downto 0) & cin)) report "Error: Rotating " & integer'image(in1) & " left with a carry in of " & integer'image(conv_integer(cin)) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(conv_integer(conv_std_logic_vector(in1, output'length)(WIDTH-2 downto 0) & cin)) severity warning;
                elsif selects = 9 then
                  wait for 10 ns;
                  assert(output = (cin & conv_std_logic_vector(in1, output'length)(WIDTH-1 downto 1))) report "Error: Rotating " & integer'image(in1) & " right with a carry in of " & integer'image(conv_integer(cin)) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(conv_integer(cin & conv_std_logic_vector(in1, output'length)(WIDTH-1 downto 1))) severity warning;
                elsif selects = 10 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1-1, output'length)) report "Error: " & integer'image(in1) & " - " & integer'image(1) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1-1) severity warning;
                elsif selects = 11 then
                  wait for 10 ns;
                  assert(output = conv_std_logic_vector(in1+1, output'length)) report "Error: " & integer'image(in1) & " + " & integer'image(1) & " = " & integer'image(conv_integer(output)) & " instead of " & integer'image(in1+1) severity warning;
                else
                  wait for 5 ns;
                  assert(output = conv_std_logic_vector(0, output'length)) report "Error: a select value of " & integer'image(selects) & " was used and an output other than 0 was returned. The output returned was: " & integer'image(conv_integer(output)) severity warning;
                end if;


                -- Check flags
                if selects < 3 then
                  -- Check the C Flag
                  if (selects = 0 and ((in1 + in2 + conv_integer(cin)) > 255)) or (selects > 0 and (in1 + conv_integer(not conv_std_logic_vector(in2, input2'length)) + conv_integer(cin) > 255)) then
                    assert (c = '1') report "Error: The c flag was " & integer'image(conv_integer(c)) & " and was supposed to be " & integer'image(1) & " because input1 was : " & integer'image(in1) & " input2 was: " & integer'image(in2) severity warning;
                  else
                    assert (c = '0') report "Error: The c flag was " & integer'image(conv_integer(c)) & " and was supposed to be " & integer'image(0) severity warning;
                  end if;
                  -- Check the V flag
                  if (in1 < 128 and in2 < 128 and output >= 128) or (in1 >= 128 and in2 >= 128 and output < 128) then
                    assert (v = '1') report "Error: The v flag was supposed to be true because an overflow was generated when " & integer'image(in1) & " and was operated on with" & integer'image(in2) severity warning;
                  else
                    assert (v = '0') report "Error: The v flag was supposed to be false because an overflow should not be generated when " & integer'image(in1) & " and was operated on with" & integer'image(in2) severity warning;
                  end if;

                elsif selects > 5 and selects < 10 then
                  assert(v = '0') report "Error: The v flag was not supposed to be asserted here and was somehow set to 1." severity warning;
                  if selects = 6 or selects = 8 then
                    assert(c = conv_std_logic_vector(in1, input1'length)(width-1)) report "The carry flag was not equal to the upper bit of the input on a shift/rotate left" severity warning;
                  else
                    assert (c = conv_std_logic_vector(in1, input1'length)(0)) report"The carry flag was not equal to the lower bit of the input on a shift/rotate right" severity warning;
                  end if;
                else
                  assert(c = '0') report "Error: The c flag was not supposed to be asserted here and was somehow set to 1." severity warning;
                  assert(v = '0') report "Error: The v flag was not supposed to be asserted here and was somehow set to 1." severity warning;
                end if;

                if output = conv_std_logic_vector(0, output'length) then
                  assert (z = '1') report "Error: The z flag was " & integer'image(conv_integer(z)) & " and was supposed to be " & integer'image(1) severity warning;
                else
                  assert (z = '0') report "Error: The z flag was " & integer'image(conv_integer(z)) & " and was supposed to be " & integer'image(0) severity warning;
                end if;

                assert (s = output(WIDTH-1)) report "Error: The s flag was " & integer'image(conv_integer(s)) & " and was supposed to be " & integer'image(conv_integer(output(WIDTH-1))) severity warning;
            end loop;
          end loop;
        end loop;

        report "SIMULATION FINISHED";
        wait;
    end process;
end TB;
