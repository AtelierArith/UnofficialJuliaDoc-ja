```julia
highlight(io, x; color, note, notecolor,
          context_lines_before, context_lines_inner, context_lines_after)

highlight(io::IO, source::SourceFile, range::UnitRange; kws...)
```

Print the lines of source code surrounding `x` which is highlighted with background `color` and underlined with markers in the text. A `note` in `notecolor` may be provided as annotation. By default, `x` should be an object with `sourcefile(x)` and `byte_range(x)` implemented.

The context arguments `context_lines_before`, etc, refer to the number of lines of code which will be printed as context before and after, with `inner` referring to context lines inside a multiline region.

The second form shares the keywords of the first but allows an explicit source file and byte range to be supplied.
