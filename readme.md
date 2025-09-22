![](https://img.shields.io/badge/Godot-4.5-blue?style=flat&labelColor=fff&logo=godotengine&link=https%3A%2F%2Fgodotengine.org%2F)
![](https://img.shields.io/badge/gbjam-13-yellow?style=flat&logo=itchdotio&link=https%3A%2F%2Fitch.io%2Fjam%2Fgbjam-13)

<p align="center">
    <img src="promo/titles1.png" />
</p>

Make a strong build using cards and defeat the boss :)

<p align="center">
    <img src="promo/titles2.png" />
</p>

- `WASD` / `Arrow keys`: D-Pad (move)
- `L` / `Space`: A (confirm / shoot a missile)
- `K` / `Backspace`: B (back / toggle shields)
- `Tab`: Select (change game mode on the title screen)

<p align="center">
    <img src="promo/titles3.png" />
</p>

- Some cards are unlucky (`2`, `3`): they increase bad luck and trigger a negative effect during unlucky waves.
- `A`s are lucky cards: they give a bonus proportional to the bad luck stat.
- `7`s are lucky cards: they trigger a positive effect during unlucky waves.
- `5`s cards increase a stat and can be obtained multiple times.


- In each game, the first card will be unlucky.
- In other card rewards, the leftmost card will be a `5` and the rightmost card will be a lucky (`A`, `7`) or unlucky (`2`, `3`) card.
- The `9` of clubs and the `6` of diamonds are banned from the draft 7 game mode.

<details>
<summary>Spoiler: Cards Table</summary>

| number \ family | spades (damage)                                   | clubs (luck)                                | hearts (tank)                                  | diamonds (bullet effects)                       |
|-----------------|---------------------------------------------------|---------------------------------------------|------------------------------------------------|-------------------------------------------------|
| `A` (lucky)     | bad luck = damage up                              | bad luck = double shots chance              | bad luck = chance to dodge damage              | bad luck = faster reloads                       |
| `2` (unlucky)   | bad luck +2<br>unlucky: can't shoot for 5 seconds | bad luck +2<br>unlucky: speed down          | bad luck +2<br>unlucky: can't shield           | bad luck +2<br>unlucky: imprecise shots         |
| `3` (unlucky)   | bad luck +1<br>unlucky: enemy damage up           | bad luck +1<br>unlucky: enemy shot speed up | bad luck +1<br>unlucky: heal enemies on screen | bad luck +1<br>unlucky: slower shots            |
| `4`             | increase missile area                             | shorter unlucky intervals                   | longer shields                                 | shot speed up                                   |
| `5`             | damage up                                         | speed up                                    | hull up                                        | shot frequency up                               |
| `6`             | damage up for each missing hull points            | bad luck + 2                                | regen 1 hull HP every 10 kills                 | shot frequency increases every 6 kills per wave |
| `7` (lucky)     | unlucky: triple shot                              | unlucky: all stats up                       | unlucky: recharge shields                      | unlucky: slow enemy bullets                     |
| `8`             | damage up if shield and missile are charged       | two random stats up                         | repair 50% hull on death                       | 2 additional diagonal shots<br>damage down      |
| `9`             | missiles have auto aim                            | always unlock the 4 card options            | shields deflect enemy shots                    | shots wrap around screen edges                  |

</details>

<p align="center">
    <img src="promo/titles4.png" />
</p>

- [yopox](https://yopox.fr): Programming
- [ThronoCrigger](https://thronocrigger.bandcamp.com/): BGM
- [SanshPixel](https://linktr.ee/sanshpixel): Pixel art

<p align="center">
    <img src="promo/titles5.png" />
</p>

- fonts (`assets/fonts/`)
  - [_m3x6_ font by Daniel Linssen](https://managore.itch.io/m3x6)
  - [_Mask 17_ font by somepx](https://somepx.itch.io/pixel-font-mask)
- icons
  - [_mrmotext_ by MrmoTarius](https://mrmotarius.itch.io/mrmotext)
- palettes (sampled from music album covers)
  - Title, Stage 1 & 2: [Washed, Engelwood](https://engelwood.bandcamp.com/album/washed)
  - Stage 3 & 4: [Loved, Parcels](https://parcelsmusic.bandcamp.com/album/loved-1)
  - Stage 5 & 6: [21st Century Love, The Flints](https://theflintsmusic.bandcamp.com/album/21st-century-love)
  - Final Stage: [Grasa, Nathy Peluso](https://www.discogs.com/fr/master/3657536-Nathy-Peluso-Grasa)
  - Draft 7 Mode: [Nexus-2060, Capsule](https://www.discogs.com/fr/release/659698-Capsule-Nexus-2060)