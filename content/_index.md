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
use chuot::{PixelGame, Context, GameConfig};

struct MyGame;

impl PixelGame for MyGame {
  fn update(&mut self, ctx: Context) {}

  fn render(&mut self, ctx: Context) {
    ctx.text("font", "Hello world!").draw();
  }
}

fn main() {
  MyGame {}.run(chuot::load_assets!(), GameConfig::default()).unwrap();
}
```
