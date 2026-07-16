# Post-render cleanup, run automatically by Quarto after every `quarto render`
# (see project.post-render in _quarto.yml).
#
# The reveal.js talk in slides/slides/ copies its own .qmd source into the
# output dir during render. Left there, that stray is picked up as an input on
# the NEXT render and re-rendered into docs/docs/..., the nesting that used to
# accumulate. Deleting strays here — after render, before the next one — retires
# that bug without excluding the deck (which would empty the Slides listing and
# prune the committed deck HTML).
out <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
strays <- list.files(out, pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
if (length(strays)) {
  file.remove(strays)
  cat("post-render: removed", length(strays), "stray .qmd from", out, "\n")
}
