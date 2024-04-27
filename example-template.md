+++
title = "${title}"
description = ""
date = "${date}"
template = "example.html"
+++

<script type="module">
import init from "/wasm/${example}.js";
window.addEventListener("load", () => {
  var canvas = document.createElement("canvas");
  canvas.id = "chuot";
  document.getElementById("wasm").appendChild(canvas);

  init();
});
</script>

<div id="wasm"></div>

${description}

[Source](https://github.com/tversteeg/chuot/blob/main/examples/${example}.rs)

```rust
${code}
```
