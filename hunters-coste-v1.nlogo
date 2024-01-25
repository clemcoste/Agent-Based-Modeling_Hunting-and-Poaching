; Boar, protected species (wolves), hunters, gatekeepers and poachers are breeds of turtles
breed [ boars boar ]
breed [ hunters hunter ]
breed [ wolves wolf ]
breed [ poachers poacher ]
breed [ gatekeepers gatekeeper ]
patches-own [trap?]

; Define some variable for boars and wolves
boars-own [gender age b_gestation carrying? b_longevity]
wolves-own [gender age w_gestation carrying? w_longevity]

to setup
  clear-all

  ask patches [ set pcolor lime - 3 ] ; set default background color

  create-hunters initial-hunters ; initialize hunters
  [set shape  "hunter"
    ;set size 1.5
    set color white
    setxy random-xcor random-ycor]

  create-boars initial-boars ; initialize boars
    [set shape "boar"
     set color black
     setxy random-xcor random-ycor
     ifelse (random 100 < 50)
    [set gender "M"]
    [set gender "F"]
    set carrying? false
    set b_gestation 0
    set age random mean-b_longevity
    set b_longevity mean-b_longevity
    ]

  if enable-poaching [ ; initialize wolves, poachers and gatekeepers if variation 2 is activated
    create-wolves initial-wolves
    [set shape "wolf"
      set color black
      setxy random-xcor random-ycor
      ifelse (random 100 < 50)
    [set gender "M"]
    [set gender "F"]
    set carrying? false
    set w_gestation 0
    set age random mean-w_longevity
    set w_longevity mean-w_longevity
    ]

    create-poachers initial-poachers
  [set shape  "poacher"
    ;set size 1.5
    ;set color red
    setxy random-xcor random-ycor]

    create-gatekeepers initial-gatekeepers
  [set shape  "person police"
    ;set size 1.5
    ;set color white
    setxy random-xcor random-ycor]

  ]
  reset-ticks
  ;display-labels
end

to go

  ifelse (enable-poaching and not any? wolves) ; stop if boars population is going to high or if there is no more wolves or boars
  [ stop ]
  [if (not any? boars) or count boars > 800 [ stop ]]

  ask hunters [move shot-hunters]
  ask boars [move
    check-if-dead-b
    reproduce-boars-males
    reproduce-boars-females
  ]
  if enable-poaching [
    ask wolves [move check-if-dead-w reproduce-wolves-males reproduce-wolves-females]
    ask poachers [move shot-poachers put-trap]
    ask gatekeepers [move arrest-poachers]
  ]
  update-patches
  tick
  ;display-labels
end

to move  ; turtle procedure
  rt random 50
  lt random 50
  fd 1
end

to shot-hunters ; hunters are shooting boars with a certain accuracy
  let found-boar one-of boars-here
  if (found-boar != nobody)  [
    if (random 100 < shot-accuracy)[
      ask found-boar [ die ]
    ]
  ]
end

to shot-poachers ; priority to kill wolves with a certain accuracy
  let found-wolf one-of wolves-here
  ifelse (found-wolf != nobody) [if (random 100 < shot-accuracy)[ask found-wolf [ die ]]]
  [let found-boar one-of boars-here if (found-boar != nobody)  [if (random 100 < shot-accuracy)[ask found-boar [ die ]]]]
end

to put-trap ; poachers are putting some traps on their walk
  if (random 100 < ratio-trap)
  [
    set trap? true
    ask patch-here [set pcolor red]
  ]
end

to arrest-poachers ; if gatekeeper encounters a poacher, he arrests him
  let found-poacher one-of poachers-here
  if (found-poacher != nobody) [ask found-poacher [ die ]]
end

to reproduce-boars-males ; if encounter a female not carrying, then we apply the reproduction rate and the female is carrying or not depending to this
  if (count boars in-radius 1 with [not carrying? and gender = "F"]) = 1
  and (count other boars in-radius 1 with [gender = "M"]) = 0
  and (random 100 < boar-reproduction-rate) [ ;start b_gestation
    ask one-of boars in-radius 1 with [not carrying? and gender = "F"]
    [set carrying? true]
  ]
end

to reproduce-wolves-males ; if encounter a female not carrying, then we apply the reproduction rate and the female is carrying or not depending to this
  if (count wolves in-radius 1 with [not carrying? and gender = "F"]) = 1
  and (count other wolves in-radius 1 with [gender = "M"]) = 0
  and (random 100 < wolf-reproduction-rate) [ ;start w_gestation
    ask one-of wolves in-radius 1 with [not carrying? and gender = "F"]
    [set carrying? true]
  ]
end

to reproduce-boars-females ; if carrying and end of gestation, get birth and reset the gestation, else if carrying, then increment the gestation
  if carrying? and b_gestation = b_gestation-period [
      set b_gestation 0
      set carrying? false
      hatch 1 [
        rt random-float 360
        fd 1
        set age 0
        ;set color orange
        ifelse (random 100 < 50)
        [set gender "M"]
        [set gender "F"]
      ]
  ] ; end get birth
  if carrying?
  [set b_gestation b_gestation + 1]
end

to reproduce-wolves-females ; if carrying and end of gestation, get birth and reset the gestation, else if carrying, then increment the gestation
  if carrying? and w_gestation = w_gestation-period
   [
      set w_gestation 0
      set carrying? false
      hatch 1 [
        rt random-float 360
        fd 1
        set age 0
        ;set color orange
        ifelse (random 100 < 50)
        [set gender "M"]
        [set gender "F"]
      ]
  ] ; end get birth
  if carrying?
  [set w_gestation w_gestation + 1]
end

to check-if-dead-b ; die if too old
  ifelse age > b_longevity [
    die
  ][
    set age age + 1
  ]
end

to check-if-dead-w ; die if too old
  ifelse age > w_longevity [
    die
  ][
    set age age + 1
  ]
end

to update-patches ; interaction between agents and patches
  ask patches with [pcolor = red]
    [
      ask gatekeepers-here [
        set pcolor lime - 3
      ]
      ask hunters-here [
        set pcolor lime - 3
      ]
      ask wolves-here [
        set pcolor lime - 3
        die
      ]
      ask boars-here [
        ;set pcolor lime - 3
        ;die
      ]
    ]
end

;to display-labels
;  ask boars [ set label "" ]
;  ask boars [ set label gender ]
;end

; Copyright 2024 Clément COSTE.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
29
16
92
49
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
101
15
164
48
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
10
80
184
113
initial-hunters
initial-hunters
0
30
7.0
1
1
 hunters
HORIZONTAL

SLIDER
11
119
183
152
initial-boars
initial-boars
0
400
400.0
5
1
boars
HORIZONTAL

SLIDER
8
374
180
407
initial-wolves
initial-wolves
0
400
40.0
1
1
wolves
HORIZONTAL

SWITCH
20
338
167
371
enable-poaching
enable-poaching
1
1
-1000

SLIDER
9
414
189
447
initial-poachers
initial-poachers
0
20
1.0
1
1
poachers
HORIZONTAL

SWITCH
282
484
423
517
enable-damage
enable-damage
1
1
-1000

MONITOR
424
484
513
529
NIL
damage costs
17
1
11

SLIDER
10
451
227
484
initial-gatekeepers
initial-gatekeepers
0
20
1.0
1
1
gatekeepers
HORIZONTAL

SLIDER
13
186
185
219
shot-accuracy
shot-accuracy
0
100
70.0
10
1
%
HORIZONTAL

PLOT
664
15
932
165
Boars population
time
population
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"boars" 1.0 0 -16777216 true "" "plot (count boars)"

SLIDER
11
492
203
525
wolf-reproduction-rate
wolf-reproduction-rate
0
100
12.0
1
1
%
HORIZONTAL

MONITOR
931
62
1026
107
female_wolves
count wolves with [gender = \"F\"]
17
1
11

SLIDER
12
219
206
252
boar-reproduction-rate
boar-reproduction-rate
0
100
29.0
1
1
%
HORIZONTAL

SLIDER
15
252
187
285
b_gestation-period
b_gestation-period
0
100
30.0
1
1
NIL
HORIZONTAL

MONITOR
932
16
1020
61
female_boars
count boars with [gender = \"F\"]
17
1
11

MONITOR
1019
16
1096
61
male_boars
count boars with [gender = \"M\"]
17
1
11

SLIDER
13
152
185
185
mean-b_longevity
mean-b_longevity
0
200
100.0
1
1
NIL
HORIZONTAL

SLIDER
13
528
185
561
mean-w_longevity
mean-w_longevity
0
200
130.0
5
1
NIL
HORIZONTAL

SLIDER
14
564
186
597
w_gestation-period
w_gestation-period
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
15
600
187
633
ratio-trap
ratio-trap
0
100
8.0
1
1
%
HORIZONTAL

MONITOR
1013
61
1096
106
male_wolves
count wolves with [gender = \"M\"]
17
1
11

MONITOR
931
108
1032
153
active poachers
count poachers
17
1
11

PLOT
664
281
933
401
Poachers
Time
Number
0.0
5.0
0.0
5.0
true
false
"" ""
PENS
"poachers" 1.0 0 -16777216 true "" "plot (count poachers)"

PLOT
664
401
933
521
Traps
Time
Number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"traps" 1.0 0 -16777216 true "" "plot count patches with [ pcolor = red ]"

TEXTBOX
277
460
493
488
EXTENDING THE MODEL (to be implemented)
11
0.0
1

TEXTBOX
54
55
204
74
VARIATION 1
15
0.0
1

TEXTBOX
49
302
199
321
VARIATION 2
15
0.0
1

PLOT
665
165
933
285
Wolves population
Time
Population
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot (count wolves)"

MONITOR
934
154
1013
199
active traps
count patches with [ pcolor = red ]
17
1
11

@#$#@#$#@
## WHAT IS IT?

The model is about hunting, poaching and species reproduction. It tends to show the impact of hunting and/or poaching on two kind of species : one consider as pest and very invasive (boars) and one which is protected (wolves).

## CONTEXT

**VARIATION 1 :** "Boars are the most prolific large mammal in North America, which presents many challenges for eradication efforts. An estimated 75% of a population must be removed to maintain the same number of individuals from one year to the next. Most often, wild hogs breed once or twice per year in favorable conditions. Compared to other large mammals, wild hogs have a very short gestation period of about 114 days. Sows are sexually mature at 6-8 months of age and average 4-6 piglets per litter." Link : https://www.mdwfp.com/wildlife-hunting/wild-hog-program/about-wild-hogs/breeding-and-social-behavior/

**VARIATION 2 :** "The reintroduced red wolf (Canis rufus) population in northeastern North Carolina declined to 7 known wolves by October 2020, the majority of which is due to poaching (illegal killing), the major component of verified anthropogenic mortality in this and many other carnivore populations. Poaching is still not well understood and is often underestimated, partly as a result of cryptic poaching, when poachers conceal evidence." Link : https://dx.plos.org/10.1371/journal.pone.0244261

## HOW IT WORKS

There are two main variations to this model.

**VARIATION 1 :** Consider only boars and hunters. Hunters (in green) will walk into the map, and if he encounters a boar, it will shoot with an accuracy which is a variable.
The boars are governed by several settings about their life duration, gestation period and reproduction rate.
The aim is to play with the different settings, and see how the hunters are regulating the boars population, which have a very high reproduction rate : without hunters, the boars population grows exponentialy. With several hunters, the population is regulated, and tends to augment but more smoothly, which is the case in the real life.

**VARIATION 2 :** Wolves are introduced. The population is very low, and they have a reproduction cycle and rate way less important than the boars.
In this variation, we take into consideration the poaching : poachers are going to put some traps on their walk (red patches), and tends to have the same shot accuracy than the hunters. The poachers will shot the animal present on their patches, with a preference for wolves as it is protected and it worth more money. Traps will catch only wolves are they are dedicated to them.
In order to apply the law, some gatekeepers are here in order to catch the poachers and remove the traps.
In the same way, the hunters will also remove the traps, as they do not endorse this practice.

## HOW TO USE IT

The interface is splitted into plots, monitors, switches, slides, buttons and a display.
The display will show :
- hunters (green turtle)
- boars
- wolves
- poachers (orange turtle)
- gatekeepers (blue turtle)
- traps (red patches)

1) By default, the first variation with hunters only is activated.
To activate the second variation which considers poaching, please activate the switch called "enable-poaching".
2) Adjust the slider parameters (see below), or use the default settings.
3) Press the SETUP button to set the scenario, and the GO button to launch the simulation
4) Monitors and Plots are available to display the different population available.

_**Parameters variation 1:**_
**INITIAL-HUNTERS:** The initial number of hunters [default : 7]
**INITIAL-BOARS:** The initial number of boars [default : 400]
**MEAN-B_LONGEVITY:** Set the age longevity for a boar. After that age, the boar will die. [default : 100]
**SHOT-ACCURACY:** The shot precision for hunters (and poachers in variation 2) [default : 70]
**BOAR-REPRODUCTION-RATE:** The probability of a boar reproducing each time a Male encounters a Female which is not already carrying [default : 29]
**B_GESTATION-PERIOD:** Period during which a female boar carries before giving birth [default : 30]

_**Parameters variation 2:**_
**INITIAL-WOLVES:** The initial number of wolves [default : 40]
**INITIAL-POACHERS:** The initial number of poachers [default : 1]
**INITIAL-GATEKEEPERS:** The initial number of gatekeepers [default : 1]
**WOLF-REPRODUCTION-RATE:** The probability of a wolf reproducing each time a Male encounters a Female which is not already carrying [default : 12]
**MEAN-W_LONGEVITY:** Set the age longevity for a wolf. After that age, the wolf will die. [default : 130]
**W_GESTATION-PERIOD:** Period during which a female wolf carries before giving birth [default : 40]
**RATIO-TRAP:** Ratio of traps put by poachers on their walk [default : 8]



## THINGS TO NOTICE

When running the variation 1, we observe that the number of boars depends on the number of hunters on site. Without hunters, the number of boars is evoluting exponentially. With some hunters, the boar population fluctuates but the main trend is to increase. But is there a critical number of hunters which will tends to eliminate all the boars, even if they have a high reproduction rate ? What happens if there is no hunters ?

When running the variation 2, we observe that the presence of poachers affect both boars and wolves population. Nevertheless, due to the fact that they have a lower reproduction rate than the boars, that they are a lower population and that poachers are targeting them especially, they have a high risk of extinction. But can we increase the number of gatekeepers in order to stop it ? Even without poachers, are the wolves in danger ?

**Notes:**
* For simplicity purpose :
	- We assume that a gestation will lead to only one child
	- We do not impose an age in order for a female to be able to carry a baby
	- We assume that at the beginning, no animal is already carrying, which affects the first ticks of the simulation (around 200 ticks)
* All agents are moving randomly on the map
* Traps are dedicated to wolves
* Males have gestation and carrying parameters but we never use them, and we bring some checks in the code in order to avoid them in reproduction procedures
* The number of hunters, and gatekeepers are fixed during the simulation, according to the initial setting
* There is no interaction between :
	- boars and [ wolves, gatekeepers ]
	- hunters and [ poachers, gatekeepers, wolves ]

## THINGS TO TRY

**Variation 1 :**
- At first, you can launch the variation 1 scenario with default settings. You will observe that the boar population is going to be more or less stable, and then increase more and more, which is similar to what happens in real life (boar is a very invasive species).
- Then, try to reduce the number of hunters, or even put it at 0 : you will observe how the hunters are regulating the boar population, and why they are important to regulate invasive species.
If you want to go further : Try to adjust the settings, especially the gestation, mean longevity and the reproduction rate for boars. 
Try to play with boars reproduction variable : what happen if the gestation is too long, even if the reproduction rate is high ?

Ex to reach a population of 800 boars with default settings : 7 hunters => 3179 ticks / 0 hunters => 351 ticks

**Variation 2 :**
- First, try to set the initial-poachers to 0 in order to see how the wolves population is evoluting. Is it stable ? Are they at risk even if nobody aree hunting them ?
- Now, try to introduce just 1 poacher, as it is by default : how is it affecting boars and wolves population ? What happen if the poacher get caught rapidly ? If he never get caught ? If the poacher get caught too rapidly by a gatekeeper, you can still relaunch the simulation in order to observe another result.

Ex with default settings : one poacher which is never caught by a gatekeeper will eradicate the wolf population in 836 ticks during one of my simulation => even one poacher will affect a lot the life of the wolf population.

## EXTENDING THE MODEL

One thing I would like to add is the fact that boars are a real problem for the collectivity, as they produce a lot of damages for barriers and agriculture fields : it will be interesting to put some random patches for agriculture fields and barriers, affect a cost for each, and when a boar is present on it, it destroys it. We can imagine that after a certain timer, the barrier or the field will be back again, with a certain cost for the society.

In order of code, I think there is a lot of repetitive code which can be improved to clean the code and make it more readable/concise.

Finally, we can go further by implementing some of the remarks made in the part "THINGS TO NOTICE".


## RELATED MODELS

- Wilensky, U. (1997). NetLogo Wolf Sheep Predation model. http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

- Dabholkar, S., Lee, J.S. and Wilensky, U. (2020). NetLogo Sex Ratio Equilibrium model. http://ccl.northwestern.edu/netlogo/models/SexRatioEquilibrium. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## CREDITS AND REFERENCES

- Morthland, J. (2011), A Plague of Pigs in Texas - https://www.smithsonianmag.com/science-nature/a-plague-of-pigs-in-texas-73769069/

- Analysis of Poaching Activities in Kainji Lake National Park of Nigeria. - Scientific Figure on ResearchGate - https://www.researchgate.net/figure/Relationship-between-number-of-arrested-poachers-and-staff-strength_fig4_234032442

- Suzanne W. Agan , Adrian Treves , Lisabeth L. Willey (2021) - Estimating poaching risk for the critically endangered wild red wolf (Canis rufus) - https://dx.plos.org/10.1371/journal.pone.0244261

## HOW TO CITE

Copyright 2024 Clément COSTE.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Clément COSTE at coste.clement@icloud.com

=========================================================================

"No one goes _**hunting**_ nowadays, it’s too crowded." **Yogi Berra**

<!-- 2024 Cite: COSTE C. -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boar
false
0
Polygon -7500403 true true 150 90 75 105 60 150 75 210 105 285 195 285 225 210 240 150 225 105
Polygon -16777216 true false 105 285 135 270 150 285 165 270 195 285
Polygon -7500403 true true 135 225 142 248 159 263 183 272 206 272 232 265 247 258 260 246 270 231 277 212 259 226 239 238 217 243 189 242 169 231 159 214
Polygon -7500403 true true 165 225 158 248 141 263 117 272 94 272 68 265 53 258 40 246 30 231 23 212 41 226 61 238 83 243 111 242 131 231 141 214
Polygon -7500403 true true 195 195 218 188 233 171 242 147 225 120 235 98 228 83 225 75 210 45 195 30 196 71 180 90 180 105 212 141 201 161 184 171
Polygon -16777216 true false 150 150 165 180 210 150
Polygon -7500403 true true 105 195 82 188 67 171 58 147 75 135 65 98 72 83 75 75 90 45 105 30 104 71 120 90 120 105 88 141 99 161 116 171
Polygon -16777216 true false 150 150 135 180 90 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cow skull
false
0
Polygon -7500403 true true 150 90 75 105 60 150 75 210 105 285 195 285 225 210 240 150 225 105
Polygon -16777216 true false 150 150 90 195 90 150
Polygon -16777216 true false 150 150 210 195 210 150
Polygon -16777216 true false 105 285 135 270 150 285 165 270 195 285
Polygon -7500403 true true 240 150 263 143 278 126 287 102 287 79 280 53 273 38 261 25 246 15 227 8 241 26 253 46 258 68 257 96 246 116 229 126
Polygon -7500403 true true 60 150 37 143 22 126 13 102 13 79 20 53 27 38 39 25 54 15 73 8 59 26 47 46 42 68 43 96 54 116 71 126

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

hunter
false
0
Polygon -13840069 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13840069 true false 105 120 105 135 114 155 120 196 180 196 187 158 210 120 255 105 195 91 165 91 150 106 150 135 135 91 105 91
Circle -13840069 true false 110 5 80
Rectangle -13840069 true false 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13840069 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 120 180 180 195
Polygon -13840069 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28
Polygon -13840069 true false 165 15 225 0 225 15 150 30
Polygon -16777216 true false 120 105 285 105 285 120 180 120 120 150
Polygon -1 false false 120 105 120 150 180 120 285 120 285 105
Line -1 false 285 90 285 105

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

poacher
false
0
Polygon -955883 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -955883 true false 105 120 105 135 114 155 120 196 180 196 187 158 210 120 255 105 195 91 165 91 150 106 150 135 135 91 105 91
Circle -955883 true false 110 5 80
Rectangle -955883 true false 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -955883 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 120 180 180 195
Polygon -955883 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28
Polygon -955883 true false 165 15 225 0 225 15 150 30
Polygon -16777216 true false 120 105 285 105 285 120 180 120 120 150
Polygon -1 false false 120 105 120 150 180 120 285 120 285 105
Line -1 false 285 90 285 105

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
