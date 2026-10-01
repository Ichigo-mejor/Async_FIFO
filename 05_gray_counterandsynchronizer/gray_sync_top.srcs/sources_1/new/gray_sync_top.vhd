----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.09.2026 19:55:01
-- Design Name: 
-- Module Name: gray_sync_top - structural
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

entity gray_sync_top is
port ( wr_clk : in  STD_LOGIC;
        rd_clk : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        en     : in  STD_LOGIC;
        gray_out_sync : out STD_LOGIC_VECTOR(3 downto 0)
);
end gray_sync_top;

architecture structural of gray_sync_top is
component gray_counter is 
port (clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           Y_count : out std_logic_vector( 3 downto 0);
           gray_count : out std_logic_vector(3 downto 0)
);
end component;

component synchronizer is 
port(clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           async_in : in std_logic_vector(3 downto 0);
           sync_out : out std_logic_vector(3 downto 0)
);

end component;
signal gray_val : STD_LOGIC_VECTOR(3 downto 0);
    signal bin_val  : STD_LOGIC_VECTOR(3 downto 0);

begin

    GC: gray_counter
        port map (
            clk        => wr_clk,
            rst        => rst,
            en         => en,
            Y_count    => bin_val,
            gray_count => gray_val
        );

    SYNC: synchronizer
        port map (
            clk      => rd_clk,
            rst      => rst,
            async_in => gray_val,
            sync_out => gray_out_sync
        );


end structural;
