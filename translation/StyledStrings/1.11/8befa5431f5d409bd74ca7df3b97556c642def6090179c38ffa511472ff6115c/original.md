```
termcolor(io::IO, color::SimpleColor, category::Char)
```

Print to `io` the SGR code to set the `category`'s slot to `color`, where `category` is set as follows:

  * `'3'` sets the foreground color
  * `'4'` sets the background color
  * `'5'` sets the underline color

If `color` is a `SimpleColor{Symbol}`, the value should be a a member of `ANSI_4BIT_COLORS`. Any other value will cause the color to be reset.

If `color` is a `SimpleColor{RGBTuple}` and `get_have_truecolor()` returns true, 24-bit color is used. Otherwise, an 8-bit approximation of `color` is used.
