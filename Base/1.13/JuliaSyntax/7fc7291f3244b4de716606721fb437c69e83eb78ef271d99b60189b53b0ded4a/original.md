```julia
# Parse a single expression/statement
parsestmt(TreeType, text, [index];
          version=VERSION,
          ignore_trivia=true,
          filename=nothing,
          ignore_errors=false,
          ignore_warnings=ignore_errors)

# Parse all statements at top level (file scope)
parseall(...)

# Parse a single syntax atom
parseatom(...)
```

Parse Julia source code string `text` into a data structure of type `TreeType`. `parsestmt` parses a single Julia statement, `parseall` parses top level statements at file scope and `parseatom` parses a single Julia identifier or other "syntax atom".

If `text` is passed without `index`, all the input text must be consumed and a tree data structure is returned. When an integer byte `index` is passed, a tuple `(tree, next_index)` will be returned containing the next index in `text` to resume parsing. By default whitespace and comments before and after valid code are ignored but you can turn this off by setting `ignore_trivia=false`.

`version` (default `VERSION`) may be used to set the syntax version to any Julia version `>= v"1.0"`. We aim to parse all Julia syntax which has been added after v"1.0", emitting an error if it's not compatible with the requested `version`.

Pass `filename` to set any file name information embedded within the output tree, if applicable. This will also annotate errors and warnings with the source file name.

A `ParseError` will be thrown if any errors or warnings occurred during parsing. To avoid exceptions due to warnings, use `ignore_warnings=true`. To also avoid exceptions due to errors, use `ignore_errors=true`.
