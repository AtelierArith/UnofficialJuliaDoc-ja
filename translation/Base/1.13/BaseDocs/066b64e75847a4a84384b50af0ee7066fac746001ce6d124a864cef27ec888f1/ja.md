```julia
function
```

関数は、`function` キーワードを使って定義します。

```julia
function add(a, b)
    return a + b
end
```

または、短縮形の記法を使います。

```julia
add(a, b) = a + b
```

[`return`](@ref) キーワードの使い方は他の言語とまったく同じですが、省略できることもよくあります。明示的な `return` 文がない関数は、関数本体の最後の式を返します。
