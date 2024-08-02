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

## What is CRUCIAL before the game is finished?

* Singleplayer
  * Either an AI opponent to actually play against
  * Or you need to collect X treasures (before the AI opponent does), without blowing up of course. (Because bombs are always inverted and kill yourself.)
    * Already implemented treasure tracking and winning, juts need to communicate this and make the other adjustments
    * Create unique TUTORIAL to explain this solo mode (with treasure hunting), display as needed

Better MAP
* Place some leaf decorations and stuff
* Actually use the eroded layers
  * Like "terrains" with a special effect? (Some change your movement speed. Some make you lose control. Some can't have hidden elements, or have a LOT of them.)
  * Those bottom layers _permanently_ reveal things that are within their radius??

Determine included elements/mechanics more smartly:
* To get Battery in there, but not on your first game.
* Same with treasure/trap (already have sound effects for those)
* When/how to introduce inversion (if at all)?
* (This basically feeds into "random setup per round" system as you play more rounds)

FINETUNE:
* Radii (small, medium, large) of bombs (yeah, small is TOO SMALL)
* Numbers of hidden elements that appear
  * Lives shouldn't appear too often, for example, or it's too easy.
* Escalation over time / player count
* Slot sensitivity

HANDLE ALL @TODO's IN THE CODE

## What is PROBABLY NICE?

* Rules tweaks and testing
  * TRACK STATS ( + display on game over)
  * BOMBS COME IN PAIRS
  * USING YOUR BEACON => EVERYONE ELSE GOES HAYWIRE
  * USING YOUR BEACON => BLAST ROW/COLUMN?
  * BEACON SHOWS DIRECTION (or also gives info in _some way_)
  * FORTNITE SHRINKING CIRCLE (to force escalation and games coming to a close)
  * SLOTS GET LESS ACCURATE AS YOU LOSE LIVES
  * GROUND EROSION / STORYTELLING:
    * Whenever a bomb goes off, some underlying part of the ground/map/level is _revealed_. 
    * This can tell a story? With scribbles, skeletons, objects scattered around, maybe limbs from a tentacled monster, etcetera?
    * (Potentially, this part of the map might be _permanently_ revealed, and maybe you can even pick up some of those items.)
  * INCLUDE BATTERY ALWAYS => but display it on the BEACON

JUICE:
* Some movement/walking sounds?
* Death sprite could get particles and look nicer/more clear
* Some simple particles/modulate change should show battery empty (and all its corresponding effects) too
* That _other_ theme song might be better, if I just cut it shorter?
* Show inversion + "size" (small/medium/big) of an element on its reminder?

STORY:
* A war that create a world with loads of bombs stuck under the surface (as well as shields and other things)
* Robots were created and tasked with finding them.
* But of course, humans soon saw potential for competition and turned it into a sport!


How to do **single player?**
* It spawns another player that is simply controlled by AI.
* It tries to be a player:
  * It moves randomly at first.
  * It _tracks_ how its slots change; once it's seen this a few times, it knows roughly where something is.
  * It checks _who will get somewhere first_ (distance + speed check): it won't go if the player will be first.
  * There's a lot of _randomness_ here to prevent them being "perfect" players.


@TUTORIAL:
  * The issue is: How will we clearly explain/show INVERSION or some of the other rules? (Just change the tutorial image to another one as you replay the game??)
    * NO WAIT, INVERSION can just be embedded in the DESCRIPTION. (+An extra identifier to make sure this is clear.)
    * Bomb = "-1 Life to all within radius" / Bomb Inverted = "-1 Life to you"
    * Just TURN OFF inversion (and other special stuff) on the first attempt/play anyway?


## Optional / Niceties

* Implement other elements like Trap or Battery Recharge
  * Trap = small radius, rare, but instantly kills all (by yeeting them away)
  * Battery = if battery is low, your slots stop working => you can recharge by visiting your beacon (the slot therefore displays "battery left", not distance to anything)
  * Treasure = simply allows collecting treasure, needed to win the game => we can display treasures so far on your BEACON 
* Use Progression _and_ Player Count more for scaling things and ramping them up
  * Slightly bigger bomb radii + higher base speed for all
* Maybe the _functionality_ of each type (bomb, speed, ...) can be on the resources too? (So interactor merely calls the trigger function, and inputs the config/map_data resources)
* Use all the other explosion sounds too; randomly pick one for each explosion

