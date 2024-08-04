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

TREASURE:
* Display custom tutorial image to explain this, only shown on single player?

MAP:
* Place some leaf decorations and stuff

AI (skeleton):
* IF num == -1, enable some AI module, disable the player input module
* Repeat this cycle: pick a direction, walk that way until the timer runs out.
* Once we're _close to something we can grab_, set that as the destination instead, and keep walking until we get it (or it's gone)
* REMEMBER: anything that's not inverted is "desirable" to trigger

(On Singleplayer, both normal bombs and inverted bombs would work ... but it does feel like inverted is a better standard?)
=> Maybe a better rule is that inverted bombs simply hit EVERYONE in range, so it can act like a suicide mission.


## What is PROBABLY NICE?

* INVERSION:
  * On repeat plays, turn this on.
  * Show some extra marker on REMINDERS to help communicate this
  * (Also an extra marker that shows the element's influence/size)



* Rules tweaks and testing
  * USING YOUR BEACON => BLAST ROW/COLUMN?
  * BEACON SHOWS DIRECTION (or also gives info in _some way_)
  * FORTNITE SHRINKING CIRCLE (to force escalation and games coming to a close)

* Implemented, need to be tested
  * INCLUDE BATTERY ALWAYS => but display it on the BEACON
  * USING YOUR BEACON => EVERYONE ELSE GOES HAYWIRE
  * TRACK STATS ( + display on game over)
  * SLOTS GET LESS ACCURATE AS YOU LOSE LIVES
  * BOMBS COME IN PAIRS
  * TRAP: a "yeet into the air" animation
  * @IDEA: When standing inside such an area, the slot of that particular color _doesn't work_.


PROGRESSION:
* A "random setup per round" as you play more rounds. (With actual specific curses/bonuses/etcetera)

JUICE:
* Some movement/walking sounds?
* Death sprite could get particles and look nicer/more clear
* Some simple particles/modulate change should show battery empty (and all its corresponding effects) too => GRAYSCALE shader
* That _other_ theme song might be better, if I just cut it shorter?
* Show inversion + "size" (small/medium/big) of an element on its reminder?
* Finetune slot sensitivity

MAP:
* Actually use the eroded layers
  * Like "terrains" with a special effect? (Some change your movement speed. Some make you lose control. Some can't have hidden elements, or have a LOT of them.)
  * Those bottom layers _permanently_ reveal things that are within their radius??
  * This can tell a story? With scribbles, skeletons, objects scattered around, maybe limbs from a tentacled monster, etcetera?
  * (Potentially, this part of the map might be _permanently_ revealed, and maybe you can even pick up some of those items.)

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


## What can I do AFTER sending it in?

* Screenshots
* Nice itch.io page
* Marketing image

## Optional / Niceties

* Implement other elements like Trap or Battery Recharge
  * Trap = small radius, rare, but instantly kills all (by yeeting them away)
  * Battery = if battery is low, your slots stop working => you can recharge by visiting your beacon (the slot therefore displays "battery left", not distance to anything)
  * Treasure = simply allows collecting treasure, needed to win the game => we can display treasures so far on your BEACON 
* Use Progression _and_ Player Count more for scaling things and ramping them up
  * Slightly bigger bomb radii + higher base speed for all
* Maybe the _functionality_ of each type (bomb, speed, ...) can be on the resources too? (So interactor merely calls the trigger function, and inputs the config/map_data resources)
* Use all the other explosion sounds too; randomly pick one for each explosion

