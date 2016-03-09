library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is

  generic (
    WIDTH : positive);

  port (
    input1 : in  std_logic_vector(WIDTH-1 downto 0);
    input2 : in  std_logic_vector(WIDTH-1 downto 0);
    output : out std_logic_vector(WIDTH-1 downto 0);
    carry  : out std_logic
    );

end add;

architecture BAD of add is

begin  -- BAD

  process (input1, input2)

    variable temp_add : std_logic_vector(WIDTH downto 0);

  begin

    -- With numeric_std, we must explicitly convert the inputs to unsigned to
    -- perform addition. The resize function extends the inputs, in a similar
    -- way to the conv_* functions in std_logic_arith.

    -- *******Important**********
    -- Note that with numeric_std, we have to explicitly cast the result back
    -- to std_logic_vector so that it matches std_logic_vector. This is a key
    -- difference between numeric_std and std_logic_arith.

    temp_add := std_logic_vector(resize(unsigned(input1), WIDTH+1) +
                                 resize(unsigned(input2), WIDTH+1));

    output <= temp_add(WIDTH-1 downto 0);
    carry <= temp_add(WIDTH);

  end process;

end BAD;

architecture GOOD1 of add is

begin  -- GOOD1

  process (input1, input2)

    variable temp_add : std_logic_vector(WIDTH downto 0);

  begin

    -- same code as std_logic_arith and std_logic_arith+std_logic_unsigned,
    -- except here we have to explictly cast back to std_logic_vector

    temp_add := std_logic_vector(unsigned("0"&input1) + unsigned("0"&input2));

    output <= temp_add(WIDTH-1 downto 0);
    carry  <= temp_add(WIDTH);

  end process;


end GOOD1;


architecture GOOD2 of add is

begin  -- GOOD2

  process (input1, input2)

    variable temp_add : unsigned(WIDTH downto 0);

  begin

    -- casting isn't needed here because the variable is already unsigned

    temp_add := unsigned("0"&input1) + unsigned("0"&input2);

    -- casting is required here to explicitly convert unsigned to
    -- std_logic_vector

    output <= std_logic_vector(temp_add(WIDTH-1 downto 0));
    carry  <= std_logic(temp_add(WIDTH));

  end process;

end GOOD2;


architecture GOOD3 of add is

begin  -- GOOD3

  process (input1, input2)

    variable temp_add : unsigned(WIDTH downto 0);

  begin

    -- the following is also correct. The width of the sum result is the max
    -- width of the inputs. This means you really only have to extend one
    -- input. However, some consider explicit extension of all inputs to be
    -- more readable. I'll let you decide whichever you prefer.

    temp_add := resize(unsigned(input1), WIDTH+1) + unsigned(input2);

    output <= std_logic_vector(temp_add(WIDTH-1 downto 0));
    carry  <= std_logic(temp_add(WIDTH));

  end process;

end GOOD3;
