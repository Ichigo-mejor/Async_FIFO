----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 01:10:41
-- Design Name: 
-- Module Name: t_ff - Behavioral
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

entity t_ff is
Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);

end t_ff;

architecture Behavioral of t_ff is
signal q_reg : std_logic := '0' ;

begin
process(clk, rst)
begin 
if rst = '1' then
     q_reg <= '0';
     elsif rising_edge(clk) 
     then
     q_reg <= not q_reg;
     end if;
     end process;
     
     q <= q_reg;


end Behavioral;
