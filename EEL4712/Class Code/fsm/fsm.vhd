-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

-- The following example illustrates two models that I would recommend for
-- creating a finite state machine (FSM), which I refer to as the 1-process
-- and 2-process models. The 1-process model is slightly easier, but has the
-- disadvantage of having registers/flip-flops on all outputs, which generally
-- adds one cycle of latency. The 2-process model requires a little more
-- code, but is more flexible. When timing/area are not a concern, the
-- 1-process model can save a little bit of time, but I would still recommend
-- using the 2-process model. Once you get used to it, it requires only a
-- minor amount of additional effort, and in my opinion is easier to debug.

-- The following example implements the FSM illustrated in fsm.pdf. Note that
-- you should always draw the FSM first and then convert it to VHDL, which
-- requires almost no thought.

entity FSM is
  port (
    clk, rst, en : in  std_logic;
    output       : out std_logic_vector(3 downto 0));
end FSM;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 1-process model examples
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

architecture PROC1_1 of FSM is

  -- There are numerous ways to do state machines, but I recommend declaring
  -- your own type that defines each possible state. This makes the code more
  -- readable, and the state names will appear in the waveform simulation. 
  type STATE_TYPE is (STATE_0, STATE_1, STATE_2, STATE_3);

  -- create a signal to store the current state. Notice that its type is STATE_
  -- TYPE, which we just defined 
  signal state : STATE_TYPE;

begin 

  -- the 1-process FSM model treats the entire FSM like sequential logic. In
  -- other words, all signals that are assigned values are implemented as
  -- registers. Therefore, we will follow the exact same synthesis guidelines
  -- as we did for sequential logic. 
  
  process(clk, rst)
  begin
    if (rst = '1') then
      -- initialize outputs and state
      output <= "0001";
      state <= STATE_0;
      
    elsif(clk'event and clk = '1') then

      -- the 1-process FSM is implemented as a case statement, with one case
      -- for each state
      
      case state is
        when STATE_0 =>

          -- whenever possible, use a template similar to something below for
          -- each state. In this example, I define the outputs and then define
          -- the next state logic. You can then simply copy and paste for each
          -- state, while changing the appropriate values.
          
          output  <= "0001";

          if (en = '1') then
            state <= STATE_1;
          else
            state <= STATE_0;
          end if;
          
        when STATE_1 =>

          output  <= "0010";

          if (en = '1') then
            state <= STATE_2;
          else
            state <= STATE_1;
          end if;

        when STATE_2 =>

          output  <= "0100";

          if (en = '1') then
            state <= STATE_3;
          else
            state <= STATE_2;
          end if;

        when STATE_3 =>

          output  <= "1000";

          if (en = '1') then
            state <= STATE_0;
          else
            state <= STATE_3;
          end if;
         
        when others => null;
      end case;

    end if;
  end process;
end PROC1_1;

-- minor change to the 1-process model

architecture PROC1_2 of FSM is

  type STATE_TYPE is (STATE_0, STATE_1, STATE_2, STATE_3);
  signal state : STATE_TYPE;

begin 
  
  process(clk, rst)
  begin
    if (rst = '1') then
      output <= "0001";
      state <= STATE_0;
    elsif(clk'event and clk = '1') then

      case state is
        when STATE_0 =>
          
          output  <= "0001";

          -- we don't actually need to reassign state with the same value,
          -- because state is implemented as a register and will preserve this
          -- value automatically
          if (en = '1') then
            state <= STATE_1;
          end if;
          
        when STATE_1 =>

          output  <= "0010";

          if (en = '1') then
            state <= STATE_2;          
          end if;

        when STATE_2 =>

          output  <= "0100";

          if (en = '1') then
            state <= STATE_3;
          end if;

        when STATE_3 =>

          output  <= "1000";

          if (en = '1') then
            state <= STATE_0;
          end if;
         
        when others => null;
      end case;

    end if;
  end process;
end PROC1_2;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- 2-process model examples
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- The difference between the 1-process model and the 2-process model is that
-- the 2-process model implements an FSM as a state register combined with
-- combinational logic for next-state logic and output logic (which is how FSMs
-- are normally implemented). Because the 2-process model explictly uses
-- combinational logic, it avoids the output registers that are created by
-- the 1-process model. Avoiding these registers is critical when timing is
-- important, which will be illustrated in another example. Note that with the
-- provided testbench the output of the 1-process model is always 1 cycle
-- behind the 2-process model, which is caused by the register on the output.

architecture PROC2_1 of FSM is

  type STATE_TYPE is (STATE_0, STATE_1, STATE_2, STATE_3);
  signal state, next_state : STATE_TYPE;  -- the 2-process model
                                          -- uses state and next_state

begin

  -- process to model the state register. Note that this is exactly the same
  -- code that was previously used to implement a register. This process
  -- assigns the state signal on a rising clock edge, which means that state is
  -- implemented as a register (which is what we want).
  process(clk, rst)
  begin
    if (rst = '1') then
       -- Set the initial state. You might be tempted to define an output here,
       -- like what was done in the 1-process model. However, this will cause
       -- an multiple driver error because we will also be assigning output in
       -- the next process. Remember: only one process can assign a signal.
      state <= STATE_0;                
    elsif(clk'event and clk = '1') then
      state <= next_state;
    end if;
  end process;

  -- process to model the next-state logic and output logic
  -- This process is defining combinational logic, so make sure to have all
  -- inputs to the logic in the sensitivity list. Note that this is not the
  -- same as the inputs to the entity. The combinational logic uses "state" as
  -- an input, but state is not an input to the entity.
  process(en, state)
  begin

    -- again, we use a case statement to define behavior of each state    
    case state is
      when STATE_0 =>

        -- I use a similar template as before, where I first define outputs and
        -- then define next-state logic. However, notice that I no longer
        -- defined "state". Instead, I define "next_state", which in turn gets
        -- assigned to "state" on the next rising clock edge (which is exactly
        -- what we want).
        
        output <= "0001";

        if (en = '1') then
          next_state <= STATE_1;        
        else
          next_state <= STATE_0;
        end if;

      when STATE_1 =>

        output <= "0010";

        if (en = '1') then
          next_state <= STATE_2;
        else
          next_state <= STATE_1;
        end if;

      when STATE_2 =>

        output <= "0100";

        if (en = '1') then
          next_state <= STATE_3;
        else
          next_state <= STATE_2;
        end if;

      when STATE_3 =>

        output <= "1000";

        if (en = '1') then
          next_state <= STATE_0;
        else
          next_state <= STATE_3;
        end if;

      when others => null;
    end case;
  end process;
end PROC2_1;


architecture PROC2_2 of FSM is

  type STATE_TYPE is (STATE_0, STATE_1, STATE_2, STATE_3);
  signal state, next_state : STATE_TYPE;
  
begin

  -- same as before
  process(clk, rst)
  begin
    if (rst = '1') then
      state <= STATE_0;                
    elsif(clk'event and clk = '1') then
      state <= next_state;
    end if;
  end process;

  process(en, state)
  begin

    -- In this example, we use a default value for next_state to simplify the
    -- next-state logic. The following line of code assumes that next_state is
    -- equal to state unless we specify otherwise later in the process.

    next_state <= state;    

    case state is
      when STATE_0 =>

        output <= "0001";

        -- because we use a default next_state, we don't need the "else"
        
        if (en = '1') then
          next_state <= STATE_1;        
        end if;

      when STATE_1 =>

        output <= "0010";

        if (en = '1') then
          next_state <= STATE_2;
        end if;

      when STATE_2 =>

        output <= "0100";

        if (en = '1') then
          next_state <= STATE_3;
        end if;

      when STATE_3 =>

        output <= "1000";

        if (en = '1') then
          next_state <= STATE_0;
        end if;

      when others => null;
    end case;
  end process;
end PROC2_2;
