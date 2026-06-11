const express = require("express");
const path = require("path");
const fs = require("fs");

const app = express();
const root = __dirname;
const port = process.env.PORT || 3000;

app.set("view engine", "ejs");
app.set("views", path.join(root, "views"));

app.use("/assets", express.static(path.join(root, "assets"), {
  immutable: true,
  maxAge: "1y"
}));

// Pages principales
app.get("/", (req, res) => res.render("index", { currentPage: "home" }));
app.get("/actualites", (req, res) => res.render("actualites", { currentPage: "actualites" }));
app.get("/rejoindre", (req, res) => res.render("rejoindre", { currentPage: "rejoindre" }));

// Routes pages dédiées
app.get("/services",  (req, res) => res.render("services",  { currentPage: "services" }));
app.get("/about",     (req, res) => res.render("about",     { currentPage: "about" }));
app.get("/values",    (req, res) => res.render("values",    { currentPage: "values" }));
app.get("/approach",  (req, res) => res.render("approach",  { currentPage: "approach" }));
app.get("/contact",   (req, res) => res.render("contact",   { currentPage: "contact" }));

// Pages offres d'emploi
app.get("/nous-rejoindre/:slug", (req, res) => {
  const view = `nous-rejoindre/${req.params.slug}`;
  const filePath = path.join(root, "views", view + ".ejs");
  if (!fs.existsSync(filePath)) return res.status(404).send("Page non trouvée");
  res.render(view, { currentPage: "rejoindre" });
});

app.use((req, res) => res.status(404).send("Page non trouvée"));

app.listen(port, () => {
  console.log(`Move2Cloud Tunisie website listening on port ${port}`);
});
