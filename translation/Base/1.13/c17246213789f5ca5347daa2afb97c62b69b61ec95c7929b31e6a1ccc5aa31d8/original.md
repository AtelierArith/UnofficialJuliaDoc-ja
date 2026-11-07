```julia
_xfadjoint(op, itr) -> op′, itr′
```

Given a pair of reducing function `op` and an iterator `itr`, return a pair `(op′, itr′)` of similar types.  If the iterator `itr` is transformed by an iterator transform `ixf` whose adjoint transducer `xf` is known, `op′ = xf(op)` and `itr′ = ixf⁻¹(itr)` is returned.  Otherwise, `op` and `itr` are returned as-is.  For example, transducer `rf -> MappingRF(f, rf)` is the adjoint of iterator transform `itr -> Generator(f, itr)`.

Nested iterator transforms are converted recursively.  That is to say, given `op` and

```julia
itr = (ixf₁ ∘ ixf₂ ∘ ... ∘ ixfₙ)(itr′)
```

what is returned is `itr′` and

```julia
op′ = (xfₙ ∘ ... ∘ xf₂ ∘ xf₁)(op)
```
