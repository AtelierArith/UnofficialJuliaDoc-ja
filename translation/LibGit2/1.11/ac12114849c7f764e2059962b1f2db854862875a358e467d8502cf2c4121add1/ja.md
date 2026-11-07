```julia
author(c::GitCommit)
```

コミットの作成者 `c` の `Signature` を返します。作成者とは、該当するファイルに変更を加えた人のことです。詳しくは [`committer`](@ref) を参照してください。
