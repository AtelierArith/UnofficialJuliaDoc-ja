```julia
struct PartialStruct
    typ
    undefs::Vector{Union{Nothing,Bool}} # represents whether a given field may be undefined
    fields::Vector{Any} # i-th element describes the lattice element for the i-th defined field
end
```

This extended lattice element is introduced when we have information about an object's fields beyond what can be obtained from the object type. E.g. it represents a tuple where some elements are known to be constants or a struct whose `Any`-typed field is initialized with value whose type is concrete.

  * `typ` indicates the type of the object
  * `undefs` records defined-ness of each field
  * `fields` holds the lattice elements corresponding to each field of the object

`fields` corresponds to the fields that `typ` can have. If `typ` is a struct that can have `n` fields, then `length(fields) == n`. A special case: if `typ` is a variable-length `Tuple`, then `length(fields) == datatype_min_ninitialized(typ) + 1`. The last element represents the `Vararg` element.

`undefs` is a `Vector{Union{Nothing,Bool}}` with the same length as `fields`, encoding the following information about field defined-ness:

  * `undefs[i] === nothing` indicates the corresponding element in `fields` may be undefined
  * `undefs[i] === false` indicates the corresponding element in `fields` is guaranteed to be defined
  * `undefs[i] === true` indicates the corresponding element in `fields` is guaranteed to be undefined

If `field[i]` is of type `Union{}`, it means the `i`-th field is never be initialized and thus never be defined. In this case, `undefs[i]` should always be `true`.

The same applies if `typ` is a `Tuple`, and because of how `Tuple` elements are initialized, `undefs[i] === false` holds except that `undefs[end]` may be `nothing` when the last element is `Vararg`.
