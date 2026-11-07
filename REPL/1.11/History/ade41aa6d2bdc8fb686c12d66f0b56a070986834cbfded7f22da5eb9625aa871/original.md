```julia
focus_matches(search::FilterSpec, content::AnnotatedString, targetwidth::Int) -> AnnotatedString
```

Center and trim `content` around matching regions, adding ellipses.

To best display matches, this function operates in multiple stages:

1. Find all matching character ranges in `content` via `matchregions(search, String(content))`.
2. Choose a primary match region that can be fully shown within `targetwidth`, preferring the first match.
3. Starting from the end of that region, expand a window leftwards up to `targetwidth`, accounting for character widths.
4. If the left bound exceeds the start of `content`, reserve space for a leading ellipsis (`LINE_ELLIPSIS`) and adjust the window.
5. Expand the window rightwards similarly, inserting a trailing ellipsis if there is remaining text.
6. Slice out the computed substring from `content`, preserving existing annotations.
7. Re-apply the match highlight face (`:REPL_History_search_match`) to any regions within the window.
8. Pad the result with spaces if its width is less than `targetwidth`.

The returned `AnnotatedString` is exactly `targetwidth` columns wide, guaranteeing at least one full match is visible and highlighted.
