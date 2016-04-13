library ieee;
use ieee.std_logic_1164.all;

package internal_lib is

--- --- --- --- --- --- --- --- --- ---
--- --- - Instruction Value --- --- ---
--- --- --- --- --- --- --- --- --- ---
  constant ALU_ADCR : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SBCR : std_logic_vector(3 downto 0) := "0001";
  constant ALU_CMPR : std_logic_vector(3 downto 0) := "0010";
  constant ALU_ANDR : std_logic_vector(3 downto 0) := "0011";
  constant ALU_ORR  : std_logic_vector(3 downto 0) := "0100";
  constant ALU_XORR : std_logic_vector(3 downto 0) := "0101";
  constant ALU_SLRL : std_logic_vector(3 downto 0) := "0110";
  constant ALU_SRRL : std_logic_vector(3 downto 0) := "0111";
  constant ALU_ROLC : std_logic_vector(3 downto 0) := "1000";
  constant ALU_RORC : std_logic_vector(3 downto 0) := "1001";
  constant ALU_DECA : std_logic_vector(3 downto 0) := "1010";
  constant ALU_INCA : std_logic_vector(3 downto 0) := "1011";
  constant ALU_ZS   : std_logic_vector(3 downto 0) := "1100";
  constant ALU_SETC : std_logic_vector(3 downto 0) := "1101";
  constant ALU_CLRC : std_logic_vector(3 downto 0) := "1110";

  constant ADCR     : std_logic_vector(7 downto 0) := "00000001";
  constant SBCR     : std_logic_vector(7 downto 0) := "00010001";
  constant CMPR     : std_logic_vector(7 downto 0) := "10010001";
  constant ANDR     : std_logic_vector(7 downto 0) := "00100001";
  constant ORR      : std_logic_vector(7 downto 0) := "00110001";
  constant XORR     : std_logic_vector(7 downto 0) := "01000001";
  constant SLRL     : std_logic_vector(7 downto 0) := "01010001";
  constant SRRL     : std_logic_vector(7 downto 0) := "01100001";
  constant ROLC     : std_logic_vector(7 downto 0) := "01010010";
  constant RORC     : std_logic_vector(7 downto 0) := "01100010";
  constant DECA     : std_logic_vector(7 downto 0) := "11111011";
  constant INCA     : std_logic_vector(7 downto 0) := "11111010";
  constant LDAI     : std_logic_vector(7 downto 0) := "10000100";
  constant LDAA     : std_logic_vector(7 downto 0) := "10001000";
  constant LDAD     : std_logic_vector(7 downto 0) := "10000001";
  constant STAA     : std_logic_vector(7 downto 0) := "11110110";
  constant STAR     : std_logic_vector(7 downto 0) := "11110001";
  constant BCCA     : std_logic_vector(7 downto 0) := "10110000";
  constant BCSA     : std_logic_vector(7 downto 0) := "10110001";
  constant BEQA     : std_logic_vector(7 downto 0) := "10110010";
  constant BMIA     : std_logic_vector(7 downto 0) := "10110011";
  constant BNEA     : std_logic_vector(7 downto 0) := "10110100";
  constant BPLA     : std_logic_vector(7 downto 0) := "10110101";
  constant BVCA     : std_logic_vector(7 downto 0) := "10110110";
  constant BVSA     : std_logic_vector(7 downto 0) := "10110111";
  constant SETC     : std_logic_vector(7 downto 0) := "11111000";
  constant CLRC     : std_logic_vector(7 downto 0) := "11111001";
  constant LDSI     : std_logic_vector(7 downto 0) := "10001001";
  constant CALL     : std_logic_vector(7 downto 0) := "11001000";
  constant RET      : std_logic_vector(7 downto 0) := "11000000";
  constant LDXI     : std_logic_vector(7 downto 0) := "10001010";
  constant LDAX     : std_logic_vector(7 downto 0) := "10111100";
  constant STAX     : std_logic_vector(7 downto 0) := "11101100";
  constant INCX     : std_logic_vector(7 downto 0) := "11111100";
  constant DECX     : std_logic_vector(7 downto 0) := "11111101";
  constant MULT     : std_logic_vector(7 downto 0) := "01000000";


  --- --- --- --- --- --- --- --- --- ---
  --- --- --- --Bus Selects-- --- --- ---
  --- --- --- --- --- --- --- --- --- ---

  type busIn is array (integer range <>) of std_logic_vector(7 downto 0);
  type bigBus is array (integer range <>) of std_logic_vector(15 downto 0);

  constant INTERN_BUS   : std_logic_vector(1 downto 0) := "00";
  constant SW0          : std_logic_vector(1 downto 0) := "01";
  constant SW1          : std_logic_vector(1 downto 0) := "10";
  constant RAM_L        : std_logic_vector(1 downto 0) := "11";

  constant ADDR_INDEX   : std_logic_vector(1 downto 0) := "00";
  constant ADDR_ADDR    : std_logic_vector(1 downto 0) := "01";
  constant ADDR_PC      : std_logic_vector(1 downto 0) := "10";
  constant ADDR_STACK   : std_logic_vector(1 downto 0) := "11";

  constant D            : std_logic_vector(3 downto 0) := "0000";
  constant ACC          : std_logic_vector(3 downto 0) := "0001";
  constant STACK_H      : std_logic_vector(3 downto 0) := "0010";
  constant STACH_L      : std_logic_vector(3 downto 0) := "0011";
  constant INDEX_H      : std_logic_vector(3 downto 0) := "0100";
  constant INDEX_L      : std_logic_vector(3 downto 0) := "0101";
  constant RAM_REG      : std_logic_vector(3 downto 0) := "0110";
  constant ALU_REG      : std_logic_vector(3 downto 0) := "0111";
  constant B_REG        : std_logic_vector(3 downto 0) := "1000";
  constant PCL          : std_logic_vector(3 downto 0) := "1001";
  constant PCH          : std_logic_vector(3 downto 0) := "1010";


  --- --- --- --- --- --- --- --- --- ---
  --- --- --- - Controller  - --- --- ---
  --- --- --- --- --- --- --- --- --- ---

  type STATE_TYPE is (INIT, FETCH, DECODE, READ_FROM_MEMORY, TRANSFER_EXT_TO_INT, PC_INC, GET_RAM, LDAI_0, LDAA_0, LDAA_1, LDAA_2, STAA_0, STAA_1, STAR_0, LOAD_ADDR_0, LOAD_ADDR_1, LOAD_ADDR_2, LOAD_ADDR_3, ALU_ALL_0, ALU_EN_0, ALU_CZS_0, ALU_ZS_0, INC_FETCH, BRANCH_TAKEN_0, BRANCH_TAKEN_1, BRANCH_TAKEN_2, BRANCH_TAKEN_3, BRANCH_TAKEN_4, BRANCH_NOT_TAKEN, SETC_0, LDAX_0, LDAX_1, LDAX_2, LDAX_3, LDAD_0, CALL_0, CALL_1, CALL_2, CALL_3, CALL_4, CALL_5, CALL_6, RET_0, RET_1, RET_2, RET_3, RET_4, RET_5, RET_6, MULT_0, MULT_1, MULT_2, MULT_3, MULT_4, MULT_5, MULT_6, MULT_7, MULT_8, MULT_9);




end package;
