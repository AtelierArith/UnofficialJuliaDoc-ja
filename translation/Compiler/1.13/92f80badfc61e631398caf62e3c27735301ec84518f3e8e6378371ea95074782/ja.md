```julia
info::ApplyCallInfo <: CallInfo
```

この情報は、`_apply_iterate(...)`の呼び出しに適用され、実際に適用される呼び出しの情報と、`iterate`関数への暗黙的な呼び出しに関する情報の両方を含みます。呼び出し自体がさらに別の`_apply_iterate`である場合もあり、その場合、`info.call`フィールドは別の`ApplyCallInfo`になります。この情報は、`_apply_iterate`呼び出し以外の文では使用できません。
