```
tryparsenext(tok::AbstractDateToken, str::String, i::Int, len::Int, locale::DateLocale)
```

`tryparsenext` parses for the `tok` token in `str` starting at index `i`. `len` is the length of the string.  parsing can be optionally based on the `locale`. If a `tryparsenext` method does not need a locale, it can leave the argument out in the method definition.

If parsing succeeds, returns a tuple of 2 elements `(res, idx)`, where:

  * `res` is the result of the parsing.
  * `idx::Int`, is the index *after* the index at which parsing ended.
