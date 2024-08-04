# MINI JAM 164

Theme: Destruction
Limitation: ?

## Controls

1-4 players, each one can only move (WASD/GAMEPAD)

## Objective

Last one standing wins. You lose lives by being caught in the bomb blasts of other players; run out of lives and you die.

## Gameplay

Each player is a triangle with 3 slots: small, medium, large. (Also red, green, blue.)

The map has randomly generated hot spots (with important stuff), but they are INVISIBLE.

* Instead, those three slots fill up/drain (like progress bars) depending on your distance to a certain element.
* When you walk close enough/over the element, you trigger it.

What these slots mean is randomly generated, so I can just display it permanently in the UI. The three possible elements are ...

* BOMBS = these kill everyone within radius (but not the one who set it off)
* SPEED = these are speed boosts so you can walk faster and faster
* LIVES = these are extra lives

The _size_ of the element determines how much you get. (Small slot = small explosion, small speed bump, only 0.5 extra life)


## What is PROBABLY NICE?

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

## What can I do AFTER sending it in?

