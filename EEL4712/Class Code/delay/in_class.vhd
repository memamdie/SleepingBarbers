library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

type reg_array is array (0 to 99) of std_logic_vector(width-1 downto 0);

signal regs, regs2 : reg_array;

type array_type2 is array (integer range <>) of std_logic_vector(15 downto 0);

signal x    : array_type2(0 to 99);
signal y    : array_type2(0 to 999);
signal regs : array_type2(0 to cycles);
signal z    : array_type2(99 downto 0);

--to access the 11th element of the array then the 6th bit of the std_logic_vector use z(10)(5);
type std_logic_vector is array (integer range <>) of std_logic;

type array_type3 is array(integer range <>, integer range <>) of std_logic_vector(15 downto 0);

signal x    : array_type3(99 downto 0, 99 downto 0);
-- to access the 3rd row 4th column and fifth bit use x(2, 3)(4);
