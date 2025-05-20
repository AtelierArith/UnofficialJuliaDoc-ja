```
x::EscapeInfo
```

A lattice for escape information, which holds the following properties:

  * `x.Analyzed::Bool`: not formally part of the lattice, only indicates whether `x` has been analyzed
  * `x.ReturnEscape::Bool`: indicates `x` can escape to the caller via return
  * `x.ThrownEscape::BitSet`: records SSA statement numbers where `x` can be thrown as exception:

      * `isempty(x.ThrownEscape)`: `x` will never be thrown in this call frame (the bottom)
      * `pc ∈ x.ThrownEscape`: `x` may be thrown at the SSA statement at `pc`
      * `-1 ∈ x.ThrownEscape`: `x` may be thrown at arbitrary points of this call frame (the top)

    This information will be used by `escape_exception!` to propagate potential escapes via exception.
  * `x.AliasInfo::Union{Bool,IndexableFields,IndexableElements,Unindexable}`: maintains all possible values that can be aliased to fields or array elements of `x`:

      * `x.AliasInfo === false` indicates the fields/elements of `x` aren't analyzed yet
      * `x.AliasInfo === true` indicates the fields/elements of `x` can't be analyzed, e.g. the type of `x` is not known or is not concrete and thus its fields/elements can't be known precisely
      * `x.AliasInfo::IndexableFields` records all the possible values that can be aliased to fields of object `x` with precise index information
      * `x.AliasInfo::IndexableElements` records all the possible values that can be aliased to elements of array `x` with precise index information
      * `x.AliasInfo::Unindexable` records all the possible values that can be aliased to fields/elements of `x` without precise index information
  * `x.Liveness::BitSet`: records SSA statement numbers where `x` should be live, e.g. to be used as a call argument, to be returned to a caller, or preserved for `:foreigncall`:

      * `isempty(x.Liveness)`: `x` is never be used in this call frame (the bottom)
      * `0 ∈ x.Liveness` also has the special meaning that it's a call argument of the currently analyzed call frame (and thus it's visible from the caller immediately).
      * `pc ∈ x.Liveness`: `x` may be used at the SSA statement at `pc`
      * `-1 ∈ x.Liveness`: `x` may be used at arbitrary points of this call frame (the top)

There are utility constructors to create common `EscapeInfo`s, e.g.,

  * `NoEscape()`: the bottom(-like) element of this lattice, meaning it won't escape to anywhere
  * `AllEscape()`: the topmost element of this lattice, meaning it will escape to everywhere

`analyze_escapes` will transition these elements from the bottom to the top, in the same direction as Julia's native type inference routine. An abstract state will be initialized with the bottom(-like) elements:

  * the call arguments are initialized as `ArgEscape()`, whose `Liveness` property includes `0` to indicate that it is passed as a call argument and visible from a caller immediately
  * the other states are initialized as `NotAnalyzed()`, which is a special lattice element that is slightly lower than `NoEscape`, but at the same time doesn't represent any meaning other than it's not analyzed yet (thus it's not formally part of the lattice)
