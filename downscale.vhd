library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity downscale is
  generic (
    N : integer := 2
  );
  port (
    clk   : in std_logic;
    
    --RBG INPUT
    --Mungkin ini bisa dijadiin NxN array
    r_in  : in std_logic_vector(7 downto 0);
    g_in  : in std_logic_vector(7 downto 0);
    b_in  : in std_logic_vector(7 downto 0);

    --RGB OUTPUT
    r_out : out std_logic_vector(7 downto 0);
    g_out : out std_logic_vector(7 downto 0);
    b_out : out std_logic_vector(7 downto 0)
    
  );
end entity downscale;

architecture rtl of downscale is
  signal sum : std_logic_vector(7 downto 0);
  signal average : std_logic_vector(7 downto 0);

  signal r_avg : std_logic_vector(7 downto 0);
  signal g_avg : std_logic_vector(7 downto 0);
  signal b_avg : std_logic_vector(7 downto 0);
begin

  --For Loop

end architecture;