Welcome to my devlog for the game [Bombgoggles](https://pandaqi.itch.io/bombgoggles/). It will be a very brief one, because it's a very short jam (it's literally called the _Mini Jam_) and I can't even use most of the time we do get. Nevertheless, I think through problems and ideas by _writing_ in this devlog (like a diary), so I'm creating one anyway.

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

First of all: what a huge difference, of course. In a game that's all about hidden information, it's just a completely different experience when you can _see_ where everything is, as opposed to when it's all hidden. When everything is visible, you think "this is the most boring game ever, I can just walk to the treasure right there" :p But of course, when that's all hidden, it becomes quite tense and difficult.

Was it fun though? Erm ...

### Finetuning the Game Loop

In the very first version of the game, you only had your three slots. 

* At the start, three random options (from all "hidden elements that can appear") were chosen.
* These slots indicated how close you were.
* And using that, yes, you could quite accurately find the thing you wanted.

There were two problems here. It was too easy/straightforward, and there weren't clear reasons/stakes for why you'd _want_ (or not want) to find certain things. Certain combinations of three elements (such as any that had _no way to kill other players at all_) weren't balanced or playable.

You had infinite time to try and find that one thing you were looking for. Depending on the random selection of elements, the map was either a minefield that made it impossible to do anything, or very safe in any case.

I had terrain destruction programmed ... but didn't actually know what to do with it yet.

The "battery" mechanic, at this point, was just another slot. One that could be randomly chosen ... or not. That slot indicated how much battery you had left (instead of distance to something), and being out of battery made you _slow_.

So I changed the following things.

* Battery is shown on your _beacon_ and it's _always included_. You recharge by visiting your beacon, and it teleports to a random new location when you do so. (Why? To force you to keep moving around. You can't hide in a corner or endlessly search for that one treasure that might be close.)
* When selecting three options, there is always at least one option to kill yourself/others.
* I needed to try a lot of rules to make the goggles less straightforward. As stated, I could make them go "haywire" (display random results for X milliseconds) or "disable" them (show nothing at all for Y milliseconds) under certain circumstances.
* A simple function checks if there's a _hole_ in the terrain. ( = All layers have been erased at your specific position.) If so, you die.

This was _better_, but still a bit vague and too freeform.

I had no time to dwell on it, though, so I decided this was "playable enough for now" and continued.

### Wait, what about single player?

Yes, this was the problem that needed my time now! I only had a few hours to actually make the game playable in single player.

This was when _treasures_ got introduced. Yes, they only appeared in the game because of singleplayer, and very late as well.

I had two options.

* Play the usual game, but against a bot. I could make the bot as intelligent as possible at playing this game that didn't have its rules finished yet.
* Change the mode in single player: it's about collecting treasures. Just collect 5 of them more quickly than the bot.

The first one was just too hard in the given timeframe. The bot would have to move around, infer information from its goggles, then calculate where a bomb would be, then understand when the player would be close enough to use it on them, and so forth.

Most likely, I'd lose the final time in the jam creating a bot that was either cheating (it would know the exact locations of all elements, be impossible to beat, etcetera) or no challenge at all.

So I picked the second option.

The bot doesn't actually have to play like a human. It just has to _appear_ to be a nice opponent. As such,

* The bot moves around randomly. (On a random timer, pick a random position close to you that's within map bounds, walk there.)
* When picking a new direction, if it senses it's close enough to a hidden element, it moves towards that instead.
  * Only if this element is _good_ to visit, of course.
  * And not if this element "does nothing" for the bot (such as a Life when already at max lives), because visiting the element would not remove it then, which would get the bot stuck in an endless loop :p
* If multiple elements are in range, it prefers treasures.
* Bombs don't damage it. (It's not fun if the bot just accidentally, stupidly kills itself in 3 seconds at the start of the game. And I have no time to write an algorithm to prevent this.)
* But all other rules apply to the bot just the same, which means, for example, that it runs back to its beacon once battery becomes low.

This took almost no time to implement, yet the bot _seems_ somewhat intelligent. It makes the game more fun and "alive" when playing solo, because it _feels_ like you're playing against something, and the bot actually has a good chance of winning.

Not perfect, but it's okay.

### Polishing

I took an hour or two to go over the "usual polishing": sound effects, little animations when things appear/disappear/change, proper UI (login screen/countdown/tutorial/game over), a few particles for the most important parts (such as bombs).

I consider this all mandatory stuff, but also not the interesting part of game dev if you ask me. So I just sit down (or, rather, stand up behind my desk) and power through all these things like there's no tomorrow.

The _actual_ polishing part, which feels more important to me, is about tweaking the rules and refining the core gameplay loop. This usually comes down to simple "quality of life" improvements and simple "I accidentally made this thing dumb and vague, let's just make it simpler"

For example, I had no animation yet for when your battery was running low. Yes, once it ran out, you'd hear a sound effect and your player would go grayscale. But you really want to know, as a player, when your battery is below ~20%. Once I added an animation (flash bright, pop up) on your beacon---which took 30 seconds---the game instantly became less annoying to play.

Similarly, I had loads of rules in mind for the _terrains_.

* Holes kill you.
* Holes slow you down.
* Holes make your goggles go haywire.
* The color of the terrain below your feet determines which goggle will malfunction.
* The color of the terrain below your feet has other special properties, such as a speed boost/slowdown.

I implement them all, then toggle them on/off and test to see which ones are actually fun. Most are not. For example, especially in multiplayer games, holes can appear quite quickly and be quite large. If they'd kill you ... then it'd just mean all players would stop moving and stop being able to reach other corners of the map (if there were a hole anywhere near the center). A nice idea in theory---not so much in practice.

I made feedback _bigger_ and _stay longer_. (I also randomized their position a little, so if multiple feedback texts appear above your head at the same time, they are spaced out to still be readable.) Tiny tweak, huge effect.

I moved _all_ effects on goggles to "deactivate". (This was made definitive after the playtest, which I'll talk about next section.) If something goes wrong with your goggles, they just show _nothing_. This is the _clearest_ indicator that something is wrong or some effect triggered, as opposed to other effects such as "they display _random results_". That one is just much harder to grasp for a player, leading to confusion instead of tension or fun.

At this point, we're nearing late evening here. I've participated in 3 game jams the past few days, so I'm a little tired and want to go to bed even earlier than usual :p

I only have an hour or two left, so I had to accept that the game just felt a bit "meh" to me and I had not enough time to make any major changes now.

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

All these tweaks made the game _much better_. 

{{% remark %}}
The smaller map size is really something I should be testing and refining at the _start_ of development, when I'm setting up the sizes for everything. I constantly realize I want a smaller map late in development, and then need to go tweak other numbers based on the original size as well.
{{% /remark %}}

Both singleplayer and multiplayer are a much more tense and challenging experience than before. The things that happen are more consistent and "graspable" after one or two attempts. You're in each other's face, but still far enough apart to flee or do your own thing. 

All of this is mostly thanks to the **battery empty = life lost** mechanic.

This game (and the other two I made in this period) made me realize just how crucial that is to any game. You want _some element_ that provides a _constant "hard" pressure (in a loop)_. That feels like the best way to keep that gameplay _loop_ challenging at all times.

* It was not enough to just say "battery empty = some bad effects". That's too soft, too vague.
* It was not enough to have this far-off pressure of "oh no, the opponent is collecting more treasures than you, and might win in a minute". We need something more immediate and cyclical.
* So, every X seconds, you must visit your beacon to recharge, or get the harsh (but clearly defined) penalty of losing a life.

That simple tweak took the game from "meh" to "this is actually something". And it did the same thing for those other two games I made :p

For example, _Druids in the Dark_ (which I made for the PirateJam 2024.2) felt like a "meh" idea as well. There were holes in the map and there was a shadow around your player, which meant you had to memorize the holes and walk around them. This was a good idea in theory---but not in practice.

* You couldn't actually walk into holes (the code prevented you). So the only downside to trying to do so was "some time lost/less efficiency". Which is too soft, too vague.
* The only reason you'd care about time lost, was because you needed to fulfill orders. But those can have quite a lot of time left for delivery, so the disadvantage for _trying_ to move into a hole is not immediate or repetitive/cyclical enough.
* When I simply changed the rule to "you can walk into holes; and then you die", the game started working!

I'll write a longer article about this revelation and my thoughts about it soon.

Anyway, midnight had now passed. I considered the game done, made some simple marketing assets, and sent it in. 

_Why spend much time on a pretty header if you're so strapped for time?_ After so many years, I've learned the hard lesson of how important marketing is. Or, rather, making things _look somewhat nice_. I've also gotten quite good at it, thanks to creating headers/icons/illustrations for over 50 board games now. Within 30-60 minutes, I can make my game look enticing and have 100x more people click on it, without even increasing the quality of the game. That's too valuable for me to ignore, even if I'm tired and don't feel like I can miss the time.

And this turned out to be true, again. (This is _Tiamo from the future_ speaking.) Despite being part of a _muuuuch_ smaller jam, the Bombgoggles has seen more views and reactions than games I sent in to huge jams (such as GMTK) years ago, when I didn't make much effort to make it look a little nicer. Both within and outside of the jam, because these games also simply appear on the "new" listing or in people's feeds.

I just wish the actual game turned out better :p

Then I went to bed for the first good sleep in a few days. (I wrote the final half of this devlog the next day, at a leisurely pace.)

## Conclusion

I did good work. That's always the best and first thing to tell yourself. Within a very limited timeframe, 

I created something unique, playable, thematic, and sometimes even fun. I learned a lot of things about Godot, Custom Resources, and some other nice code architecture things. I learned one or two new effects for making things visually nicer.

I can always go back later, for just a few days, and take the game from "meh" to "really fun". Because I _have_ the first version now. I _have_ almost all the work out of the way and an easy setup to tweak things and turn rules on/off. Changing some numbers later, adding a single new sprite, it's all _nearly no work at all_---as opposed to creating the entirety of this game.

So, no matter the results of this jam, or how "meh" I think the game became (in my personal opinion), I'm glad I worked my ass off for it.

Now one or two days rest. And then we have two more game jams this summer!

Keep playing, and developing,

Pandaqi