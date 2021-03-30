----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 01:24:12 PM
-- Design Name: 
-- Module Name: tb_d_latch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_d_latch is
--  Port ( );
end tb_d_latch;

architecture Behavioral of tb_d_latch is

    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
     
    signal s_clk_100MHz     : std_logic; 
    signal s_en     : std_logic;
    signal s_arst   : std_logic;
    signal s_d      : std_logic;
    signal s_q      : std_logic;
    signal s_q_bar  : std_logic;
    
begin

    uut_d_latch : entity work.d_latch
    port map(
            --- WRITE YOUR CODE HERE
         clk    => s_clk_100MHz,
         en     => s_en,
         arst   => s_arst,
         d      => s_d,
         q      => s_q,
         q_bar  => s_q_bar
         
        );
   
   p_clk_gen : process
        begin
            while now < 750 ns loop         -- 75 periods of 100MHz clock
                s_clk_100MHz <= '0';
                wait for c_CLK_100MHZ_PERIOD / 2;
                s_clk_100MHz <= '1';
                wait for c_CLK_100MHZ_PERIOD / 2;
            end loop;
            wait;
        end process p_clk_gen;
        
    p_arst_gen : process
    begin
        s_arst <= '0';
        wait for 10 ns;
        
        -- Reset activated
        s_arst <= '1';
        wait for 53 ns;

        s_arst <= '0';
        wait for 162 ns;
        
        s_arst <= '1';
        wait for 37 ns;
        
        s_arst <= '0';
        wait;
        
        end process p_arst_gen;
    
    
       --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
   p_stimulus: process
    begin
        report "Stimulus process started" severity note;
        s_en <= '0';
        s_d <= '0';
        
        --d sequence
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        --/d sequence
        
        s_en <= '1';
        
        --d sequence
        wait for 10 ns;
        s_d <= '1';
        
        wait for 5 ns;
        assert(s_q = '1' and s_q_bar = '0')
        report "asdad adad dad" severity error;
        
        wait for 5 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        --/d sequence
        
        s_en <= '0';
        
        --d sequence
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        --/d sequence
        
        s_en <= '1';
        
        wait for 5 ns;
        assert(s_q = '0' and s_q_bar = '1')
        report "asdad adad dad" severity error;
        
        --d sequence
        wait for 5 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        s_d <= '1';
        wait for 10 ns;
        s_d <= '0';
        wait for 10 ns;
        --/d sequence
        
        report "Stimulus process finished" severity note;
        wait;
        
    end process p_stimulus;
    
end Behavioral;
