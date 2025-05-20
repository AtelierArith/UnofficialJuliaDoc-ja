```
current(rb::GitRebase) -> Csize_t
```

現在の [`RebaseOperation`](@ref) のインデックスを返します。まだ操作が適用されていない場合（[`GitRebase`](@ref) が構築されたが `next` がまだ呼ばれていないか、`rb` の反復がまだ始まっていない場合）、`GIT_REBASE_NO_OPERATION` を返します。これは `typemax(Csize_t)` に等しいです。
