----------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 17:15:41
-- Design Name: 
-- Module Name: synchronizer - Behavioral
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

entity synchronizer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           async_in : in std_logic_vector(3 downto 0);
           sync_out : out std_logic_vector(3 downto 0)
           );
end synchronizer;

architecture Behavioral of synchronizer is
signal stage1 : std_logic_vector(3 downto 0) := "0000";
signal stage2 : std_logic_vector(3 downto 0) := "0000";
begin

process(clk,rst)
begin 
 if rst = '1' then 
 stage1 <= "0000"; 
 stage2 <= "0000";
 
 elsif rising_edge(clk) then
  stage1 <= async_in;
  stage2 <= stage1;
   
  end if;
  end process;
  
   sync_out <= stage2;
end Behavioral;
