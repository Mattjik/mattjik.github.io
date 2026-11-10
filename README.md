# My Game Hub

A simple static site that collects browser games in one place. The home page (`index.html`) shows every game as a tile with search, favorites, and a random-game button.

## Adding a game

1. Put the game's files in a new folder, e.g. `games/game17/`, with an `index.html` inside.
2. Add a thumbnail image to `thumbnails/` (a 4:3 picture looks best).
3. Open `index.html` and add one line to the `GAMES` list:

   ```js
   { id: "game17", name: "My New Game", thumb: "mynewgame.jpg" },
   ```

   You can also add `note: "PC only"` to show a short note under the name.

## Hosting

The site is plain HTML and needs no build step. It deploys as-is on Netlify or GitHub Pages.
