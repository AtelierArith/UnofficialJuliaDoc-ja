```
let
```

`let` ブロックは新しいハードスコープを作成し、オプションで新しいローカルバインディングを導入します。

他のスコープ構造と同様に、`let` ブロックは新しく導入されたローカル変数がアクセス可能なコードのブロックを定義します。さらに、構文はカンマ区切りの代入と、`let` と同じ行にオプションで現れる変数名に特別な意味を持ちます。

```julia
let var1 = value1, var2, var3 = value3
    code
end
```

この行で導入された変数は `let` ブロックにローカルであり、代入は順番に評価され、各右辺は左辺の名前を考慮せずにスコープ内で評価されます。したがって、`let x = x` のように書くことは理にかなっています。なぜなら、2つの `x` 変数は異なり、左辺が外部スコープの `x` をローカルにシャドウイングしているからです。これは、ローカルスコープに入るたびに新しいローカル変数が新たに作成されるため、特にクロージャを介してスコープを超えて生き残る変数の場合に有用なイディオムとなることがあります。上記の例の `var2` のように、代入なしの `let` 変数は、まだ値にバインドされていない新しいローカル変数を宣言します。

対照的に、[`begin`](@ref) ブロックは複数の式をまとめますが、スコープを導入したり、特別な代入構文を持ったりはしません。

### 例

以下の関数では、単一の `x` が `map` によって3回反復的に更新されます。返されるクロージャはすべてその1つの `x` を最終値で参照します。

```jldoctest
julia> function test_outer_x()
           x = 0
           map(1:3) do _
               x += 1
               return ()->x
           end
       end
test_outer_x (generic function with 1 method)

julia> [f() for f in test_outer_x()]
3-element Vector{Int64}:
 3
 3
 3
```

しかし、*新しい* ローカル変数を導入する `let` ブロックを追加すると、同じ名前を使用（シャドウ）することを選んでも、3つの異なる変数がキャプチャされることになります（各反復ごとに1つ）。

```jldoctest
julia> function test_let_x()
           x = 0
           map(1:3) do _
               x += 1
               let x = x
                   return ()->x
               end
           end
       end
test_let_x (generic function with 1 method)

julia> [f() for f in test_let_x()]
3-element Vector{Int64}:
 1
 2
 3
```

新しいローカル変数を導入するすべてのスコープ構造は、繰り返し実行されるとこのように動作します。`let` の特徴的な機能は、同じ名前の外部変数をシャドウイングする新しい `local` を簡潔に宣言できることです。たとえば、`do` 関数の引数を直接使用することも、同様に3つの異なる変数をキャプチャします。

```jldoctest
julia> function test_do_x()
           map(1:3) do x
               return ()->x
           end
       end
test_do_x (generic function with 1 method)

julia> [f() for f in test_do_x()]
3-element Vector{Int64}:
 1
 2
 3
```
