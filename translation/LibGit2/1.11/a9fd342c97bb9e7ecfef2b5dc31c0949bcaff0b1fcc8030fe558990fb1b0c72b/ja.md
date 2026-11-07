```julia
current(rb::GitRebase)::Csize_t
```

現在の[`RebaseOperation`](@ref)のインデックスを返します。まだ操作が適用されていない場合（[`GitRebase`](@ref)は構築されているものの、`next`がまだ呼び出されていない、または`rb`の反復がまだ始まっていない場合）は、`GIT_REBASE_NO_OPERATION`を返します。これは`typemax(Csize_t)`と等しい値です。
