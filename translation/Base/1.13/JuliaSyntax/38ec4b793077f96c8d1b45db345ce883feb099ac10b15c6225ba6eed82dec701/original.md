```julia
_printstyled(io::IO, text;
             fgcolor=nothing, bgcolor=nothing, href=nothing)
```

Like Base.printstyled, but allows providing RGB colors for true color terminals, both foreground and background colors, and hyperlinks. Colors may be given as one of the standard color names as in `Base.printstyled`, an integer for 256 color terms, or an (r,g,b) triple with `0 <= r <= 255` etc for true color terminals.

  * `fgcolor` - set foreground color
  * `bgcolor` - set background color
  * `href`    - set hyperlink reference
