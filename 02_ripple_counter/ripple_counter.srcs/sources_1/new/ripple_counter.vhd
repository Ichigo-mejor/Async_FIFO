----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 01:13:22
-- Design Name: 
-- Module Name: ripple_counter - Behavioral
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

entity ripple_counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : out std_logic_vector(3 downto 0)
          );
end ripple_counter;

architecture structural of ripple_counter is
component t_ff is  
port (
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            q   : out STD_LOGIC
        );
    end component;
     signal q0, q1, q2, q3   : STD_LOGIC;
    signal q0_n, q1_n, q2_n : STD_LOGIC;
begin
    -- Stage 0: clocked by the real system clock
    FF0: t_ff port map (clk => clk,   rst => rst, q => q0);

    q0_n <= not q0;
    q1_n <= not q1;
    q2_n <= not q2;

    -- Stage 1: clocked by stage 0's inverted output (for up-counting)
    FF1: t_ff port map (clk => q0_n,  rst => rst, q => q1);

    -- Stage 2: clocked by stage 1's inverted output
    FF2: t_ff port map (clk => q1_n,  rst => rst, q => q2);

    -- Stage 3: clocked by stage 2's inverted output
    FF3: t_ff port map (clk => q2_n,  rst => rst, q => q3);

    count <= q3 & q2 & q1 & q0;   -- MSB to LSB

end Structural;
