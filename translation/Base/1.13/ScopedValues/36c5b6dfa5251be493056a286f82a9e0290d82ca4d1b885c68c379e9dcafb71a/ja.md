```julia
LazyScopedValue{T}(f::OncePerProcess{T})
```

現在のスコープで値が設定されていない場合に、`OncePerProcess{T}`を使ってデフォルト値を遅延計算するスコープ付きの値です。`ScopedValue`とは異なり、デフォルト値は構築時には評価されず、初めてアクセスされたときにのみ評価されます。

# Examples

```julia-repl
julia> using Base.ScopedValues;

julia> const editor = LazyScopedValue(OncePerProcess(() -> ENV["JULIA_EDITOR"]));

julia> editor[]
"vim"

julia> with(editor => "emacs") do
           sval[]
       end
"emacs"

julia> editor[]
"vim"
```

!!! compat "Julia 1.13"
    LazyScopedValueにはJulia 1.13以降が必要です。

