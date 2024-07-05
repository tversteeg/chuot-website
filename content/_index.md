+++
paginate_by = 6
sort_by = "date"
template = "pages.html"
+++

<center>

# Chuột 

Chuột is an AGPL licensed and opinionated game engine for 2D pixel-art games built in Rust.

</center>

## Example usage

```rust
use chuot::{Config, Context, Game};

/// Define a game state.
struct MyGame;

impl Game for MyGame {
    /// Update the game, handle input, move enemies, etc.
    fn update(&mut self, ctx: Context) {
        // ..
    }

    /// Render the game.
    fn render(&mut self, ctx: Context) {
        // Load a text asset and draw it
        ctx.text("font", "Hello world!")
            // Draw the text on the screen
            .draw();
    }
}

fn main() {
  let game = MyGame;

  game.run(chuot::load_assets!(), Config::default());
}
```

<center><br/>

[![Support Palestine](https://raw.githubusercontent.com/Safouene1/support-palestine-banner/master/banner-project.svg)](https://github.com/Safouene1/support-palestine-banner)

</center>
