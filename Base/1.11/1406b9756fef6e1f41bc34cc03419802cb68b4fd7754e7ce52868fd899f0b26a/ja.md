```
Ref{T}
```

型 `T` のデータを安全に参照するオブジェクトです。この型は、正しい型の有効な、Julia によって割り当てられたメモリを指すことが保証されています。基になるデータは、`Ref` 自体が参照されている限り、ガーベジコレクタによって解放されることから保護されています。

Julia では、`Ref` オブジェクトは `[]` を使ってデリファレンス（読み込みまたは格納）されます。

型 `T` の値 `x` への `Ref` の作成は通常 `Ref(x)` と書かれます。さらに、コンテナ（Array や Ptr など）への内部ポインタを作成するためには、`Ref(a, i)` と書くことで、`a` の `i` 番目の要素への参照を作成できます。

`Ref{T}()` は初期化なしで型 `T` の値への参照を作成します。ビット型 `T` の場合、値は現在割り当てられているメモリに存在するものになります。非ビット型 `T` の場合、参照は未定義となり、デリファレンスを試みるとエラー "UndefRefError: access to undefined reference" が発生します。

`Ref` が未定義の参照かどうかを確認するには、[`isassigned(ref::RefValue)`](@ref) を使用します。例えば、`isassigned(Ref{T}())` は `T` がビット型でない場合 `false` になります。`T` がビット型の場合、`isassigned(Ref{T}())` は常に true になります。

`ccall` 引数（`Ptr` または `Ref` 型のいずれか）として渡されると、`Ref` オブジェクトは参照するデータへのネイティブポインタに変換されます。ほとんどの `T` に対して、または `Ptr{Cvoid}` に変換された場合、これはオブジェクトデータへのポインタです。`T` が `isbits` 型の場合、この値は安全に変更できますが、そうでない場合は変更は厳密に未定義の動作となります。

特別なケースとして、`T = Any` を設定すると、`Ptr{Any}` に変換されたときに参照自体へのポインタが作成されます（`T` が不変の場合は `jl_value_t const* const*`、そうでない場合は `jl_value_t *const *`）。`Ptr{Cvoid}` に変換された場合でも、他の `T` と同様にデータ領域へのポインタが返されます。

`C_NULL` インスタンスの `Ptr` を `ccall` の `Ref` 引数に渡して初期化することができます。

# ブロードキャスティングでの使用

`Ref` は、参照された値をスカラーとして扱うために、ブロードキャスティングで使用されることがあります。

# 例

```jldoctest
julia> r = Ref(5) # 初期値を持つ Ref を作成
Base.RefValue{Int64}(5)

julia> r[] # Ref から値を取得
5

julia> r[] = 7 # Ref に新しい値を格納
7

julia> r # Ref は現在 7 を含んでいる
Base.RefValue{Int64}(7)

julia> isa.(Ref([1,2,3]), [Array, Dict, Int]) # ブロードキャスティング中に参照値をスカラーとして扱う
3-element BitVector:
 1
 0
 0

julia> Ref{Function}()  # 非ビット型 Function への未定義の参照
Base.RefValue{Function}(#undef)

julia> try
           Ref{Function}()[] # 未定義の参照をデリファレンスするとエラーが発生
       catch e
           println(e)
       end
UndefRefError()

julia> Ref{Int64}()[]; # ビット型への参照は与えられない場合は未定義の値を参照する

julia> isassigned(Ref{Int64}()) # ビット型への参照は常に割り当てられている
true
```
