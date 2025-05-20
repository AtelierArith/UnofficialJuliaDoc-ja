```
upstream(ref::GitReference) -> Union{GitReference, Nothing}
```

`ref`を含むブランチが指定されたアップストリームブランチを持っているかどうかを判断します。

アップストリームブランチが存在する場合は`GitReference`を返し、要求されたブランチにアップストリームの対応がない場合は[`nothing`](@ref)を返します。
