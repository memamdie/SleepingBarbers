-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end fsm_tb;

architecture TB of fsm_tb is

  signal clk, rst, en : std_logic := '0';
  signal output1p_1       : std_logic_vector(3 downto 0);
  signal output1p_2       : std_logic_vector(3 downto 0);
  signal output2p_1       : std_logic_vector(3 downto 0);
  signal output2p_2       : std_logic_vector(3 downto 0);

begin

  U_FSM_1P_1 : entity work.fsm(PROC1_1)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      output => output1p_1);
  
  U_FSM_1P_2 : entity work.fsm(PROC1_2)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      output => output1p_2);

  U_FSM_2P_1 : entity work.fsm(PROC2_1)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      output => output2p_1);
  
  U_FSM_2P_2 : entity work.fsm(PROC2_2)
    port map (
      clk    => clk,
      rst    => rst,
      en     => en,
      output => output2p_2);
  
  clk <= not clk after 5 ns;

  process
  begin

    rst <= '1';
    en  <= '0';
    for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
    wait until clk'event and clk = '1';

    for i in 0 to 1000 loop
      for j in 0 to 3 loop
        en <= '1';
        wait until clk'event and clk='1';
      end loop;  -- j

      en <= '0';
      wait until clk'event and clk='1';      
    end loop;  -- i
    
  end process;
end;
