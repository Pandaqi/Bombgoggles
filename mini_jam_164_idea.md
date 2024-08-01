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

## What do we need?

* Scenes to create/finish (and then update type hints):
  * Element Reminder (a gravestone with sprite + explanation text)
  * Player Beacon (some tower/pillar/totem showing your LIVES and PLAYER COLOR, and room for perhaps something else)
  * HiddenElement (Bomb/Speed/Life/Trap) (so I can actually SEE what I'm doing)
  * Explosion ( + Trap) effects

* Player Modules
  * Visuals => general animations, tweens, particles, dead-sprite, etcetera + updates visual display (for goggles)
* PreGame/Tutorial => create ONE fixed image (which includes the button to dismiss as well)
  * "Your slots fill up the closer you get to a certain hidden element. Once close enough, you trigger it. Last one standing wins."
  * The issue is: How will we clearly explain/show INVERSION or some of the other rules? (Just change the tutorial image to another one as you replay the game??)
    * NO WAIT, INVERSION can just be embedded in the DESCRIPTION.
    * Bomb = "-1 Life to all within radius" / Bomb Inverted = "-1 Life to you"
* PostGame = 
  * A game over screen + who won + buttons to restart or whatever
  * Zoom in on the winning player, give them a jumping animation or something?
  * This should CLOSE THE GAME LOOP
* Rules tweaks and testing
  * Lots of range numbers are just fixed now => should move to config or be dynamic
  * Try all the different Config tweaks and ideas below
  * Experiment with "eroding" the ground floor => it's a shader that gets a list of CENTERS and RADII, then cuts out circles based on that (just draw nothing at those pixels)
    * What's the PURPOSE?
    * Maybe there are multiple layers => this creates nice persistence and variety over time
    * But when you've eroded the bottom layer, it's a HOLE you can fall into??
* AI Player
* Graphics + Sound Effects + Polishing
  * Unique sprites+colors+symbols for the 4 players, because I also really need those on the beacons
  * Some silly squash/stretch jumping movement animation?
  * Don't forget the other effects I downloaded => https://pixabay.com/sound-effects/search/explosi%C3%B3n/


SoundFX:
* Explode, obviously
* Speed/Life change
* Start Game/End Game (in Progression)

Because stuff is hidden, we **don't really need graphics!**

Otherwise, the graphical style is just simple vector but with stuff cut-out/destroyed.

How to do **single player?**
* It spawns another player that is simply controlled by AI.
* It tries to be a player:
  * It moves randomly at first.
  * It _tracks_ how its slots change; once it's seen this a few times, it knows roughly where something is.
  * It checks _who will get somewhere first_ (distance + speed check): it won't go if the player will be first.
  * There's a lot of _randomness_ here to prevent them being "perfect" players.

**@TODO: Do we need some element to force players to act and get close?** Or is it enough that you literally can't get info without moving, and the exact location is a guess so you don't know if you're first anyway?
* Some bombs might be _public_. You can disarm them by getting close to them, and otherwise you must move _away_ (which I can sneakily use to force players closer together)
* Disarming must get some benefit then, though, otherwise it's too risky.
* If you disarm, everyone else's slots go HAYWIRE for a few seconds, _but not yours_?
  * **YES, these are your personal beacons, and probably best if these indicate DIRECTION instead of distance?** (To get variety and other means to figure out the secret map.)
* Otherwise we always have the **Fortnite approach**: after X amount of time, start reducing the playing area and killing anything that steps outside.


## Optional / Niceties

* Use Progression _and_ Player Count more for scaling things and ramping them up
* Maybe the _functionality_ of each type (bomb, speed, ...) can be on the resources too? (So interactor merely calls the trigger function, and inputs the config/map_data resources)




## Trying to find something for all limitations

I have to start the project a day early, otherwise I just won't find the time to finish it later. So let's do something crazy here ...

* [x] **Manually controlled**:
  * The bombs (and other things) need to be visited manually to actually trigger them.
  * Your beacons are the same thing
  * Maybe the players are more "robotic", and the story it tells is about how these are some sort of Olympic Bombgoggles games that are remote controlled by you---the players?
* [x] **Everything in a pair**: 
  * Players + Their personal beacon = a pair
  * Slots + invisible elements = pairings
  * Bombs always explode in _pairs_ => triggering one triggers another hidden one; they also spawn in pairs of course.
* [x] **Reversed progression**: we can just turn the slots ON THEIR HEAD => the "speed" one actually LOWERS your speed, and the "lives" one actually LOSES a life.
  * Just make this a toggle on the elements. ONE OF THEM (at least) is always inverted and bad for you.
* [x] **Changing rules**: already have this one. What each slot represents changes all the time. I might also add random modifiers to each round, when I create many different rules to try out anyway.
* [x] **Environmental storytelling**: 
  * Whenever a bomb goes off, some underlying part of the ground/map/level is _revealed_. 
  * This can tell a story? With scribbles, skeletons, objects scattered around, maybe limbs from a tentacled monster, etcetera?
  * (Potentially, this part of the map might be _permanently_ revealed, and maybe you can even pick up some of those items.)
* [x] **Diegetic UI**: already have this one.
  * The "recipes" (for each slot) are in the level itself.
  * The lives of each player are on their PERSONAL BEACON. (Which they can make explode + move around by visiting it.)
* [x] **Constant escalation**:
  * The boosts/debuffs from triggering stuff increases over time. (So bombs get bigger, speed boosts get larger, etcetera)
  * Stuff spawns more QUICKLY over time/in bigger numbers
  * Maybe your slots also get less accurate as you lose lives?
* [x] **Zero gravity**: 
  * Well, I can just say that the game has no gravity at all, but that's a bit meh :p
  * HAHA: There are also "spring traps". If they spring on you, you're yeeted out of the level, and you're just instantly dead (no matter your number of lives; you simply never return to the playing field/camera view) => because there is NO GRAVITY
  * This game idea does NOT really work if we turn it into a side platformer, as then we can't be sure that spots are actually REACHABLE. 
    * Unless we make jumping really easy and free and you get anywhere blindly ... which we CAN actually do if it's zero gravity.!
    * The movement you input is simply where you go, but then it's no different than regular movement again.
* [x] **Only triangles**: already have this one. Your slots are a triangle, I can make the visuals only triangles (though perhaps swap out with that other font for Smackshapes then), you're basically triangulating your position.
  * **YES!** Those "public beacons" display their distance/direction to closest element. If you get close to them, you disarm them. They blast row/column, but not you.