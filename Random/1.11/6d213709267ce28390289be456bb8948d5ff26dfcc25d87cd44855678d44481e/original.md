```julia
randstring([rng=default_rng()], [chars], [len=8])
```

Create a random string of length `len`, consisting of characters from `chars`, which defaults to the set of upper- and lower-case letters and the digits 0-9. The optional `rng` argument specifies a random number generator, see [Random Numbers](@ref).

# Examples

```jldoctest
julia> Random.seed!(3); randstring()
"Lxz5hUwn"

julia> randstring(Xoshiro(3), 'a':'z', 6)
"iyzcsm"

julia> randstring("ACGT")
"TGCTCCTC"
```

!!! note
    `chars` can be any collection of characters, of type `Char` or `UInt8` (more efficient), provided [`rand`](@ref) can randomly pick characters from it.

