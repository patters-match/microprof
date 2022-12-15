# MicroProfanation by IvanBasic
# 
# for 48K Issue 3 ZX Spectrum
# unpicked and commented for zmakebas by patters
#
# https://spectrumcomputing.co.uk/forums/viewtopic.php?t=8372
#
#
goto @initialise
@mainloop:
#                                                          --- player ---
#                                                          position: y,x
#                                                          inline attributes are much faster to render
#                                                          delete the player character at its previous position
#                                                          and print the player character, appropriate direction and animation cycle
        print at v,u;"\{16}\{0} \{16}\{7}" and attr (y,x)<>3;\
              at y,x; ink 3;"\e\f\c\d"(f+s);
#                                                          v & u will be used to store the previous y & x position
        let v=y
        let u=x
#                                                          --- drip ---
#                                                          position c,d
#                                                          e will be used to store the previous c vertical position 
        let e=c
#                                                          drip falls one row
        let c=c+1
#                                                          does it collide with anything?
#                                                          if so, draw the splash and play sound, reset the drip
#                                                          and if tested position was magenta then player died
        let t=attr (c,d)
        if t then \
            print at e,d;"\{19}\{1}\{16}\{4}\q" and e-1: \
            let c=1: \
            beep .003,h: \
            if t=3 then \
                goto @loselife
#                                                          delete the last drip and print the new drip
        print at e,d;"\{16}\{0} \{16}\{4}" and e>1;\
                at c,d;"\{16}\{4}\{19}\{1}\k" and c>1;
#                                                          --- snake ---
#                                                          position: g,h
#                                                          i will be used to store the previous h horizontal position 
        let i=h
#                                                          snake attempts move by horizontal increment l
        let h=h+l
#                                                          does it collide with anything?
        let t=attr (g,h)
#                                                          increment animation cycle
        let m=not m
#                                                          if it collides, maintain horizontal position, change direction animation frame and horizontal increment direction
#                                                          and if tested position was magenta then player died
        if t then \
            let h=i: \
            let l=-l: \
            let k=4-k: \
            if t=3 then \
                goto @loselife
#                                                          delete the snake at its previous position
#                                                          and print the snake, appropriate direction and animation cycle
        print at g,i;"\{16}\{0} \{16}\{7}";\
                at g,h; bright 1;"\i\j\g\h"(m+k);
#                                                          --- keyboard input ---
#                                                          incompatible with Issue 2 Spectrums
#
#                                                          is a key in half-row CAPS SHIFT to V being pressed? (a jump)
#                                                          is the player on a floor? (non-bright attribute - hazards are bright)
#                                                          j is jump size (1 for x,c,v - 2 for Caps Shift, z)
        if in 65278<191 then \
            let t=attr (y+1,x): \
            if t then \
                if t<64 then \
                    let j=1+(in 65278>187)
#                                                          player moves left (O)
#                                                          set player appropriate direction and animation cycle
#                                                          check whether encountered a hazard (BRIGHT 1), or
#                                                              a teleport (BRIGHT 1, PAPER > 0, INK > 5) / exited screen (FLASH 1)
        let f=f and inkey$<>""
        if in 57342=189 then \
            let s=3: \
            let f=not f: \
            let x=x-1: \
            let t=attr (y,x): \
            if t then \
                let x=u: \
                if t>64 then \
                    goto @loselife + (( @changescreen - @loselife ) and t>78)
#                                                          player moves right (P)
#                                                          set player appropriate direction and animation cycle
#                                                          check whether encountered a hazard (BRIGHT 1), or
#                                                              a teleport (BRIGHT 1, PAPER > 0, INK > 5) / exited screen (FLASH 1)
        if in 57342=190 then \
            let s=1: \
            let f=not f: \
            let x=x+1: \
            let t=attr (y,x): \
            if t then \
                let x=u: \
                if t>64 then \
                    goto @loselife + (( @changescreen - @loselife ) and t>78)
#                                                          player falls unless jumping
#                                                          check new position, if attribute is not black then stop falling
#                                                          check whether encountered a hazard (BRIGHT 1), or
#                                                              a teleport (BRIGHT 1, PAPER > 0, INK > 5) / exited screen (FLASH 1)
        let y=y+1-(2 and j>0)
        let j=j-1
        let t=attr (y,x)
        if t then \
            let y=v: \
            if t>64 then \
                let x=u: \
                    goto @loselife + (( @changescreen - @loselife ) and t>78)
#
        goto @mainloop
#
@loselife:
        let t=22528+32*y+x
#                                                          paint player bright white
        poke t,71
        border 7
#                                                          splat sound
        beep .02,-8
        beep .01,-4
        beep .005,0
        beep .005,0
        border 0
#                                                          end jump
        let j=0
#                                                          revert x and y to player start coords for the current screen
        let y=q
        let x=r
#                                                          decrement lives counter and update on screen
        let o=o-1
        print at 10,24; ink 7;o
#                                                          delete player (paint black) at current position
        poke t,0
#                                                          paint the former position of the drip yellow if it was at the top-most position (?)
        poke 22528+32*e+d,6 and e=1
#                                                          delete player (paint black) at former position
        poke 22528+v*32+u,0
        goto @newgame - (( @newgame - @mainloop ) and o)
#
@changescreen:
#                                                          --- normal exit case ---
#                                                          level selection based on which side of the screen the player exited
#                                                          level array is 6 columns x 10 rows deep
        let t=(1 and x>23)-(1 and x<8)+(6 and y>7)-(6 and y<2)
        let p=p+t
#                                                          update player y coord for new screen
        let y=(y and abs t<>6)+(1 and t=6)+(8 and t=-6)
#                                                          reset high jump if player exited screen left
        let j=2 and t=-6
#                                                          update player x coord for new screen
        let x=(x and abs t<>1)+(24 and t=-1)+(7 and t=1)
#                                                          reset previous u and v (previous x and y are no longer relevant now we have changed screen)
        let u=x
        let v=y
#                                                          set player start coords for this screen
        let r=x
        let q=y
#                                                          --- teleport exit case ---
#                                                          notice that the game completion logic can only be triggered via a teleport
#                                                          each screen has 7 teleport bytes in the 5(REEN5 binary data (420 bytes from 64765)
#                                                          stored as:
#                                                            - teleport y coord
#                                                            - teleport x coord
#                                                            - teleport chr$
#                                                            - teleport attr
#                                                            - destination screen number
#                                                            - destination player y coord
#                                                            - destination player x coord
#                                                          read destination level, and new player x and y coords from the 5(REEN5 binary data
#                                                          if player reaches screen 61 the game ends, displaying percentage of rooms explored
        if not t then \
            border 1: \
            let t=64762+7*p: \
            let p=peek t: \
            let y=peek (t+1): \
            let x=peek (t+2): \
            let u=x: \
            let v=y: \
            let r=x: \
            let q=y: \
            border 0: \
            beep .01,20: \
            beep .01,10: \
            if p>60 then \
                print at 3,10; paper 4;tab 22;at 4,10;" W3|| DoN3! ";\
                      at 5,10;"     ";int (5*w/3);"%";tab 22;\
                      at 6,10;"  3XP|o\o3D  ";\
                      at 7,10;tab 22: \
                for p=1 to 1000: \
                next p: \
                goto @newgame
#
@drawscreen:
        beep .01,-10
        beep .01,30
#                                                          reset drip and snake hazards
        let e=1
        let k=1
        let l=1
        let c=1
#                                                          for the starting screen, p=6
#                                                          retrieve snake x coord for this screen from the 5(REEN5 binary data (60 bytes from 65245)
        let h=peek (65245+p)
#                                                          reset former position of snake
        let i=h
#                                                          retrieve drip x coord for this screen from the 5(REEN5 binary data (60 bytes from 65185)
        let d=peek (65185+p)
#                                                          d=16
#                                                          level map, each character encodes a screen
#                                                          print the selected character with INK 0 so it remains hidden
        print at 21,0;"R\'.\mbJ\' \l\: \n&f\c4N""=w\''\..Bv0\i\oK.XC!`pd\s9*}\eMV3\\^$D\tsmt\ukzL7{Ay\g%\@g"(p)
        let b$=""
        for b=1 to 6
            for a=1 to 6
#                                                          test 6 x 6 pixels in the hidden character and use this to retrieve the matching block data strings with
#                                                            inline formatting from the multidimensional B|O(K5 string array p$ (6 x 6 x 23 length)
                let b$=b$+(p$(b,a) and point (b,a))
            next a
        next b
#                                                          set the LPRINT buffer position to 22535 (screen attribute memory)
        poke 23681,88
        poke 23680,7
#                                                          print 18 x 8 vertical columns, one row per byte of this string, of attribute 0
#                                                          (INK 0; PAPER 0; BRIGHT 0; FLASH 0)
        lprint "                  "
#                                                          add an extra row underneath, and FLASH the row which will be above the top row of bricks
        print at 8,7,,\
              at 0,7; flash 1,,
#                                                          increment the screens visited counter (w) if this screen has not yet been seen
        let w=w+peek (65306+p)
#                                                          record this screen as visited
        poke 65306+p,0
#                                                          print the screens visited counter, and print the standard screen top and bottom rows of bricks,
#                                                            appending the level-specific block data (b$)
        print ink 7;at 10,15;w;" ";\
                    at 1,7;"\{16}\{6}\b\s\a\{16}\{0}  \{16}\{6}\a\a\t\s\b\a\b\{16}\{0}  \{16}\{6}\b\a\a\b";\
                    at 8,7;"\a\a\b\{16}\{0}  \{16}\{6}\t\b\s\b\s\b\a\{16}\{0}  \{16}\{6}\b\b\b\a";b$
#                                                          each screen has 7 teleport bytes in the 5(REEN5 binary data (420 bytes from 64765)
#                                                          stored as:
#                                                            - teleport y coord
#                                                            - teleport x coord
#                                                            - teleport chr$
#                                                            - teleport attr
#                                                            - destination screen number
#                                                            - destination player y coord
#                                                            - destination player x coord
#                                                          fetch the teleport object data, e.g. t=64800 for the first screen (screen 6)
        let t=64758+7*p
        print at peek t,peek (t+1);chr$ peek (t+2)
#                                                          poke the attribute data directly to the display memory
        poke 22528+32*peek t+peek (t+1),peek (t+3)
        goto @mainloop
#
@newgame:
        restore @newgame
#                                                          INK 0; PAPER 0; BRIGHT 0; FLASH 1
        poke 23693,128
        cls
#                                                          whole screen is now FLASH 1, though black on black
#                                                          write 61 bytes of value 1, will track which screens have been visited
        for p=65307 to 65367
            poke p,1
        next p
#                                                          INK 0; PAPER 0; BRIGHT 0; FLASH 0
        poke 23693,0
        print at 10,7;"\{16}\{4}Screens-\{16}\{7}0  \{16}\{5}Lives-\{16}\{7}9";\
              at 12,7;"Mi\{16}\{4}<ProfanatioN>\{20}\{0}\{16}\{7}crO\{16}\{7}"
        read y,x,t,c,d,g,h,i,e,f,s,u,v,j,m,l,k,q,r,o,p,w
        goto @drawscreen
        data 7,22,0,2,13,7,9,21,0,0,3,x,y,0,1,1,1,y,x,9,6,0
#
@initialise:
#                                                          INK 7; PAPER 0; BRIGHT 0; FLASH 0
        poke 23693,7
        inverse 0
        over 0
#                                                          point UDG sysvar UInt16 to 65368 (this is the default for a 48K)
#        poke 23675,88
#        poke 23676,255
        border 0
        clear 64764
        print ink 6;''"     ""...ON|Y 7HO5E WHO"'\
                      "         7RU57 7HE 5N4KE5"'\
                      "         WI|| `|ND"'\
                      "         7H3|R W4Y OU7..."""'''
        dim p$(6,6,23)
#                                                          load binary data
#                                                          B|O(K5 (837 bytes)
        load "" data p$()
#                                                          5(REEN5 (542 bytes)
        load ""code 64765
#                                                          5PR|7E5 (170 bytes)
        load ""code usr "a"
        pause 100
        goto @newgame
