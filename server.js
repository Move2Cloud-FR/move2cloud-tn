const express = require("express");
const path = require("path");

const app = express();
const root = __dirname;
const port = process.env.PORT || 3000;

app.use("/assets", express.static(path.join(root, "assets"), {
  immutable: true,
  maxAge: "1y"
}));

app.use(
  express.static(root, {
    dotfiles: "ignore",
    extensions: ["html"],
    index: "index.html",
    maxAge: "1h"
  })
);

app.get("*", (_req, res) => {
  res.sendFile(path.join(root, "index.html"));
});

app.listen(port, () => {
  console.log(`Move2Cloud Tunisie website listening on port ${port}`);
});
