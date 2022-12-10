library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity grayscale_tb is
end grayscale_tb;

architecture sim of grayscale_tb is
  signal PresentState, NextState : integer range 0 to 2;

  type header_type  is array (0 to 53) of character;

  type pixel_type is record
    red : std_logic_vector(7 downto 0);
    green : std_logic_vector(7 downto 0);
    blue : std_logic_vector(7 downto 0);
  end record;

  type row_type is array (integer range <>) of pixel_type;
  type row_pointer is access row_type;
  type image_type is array (integer range <>) of row_pointer;
  type image_pointer is access image_type;

  -- DUT signals
  signal r_in : std_logic_vector(7 downto 0);
  signal g_in : std_logic_vector(7 downto 0);
  signal b_in : std_logic_vector(7 downto 0);
  signal r_out : std_logic_vector(7 downto 0);
  signal g_out : std_logic_vector(7 downto 0);
  signal b_out : std_logic_vector(7 downto 0);

  -- Clock signal
  signal clk : std_logic := '0';

  -- Clock generator
  component clock_gen is
    port (
      clk : out std_logic
    );
  end component;

begin

  DUT :entity work.grayscale(rtl)
  port map (
    clk => clk,
    r_in => r_in,
    g_in => g_in,
    b_in => b_in,
    r_out => r_out,
    g_out => g_out,
    b_out => b_out
  );

  process
    type char_file is file of character;
    file bmp_file : char_file open read_mode is "input.bmp";
    file out_file : char_file open write_mode is "output.bmp";
    variable header : header_type;
    variable image_width : integer;
    variable image_height : integer;
    variable row : row_pointer;
    variable image : image_pointer;
    variable padding : integer;
    variable char : character;
  begin

    for i in header_type'range loop
      read(bmp_file, header(i));
    end loop;

    PresentState <= 0;
    NextState <= 1;

    assert header(0) = 'B' and header(1) = 'M'
      report "NOT A BMP FILE"
      severity failure;

    assert character'pos(header(10)) = 54 and
      character'pos(header(11)) = 0 and
      character'pos(header(12)) = 0 and
      character'pos(header(13)) = 0
      report "Header is not 54 bytes"
      severity failure;

    assert character'pos(header(14)) = 40 and
      character'pos(header(15)) = 0 and
      character'pos(header(16)) = 0 and
      character'pos(header(17)) = 0
      report "DIB headers size is not 40 bytes"
      severity failure;

    assert character'pos(header(26)) = 1 and
      character'pos(header(27)) = 0
      report "Color planes is not 1" severity failure;

    assert character'pos(header(28)) = 24 and
      character'pos(header(29)) = 0
      report "Bits per pixel is not 24" severity failure;

    image_width := character'pos(header(18)) +
      character'pos(header(19)) * 2**8 +
      character'pos(header(20)) * 2**16 +
      character'pos(header(21)) * 2**24;

    image_height := character'pos(header(22)) +
      character'pos(header(23)) * 2**8 +
      character'pos(header(24)) * 2**16 +
      character'pos(header(25)) * 2**24;

    report "image_width: " & integer'image(image_width) &
      ", image_height: " & integer'image(image_height);

    padding := (4 - image_width*3 mod 4) mod 4;

    image := new image_type(0 to image_height - 1);

    PresentState <= 1;
    NextState <= 2;
    for row_i in 0 to image_height - 1 loop

      row := new row_type(0 to image_width - 1);

      for col_i in 0 to image_width - 1 loop

        read(bmp_file, char);
        row(col_i).blue :=
          std_logic_vector(to_unsigned(character'pos(char), 8));

        read(bmp_file, char);
        row(col_i).green :=
          std_logic_vector(to_unsigned(character'pos(char), 8));

        read(bmp_file, char);
        row(col_i).red :=
          std_logic_vector(to_unsigned(character'pos(char), 8));

      end loop;

      for i in 1 to padding loop
        read(bmp_file, char);
      end loop;

      image(row_i) := row;

    end loop;

    for row_i in 0 to image_height - 1 loop
      row := image(row_i);

      for col_i in 0 to image_width - 1 loop

        r_in <= row(col_i).red;
        g_in <= row(col_i).green;
        b_in <= row(col_i).blue;
        wait for 10 ns;

        row(col_i).red := r_out;
        row(col_i).green := g_out;
        row(col_i).blue := b_out;

      end loop;
    end loop;

    PresentState <= 2;
    nextstate <= 0;

    for i in header_type'range loop
      write(out_file, header(i));
    end loop;

    for row_i in 0 to image_height - 1 loop
      row := image(row_i);

      for col_i in 0 to image_width - 1 loop

        write(out_file,
          character'val(to_integer(unsigned(row(col_i).blue))));

        write(out_file,
          character'val(to_integer(unsigned(row(col_i).green))));

        write(out_file,
          character'val(to_integer(unsigned(row(col_i).red))));

      end loop;

      deallocate(row);

      for i in 1 to padding loop
        write(out_file, character'val(0));
      end loop;

    end loop;

    deallocate(image);

    file_close(bmp_file);
    file_close(out_file);

    report "Simulation done. Check ""output.bmp"" image.";
    finish;
  end process;

end architecture;