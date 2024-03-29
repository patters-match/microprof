# MicroProfanation - a commented source

A BASIC programming competition-winning game for the ZX Spectrum, by [IvanBasic](https://spectrumcomputing.co.uk/list?label_id=16585).

![MicroProfanation Screenshots](images/microprofanation.png "MicroProfanation Screenshots")

The game tape image can be downloaded [here](https://spectrumcomputing.co.uk/zxdb/add/public/uploads/38861_48_en.tap) at Spectrum Computing, and will soon be included in ZXDB.

This is a micro platform game with animated hazards and [an extensive map](https://maps.speccy.cz/map.php?id=MicroProfanation&sort=4&part=13&ath=0) which runs at a decent playable speed, not typically possible using Sinclair BASIC. It's micro-scale in terms of its presentation (single characters) but also its codebase which, in its original form, is crammed into a mere 12 lines. It's a hommage to the 1985 Dinamic pyramid-explorer [Abu Simbel Profanation](https://spectrumcomputing.co.uk/entry/48/ZX-Spectrum/Abu_Simbel_Profanation). MicroProfanation won the BASIC category of Argentinian computer museum Espacio Tec's [Retrogame Dev competition 2022](https://twitter.com/tbrazil_speccy?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1589174459692650498%7Ctwgr%5E%7Ctwcon%5Es2_&ref_url=).

Each of IvanBasic's previous games sidesteps the conventional limitations of the BASIC language, with outstanding results:
- [Rompetechos](https://spectrumcomputing.co.uk/entry/30322/ZX-Spectrum/Rompetechos) - a large adventure game with great cartoon graphics and responsive controls
- [Brain 8](https://spectrumcomputing.co.uk/entry/34781/ZX-Spectrum/Brain_8) - scrolls and animates a full screen of ROM-generated graphics at speed
- [Aznar The Sport Star](https://spectrumcomputing.co.uk/entry/35104/ZX-Spectrum/Aznar_The_Sport_Star) - sports game with very responsive controls
- [Pedro Pomez](https://spectrumcomputing.co.uk/entry/35343/ZX-Spectrum/Pedro_Pomez) - a platform game with a [vast colourful map](https://maps.speccy.cz/map.php?id=PedroPomez&sort=4&part=16&ath=0)
- [Micro Gauntlet](https://bunsen.itch.io/micro-gauntlet-by-ivanbasic) - a 10-line micro game which perfectly captures the spirit of the original
- [STOP THE micro EXPRESS](https://bunsen.itch.io/stop-the-micro-express-by-ivanbasic) - another distillation of a classic title, but even more technically ambitious

These games are eye-opening as to what can be achieved with the humble ZX Spectrum's native BASIC interpreter, and picking them apart to understand them is always interesting. This particular listing uses an ingenious method of encoding its levels using the bitmap data in regular characters to select combinations of level-building primitives. The primitives are stored in a multidimensional string array containing inline positioning and formatting escape sequences.

Unfortunately optimised Sinclair BASIC listings tend to use techniques which improve performance at the significant expense of comprehension: single letter variable names, huge long lines, a confusing structure to keep critical loops at the top, no comments, inline attribute changes, character set redirection, etc.

However it is possible to put the code into a modern editor and to use [zmakebas](https://github.com/ohnosec/zmakebas) to build it into a ```.tap``` file. This permits teasing the listing apart, indenting and line-wrapping for clarity, commenting it in a way that won't slow down execution, and using more intuitive labels rather than line numbers. That is what I have done here.

Furthermore I have updated my own [Sublime syntax highlighter for ZX BASIC](https://github.com/patters-syno/zx-basic-syntax) to highlight zmakebas listings, as shown in the above right image.

## Source files
- **[microprof.bas](https://github.com/patters-syno/profanation/blob/main/microprof.bas)** will build to functionally the same 12-line Spectrum listing as the [original release](https://spectrumcomputing.co.uk/zxdb/add/public/uploads/38861_48_en.tap)

- **[microprof_annotated.bas](https://github.com/patters-syno/profanation/blob/main/microprof_annotated.bas)** is the same file as above but with all statements separated into their own lines where possible to allow descriptive comments. zmakebas does not permit comments in between line-wrapped code. These comments do not end up in the Spectrum listing. As a result of splitting out the lines this build may run very slightly slower, but I cannot objectively notice any difference when play testing.

- **data.bin.tap** is the binary data for the screen building blocks, each game screen's metadata, and the user-defined graphics, in ```.tap``` format ready to be concatenated with the built BASIC binary. If this was strictly a 1980s magazine type-in this data ought to be part of the listing, but it would just slow things down a lot doing an initial READ from DATA statements, so I didn't convert it.

## Building

These files can be assembled back into the game ```.tap``` file using [zmakebas](https://github.com/ohnosec/zmakebas).

  ```bash
  zmakebas -n MicroProfa -o program.tap -l -i 10 -a @initialise microprof.bas
  
  # Now merge the binary data tape blocks
  
  # macOS / Linux
  cat program.tap data.bin.tap > MicroProfanation.tap
  
  # Windows
  copy /b program.tap+data.bin.tap MicroProfanation.tap
  ```
  
