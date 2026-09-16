# Post-render rewrite, run automatically by Quarto after every `quarto render`
# (see project.post-render in _quarto.yml).
#
# Quarto builds sitemap.xml from output paths, so every page lands in it as
# .../who/index.html. The pages themselves declare the directory form as
# canonical (format.html.canonical-url in _quarto.yml), so the sitemap hands
# Google a set of URLs that each point, by canonical, at a different address.
# Google honours the canonical either way — but the Sitemaps report then shows
# every submitted URL indexed under a URL that was never submitted. Stripping
# the trailing index.html makes the sitemap agree with the canonicals.
#
# This does NOT stop Google finding the index.html form: the navbar links to it
# from every page. Those URLs stay in the index as "alternate page with proper
# canonical tag", which is the canonical tags working, not a problem to fix.
#
# Matched as a fixed string, not a regex, so only a literal trailing
# index.html inside a <loc> is touched — pages that are genuinely named files
# (slides/..., interactive/stacks.html) are left alone.
out <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
sitemap <- file.path(out, "sitemap.xml")
target <- "/index.html</loc>"
if (file.exists(sitemap)) {
  lines <- readLines(sitemap, warn = FALSE)
  hits <- sum(lengths(regmatches(lines, gregexpr(target, lines, fixed = TRUE))))
  if (hits) {
    writeLines(gsub(target, "/</loc>", lines, fixed = TRUE), sitemap)
    cat("post-render: rewrote", hits, "sitemap URLs to canonical form\n")
  }
}
