```julia
info::UnionSplitApplyCallInfo <: CallInfo
```

`UnionSplitInfo`と同様ですが、`MethodMatchInfo`ではなく`ApplyCallInfo`を対象とします。この情報は、`_apply_iterate`呼び出し以外の文では使用できません。
