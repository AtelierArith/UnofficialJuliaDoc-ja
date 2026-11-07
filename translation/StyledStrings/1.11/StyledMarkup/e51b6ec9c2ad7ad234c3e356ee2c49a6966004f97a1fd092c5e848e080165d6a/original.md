```julia
read_annotation!(state::State, i::Int, char::Char, newstyles::Vector) -> Bool
```

Read the annotations at `i` (`char`), and push the style read to `newstyles`.

This skips whitespace and checks what the next character in `state.s` is, detects the form of the annotation, and parses it using the appropriate specialised function like so:

  * `:`, end of annotation, do nothing
  * `(`, inline face declaration, use `read_inlineface!`
  * otherwise, use `read_face_or_keyval!`

After parsing the annotation, returns a boolean value signifying whether there is an immediately subsequent annotation to be read.
