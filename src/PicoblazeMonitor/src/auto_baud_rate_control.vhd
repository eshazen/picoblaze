--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2014, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--
--
-- Definition of a program memory for KCPSM6 including generic parameters for the 
-- convenient selection of device family, program memory size and the ability to include 
-- the JTAG Loader hardware for rapid software development.
--
-- This file is primarily for use during code development and it is recommended that the 
-- appropriate simplified program memory definition be used in a final production design. 
--
--    Generic                  Values             Comments
--    Parameter                Supported
--  
--    C_FAMILY                 "7S"               7-Series device 
--                                                  (Artix-7, Kintex-7, Virtex-7 or Zynq)
--                             "US"               UltraScale device
--                                                  (Kintex UltraScale and Virtex UltraScale)
--
--    C_RAM_SIZE_KWORDS        1, 2 or 4          Size of program memory in K-instructions
--
--    C_JTAG_LOADER_ENABLE     0 or 1             Set to '1' to include JTAG Loader
--
-- Notes
--
-- If your design contains MULTIPLE KCPSM6 instances then only one should have the 
-- JTAG Loader enabled at a time (i.e. make sure that C_JTAG_LOADER_ENABLE is only set to 
-- '1' on one instance of the program memory). Advanced users may be interested to know 
-- that it is possible to connect JTAG Loader to multiple memories and then to use the 
-- JTAG Loader utility to specify which memory contents are to be modified. However, 
-- this scheme does require some effort to set up and the additional connectivity of the 
-- multiple BRAMs can impact the placement, routing and performance of the complete 
-- design. Please contact the author at Xilinx for more detailed information. 
--
-- Regardless of the size of program memory specified by C_RAM_SIZE_KWORDS, the complete 
-- 12-bit address bus is connected to KCPSM6. This enables the generic to be modified 
-- without requiring changes to the fundamental hardware definition. However, when the 
-- program memory is 1K then only the lower 10-bits of the address are actually used and 
-- the valid address range is 000 to 3FF hex. Likewise, for a 2K program only the lower 
-- 11-bits of the address are actually used and the valid address range is 000 to 7FF hex.
--
-- Programs are stored in Block Memory (BRAM) and the number of BRAM used depends on the 
-- size of the program and the device family. 
--
-- In any 7-Series or UltraScale device a BRAM is capable of holding 2K instructions so 
-- obviously a 2K program requires only a single BRAM. Each BRAM can also be divided into 
-- 2 smaller memories supporting programs of 1K in half of a 36k-bit BRAM (generally 
-- reported as being an 18k-bit BRAM). For a program of 4K instructions, 2 BRAMs are used.
--
--
-- Program defined by 'Z:\home\hazen\work\Basys3\MyPicoblazeAXI\psm\auto_baud_rate_control.psm'.
--
-- Generated by KCPSM6 Assembler: 15 Jul 2019 - 11:37:32. 
--
-- Assembler used ROM_form template: ROM_form_JTAGLoader_Vivado_2June14.vhd
--
-- Standard IEEE libraries
--
--
package jtag_loader_pkg is
 function addr_width_calc (size_in_k: integer) return integer;
end jtag_loader_pkg;
--
package body jtag_loader_pkg is
  function addr_width_calc (size_in_k: integer) return integer is
   begin
    if (size_in_k = 1) then return 10;
      elsif (size_in_k = 2) then return 11;
      elsif (size_in_k = 4) then return 12;
      else report "Invalid BlockRAM size. Please set to 1, 2 or 4 K words." severity FAILURE;
    end if;
    return 0;
  end function addr_width_calc;
end package body;
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.jtag_loader_pkg.ALL;
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--  
library unisim;
use unisim.vcomponents.all;
--
--
entity auto_baud_rate_control is
  generic(             C_FAMILY : string := "7S"; 
              C_RAM_SIZE_KWORDS : integer := 2;
           C_JTAG_LOADER_ENABLE : integer := 0);
  Port (      address : in std_logic_vector(11 downto 0);
          instruction : out std_logic_vector(17 downto 0);
               enable : in std_logic;
                  rdl : out std_logic;                    
                  clk : in std_logic);
  end auto_baud_rate_control;
--
architecture low_level_definition of auto_baud_rate_control is
--
signal       address_a : std_logic_vector(15 downto 0);
signal       data_in_a : std_logic_vector(35 downto 0);
signal      data_out_a : std_logic_vector(35 downto 0);
signal    data_out_a_l : std_logic_vector(35 downto 0);
signal    data_out_a_h : std_logic_vector(35 downto 0);
signal       address_b : std_logic_vector(15 downto 0);
signal       data_in_b : std_logic_vector(35 downto 0);
signal     data_in_b_l : std_logic_vector(35 downto 0);
signal      data_out_b : std_logic_vector(35 downto 0);
signal    data_out_b_l : std_logic_vector(35 downto 0);
signal     data_in_b_h : std_logic_vector(35 downto 0);
signal    data_out_b_h : std_logic_vector(35 downto 0);
signal        enable_b : std_logic;
signal           clk_b : std_logic;
signal            we_b : std_logic_vector(7 downto 0);
-- 
signal       jtag_addr : std_logic_vector(11 downto 0);
signal         jtag_we : std_logic;
signal       jtag_we_l : std_logic;
signal       jtag_we_h : std_logic;
signal        jtag_clk : std_logic;
signal        jtag_din : std_logic_vector(17 downto 0);
signal       jtag_dout : std_logic_vector(17 downto 0);
signal     jtag_dout_1 : std_logic_vector(17 downto 0);
signal         jtag_en : std_logic_vector(0 downto 0);
-- 
signal picoblaze_reset : std_logic_vector(0 downto 0);
signal         rdl_bus : std_logic_vector(0 downto 0);
--
constant BRAM_ADDRESS_WIDTH  : integer := addr_width_calc(C_RAM_SIZE_KWORDS);
--
--
component jtag_loader_6
generic(                C_JTAG_LOADER_ENABLE : integer := 1;
                                    C_FAMILY : string  := "7S";
                             C_NUM_PICOBLAZE : integer := 1;
                       C_BRAM_MAX_ADDR_WIDTH : integer := 10;
          C_PICOBLAZE_INSTRUCTION_DATA_WIDTH : integer := 18;
                                C_JTAG_CHAIN : integer := 2;
                              C_ADDR_WIDTH_0 : integer := 10;
                              C_ADDR_WIDTH_1 : integer := 10;
                              C_ADDR_WIDTH_2 : integer := 10;
                              C_ADDR_WIDTH_3 : integer := 10;
                              C_ADDR_WIDTH_4 : integer := 10;
                              C_ADDR_WIDTH_5 : integer := 10;
                              C_ADDR_WIDTH_6 : integer := 10;
                              C_ADDR_WIDTH_7 : integer := 10);
port(              picoblaze_reset : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                           jtag_en : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                          jtag_din : out STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                         jtag_addr : out STD_LOGIC_VECTOR(C_BRAM_MAX_ADDR_WIDTH-1 downto 0);
                          jtag_clk : out std_logic;
                           jtag_we : out std_logic;
                       jtag_dout_0 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_1 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_2 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_3 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_4 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_5 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_6 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_7 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0));
end component;
--
begin
  --
  --  
  ram_1k_generate : if (C_RAM_SIZE_KWORDS = 1) generate
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a(13 downto 0) <= address(9 downto 0) & "1111";
      instruction <= data_out_a(17 downto 0);
      data_in_a(17 downto 0) <= "0000000000000000" & address(11 downto 10);
      jtag_dout <= data_out_b(17 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b(17 downto 0) <= data_out_b(17 downto 0);
        address_b(13 downto 0) <= "11111111111111";
        we_b(3 downto 0) <= "0000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b(17 downto 0) <= jtag_din(17 downto 0);
        address_b(13 downto 0) <= jtag_addr(9 downto 0) & "1111";
        we_b(3 downto 0) <= jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      -- 
      kcpsm6_rom: RAMB18E1
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => "000000000000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => "000000000000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => "000000000000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => "000000000000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"10FF600990013F003E0F3D421C401C001D001E001F0090022004200420042004",
                    INIT_01 => X"043E0460960204281A451B0002D602C6044FD002E010BF00BE1CBD209C001001",
                    INIT_02 => X"043E04F004281A9F1B00602596013F003E0F3D421C401C001D001E001F000431",
                    INIT_03 => X"1AC21B00E038BF00BE1CBD209C00160116FF0431043E04C0043E04D0043E04E0",
                    INIT_04 => X"15741561156C15751563156C156115431520150D150D20F60431043E04600428",
                    INIT_05 => X"157315751520157315651575156C1561157615201566156F1520156E156F1569",
                    INIT_06 => X"15651568157415201565156E15691566156515641520156F1574152015641565",
                    INIT_07 => X"1563156515441520150D150D1565157415611572152015441555154115421520",
                    INIT_08 => X"15711565157215661520156B1563156F156C156315201564156515721561156C",
                    INIT_09 => X"152015001520153D15201529157A1548154D1528152015791563156E15651575",
                    INIT_0A => X"1520156B1563156F156C15631520156415651574157215651576156E156F1543",
                    INIT_0B => X"153D15201529157A15481528152015791563156E156515751571156515721566",
                    INIT_0C => X"1574156515731527152015201520152015201520152015201520152015001520",
                    INIT_0D => X"1575156C15611576152015271565157415611572155F1564157515611562155F",
                    INIT_0E => X"12E8500060EBB1009001B13FB03E500060E69001B03D15001520153D15201565",
                    INIT_0F => X"04281A871B010431043E0460960204281A3B1B01500060F1B300920100E91303",
                    INIT_10 => X"E10D9704140114009706076021101401E10AD60B04281AAA1B010431043E0460",
                    INIT_11 => X"043E04F004281ACD1B01611696013F003E031DE81D001E001F000431043EF43D",
                    INIT_12 => X"9D063700160116001700BF00BE009D0804281AF01B010431043E04D0043E04E0",
                    INIT_13 => X"156115431520150D150D22130431043E0460043E0470F73FF63EE12DBF00BE00",
                    INIT_14 => X"1566156F157315201566156F1520156E156F156915741561156C15751563156C",
                    INIT_15 => X"1575156C15611576152015791561156C15651564152015651572156115771574",
                    INIT_16 => X"156C156315201564156515721561156C1563156515441520150D150D15731565",
                    INIT_17 => X"154D1528152015791563156E1565157515711565157215661520156B1563156F",
                    INIT_18 => X"1563156F156C15431520152015201520152015001520153D15201529157A1548",
                    INIT_19 => X"15731575153115201572156F1566152015731565156C1563157915631520156B",
                    INIT_1A => X"15201520152015201520152015001520153D152015791561156C156515641520",
                    INIT_1B => X"1575156F1563155F15791561156C15651564155F157315751531152715201520",
                    INIT_1C => X"15201520152015001520153D152015651575156C15611576152015271574156E",
                    INIT_1D => X"1566152015731565156C1563157915631520156B1563156F156C154315201520",
                    INIT_1E => X"15001520153D152015791561156C1565156415201573156D153115201572156F",
                    INIT_1F => X"156C15651564155F1573156D1531152715201520152015201520152015201520",
                    INIT_20 => X"152015651575156C15611576152015271574156E1575156F1563155F15791561",
                    INIT_21 => X"1F0004281A9D1B026216D573221CD5532216045704281A4A1B0215001520153D",
                    INIT_22 => X"00EF042F043C05C0043C05D00452153A043C05E0043C05F0043A1C001D001E00",
                    INIT_23 => X"6223DD061D011C006223DC0A1C0122302213D5722213D5529501E239D0089000",
                    INIT_24 => X"156D156915531520150D150D22231F006223DF061F011E006223DE0A1E011D00",
                    INIT_25 => X"15201567156E156915731575152015721565156D1569157415201565156C1570",
                    INIT_26 => X"156515721561157715741566156F157315201573156D15311520156515681574",
                    INIT_27 => X"157215501520150D150D1570156F156F156C152015791561156C156515641520",
                    INIT_28 => X"15731520156F1574152015791565156B15201527155315271520157315731565",
                    INIT_29 => X"1520150D150D1500150D150D15721565156D1569157415201574157215611574",
                    INIT_2A => X"1574152015791565156B15201527155215271520157315731565157215501528",
                    INIT_2B => X"156D15691574152015741565157315651572152F1570156F157415731520156F",
                    INIT_2C => X"151B50000452154A045215320452155B0452151B1500150D150D152915721565",
                    INIT_2D => X"155F152015205000042F0452458004281ADD1B025000045215480452155B0452",
                    INIT_2E => X"155F15201520155F155F155F155F1520155F155F155F155F155F155F15201520",
                    INIT_2F => X"150D155F155F15201520155F155F15201520155F155F15201520155F155F155F",
                    INIT_30 => X"1520155F15201520157C155F155F155F1520152F1520152F157C1520157C1520",
                    INIT_31 => X"152F157C15201520152F155C15201520157C157C155F155F155F1520152F155C",
                    INIT_32 => X"157C152015201520157C1520152F152015271520157C1520150D155F152F1520",
                    INIT_33 => X"152F155C157C1520157C155C1520155F155F155F155C15201529155F157C1520",
                    INIT_34 => X"1520155C1520152E1520157C1520150D155C1520155F15271520157C1520157C",
                    INIT_35 => X"15201529155F155F155F1520152F155F155F15201520157C155F155F155F157C",
                    INIT_36 => X"1520150D152915201529155F15281520157C1520157C15201520157C1520157C",
                    INIT_37 => X"152015201520157C155F157C155F155F155F155F155C155F155C157C155F157C",
                    INIT_38 => X"155F155C157C155F157C15201520157C155F157C152F155F155F155F155F157C",
                    INIT_39 => X"154215201563156915741561156D156F157415751541150D150D152F155F155F",
                    INIT_3A => X"156C156F15721574156E156F1543152015651574156115521520154415551541",
                    INIT_3B => X"156515441520156515721561157715741566156F155315201564156E15611520",
                    INIT_3C => X"150D1567156E1569156E1575155415201570156F156F154C152015791561156C",
                    INIT_3D => X"1520153A156515741561154415201579156C1562156D1565157315731541150D",
                    INIT_3E => X"1569155415201520152015391531153015321520156C1575154A152015351531",
                    INIT_3F => X"157315731541150D15321533153A15371533153A153115311520153A1565156D",
                   INITP_00 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA20D55288888355402820AAD55355400AA",
                   INITP_01 => X"82820B582D42D2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_02 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA22B5541582888835502AD448D828",
                   INITP_03 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_04 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAA8D4D4D4D6DD30A888888020DDE82AAAAAAAAA",
                   INITP_05 => X"AAAAAAAAAAAAAAAAAAA60A2228888AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_06 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_07 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
      port map(   ADDRARDADDR => address_a(13 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a(15 downto 0),
                      DOPADOP => data_out_a(17 downto 16), 
                        DIADI => data_in_a(15 downto 0),
                      DIPADIP => data_in_a(17 downto 16), 
                          WEA => "00",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(13 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b(15 downto 0),
                      DOPBDOP => data_out_b(17 downto 16), 
                        DIBDI => data_in_b(15 downto 0),
                      DIPBDIP => data_in_b(17 downto 16), 
                        WEBWE => we_b(3 downto 0),
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(13 downto 0) <= address(9 downto 0) & "1111";
      instruction <= data_out_a(17 downto 0);
      data_in_a(17 downto 0) <= "0000000000000000" & address(11 downto 10);
      jtag_dout <= data_out_b(17 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b(17 downto 0) <= data_out_b(17 downto 0);
        address_b(13 downto 0) <= "11111111111111";
        we_b(3 downto 0) <= "0000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b(17 downto 0) <= jtag_din(17 downto 0);
        address_b(13 downto 0) <= jtag_addr(9 downto 0) & "1111";
        we_b(3 downto 0) <= jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      -- 
      kcpsm6_rom: RAMB18E2
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => "000000000000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => "000000000000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => "000000000000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => "000000000000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    INIT_00 => X"10FF600990013F003E0F3D421C401C001D001E001F0090022004200420042004",
                    INIT_01 => X"043E0460960204281A451B0002D602C6044FD002E010BF00BE1CBD209C001001",
                    INIT_02 => X"043E04F004281A9F1B00602596013F003E0F3D421C401C001D001E001F000431",
                    INIT_03 => X"1AC21B00E038BF00BE1CBD209C00160116FF0431043E04C0043E04D0043E04E0",
                    INIT_04 => X"15741561156C15751563156C156115431520150D150D20F60431043E04600428",
                    INIT_05 => X"157315751520157315651575156C1561157615201566156F1520156E156F1569",
                    INIT_06 => X"15651568157415201565156E15691566156515641520156F1574152015641565",
                    INIT_07 => X"1563156515441520150D150D1565157415611572152015441555154115421520",
                    INIT_08 => X"15711565157215661520156B1563156F156C156315201564156515721561156C",
                    INIT_09 => X"152015001520153D15201529157A1548154D1528152015791563156E15651575",
                    INIT_0A => X"1520156B1563156F156C15631520156415651574157215651576156E156F1543",
                    INIT_0B => X"153D15201529157A15481528152015791563156E156515751571156515721566",
                    INIT_0C => X"1574156515731527152015201520152015201520152015201520152015001520",
                    INIT_0D => X"1575156C15611576152015271565157415611572155F1564157515611562155F",
                    INIT_0E => X"12E8500060EBB1009001B13FB03E500060E69001B03D15001520153D15201565",
                    INIT_0F => X"04281A871B010431043E0460960204281A3B1B01500060F1B300920100E91303",
                    INIT_10 => X"E10D9704140114009706076021101401E10AD60B04281AAA1B010431043E0460",
                    INIT_11 => X"043E04F004281ACD1B01611696013F003E031DE81D001E001F000431043EF43D",
                    INIT_12 => X"9D063700160116001700BF00BE009D0804281AF01B010431043E04D0043E04E0",
                    INIT_13 => X"156115431520150D150D22130431043E0460043E0470F73FF63EE12DBF00BE00",
                    INIT_14 => X"1566156F157315201566156F1520156E156F156915741561156C15751563156C",
                    INIT_15 => X"1575156C15611576152015791561156C15651564152015651572156115771574",
                    INIT_16 => X"156C156315201564156515721561156C1563156515441520150D150D15731565",
                    INIT_17 => X"154D1528152015791563156E1565157515711565157215661520156B1563156F",
                    INIT_18 => X"1563156F156C15431520152015201520152015001520153D15201529157A1548",
                    INIT_19 => X"15731575153115201572156F1566152015731565156C1563157915631520156B",
                    INIT_1A => X"15201520152015201520152015001520153D152015791561156C156515641520",
                    INIT_1B => X"1575156F1563155F15791561156C15651564155F157315751531152715201520",
                    INIT_1C => X"15201520152015001520153D152015651575156C15611576152015271574156E",
                    INIT_1D => X"1566152015731565156C1563157915631520156B1563156F156C154315201520",
                    INIT_1E => X"15001520153D152015791561156C1565156415201573156D153115201572156F",
                    INIT_1F => X"156C15651564155F1573156D1531152715201520152015201520152015201520",
                    INIT_20 => X"152015651575156C15611576152015271574156E1575156F1563155F15791561",
                    INIT_21 => X"1F0004281A9D1B026216D573221CD5532216045704281A4A1B0215001520153D",
                    INIT_22 => X"00EF042F043C05C0043C05D00452153A043C05E0043C05F0043A1C001D001E00",
                    INIT_23 => X"6223DD061D011C006223DC0A1C0122302213D5722213D5529501E239D0089000",
                    INIT_24 => X"156D156915531520150D150D22231F006223DF061F011E006223DE0A1E011D00",
                    INIT_25 => X"15201567156E156915731575152015721565156D1569157415201565156C1570",
                    INIT_26 => X"156515721561157715741566156F157315201573156D15311520156515681574",
                    INIT_27 => X"157215501520150D150D1570156F156F156C152015791561156C156515641520",
                    INIT_28 => X"15731520156F1574152015791565156B15201527155315271520157315731565",
                    INIT_29 => X"1520150D150D1500150D150D15721565156D1569157415201574157215611574",
                    INIT_2A => X"1574152015791565156B15201527155215271520157315731565157215501528",
                    INIT_2B => X"156D15691574152015741565157315651572152F1570156F157415731520156F",
                    INIT_2C => X"151B50000452154A045215320452155B0452151B1500150D150D152915721565",
                    INIT_2D => X"155F152015205000042F0452458004281ADD1B025000045215480452155B0452",
                    INIT_2E => X"155F15201520155F155F155F155F1520155F155F155F155F155F155F15201520",
                    INIT_2F => X"150D155F155F15201520155F155F15201520155F155F15201520155F155F155F",
                    INIT_30 => X"1520155F15201520157C155F155F155F1520152F1520152F157C1520157C1520",
                    INIT_31 => X"152F157C15201520152F155C15201520157C157C155F155F155F1520152F155C",
                    INIT_32 => X"157C152015201520157C1520152F152015271520157C1520150D155F152F1520",
                    INIT_33 => X"152F155C157C1520157C155C1520155F155F155F155C15201529155F157C1520",
                    INIT_34 => X"1520155C1520152E1520157C1520150D155C1520155F15271520157C1520157C",
                    INIT_35 => X"15201529155F155F155F1520152F155F155F15201520157C155F155F155F157C",
                    INIT_36 => X"1520150D152915201529155F15281520157C1520157C15201520157C1520157C",
                    INIT_37 => X"152015201520157C155F157C155F155F155F155F155C155F155C157C155F157C",
                    INIT_38 => X"155F155C157C155F157C15201520157C155F157C152F155F155F155F155F157C",
                    INIT_39 => X"154215201563156915741561156D156F157415751541150D150D152F155F155F",
                    INIT_3A => X"156C156F15721574156E156F1543152015651574156115521520154415551541",
                    INIT_3B => X"156515441520156515721561157715741566156F155315201564156E15611520",
                    INIT_3C => X"150D1567156E1569156E1575155415201570156F156F154C152015791561156C",
                    INIT_3D => X"1520153A156515741561154415201579156C1562156D1565157315731541150D",
                    INIT_3E => X"1569155415201520152015391531153015321520156C1575154A152015351531",
                    INIT_3F => X"157315731541150D15321533153A15371533153A153115311520153A1565156D",
                   INITP_00 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA20D55288888355402820AAD55355400AA",
                   INITP_01 => X"82820B582D42D2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_02 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA22B5541582888835502AD448D828",
                   INITP_03 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_04 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAA8D4D4D4D6DD30A888888020DDE82AAAAAAAAA",
                   INITP_05 => X"AAAAAAAAAAAAAAAAAAA60A2228888AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_06 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_07 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
      port map(   ADDRARDADDR => address_a(13 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a(15 downto 0),
                  DOUTPADOUTP => data_out_a(17 downto 16), 
                      DINADIN => data_in_a(15 downto 0),
                    DINPADINP => data_in_a(17 downto 16), 
                          WEA => "00",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(13 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b(15 downto 0),
                  DOUTPBDOUTP => data_out_b(17 downto 16), 
                      DINBDIN => data_in_b(15 downto 0),
                    DINPBDINP => data_in_b(17 downto 16), 
                        WEBWE => we_b(3 downto 0),
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "0000000000000000",  
                      CASDINB => "0000000000000000",
                     CASDINPA => "00",
                     CASDINPB => "00",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_1k_generate;
  --
  --
  --
  ram_2k_generate : if (C_RAM_SIZE_KWORDS = 2) generate
    --
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a <= '1' & address(10 downto 0) & "1111";
      instruction <= data_out_a(33 downto 32) & data_out_a(15 downto 0);
      data_in_a <= "00000000000000000000000000000000000" & address(11);
      jtag_dout <= data_out_b(33 downto 32) & data_out_b(15 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b <= "00" & data_out_b(33 downto 32) & "0000000000000000" & data_out_b(15 downto 0);
        address_b <= "1111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b <= "00" & jtag_din(17 downto 16) & "0000000000000000" & jtag_din(15 downto 0);
        address_b <= '1' & jtag_addr(10 downto 0) & "1111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom: RAMB36E1
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"10FF600990013F003E0F3D421C401C001D001E001F0090022004200420042004",
                    INIT_01 => X"043E0460960204281A451B0002D602C6044FD002E010BF00BE1CBD209C001001",
                    INIT_02 => X"043E04F004281A9F1B00602596013F003E0F3D421C401C001D001E001F000431",
                    INIT_03 => X"1AC21B00E038BF00BE1CBD209C00160116FF0431043E04C0043E04D0043E04E0",
                    INIT_04 => X"15741561156C15751563156C156115431520150D150D20F60431043E04600428",
                    INIT_05 => X"157315751520157315651575156C1561157615201566156F1520156E156F1569",
                    INIT_06 => X"15651568157415201565156E15691566156515641520156F1574152015641565",
                    INIT_07 => X"1563156515441520150D150D1565157415611572152015441555154115421520",
                    INIT_08 => X"15711565157215661520156B1563156F156C156315201564156515721561156C",
                    INIT_09 => X"152015001520153D15201529157A1548154D1528152015791563156E15651575",
                    INIT_0A => X"1520156B1563156F156C15631520156415651574157215651576156E156F1543",
                    INIT_0B => X"153D15201529157A15481528152015791563156E156515751571156515721566",
                    INIT_0C => X"1574156515731527152015201520152015201520152015201520152015001520",
                    INIT_0D => X"1575156C15611576152015271565157415611572155F1564157515611562155F",
                    INIT_0E => X"12E8500060EBB1009001B13FB03E500060E69001B03D15001520153D15201565",
                    INIT_0F => X"04281A871B010431043E0460960204281A3B1B01500060F1B300920100E91303",
                    INIT_10 => X"E10D9704140114009706076021101401E10AD60B04281AAA1B010431043E0460",
                    INIT_11 => X"043E04F004281ACD1B01611696013F003E031DE81D001E001F000431043EF43D",
                    INIT_12 => X"9D063700160116001700BF00BE009D0804281AF01B010431043E04D0043E04E0",
                    INIT_13 => X"156115431520150D150D22130431043E0460043E0470F73FF63EE12DBF00BE00",
                    INIT_14 => X"1566156F157315201566156F1520156E156F156915741561156C15751563156C",
                    INIT_15 => X"1575156C15611576152015791561156C15651564152015651572156115771574",
                    INIT_16 => X"156C156315201564156515721561156C1563156515441520150D150D15731565",
                    INIT_17 => X"154D1528152015791563156E1565157515711565157215661520156B1563156F",
                    INIT_18 => X"1563156F156C15431520152015201520152015001520153D15201529157A1548",
                    INIT_19 => X"15731575153115201572156F1566152015731565156C1563157915631520156B",
                    INIT_1A => X"15201520152015201520152015001520153D152015791561156C156515641520",
                    INIT_1B => X"1575156F1563155F15791561156C15651564155F157315751531152715201520",
                    INIT_1C => X"15201520152015001520153D152015651575156C15611576152015271574156E",
                    INIT_1D => X"1566152015731565156C1563157915631520156B1563156F156C154315201520",
                    INIT_1E => X"15001520153D152015791561156C1565156415201573156D153115201572156F",
                    INIT_1F => X"156C15651564155F1573156D1531152715201520152015201520152015201520",
                    INIT_20 => X"152015651575156C15611576152015271574156E1575156F1563155F15791561",
                    INIT_21 => X"1F0004281A9D1B026216D573221CD5532216045704281A4A1B0215001520153D",
                    INIT_22 => X"00EF042F043C05C0043C05D00452153A043C05E0043C05F0043A1C001D001E00",
                    INIT_23 => X"6223DD061D011C006223DC0A1C0122302213D5722213D5529501E239D0089000",
                    INIT_24 => X"156D156915531520150D150D22231F006223DF061F011E006223DE0A1E011D00",
                    INIT_25 => X"15201567156E156915731575152015721565156D1569157415201565156C1570",
                    INIT_26 => X"156515721561157715741566156F157315201573156D15311520156515681574",
                    INIT_27 => X"157215501520150D150D1570156F156F156C152015791561156C156515641520",
                    INIT_28 => X"15731520156F1574152015791565156B15201527155315271520157315731565",
                    INIT_29 => X"1520150D150D1500150D150D15721565156D1569157415201574157215611574",
                    INIT_2A => X"1574152015791565156B15201527155215271520157315731565157215501528",
                    INIT_2B => X"156D15691574152015741565157315651572152F1570156F157415731520156F",
                    INIT_2C => X"151B50000452154A045215320452155B0452151B1500150D150D152915721565",
                    INIT_2D => X"155F152015205000042F0452458004281ADD1B025000045215480452155B0452",
                    INIT_2E => X"155F15201520155F155F155F155F1520155F155F155F155F155F155F15201520",
                    INIT_2F => X"150D155F155F15201520155F155F15201520155F155F15201520155F155F155F",
                    INIT_30 => X"1520155F15201520157C155F155F155F1520152F1520152F157C1520157C1520",
                    INIT_31 => X"152F157C15201520152F155C15201520157C157C155F155F155F1520152F155C",
                    INIT_32 => X"157C152015201520157C1520152F152015271520157C1520150D155F152F1520",
                    INIT_33 => X"152F155C157C1520157C155C1520155F155F155F155C15201529155F157C1520",
                    INIT_34 => X"1520155C1520152E1520157C1520150D155C1520155F15271520157C1520157C",
                    INIT_35 => X"15201529155F155F155F1520152F155F155F15201520157C155F155F155F157C",
                    INIT_36 => X"1520150D152915201529155F15281520157C1520157C15201520157C1520157C",
                    INIT_37 => X"152015201520157C155F157C155F155F155F155F155C155F155C157C155F157C",
                    INIT_38 => X"155F155C157C155F157C15201520157C155F157C152F155F155F155F155F157C",
                    INIT_39 => X"154215201563156915741561156D156F157415751541150D150D152F155F155F",
                    INIT_3A => X"156C156F15721574156E156F1543152015651574156115521520154415551541",
                    INIT_3B => X"156515441520156515721561157715741566156F155315201564156E15611520",
                    INIT_3C => X"150D1567156E1569156E1575155415201570156F156F154C152015791561156C",
                    INIT_3D => X"1520153A156515741561154415201579156C1562156D1565157315731541150D",
                    INIT_3E => X"1569155415201520152015391531153015321520156C1575154A152015351531",
                    INIT_3F => X"157315731541150D15321533153A15371533153A153115311520153A1565156D",
                    INIT_40 => X"1520153A156E156F15691573157215651556152015721565156C1562156D1565",
                    INIT_41 => X"1544152015651572156115771564157215611548150D15301537152E15321576",
                    INIT_42 => X"150D24283B001A0104521000D5004BA015001520153A156E1567156915731565",
                    INIT_43 => X"450E054024521530245215202452150D045215780452156504521548043A2452",
                    INIT_44 => X"B0315000153A1507A44D950A50000452044A350F05400452044A450E450E450E",
                    INIT_45 => X"50009501245810009101645ED008900011A75000D5016452D00490005000B001",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA20D55288888355402820AAD55355400AA",
                   INITP_01 => X"82820B582D42D2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_02 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA22B5541582888835502AD448D828",
                   INITP_03 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_04 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAA8D4D4D4D6DD30A888888020DDE82AAAAAAAAA",
                   INITP_05 => X"AAAAAAAAAAAAAAAAAAA60A2228888AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_06 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_07 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_08 => X"00000000000000008B702B0AA5DA82954988888A25B6AAAAAAAAAAAAAAAAAAAA",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a(31 downto 0),
                      DOPADOP => data_out_a(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b(31 downto 0),
                      DOPBDOP => data_out_b(35 downto 32), 
                        DIBDI => data_in_b(31 downto 0),
                      DIPBDIP => data_in_b(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(14 downto 0) <= address(10 downto 0) & "1111";
      instruction <= data_out_a(33 downto 32) & data_out_a(15 downto 0);
      data_in_a <= "00000000000000000000000000000000000" & address(11);
      jtag_dout <= data_out_b(33 downto 32) & data_out_b(15 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b <= "00" & data_out_b(33 downto 32) & "0000000000000000" & data_out_b(15 downto 0);
        address_b(14 downto 0) <= "111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b <= "00" & jtag_din(17 downto 16) & "0000000000000000" & jtag_din(15 downto 0);
        address_b(14 downto 0) <= jtag_addr(10 downto 0) & "1111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom: RAMB36E2
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"10FF600990013F003E0F3D421C401C001D001E001F0090022004200420042004",
                    INIT_01 => X"043E0460960204281A451B0002D602C6044FD002E010BF00BE1CBD209C001001",
                    INIT_02 => X"043E04F004281A9F1B00602596013F003E0F3D421C401C001D001E001F000431",
                    INIT_03 => X"1AC21B00E038BF00BE1CBD209C00160116FF0431043E04C0043E04D0043E04E0",
                    INIT_04 => X"15741561156C15751563156C156115431520150D150D20F60431043E04600428",
                    INIT_05 => X"157315751520157315651575156C1561157615201566156F1520156E156F1569",
                    INIT_06 => X"15651568157415201565156E15691566156515641520156F1574152015641565",
                    INIT_07 => X"1563156515441520150D150D1565157415611572152015441555154115421520",
                    INIT_08 => X"15711565157215661520156B1563156F156C156315201564156515721561156C",
                    INIT_09 => X"152015001520153D15201529157A1548154D1528152015791563156E15651575",
                    INIT_0A => X"1520156B1563156F156C15631520156415651574157215651576156E156F1543",
                    INIT_0B => X"153D15201529157A15481528152015791563156E156515751571156515721566",
                    INIT_0C => X"1574156515731527152015201520152015201520152015201520152015001520",
                    INIT_0D => X"1575156C15611576152015271565157415611572155F1564157515611562155F",
                    INIT_0E => X"12E8500060EBB1009001B13FB03E500060E69001B03D15001520153D15201565",
                    INIT_0F => X"04281A871B010431043E0460960204281A3B1B01500060F1B300920100E91303",
                    INIT_10 => X"E10D9704140114009706076021101401E10AD60B04281AAA1B010431043E0460",
                    INIT_11 => X"043E04F004281ACD1B01611696013F003E031DE81D001E001F000431043EF43D",
                    INIT_12 => X"9D063700160116001700BF00BE009D0804281AF01B010431043E04D0043E04E0",
                    INIT_13 => X"156115431520150D150D22130431043E0460043E0470F73FF63EE12DBF00BE00",
                    INIT_14 => X"1566156F157315201566156F1520156E156F156915741561156C15751563156C",
                    INIT_15 => X"1575156C15611576152015791561156C15651564152015651572156115771574",
                    INIT_16 => X"156C156315201564156515721561156C1563156515441520150D150D15731565",
                    INIT_17 => X"154D1528152015791563156E1565157515711565157215661520156B1563156F",
                    INIT_18 => X"1563156F156C15431520152015201520152015001520153D15201529157A1548",
                    INIT_19 => X"15731575153115201572156F1566152015731565156C1563157915631520156B",
                    INIT_1A => X"15201520152015201520152015001520153D152015791561156C156515641520",
                    INIT_1B => X"1575156F1563155F15791561156C15651564155F157315751531152715201520",
                    INIT_1C => X"15201520152015001520153D152015651575156C15611576152015271574156E",
                    INIT_1D => X"1566152015731565156C1563157915631520156B1563156F156C154315201520",
                    INIT_1E => X"15001520153D152015791561156C1565156415201573156D153115201572156F",
                    INIT_1F => X"156C15651564155F1573156D1531152715201520152015201520152015201520",
                    INIT_20 => X"152015651575156C15611576152015271574156E1575156F1563155F15791561",
                    INIT_21 => X"1F0004281A9D1B026216D573221CD5532216045704281A4A1B0215001520153D",
                    INIT_22 => X"00EF042F043C05C0043C05D00452153A043C05E0043C05F0043A1C001D001E00",
                    INIT_23 => X"6223DD061D011C006223DC0A1C0122302213D5722213D5529501E239D0089000",
                    INIT_24 => X"156D156915531520150D150D22231F006223DF061F011E006223DE0A1E011D00",
                    INIT_25 => X"15201567156E156915731575152015721565156D1569157415201565156C1570",
                    INIT_26 => X"156515721561157715741566156F157315201573156D15311520156515681574",
                    INIT_27 => X"157215501520150D150D1570156F156F156C152015791561156C156515641520",
                    INIT_28 => X"15731520156F1574152015791565156B15201527155315271520157315731565",
                    INIT_29 => X"1520150D150D1500150D150D15721565156D1569157415201574157215611574",
                    INIT_2A => X"1574152015791565156B15201527155215271520157315731565157215501528",
                    INIT_2B => X"156D15691574152015741565157315651572152F1570156F157415731520156F",
                    INIT_2C => X"151B50000452154A045215320452155B0452151B1500150D150D152915721565",
                    INIT_2D => X"155F152015205000042F0452458004281ADD1B025000045215480452155B0452",
                    INIT_2E => X"155F15201520155F155F155F155F1520155F155F155F155F155F155F15201520",
                    INIT_2F => X"150D155F155F15201520155F155F15201520155F155F15201520155F155F155F",
                    INIT_30 => X"1520155F15201520157C155F155F155F1520152F1520152F157C1520157C1520",
                    INIT_31 => X"152F157C15201520152F155C15201520157C157C155F155F155F1520152F155C",
                    INIT_32 => X"157C152015201520157C1520152F152015271520157C1520150D155F152F1520",
                    INIT_33 => X"152F155C157C1520157C155C1520155F155F155F155C15201529155F157C1520",
                    INIT_34 => X"1520155C1520152E1520157C1520150D155C1520155F15271520157C1520157C",
                    INIT_35 => X"15201529155F155F155F1520152F155F155F15201520157C155F155F155F157C",
                    INIT_36 => X"1520150D152915201529155F15281520157C1520157C15201520157C1520157C",
                    INIT_37 => X"152015201520157C155F157C155F155F155F155F155C155F155C157C155F157C",
                    INIT_38 => X"155F155C157C155F157C15201520157C155F157C152F155F155F155F155F157C",
                    INIT_39 => X"154215201563156915741561156D156F157415751541150D150D152F155F155F",
                    INIT_3A => X"156C156F15721574156E156F1543152015651574156115521520154415551541",
                    INIT_3B => X"156515441520156515721561157715741566156F155315201564156E15611520",
                    INIT_3C => X"150D1567156E1569156E1575155415201570156F156F154C152015791561156C",
                    INIT_3D => X"1520153A156515741561154415201579156C1562156D1565157315731541150D",
                    INIT_3E => X"1569155415201520152015391531153015321520156C1575154A152015351531",
                    INIT_3F => X"157315731541150D15321533153A15371533153A153115311520153A1565156D",
                    INIT_40 => X"1520153A156E156F15691573157215651556152015721565156C1562156D1565",
                    INIT_41 => X"1544152015651572156115771564157215611548150D15301537152E15321576",
                    INIT_42 => X"150D24283B001A0104521000D5004BA015001520153A156E1567156915731565",
                    INIT_43 => X"450E054024521530245215202452150D045215780452156504521548043A2452",
                    INIT_44 => X"B0315000153A1507A44D950A50000452044A350F05400452044A450E450E450E",
                    INIT_45 => X"50009501245810009101645ED008900011A75000D5016452D00490005000B001",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA20D55288888355402820AAD55355400AA",
                   INITP_01 => X"82820B582D42D2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_02 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA22B5541582888835502AD448D828",
                   INITP_03 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_04 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAA8D4D4D4D6DD30A888888020DDE82AAAAAAAAA",
                   INITP_05 => X"AAAAAAAAAAAAAAAAAAA60A2228888AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_06 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_07 => X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                   INITP_08 => X"00000000000000008B702B0AA5DA82954988888A25B6AAAAAAAAAAAAAAAAAAAA",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a(31 downto 0),
                  DOUTPADOUTP => data_out_a(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b(31 downto 0),
                  DOUTPBDOUTP => data_out_b(35 downto 32), 
                      DINBDIN => data_in_b(31 downto 0),
                    DINPBDINP => data_in_b(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_2k_generate;
  --
  --	
  ram_4k_generate : if (C_RAM_SIZE_KWORDS = 4) generate
    --
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a <= '1' & address(11 downto 0) & "111";
      instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
      data_in_a <= "000000000000000000000000000000000000";
      jtag_dout <= data_out_b_h(32) & data_out_b_h(7 downto 0) & data_out_b_l(32) & data_out_b_l(7 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
        data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
        address_b <= "1111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b_h <= "000" & jtag_din(17) & "000000000000000000000000" & jtag_din(16 downto 9);
        data_in_b_l <= "000" & jtag_din(8) & "000000000000000000000000" & jtag_din(7 downto 0);
        address_b <= '1' & jtag_addr(11 downto 0) & "111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom_l: RAMB36E1
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"3E6002284500D6C64F0210001C200001FF0901000F4240000000000204040404",
                    INIT_01 => X"C20038001C200001FF313EC03ED03EE03EF0289F002501000F42400000000031",
                    INIT_02 => X"7375207365756C617620666F206E6F6974616C75636C6143200D0DF6313E6028",
                    INIT_03 => X"636544200D0D6574617220445541422065687420656E69666564206F74206465",
                    INIT_04 => X"2000203D20297A484D282079636E657571657266206B636F6C6320646572616C",
                    INIT_05 => X"3D20297A48282079636E657571657266206B636F6C63206465747265766E6F43",
                    INIT_06 => X"756C61762027657461725F647561625F74657327202020202020202020200020",
                    INIT_07 => X"288701313E6002283B0100F10001E903E800EB00013F3E00E6013D00203D2065",
                    INIT_08 => X"3EF028CD0116010003E8000000313E3D0D040100066010010A0B28AA01313E60",
                    INIT_09 => X"6143200D0D13313E603E703F3E2D0000060001000000000828F001313ED03EE0",
                    INIT_0A => X"756C61762079616C6564206572617774666F7320666F206E6F6974616C75636C",
                    INIT_0B => X"4D282079636E657571657266206B636F6C6320646572616C636544200D0D7365",
                    INIT_0C => X"73753120726F662073656C637963206B636F6C43202020202000203D20297A48",
                    INIT_0D => X"756F635F79616C65645F73753127202020202020202000203D2079616C656420",
                    INIT_0E => X"662073656C637963206B636F6C43202020202000203D2065756C61762027746E",
                    INIT_0F => X"6C65645F736D3127202020202020202000203D2079616C656420736D3120726F",
                    INIT_10 => X"00289D0216731C531657284A0200203D2065756C61762027746E756F635F7961",
                    INIT_11 => X"23060100230A01301372135201390800EF2F3CC03CD0523A3CE03CF03A000000",
                    INIT_12 => X"20676E6973752072656D697420656C706D6953200D0D230023060100230A0100",
                    INIT_13 => X"7250200D0D706F6F6C2079616C6564206572617774666F7320736D3120656874",
                    INIT_14 => X"200D0D000D0D72656D6974207472617473206F742079656B2027532720737365",
                    INIT_15 => X"6D69742074657365722F706F7473206F742079656B2027522720737365725028",
                    INIT_16 => X"5F2020002F528028DD02005248525B521B00524A5232525B521B000D0D297265",
                    INIT_17 => X"0D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F5F5F5F5F5F2020",
                    INIT_18 => X"2F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F202F202F7C207C20",
                    INIT_19 => X"2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027207C200D5F2F20",
                    INIT_1A => X"20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C205F27207C207C",
                    INIT_1B => X"2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C207C20207C207C",
                    INIT_1C => X"4220636974616D6F7475410D0D2F5F5F5F5C7C5F7C20207C5F7C2F5F5F5F5F7C",
                    INIT_1D => X"6544206572617774666F5320646E61206C6F72746E6F43206574615220445541",
                    INIT_1E => X"203A6574614420796C626D657373410D0D676E696E755420706F6F4C2079616C",
                    INIT_1F => X"7373410D32333A37333A3131203A656D695420202039313032206C754A203531",
                    INIT_20 => X"442065726177647261480D30372E3276203A6E6F69737265562072656C626D65",
                    INIT_21 => X"0E4052305220520D5278526552483A520D280001520000A000203A6E67697365",
                    INIT_22 => X"00015800015E0800A70001520400000131003A074D0A00524A0F40524A0E0E0E",
                    INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"2049141FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE05400094A041414A0",
                   INITP_01 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF816CD200D68CE88",
                   INITP_02 => X"FFFFFFFFE24A957FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6160581552950FFFFF",
                   INITP_03 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                   INITP_04 => X"000000000000000000000000000000000000000048A03467D554A3FFFFFFFFFF",
                   INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a_l(31 downto 0),
                      DOPADOP => data_out_a_l(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b_l(31 downto 0),
                      DOPBDOP => data_out_b_l(35 downto 32), 
                        DIBDI => data_in_b_l(31 downto 0),
                      DIPBDIP => data_in_b_l(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
      kcpsm6_rom_h: RAMB36E1
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"02024B020D0D01010268F0DFDFDECE8808B0C89F9F9E8E0E0E0F0F4810101010",
                    INIT_01 => X"0D0DF0DFDFDECE8B0B020202020202020202020D0DB0CB9F9F9E8E0E0E0F0F02",
                    INIT_02 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A1002020202",
                    INIT_03 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_04 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_05 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_06 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_07 => X"020D0D0202024B020D0D28B0D9C900090928B0D8C8585828B0C8580A0A0A0A0A",
                    INIT_08 => X"0202020D0DB0CB9F9F8E0E0F0F02027AF0CB8A0ACB03100AF0EB020D0D020202",
                    INIT_09 => X"0A0A0A0A0A1102020202027B7BF0DFDFCE9B8B0B0BDFDFCE020D0D0202020202",
                    INIT_0A => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0B => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0C => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0D => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0E => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0F => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_10 => X"0F020D0DB1EA91EA9102020D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_11 => X"B1EE8E0EB1EE8E1191EA91EA4AF16848000202020202020A02020202020E0E0F",
                    INIT_12 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A110FB1EF8F0FB1EF8F0E",
                    INIT_13 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_14 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_15 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_16 => X"0A0A0A280202A2020D0D28020A020A020A28020A020A020A020A0A0A0A0A0A0A",
                    INIT_17 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_18 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_19 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1A => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1B => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1C => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1D => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1E => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1F => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_20 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_21 => X"A202128A120A120A020A020A020A02120A129D8D0288EA250A0A0A0A0A0A0A0A",
                    INIT_22 => X"284A1288C8B2684808286AB26848285858288A8AD2CA2802021A020202A2A2A2",
                    INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"9932619FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD206AA40193E0400F",
                   INITP_01 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5C009AA40782A6",
                   INITP_02 => X"FFFFFFFFFD356ABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8889A4EAA84AE7FFFF",
                   INITP_03 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                   INITP_04 => X"0000000000000000000000000000000000000000B473CB982AAB4DFFFFFFFFFF",
                   INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a_h(31 downto 0),
                      DOPADOP => data_out_a_h(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b_h(31 downto 0),
                      DOPBDOP => data_out_b_h(35 downto 32), 
                        DIBDI => data_in_b_h(31 downto 0),
                      DIPBDIP => data_in_b_h(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(14 downto 0) <= address(11 downto 0) & "111";
      instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
      data_in_a <= "000000000000000000000000000000000000";
      jtag_dout <= data_out_b_h(32) & data_out_b_h(7 downto 0) & data_out_b_l(32) & data_out_b_l(7 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
        data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
        address_b(14 downto 0) <= "111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b_h <= "000" & jtag_din(17) & "000000000000000000000000" & jtag_din(16 downto 9);
        data_in_b_l <= "000" & jtag_din(8) & "000000000000000000000000" & jtag_din(7 downto 0);
        address_b(14 downto 0) <= jtag_addr(11 downto 0) & "111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom_l: RAMB36E2
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"3E6002284500D6C64F0210001C200001FF0901000F4240000000000204040404",
                    INIT_01 => X"C20038001C200001FF313EC03ED03EE03EF0289F002501000F42400000000031",
                    INIT_02 => X"7375207365756C617620666F206E6F6974616C75636C6143200D0DF6313E6028",
                    INIT_03 => X"636544200D0D6574617220445541422065687420656E69666564206F74206465",
                    INIT_04 => X"2000203D20297A484D282079636E657571657266206B636F6C6320646572616C",
                    INIT_05 => X"3D20297A48282079636E657571657266206B636F6C63206465747265766E6F43",
                    INIT_06 => X"756C61762027657461725F647561625F74657327202020202020202020200020",
                    INIT_07 => X"288701313E6002283B0100F10001E903E800EB00013F3E00E6013D00203D2065",
                    INIT_08 => X"3EF028CD0116010003E8000000313E3D0D040100066010010A0B28AA01313E60",
                    INIT_09 => X"6143200D0D13313E603E703F3E2D0000060001000000000828F001313ED03EE0",
                    INIT_0A => X"756C61762079616C6564206572617774666F7320666F206E6F6974616C75636C",
                    INIT_0B => X"4D282079636E657571657266206B636F6C6320646572616C636544200D0D7365",
                    INIT_0C => X"73753120726F662073656C637963206B636F6C43202020202000203D20297A48",
                    INIT_0D => X"756F635F79616C65645F73753127202020202020202000203D2079616C656420",
                    INIT_0E => X"662073656C637963206B636F6C43202020202000203D2065756C61762027746E",
                    INIT_0F => X"6C65645F736D3127202020202020202000203D2079616C656420736D3120726F",
                    INIT_10 => X"00289D0216731C531657284A0200203D2065756C61762027746E756F635F7961",
                    INIT_11 => X"23060100230A01301372135201390800EF2F3CC03CD0523A3CE03CF03A000000",
                    INIT_12 => X"20676E6973752072656D697420656C706D6953200D0D230023060100230A0100",
                    INIT_13 => X"7250200D0D706F6F6C2079616C6564206572617774666F7320736D3120656874",
                    INIT_14 => X"200D0D000D0D72656D6974207472617473206F742079656B2027532720737365",
                    INIT_15 => X"6D69742074657365722F706F7473206F742079656B2027522720737365725028",
                    INIT_16 => X"5F2020002F528028DD02005248525B521B00524A5232525B521B000D0D297265",
                    INIT_17 => X"0D5F5F20205F5F20205F5F20205F5F5F5F20205F5F5F5F205F5F5F5F5F5F2020",
                    INIT_18 => X"2F7C20202F5C20207C7C5F5F5F202F5C205F20207C5F5F5F202F202F7C207C20",
                    INIT_19 => X"2F5C7C207C5C205F5F5F5C20295F7C207C2020207C202F2027207C200D5F2F20",
                    INIT_1A => X"20295F5F5F202F5F5F20207C5F5F5F7C205C202E207C200D5C205F27207C207C",
                    INIT_1B => X"2020207C5F7C5F5F5F5F5C5F5C7C5F7C200D2920295F28207C207C20207C207C",
                    INIT_1C => X"4220636974616D6F7475410D0D2F5F5F5F5C7C5F7C20207C5F7C2F5F5F5F5F7C",
                    INIT_1D => X"6544206572617774666F5320646E61206C6F72746E6F43206574615220445541",
                    INIT_1E => X"203A6574614420796C626D657373410D0D676E696E755420706F6F4C2079616C",
                    INIT_1F => X"7373410D32333A37333A3131203A656D695420202039313032206C754A203531",
                    INIT_20 => X"442065726177647261480D30372E3276203A6E6F69737265562072656C626D65",
                    INIT_21 => X"0E4052305220520D5278526552483A520D280001520000A000203A6E67697365",
                    INIT_22 => X"00015800015E0800A70001520400000131003A074D0A00524A0F40524A0E0E0E",
                    INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"2049141FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE05400094A041414A0",
                   INITP_01 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF816CD200D68CE88",
                   INITP_02 => X"FFFFFFFFE24A957FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6160581552950FFFFF",
                   INITP_03 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                   INITP_04 => X"000000000000000000000000000000000000000048A03467D554A3FFFFFFFFFF",
                   INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a_l(31 downto 0),
                  DOUTPADOUTP => data_out_a_l(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b_l(31 downto 0),
                  DOUTPBDOUTP => data_out_b_l(35 downto 32), 
                      DINBDIN => data_in_b_l(31 downto 0),
                    DINPBDINP => data_in_b_l(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
      kcpsm6_rom_h: RAMB36E2
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"02024B020D0D01010268F0DFDFDECE8808B0C89F9F9E8E0E0E0F0F4810101010",
                    INIT_01 => X"0D0DF0DFDFDECE8B0B020202020202020202020D0DB0CB9F9F9E8E0E0E0F0F02",
                    INIT_02 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A1002020202",
                    INIT_03 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_04 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_05 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_06 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_07 => X"020D0D0202024B020D0D28B0D9C900090928B0D8C8585828B0C8580A0A0A0A0A",
                    INIT_08 => X"0202020D0DB0CB9F9F8E0E0F0F02027AF0CB8A0ACB03100AF0EB020D0D020202",
                    INIT_09 => X"0A0A0A0A0A1102020202027B7BF0DFDFCE9B8B0B0BDFDFCE020D0D0202020202",
                    INIT_0A => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0B => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0C => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0D => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0E => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_0F => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_10 => X"0F020D0DB1EA91EA9102020D0D0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_11 => X"B1EE8E0EB1EE8E1191EA91EA4AF16848000202020202020A02020202020E0E0F",
                    INIT_12 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A110FB1EF8F0FB1EF8F0E",
                    INIT_13 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_14 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_15 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_16 => X"0A0A0A280202A2020D0D28020A020A020A28020A020A020A020A0A0A0A0A0A0A",
                    INIT_17 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_18 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_19 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1A => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1B => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1C => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1D => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1E => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_1F => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_20 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_21 => X"A202128A120A120A020A020A020A02120A129D8D0288EA250A0A0A0A0A0A0A0A",
                    INIT_22 => X"284A1288C8B2684808286AB26848285858288A8AD2CA2802021A020202A2A2A2",
                    INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_40 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_41 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"9932619FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD206AA40193E0400F",
                   INITP_01 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5C009AA40782A6",
                   INITP_02 => X"FFFFFFFFFD356ABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8889A4EAA84AE7FFFF",
                   INITP_03 => X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
                   INITP_04 => X"0000000000000000000000000000000000000000B473CB982AAB4DFFFFFFFFFF",
                   INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a_h(31 downto 0),
                  DOUTPADOUTP => data_out_a_h(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b_h(31 downto 0),
                  DOUTPBDOUTP => data_out_b_h(35 downto 32), 
                      DINBDIN => data_in_b_h(31 downto 0),
                    DINPBDINP => data_in_b_h(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_4k_generate;	              
  --
  --
  --
  --
  -- JTAG Loader
  --
  instantiate_loader : if (C_JTAG_LOADER_ENABLE = 1) generate
  --
    jtag_loader_6_inst : jtag_loader_6
    generic map(              C_FAMILY => C_FAMILY,
                       C_NUM_PICOBLAZE => 1,
                  C_JTAG_LOADER_ENABLE => C_JTAG_LOADER_ENABLE,
                 C_BRAM_MAX_ADDR_WIDTH => BRAM_ADDRESS_WIDTH,
	                  C_ADDR_WIDTH_0 => BRAM_ADDRESS_WIDTH)
    port map( picoblaze_reset => rdl_bus,
                      jtag_en => jtag_en,
                     jtag_din => jtag_din,
                    jtag_addr => jtag_addr(BRAM_ADDRESS_WIDTH-1 downto 0),
                     jtag_clk => jtag_clk,
                      jtag_we => jtag_we,
                  jtag_dout_0 => jtag_dout,
                  jtag_dout_1 => jtag_dout, -- ports 1-7 are not used
                  jtag_dout_2 => jtag_dout, -- in a 1 device debug 
                  jtag_dout_3 => jtag_dout, -- session.  However, Synplify
                  jtag_dout_4 => jtag_dout, -- etc require all ports to
                  jtag_dout_5 => jtag_dout, -- be connected
                  jtag_dout_6 => jtag_dout,
                  jtag_dout_7 => jtag_dout);
    --  
  end generate instantiate_loader;
  --
end low_level_definition;
--
--
-------------------------------------------------------------------------------------------
--
-- JTAG Loader 
--
-------------------------------------------------------------------------------------------
--
--
-- JTAG Loader 6 - Version 6.00
-- Kris Chaplin 4 February 2010
-- Ken Chapman 15 August 2011 - Revised coding style
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
library unisim;
use unisim.vcomponents.all;
--
entity jtag_loader_6 is
generic(              C_JTAG_LOADER_ENABLE : integer := 1;
                                  C_FAMILY : string := "7S";
                           C_NUM_PICOBLAZE : integer := 1;
                     C_BRAM_MAX_ADDR_WIDTH : integer := 10;
        C_PICOBLAZE_INSTRUCTION_DATA_WIDTH : integer := 18;
                              C_JTAG_CHAIN : integer := 2;
                            C_ADDR_WIDTH_0 : integer := 10;
                            C_ADDR_WIDTH_1 : integer := 10;
                            C_ADDR_WIDTH_2 : integer := 10;
                            C_ADDR_WIDTH_3 : integer := 10;
                            C_ADDR_WIDTH_4 : integer := 10;
                            C_ADDR_WIDTH_5 : integer := 10;
                            C_ADDR_WIDTH_6 : integer := 10;
                            C_ADDR_WIDTH_7 : integer := 10);
port(   picoblaze_reset : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                jtag_en : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
               jtag_din : out std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0) := (others => '0');
              jtag_addr : out std_logic_vector(C_BRAM_MAX_ADDR_WIDTH-1 downto 0) := (others => '0');
               jtag_clk : out std_logic := '0';
                jtag_we : out std_logic := '0';
            jtag_dout_0 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_1 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_2 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_3 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_4 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_5 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_6 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_7 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0));
end jtag_loader_6;
--
architecture Behavioral of jtag_loader_6 is
  --
  signal num_picoblaze       : std_logic_vector(2 downto 0);
  signal picoblaze_instruction_data_width : std_logic_vector(4 downto 0);
  --
  signal drck                : std_logic;
  signal shift_clk           : std_logic;
  signal shift_din           : std_logic;
  signal shift_dout          : std_logic;
  signal shift               : std_logic;
  signal capture             : std_logic;
  --
  signal control_reg_ce      : std_logic;
  signal bram_ce             : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
  signal bus_zero            : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
  signal jtag_en_int         : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
  signal jtag_en_expanded    : std_logic_vector(7 downto 0) := (others => '0');
  signal jtag_addr_int       : std_logic_vector(C_BRAM_MAX_ADDR_WIDTH-1 downto 0);
  signal jtag_din_int        : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal control_din         : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0):= (others => '0');
  signal control_dout        : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0):= (others => '0');
  signal control_dout_int    : std_logic_vector(7 downto 0):= (others => '0');
  signal bram_dout_int       : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0) := (others => '0');
  signal jtag_we_int         : std_logic;
  signal jtag_clk_int        : std_logic;
  signal bram_ce_valid       : std_logic;
  signal din_load            : std_logic;
  --
  signal jtag_dout_0_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_1_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_2_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_3_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_4_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_5_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_6_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_7_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal picoblaze_reset_int : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
  --        
begin
  bus_zero <= (others => '0');
  --
  jtag_loader_gen: if (C_JTAG_LOADER_ENABLE = 1) generate
    --
    -- Insert BSCAN primitive for target device architecture.
    --
    BSCAN_7SERIES_gen: if (C_FAMILY="7S") generate
    begin
      BSCAN_BLOCK_inst: BSCANE2
      generic map(    JTAG_CHAIN => C_JTAG_CHAIN,
                    DISABLE_JTAG => "FALSE")
      port map( CAPTURE => capture,
                   DRCK => drck,
                  RESET => open,
                RUNTEST => open,
                    SEL => bram_ce_valid,
                  SHIFT => shift,
                    TCK => open,
                    TDI => shift_din,
                    TMS => open,
                 UPDATE => jtag_clk_int,
                    TDO => shift_dout);
    end generate BSCAN_7SERIES_gen;   
    --
    BSCAN_UltraScale_gen: if (C_FAMILY="US") generate
    begin
      BSCAN_BLOCK_inst: BSCANE2
      generic map(    JTAG_CHAIN => C_JTAG_CHAIN,
                    DISABLE_JTAG => "FALSE")
      port map( CAPTURE => capture,
                   DRCK => drck,
                  RESET => open,
                RUNTEST => open,
                    SEL => bram_ce_valid,
                  SHIFT => shift,
                    TCK => open,
                    TDI => shift_din,
                    TMS => open,
                 UPDATE => jtag_clk_int,
                    TDO => shift_dout);
    end generate BSCAN_UltraScale_gen;   
    --
    --
    -- Insert clock buffer to ensure reliable shift operations.
    --
    upload_clock: BUFG
    port map( I => drck,
              O => shift_clk);
    --        
    --        
    --  Shift Register      
    --        
    --
    control_reg_ce_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk = '1' then
        if (shift = '1') then
          control_reg_ce <= shift_din;
        end if;
      end if;
    end process control_reg_ce_shift;
    --        
    bram_ce_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          if(C_NUM_PICOBLAZE > 1) then
            for i in 0 to C_NUM_PICOBLAZE-2 loop
              bram_ce(i+1) <= bram_ce(i);
            end loop;
          end if;
          bram_ce(0) <= control_reg_ce;
        end if;
      end if;
    end process bram_ce_shift;
    --        
    bram_we_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          jtag_we_int <= bram_ce(C_NUM_PICOBLAZE-1);
        end if;
      end if;
    end process bram_we_shift;
    --        
    bram_a_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          for i in 0 to C_BRAM_MAX_ADDR_WIDTH-2 loop
            jtag_addr_int(i+1) <= jtag_addr_int(i);
          end loop;
          jtag_addr_int(0) <= jtag_we_int;
        end if;
      end if;
    end process bram_a_shift;
    --        
    bram_d_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (din_load = '1') then
          jtag_din_int <= bram_dout_int;
         elsif (shift = '1') then
          for i in 0 to C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-2 loop
            jtag_din_int(i+1) <= jtag_din_int(i);
          end loop;
          jtag_din_int(0) <= jtag_addr_int(C_BRAM_MAX_ADDR_WIDTH-1);
        end if;
      end if;
    end process bram_d_shift;
    --
    shift_dout <= jtag_din_int(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1);
    --
    --
    din_load_select:process (bram_ce, din_load, capture, bus_zero, control_reg_ce) 
    begin
      if ( bram_ce = bus_zero ) then
        din_load <= capture and control_reg_ce;
       else
        din_load <= capture;
      end if;
    end process din_load_select;
    --
    --
    -- Control Registers 
    --
    num_picoblaze <= conv_std_logic_vector(C_NUM_PICOBLAZE-1,3);
    picoblaze_instruction_data_width <= conv_std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1,5);
    --	
    control_registers: process(jtag_clk_int) 
    begin
      if (jtag_clk_int'event and jtag_clk_int = '1') then
        if (bram_ce_valid = '1') and (jtag_we_int = '0') and (control_reg_ce = '1') then
          case (jtag_addr_int(3 downto 0)) is 
            when "0000" => -- 0 = version - returns (7 downto 4) illustrating number of PB
                           --               and (3 downto 0) picoblaze instruction data width
                           control_dout_int <= num_picoblaze & picoblaze_instruction_data_width;
            when "0001" => -- 1 = PicoBlaze 0 reset / status
                           if (C_NUM_PICOBLAZE >= 1) then 
                            control_dout_int <= picoblaze_reset_int(0) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_0-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0010" => -- 2 = PicoBlaze 1 reset / status
                           if (C_NUM_PICOBLAZE >= 2) then 
                             control_dout_int <= picoblaze_reset_int(1) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_1-1,5) );
                            else 
                             control_dout_int <= (others => '0');
                           end if;
            when "0011" => -- 3 = PicoBlaze 2 reset / status
                           if (C_NUM_PICOBLAZE >= 3) then 
                            control_dout_int <= picoblaze_reset_int(2) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_2-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0100" => -- 4 = PicoBlaze 3 reset / status
                           if (C_NUM_PICOBLAZE >= 4) then 
                            control_dout_int <= picoblaze_reset_int(3) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_3-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0101" => -- 5 = PicoBlaze 4 reset / status
                           if (C_NUM_PICOBLAZE >= 5) then 
                            control_dout_int <= picoblaze_reset_int(4) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_4-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0110" => -- 6 = PicoBlaze 5 reset / status
                           if (C_NUM_PICOBLAZE >= 6) then 
                            control_dout_int <= picoblaze_reset_int(5) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_5-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0111" => -- 7 = PicoBlaze 6 reset / status
                           if (C_NUM_PICOBLAZE >= 7) then 
                            control_dout_int <= picoblaze_reset_int(6) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_6-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "1000" => -- 8 = PicoBlaze 7 reset / status
                           if (C_NUM_PICOBLAZE >= 8) then 
                            control_dout_int <= picoblaze_reset_int(7) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_7-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "1111" => control_dout_int <= conv_std_logic_vector(C_BRAM_MAX_ADDR_WIDTH -1,8);
            when others => control_dout_int <= (others => '1');
          end case;
        else 
          control_dout_int <= (others => '0');
        end if;
      end if;
    end process control_registers;
    -- 
    control_dout(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-8) <= control_dout_int;
    --
    pb_reset: process(jtag_clk_int) 
    begin
      if (jtag_clk_int'event and jtag_clk_int = '1') then
        if (bram_ce_valid = '1') and (jtag_we_int = '1') and (control_reg_ce = '1') then
          picoblaze_reset_int(C_NUM_PICOBLAZE-1 downto 0) <= control_din(C_NUM_PICOBLAZE-1 downto 0);
        end if;
      end if;
    end process pb_reset;    
    --
    --
    -- Assignments 
    --
    control_dout (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-9 downto 0) <= (others => '0') when (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH > 8);
    --
    -- Qualify the blockram CS signal with bscan select output
    jtag_en_int <= bram_ce when bram_ce_valid = '1' else (others => '0');
    --      
    jtag_en_expanded(C_NUM_PICOBLAZE-1 downto 0) <= jtag_en_int;
    jtag_en_expanded(7 downto C_NUM_PICOBLAZE) <= (others => '0') when (C_NUM_PICOBLAZE < 8);
    --        
    bram_dout_int <= control_dout or jtag_dout_0_masked or jtag_dout_1_masked or jtag_dout_2_masked or jtag_dout_3_masked or jtag_dout_4_masked or jtag_dout_5_masked or jtag_dout_6_masked or jtag_dout_7_masked;
    --
    control_din <= jtag_din_int;
    --        
    jtag_dout_0_masked <= jtag_dout_0 when jtag_en_expanded(0) = '1' else (others => '0');
    jtag_dout_1_masked <= jtag_dout_1 when jtag_en_expanded(1) = '1' else (others => '0');
    jtag_dout_2_masked <= jtag_dout_2 when jtag_en_expanded(2) = '1' else (others => '0');
    jtag_dout_3_masked <= jtag_dout_3 when jtag_en_expanded(3) = '1' else (others => '0');
    jtag_dout_4_masked <= jtag_dout_4 when jtag_en_expanded(4) = '1' else (others => '0');
    jtag_dout_5_masked <= jtag_dout_5 when jtag_en_expanded(5) = '1' else (others => '0');
    jtag_dout_6_masked <= jtag_dout_6 when jtag_en_expanded(6) = '1' else (others => '0');
    jtag_dout_7_masked <= jtag_dout_7 when jtag_en_expanded(7) = '1' else (others => '0');
    --
    jtag_en <= jtag_en_int;
    jtag_din <= jtag_din_int;
    jtag_addr <= jtag_addr_int;
    jtag_clk <= jtag_clk_int;
    jtag_we <= jtag_we_int;
    picoblaze_reset <= picoblaze_reset_int;
    --        
  end generate jtag_loader_gen;
--
end Behavioral;
--
--
------------------------------------------------------------------------------------
--
-- END OF FILE auto_baud_rate_control.vhd
--
------------------------------------------------------------------------------------
