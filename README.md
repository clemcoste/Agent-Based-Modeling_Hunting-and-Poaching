# Agent-Based-Modeling_Hunting-and-Poaching
The model is about hunting, poaching and species reproduction. It tends to show the impact of hunting and/or poaching on two kind of species : one consider as pest and very invasive (boars) and one which is protected (wolves).

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
