# Bombgoggles

I want to do a single update later to actually make this game good and properly sell it.

## Bug Fixes

* GAME START: Don't display feedback on game start (when it initializes stuff; probably just disable feedback module/wait with init until everything activated)
* Goggles aren't accurate now! Because the progress bar uses the _whole texture_, <0.1% and >0.9% aren't really visible => Just add _boundaries_ to the display, so that it accurately updates only the inner part
* INPUT SELECT: The arrow keys aren't centered correctly

## A better CORE RULE

> Bombs blow up everyone in their radius except you. If you hit nobody else, however, you hit yourself.

This creates this push and pull of wanting other players to be close, and a great risk to making stuff explode instead of doing it willy-nilly.

## A better genre match (FAST + SPLIT-SECOND DECISIONS)

This being a quick party game about explosions, the most likely vision would be to make it _fast_. As such, all other rules of the game should be changed to accomodate this.

* Any information you need is explained _before the round starts_. (So, instead of gravestones in the level, you get 1--3 boxes with the random rules/hidden elements for this round. Then you click SPACE/BUTTON, it fades away, and you play.)
* During the round itself, there is _no new information_ and nothing that requires deep thought. (Instead, it's all about running around juggling your goggle readings. To aid this, the map would be filled with elements that ask you to make more split-second decisions. Like a door that only opens once in a while, or spikes that appear on a timer, or a conveyor belt to speed you up.)



## Better PROGRESSION

For your first game, really turn everything OFF. 

Then, for each game, randomly select 1 or 2 rules => display these on gravestones _in addition to explaining beforehand_, and make those gravestones flicker for ~10 seconds to make sure people know what's changed.

This includes _all_ my ideas (implemented or not)
* Terrain below you locks your type
* Goggles go more and more random as you lose lives
* USING YOUR BEACON => BLAST ROW/COLUMN?
* BEACON SHOWS DIRECTION (or also gives info in _some way_)
* FORTNITE SHRINKING CIRCLE (to force escalation and games coming to a close)
* BOMBS COME IN PAIRS

They'd be like drawing X random event cards for that round only.

**@IDEA (a different way to do this):** Let players FIND the rules. There's this _treasure map_ goggle that shows you the hidden location of "TUTORIAL MAPS". => If done right, this is a great way to teach the core idea of the game whenever you play, AND the actual specific rules in play this time.


## Niceties

* Main Menu (with settings control or something) + Pause Menu
* Let players PICK their goggles ( + map/game style) in menu
* CODE ARCHITECTURE: Maybe the _functionality_ of each type (bomb, speed, ...) can be on the resources too? (So interactor merely calls the trigger function, and inputs the config/map_data resources)

### Juice
* Some movement/walking sounds? Game start/stop sounds?
* Death sprite could get particles and look nicer/more clear
* That _other_ theme song might be better, if I just cut it shorter?
* Use all the other explosion sounds too; randomly pick one for each explosion
* Show some extra marker on REMINDERS to help communicate they are INVERTED
* STATS (game over): very barebones now, remove trailing comma

### Map
* Use the eroded layers more.
  * At least randomize the order / number of them.
  * Like "terrains" with a special effect? (Some change your movement speed. Some make you lose control. Some can't have hidden elements, or have a LOT of them.)
  * Those bottom layers _permanently_ reveal things that are within their radius??
  * This can tell a story? With scribbles, skeletons, objects scattered around, maybe limbs from a tentacled monster, etcetera?
  * (Potentially, this part of the map might be _permanently_ revealed, and maybe you can even pick up some of those items.)

DISCARDED:
* I basically discarded the idea of the three elements having different ranges. (I also never actually implemented those for speed/lives/etc, only for ranged things.)