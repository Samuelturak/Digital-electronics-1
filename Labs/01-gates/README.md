[EDA playground link](https://www.edaplayground.com/x/8LxB) 

``` vhdl
library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations

------------------------------------------------------------------------
-- Entity declaration for basic gates
------------------------------------------------------------------------
entity gates is
    port(
        a_i    : in  std_logic;         -- Data input
        b_i    : in  std_logic;         -- Data input
        c_i    : in  std_logic;
        f_o    : out std_logic;         -- OR output function
        fand_o : out std_logic;         -- AND output function
        fxor_o : out std_logic          -- XOR output function
    );
end entity gates;

------------------------------------------------------------------------
-- Architecture body for basic gates
------------------------------------------------------------------------
architecture dataflow of gates is
begin
    f_o  <= ((not b_i) and a_i) or ((not c_i) and (not b_i));
    fand_o <= not(not(not b_i and a_i) and not(not c_i and not b_i));
    fxor_o <= not(b_i or not a_i) or not(c_i or b_i);

end architecture dataflow;
```

![](Labs\01-gates\Screenshots\DeMorgan.png "DeMorgan.png")


