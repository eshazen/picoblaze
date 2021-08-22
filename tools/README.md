# Some picoblaze tools

```hex_to_rom.pl``` - read an assembler HEX file and template below and output an initialized ROM

Optionally trims ROM to only the non-zero (utilized) portion

```my_ROM_template.vhd``` - inferred dual-port program memory for use with ```hex_to_rom.pl```

```hex_to_uue.pl``` - read an assembler HEX file and produce a UUE encoded loader file for
loading by a picoblaze boot loader
