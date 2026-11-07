```julia
author(c::GitCommit)
```

コミット `c` の作成者の `Signature` を返します。作成者とは、該当するファイルに変更を加えた人のことです。[`committer`](@ref) も参照してください。
