The `AbstractString` type is the supertype of all string implementations in Julia. Strings are encodings of sequences of [Unicode](https://unicode.org/) code points as represented by the `AbstractChar` type. Julia makes a few assumptions about strings:

  * Strings are encoded in terms of fixed-size "code units"

      * Code units can be extracted with `codeunit(s, i)`
      * The first code unit has index `1`
      * The last code unit has index `ncodeunits(s)`
      * Any index `i` such that `1 ≤ i ≤ ncodeunits(s)` is in bounds
  * String indexing is done in terms of these code units:

      * Characters are extracted by `s[i]` with a valid string index `i`
      * Each `AbstractChar` in a string is encoded by one or more code units
      * Only the index of the first code unit of an `AbstractChar` is a valid index
      * The encoding of an `AbstractChar` is independent of what precedes or follows it
      * String encodings are [self-synchronizing](https://en.wikipedia.org/wiki/Self-synchronizing_code) – i.e. `isvalid(s, i)` is O(1)

Some string functions that extract code units, characters or substrings from strings error if you pass them out-of-bounds or invalid string indices. This includes `codeunit(s, i)` and `s[i]`. Functions that do string index arithmetic take a more relaxed approach to indexing and give you the closest valid string index when in-bounds, or when out-of-bounds, behave as if there were an infinite number of characters padding each side of the string. Usually these imaginary padding characters have code unit length `1` but string types may choose different "imaginary" character sizes as makes sense for their implementations (e.g. substrings may pass index arithmetic through to the underlying string they provide a view into). Relaxed indexing functions include those intended for index arithmetic: `thisind`, `nextind` and `prevind`. This model allows index arithmetic to work with out-of-bounds indices as intermediate values so long as one never uses them to retrieve a character, which often helps avoid needing to code around edge cases.

See also [`codeunit`](@ref), [`ncodeunits`](@ref), [`thisind`](@ref), [`nextind`](@ref), [`prevind`](@ref).
