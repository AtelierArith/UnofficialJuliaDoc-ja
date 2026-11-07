```julia
styerr!(state::State, message::AbstractString, position::Union{Nothing, Int}=nothing, hint::String="around here")
```

`position`（判明している場合は、場所を特定する一定の`hint`とともに）またはその周辺にある誤った内容に基づいて、エラーの内容を`message`で示し、`state`にエラーを登録します。
