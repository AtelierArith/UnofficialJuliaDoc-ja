```julia
styerr!(state::State, message::AbstractString, position::Union{Nothing, Int}=nothing, hint::String="around here")
```

誤りがある場合は、`position`の内容、またはその前後の内容に基づいて、`state`にエラーを登録します（場所が分かる場合は、`hint`で場所を指定します）。エラーの内容は`message`で示します。
