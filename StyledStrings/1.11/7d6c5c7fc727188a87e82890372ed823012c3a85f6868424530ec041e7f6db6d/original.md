A [`Face`](@ref) is a collection of graphical attributes for displaying text. Faces control how text is displayed in the terminal, and possibly other places too.

Most of the time, a [`Face`](@ref) will be stored in the global faces dicts as a unique association with a *face name* Symbol, and will be most often referred to by this name instead of the [`Face`](@ref) object itself.

# Attributes

All attributes can be set via the keyword constructor, and default to `nothing`.

  * `height` (an `Int` or `Float64`): The height in either deci-pt (when an `Int`), or as a factor of the base size (when a `Float64`).
  * `weight` (a `Symbol`): One of the symbols (from faintest to densest) `:thin`, `:extralight`, `:light`, `:semilight`, `:normal`, `:medium`, `:semibold`, `:bold`, `:extrabold`, or `:black`. In terminals any weight greater than `:normal` is displayed as bold, and in terminals that support variable-brightness text, any weight less than `:normal` is displayed as faint.
  * `slant` (a `Symbol`): One of the symbols `:italic`, `:oblique`, or `:normal`.
  * `foreground` (a `SimpleColor`): The text foreground color.
  * `background` (a `SimpleColor`): The text background color.
  * `underline`, the text underline, which takes one of the following forms:

      * a `Bool`: Whether the text should be underlined or not.
      * a `SimpleColor`: The text should be underlined with this color.
      * a `Tuple{Nothing, Symbol}`: The text should be underlined using the style set by the Symbol, one of `:straight`, `:double`, `:curly`, `:dotted`, or `:dashed`.
      * a `Tuple{SimpleColor, Symbol}`: The text should be underlined in the specified SimpleColor, and using the style specified by the Symbol, as before.
  * `strikethrough` (a `Bool`): Whether the text should be struck through.
  * `inverse` (a `Bool`): Whether the foreground and background colors should be inverted.
  * `inherit` (a `Vector{Symbol}`): Names of faces to inherit from, with earlier faces taking priority. All faces inherit from the `:default` face.
