----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 01:20:04
-- Design Name: 
-- Module Name: gray_count_tb - Behavioral
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

entity gray_count_tb is
end gray_count_tb;

architecture Behavioral of gray_count_tb is
component gray_counter is 
   Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           Y_count : out std_logic_vector( 3 downto 0);
           gray_count : out std_logic_vector(3 downto 0)
           );
       end component;
       
    signal clk        : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal en          : STD_LOGIC := '0';
    signal Y_count     : STD_LOGIC_VECTOR(3 downto 0);
    signal gray_count  : STD_LOGIC_VECTOR(3 downto 0);

begin
uut : gray_counter
port map(   clk        => clk,
            rst        => rst,
            en         => en,
            Y_count    => Y_count,
            gray_count => gray_count
        );

clock_process: process
begin 
 clk <= '0';
 wait for 5ns;
 clk <= '1';
 wait for 5ns; 
 end process;
 
 stim_process: process
    begin
        rst <= '1';
        en  <= '0';
        wait for 12 ns;

        rst <= '0';
        wait for 10 ns;

        en <= '1';
        wait for 200 ns;   -- let it count through full wraparound (16 states)

        std.env.stop;
    end process;



end Behavioral;
