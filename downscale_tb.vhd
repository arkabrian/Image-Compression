library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity downscale_tb is
end entity downscale_tb;

architecture rtl of downscale_tb is

  --Untuk menyimpan header
  type header_type  is array (0 to 53) of character;

  --Untuk menyimpan pixel
  type pixel_type is record
    red : std_logic_vector(7 downto 0);
    green : std_logic_vector(7 downto 0);
    blue : std_logic_vector(7 downto 0);
  end record;

  --Struktur data untuk menyimpan data pixel
  type row_type is array (integer range <>) of pixel_type;
  type row_pointer is access row_type;
  type image_type is array (integer range <>) of row_pointer;
  type image_pointer is access image_type;

  --Signal untuk UUT
  signal r_in : std_logic_vector(7 downto 0);
  signal g_in : std_logic_vector(7 downto 0);
  signal b_in : std_logic_vector(7 downto 0);
  signal r_out : std_logic_vector(7 downto 0);
  signal g_out : std_logic_vector(7 downto 0);
  signal b_out : std_logic_vector(7 downto 0);

begin

  UUT : entity work.downscale
    port map(
      r_in => r_in,
      g_in => g_in,
      b_in => b_in,
      r_out => r_out,
      g_out => g_out,
      b_out => b_out
    );

    process
      type char_file is file of character; --Mendefinisikan tipe data yang akan dibaca. Karena file yang dibaca adalah file teks, maka tipe data yang digunakan adalah character
      file bmp_file : char_file open read_mode is "input.bmp"; --Nama file input BMP
      file out_file : char_file open write_mode is "output.bmp";   --Nama file output BMP
      variable header : header_type; --Variabel untuk menyimpan data header
      variable image_width : integer; --Variabel untuk menyimpan lebar gambar
      variable image_height : integer; --Variabel untuk menyimpan tinggi gambar
      variable row : row_pointer; 
      variable image : image_pointer; --Bakal digunakan ketika gambar sudah dibaca
      variable padding : integer; 
      variable char : character;
    begin
      -- Read image width
      image_width := character'pos(header(18)) +
        character'pos(header(19)) * 2**8 +
        character'pos(header(20)) * 2**16 +
        character'pos(header(21)) * 2**24;

      -- Read image height
      image_height := character'pos(header(22)) +
        character'pos(header(23)) * 2**8 +
        character'pos(header(24)) * 2**16 +
        character'pos(header(25)) * 2**24;
    end process;

end architecture;