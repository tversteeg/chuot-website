+++
title = "${title}"
description = ""
date = "${date}"
template = "example.html"
+++

${description}

<script type="module">
import init from "../../wasm/${example}.js";
window.addEventListener("load", () => {
  init();
});
</script>

<div style="width: 960px; margin-left: auto; margin-right: auto;">
<canvas id="chuot"></canvas>
</div>

[Source](https://github.com/tversteeg/chuot/blob/main/examples/${example}.rs)

```rust
${code}
```
