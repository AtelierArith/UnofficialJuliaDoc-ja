```julia
struct PartialStruct
    typ
    undefs::Vector{Union{Nothing,Bool}} # represents whether a given field may be undefined
    fields::Vector{Any} # i-th element describes the lattice element for the i-th defined field
end
```

この拡張ラティス要素は、オブジェクトの型から得られる情報を超えて、そのフィールドに関する情報がある場合に導入されます。たとえば、一部の要素が定数であると分かっているタプルや、`Any` 型のフィールドが具象型の値で初期化されている構造体を表します。

  * `typ` はオブジェクトの型を示します
  * `undefs` は各フィールドが定義済みかどうかを記録します
  * `fields` はオブジェクトの各フィールドに対応するラティス要素を保持します

`fields` は、`typ` が持ち得るフィールドに対応します。`typ` が `n` 個のフィールドを持ち得る構造体なら、`length(fields) == n` です。特別なケースとして、`typ` が可変長の `Tuple` である場合は、`length(fields) == datatype_min_ninitialized(typ) + 1` です。最後の要素は `Vararg` 要素を表します。

`undefs` は、`fields` と同じ長さの `Vector{Union{Nothing,Bool}}` であり、フィールドが定義済みかどうかについて次の情報を符号化します。

  * `undefs[i] === nothing` は、`fields` の対応する要素が未定義である可能性を示します
  * `undefs[i] === false` は、`fields` の対応する要素が必ず定義済みであることを示します
  * `undefs[i] === true` は、`fields` の対応する要素が必ず未定義であることを示します

`field[i]` の型が `Union{}` である場合、`i` 番目のフィールドは初期化されることがなく、したがって定義済みになることもありません。この場合、`undefs[i]` は常に `true` である必要があります。

`typ` が `Tuple` である場合も同様です。また、`Tuple` 要素の初期化方法により、`undefs[i] === false` が成り立ちます。ただし、最後の要素が `Vararg` の場合は、`undefs[end]` が `nothing` となることがあります。
