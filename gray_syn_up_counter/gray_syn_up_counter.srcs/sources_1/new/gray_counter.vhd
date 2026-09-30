----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2026 22:52:01
-- Design Name: 
-- Module Name: gray_counter - Behavioral
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
use IEEE.numeric_std.ALL;
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gray_counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           Y_count : out std_logic_vector( 3 downto 0);
           gray_count : out std_logic_vector(3 downto 0)
           );
end gray_counter;

architecture Behavioral of gray_counter is
signal Y:unsigned(3 downto 0) := "0000";

begin

process(clk,rst)
begin 
if rst = '1' then
   Y <= "0000";
   elsif rising_edge(clk) then
   if en ='1' then 
   Y <= Y+1;
   end if ;
   end if;
   end process;
   Y_count <= std_logic_vector(Y);
   gray_count <= std_logic_vector(Y xor shift_right(Y,1));
end Behavioral;
