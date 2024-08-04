Welcome to my devlog for the game Bombgoggles. It will be a very brief one, because it's a very short jam (it's literally called the _Mini Jam_) and I can't even use most of the time we do get. Nevertheless, I think through problems and ideas by _writing_ in this devlog (like a diary), so I'm creating one anyway.

## What's the idea?

You get a few days to create a simple game. The theme was already given: **Destruction**.

An extra **limitation** would also appear, but only once the jam had already started. The theme was a "nice to have"; the limitation was required.

This almost made me ditch the jam altogether. Because of time zones, the reveal of the limitation was very unfortunate and would've left me with _very_ little time to work on the game. 

At the same time, the rules stated that you're not required to "build fully from scratch". So I decided to already create the "skeleton" of the project the day before: the menu, the general game loop, the scripts or setups that I'll _probably_ need, anything that didn't depend on the _actual game idea_.

This turned out to be a great idea, because it actually allowed me to create a game in the little time I had.

What was my idea?

* As usual, I tried to make a local multiplayer game.
* The theme immediately brought to mind _bombs_ and _bomberman_ and _destructive terrain_.
* Quite quickly, I came up with the following: "What if the area was filled with hidden landmines? You can trigger bombs (that will kill those around you, but not yourself) ... but how do you _find_ them?"

After brainstorming for a while, this turned into the following more specific idea.

* Random bombs (and other elements) are spawned across the world. You, however, cannot see them. Instead, you only have "Bombgoggles".
* These are _somewhat_ like progress bars or compasses: if you get closer to a bomb, they fill up. If you get further away, they empty again.
* This way, by moving around, you can judge where hidden elements might be.
* Your goal is to figure out the secret locations faster than your opponents, and trigger them strategically!

As usual, I also brainstormed many powerups/extensions/variations on the idea. I always just _program them all_, but put them behind an easy on/off toggle (a big Configuration file that everything shares) so I can test what works and disable the rest.

Having just one Bombgoggle didn't feel like enough, for example. 

* If you happen to be far away from a bomb, and another is closer ... then the other player will obviously arrive first. While you will juts _not go there_ so you don't get hit in the explosion. Which means a stalemate where nothing _interesting_ or _fun_ happens.
* But if you have _multiple things pulling at you_, then players can make different decisions. One can choose to go for X, while another goes for Y, and if you time it well and play strategically you can abuse their distraction.
* Those things should also probably not be "equal". Some are more powerful than others. Some things appear more often than others.
* And so I wrote a simple script that randomly generates a set of 3 types that can appear, scaling them from "small impact->large impact".
  * For now, those types are just BOMB (explosion that takes away lives), SPEED (gives you slightly more speed) and LIFE (gives you an extra life)

## What are my own requirements?

I usually challenge myself in one or two more ways (not required by the jam). Just to force myself to get out of my comfort zone or try some new ideas I normally wouldn't consider.

### Custom Resources

This time, I'd learned the power of **Custom Resources** in Godot. And I wanted to take full advantage and discover all they had to offer!

In previous games (no matter the game engine), I'd always had the same "meh" moments. Those moments where many different systems need to share data or reference each other, and you just feel like there is no clean/efficient way to do it. It slowly becomes a mess, more and more things are "shared" or "global", and the risk of terrible bugs increases with the hour.

Then I discovered you can create custom resources. And, more importantly, how to _use_ them in practical ways.

Let's take the **world map**, for example. Something should _know_ where players are, where hidden elements are, etcetera. Many other systems should _also_ be able to retrieve this information, for example to check if a player is currently standing on a bomb (after moving).

In my very first Godot games, I'd create one big `Map` object near the root level of the tree. Anything that needed that information, would access the exact path to get this Map object (with `@onready` and such), then use it as they pleased.

In later games, this method was obviously improved. The `Map` still existed, but it was _passed in_ as a reference to whatever needed it, and nothing else had access to it.

Now, with Custom Resources, I can do the following.

* Create one `MapData` resource. It knows the bounds of the level, the elements within, and has simple functions for "querying" the data. (For example: "Give me a random position that isn't close to any player.") Note that this is just _data_ and _reading it_, **never** actually changing or manipulating that data.
* No, for that we create a `MapModifier` node in the actual game world. This one actually instantiates objects, changes the data as needed, etcetera.

Now, everything that needs to know what's in the world, can just get a reference to the `MapData` resource. It is _one_ instance shared by everything, and I can just create an `@export` variable and drag-drop that thing.

But there's no change of stupid bugs or multiple things trying to change values, because only _one_ node changes this resource as required. (And it does so once, in very simple ways.)

No need to access exact node paths, no need to pass in/copy around references everywhere, no risk of data mutation we don't want.

I haven't learned all its tricks yet---that's why I challenged myself in this way for the jam! And maybe I went overboard with resources in some area, while neglecting to use them in another.

But I think I got the gist of it.

Let's give one final example.

* In a game like this---fight to the death with multiple players---you want the game to get harder and more intense over time. Both from a story perspective (you slowly reach a climax) and from a level duration perspective (at some point, the level has to create a winner in a reasonable amount of time).
* As such, I have a Custom Resource called `ProgressionData` which simply holds a number that states how long the level has been going. It also has some "helper functions" for getting this number in various useful ways. (Such as: get the number as a _ratio_ from 0 to 1.) => Lots of things _read_ this, but nothing changes it.
* Except for the `ProgressionModifier` node. This actually ticks up that number and connects some signals to make stuff actually happen and change in the game.

Both these elements are really short scripts, with very obvious lines of code. But now everything in the game can easily scale its values or intensity based on progression, and I don't need any AutoLoads or passing around of references for that.

The only _danger_ to this, of course, is that I shouldn't forget to **reset** those shared resources whenever you restart. (Because those "modifiers" will have changed some of their values, which should usually not be retained between runs.)

I'm still looking for an elegant way to _enforce_ this "custom resources only store data/read themselves, anything that modifies it must be a different script". But if I make variables readonly, they can _never_ be changed by an outside modifier. Oh well. If I'm just making a quick game alone, this rule is easily carried out without enforcement from the syntax checker.

### No Physics

This is a bit of an arbitrary one, but I still wanted to stick to it.

I can give everything a simple physics body (just a rectangle or circle), then use default physics methods to check if they overlap each other's areas. This would also allow me to create static objects or prevent players from walking through each other "for free".

However, it's not _really_ needed for a simple game like this. And then physics is just overkill and wasted energy. It's much faster to do simple range checks (compare distance to radius of circle) in code, and that's really all I need. I don't _want_ static objects that could block you, because then places where elements are hidden might become _unreachable_.

{{% remark %}}
I briefly considered making this a platformer instead. You'd watch the world from the side as you jump and fly around to reach the place where you think a bomb is. But there just wasn't any easy and elegant way to ensure everything was always reachable/findable, so I discarded it.
{{% /remark %}}

## The Jam Actually Starts!

Okay, I set my alarm clock early, and checked out the jam's restriction. And I prayed, really prayed, that it would not require massive changes to the skeleton I'd set up.

The restriction was **Constant Escalation**

Okay, not too bad. We can steer there quite easily.

* The game is already constantly escalating by letting bombs explode.
* Most of the slots also escalate, such as the one adding _more and more and more speed_.
* All values ramp up over time, to get to that "climax" and ensure the game ends within ~5 minutes.
* Let's execute my idea of destructible terrain => as you play, the terrain only gets worse and worse, escalating further.
* Maybe a _battery_ mechanic => as your energy depletes, you get worse (slower movement, haywire slots)
  * In a similar vein, maybe slots get less accurate as you lose lives => they are the key to the game, so modifying how (well) they work should probably be a main thing


### Getting a Visual

Because my hardware is so slow and bad, I find myself _coding_ for a looong time before actually testing anything. I basically built out entire systems before hitting _play_ once. (I've been doing that for so long that many things now seem to work on the first try, which feels both good and ... suspicious :p)

As such, at this point a lot of the systems were coded ... but had absolutely no _visuals_ for it. I could start the game, and nothing would happen on the screen, because I hadn't actually created sprites to display. Which means I also didn't _know_ if my code was actually working as it should.

So I spent some time here creating decent illustrations for everything. Then I had to insert them, test the game, fix some bugs, and the cycle continued until the game actually worked as intended.

At first, I had everything _on_, so I could actually see where all the hidden elements were. Once I was pretty sure things worked, I could turn all that off and play the game as a player would. That's the big moment where you actually check if the idea is any fun :p 

{{% remark %}}
You'd typically want to test that as quickly as possible, but let me refer you back to my statement about my terrible hardware. I can only have one program open at a time, so I can't even quickly sketch something and import it to get a visual, because I'd need to close/reopen lots of stuff. 

Also, I tend to design games where everything is interconnected with everything, so it makes no sense to test while half of the crucial parts aren't there. For example, the Goggles sensing how far away stuff is ... can't be tested until I actually have hidden stuff placed on the map, nicely spaced out, of matching types. Testing if explosions and range-checking works can only happen when there are actually multiple players to independently control.
{{% /remark %}}

@TODO

### Enjoying the Restriction

@TODO: About how I applied the restriction, working through that

### Wait, wait about single player?

@TODO

### Finetuning the Game Loop

@TODO: About ideas that did/did not work and getting the core game working as well as possible
=> I probably have to STOP HERE, then get back a few days later

### Polishing

@TODO: About the juice => sound fx, particles, tweens, quality-of-life stuff

### A quick playtest

I scraped together a functioning version of the game just in time to quickly let others test it. (It was getting late here, so if I'd been any slower, they all would've gone to bed.)

This revealed the usual flaws (and, fortunately, easy fixes).

* The map was too big, which made it unlikely that players would actually get in each other's way or interact. => **Solution = smaller map**
* Similarly, I'd introduced this idea of "ranges" (small, medium, big) assigned to the goggles, but this just made things inconsistent and bomb blasts too small to be fun. => **Solution = make all ranges equal, and bigger**
* Being out of power is just _not fun_. You move really slowly, your slots are locked (which is _confusing_), and now you have to make the looong way back to your beacon.
  * The idea behind it is to force you to keep moving. You can't linger in one place, because you have to visit your beacon, which has teleport to some random location. Which was a _good idea_, but it needs a better execution.
  * **Solution 1 = You keep your speed, and your slots simply go empty.** Empty slots is a much clearer indicator that your goggles aren't working.
  * **Solution 2 = You lose a life.** This _forces_ players to always be headed to their beacon before battery runs out. It also makes plays riskier and games tighter.
  * (Of course, I'll need to make your battery take longer to deplete, otherwise you can't move anywhere!)
* Sometimes, you clearly hit your beacon (or an element) but it just didn't activate, because the collision check was just too narrow => **Solution = increase range for overlap with elements/beacons**.
* The rules about terrain destruction and holes are hard to grasp without explanation. => **Solution = add an extra gravestone that succinctly explains how this works.** 
* I'd created some nice shaders to give the map rough edges and variation ... but they take 5+ seconds to load, which is a delay we really don't want. => **Solution = ditch duplicating the shader for each layer, just use one instance.**




## Conclusion

@TODO