# MINI JAM 164

## Future To-Do

@FEEDBACK:
* A way to customize the goggles you have.


* Rules tweaks and testing
  * USING YOUR BEACON => BLAST ROW/COLUMN?
  * BEACON SHOWS DIRECTION (or also gives info in _some way_)
  * FORTNITE SHRINKING CIRCLE (to force escalation and games coming to a close)
  * I'M NOT SURE about many of the "randomizing" or "losing accuracy" or whatever rules anyway.

* Implemented, need to be tested
  * BOMBS COME IN PAIRS

PROGRESSION:
* A "random setup per round" as you play more rounds. (With actual specific curses/bonuses/etcetera)

JUICE:
* Some movement/walking sounds? Game start/stop sounds?
* Death sprite could get particles and look nicer/more clear
* That _other_ theme song might be better, if I just cut it shorter?
* Finetune slot sensitivity
* CODE ARCHITECTURE: Maybe the _functionality_ of each type (bomb, speed, ...) can be on the resources too? (So interactor merely calls the trigger function, and inputs the config/map_data resources)
* Use all the other explosion sounds too; randomly pick one for each explosion
* Show some extra marker on REMINDERS to help communicate they are INVERTED
* STATS (game over): very barebones, remove trailing comma

MAP:
* Use the eroded layers more.
  * Like "terrains" with a special effect? (Some change your movement speed. Some make you lose control. Some can't have hidden elements, or have a LOT of them.)
  * Those bottom layers _permanently_ reveal things that are within their radius??
  * This can tell a story? With scribbles, skeletons, objects scattered around, maybe limbs from a tentacled monster, etcetera?
  * (Potentially, this part of the map might be _permanently_ revealed, and maybe you can even pick up some of those items.)

DISCARDED:
* I basically discarded the idea of the three elements having different ranges. (I also never actually implemented those for speed/lives/etc, only for ranged things.)