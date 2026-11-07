```julia
Ref{T}
```

型 `T` のデータを安全に参照するオブジェクトです。この型は、正しい型の有効な Julia 割り当てメモリを指すことが保証されています。`Ref` 自体が参照されている限り、ガベージコレクターによって参照先のデータが解放されることはありません。

Julia では、`Ref` オブジェクトの参照先の値を読み書きするには、`[]` を使います。

型 `T` の値 `x` への `Ref` の作成には、通常 `Ref(x)` と記述します。また、Array や Ptr などのコンテナー内を指すポインターを作成する場合は、`a` の `i` 番目の要素への参照を作成するために、`Ref(a, i)` と記述できます。

`Ref{T}()` は、初期化せずに型 `T` の値への参照を作成します。ビット型の `T` の場合、値は割り当てられたメモリに現在格納されているものになります。ビット型でない `T` の場合、参照は未定義となり、参照先の値を読み取ろうとすると、"UndefRefError: access to undefined reference" エラーが発生します。

`Ref` が未定義の参照かどうかを確認するには、[`isassigned(ref::RefValue)`](@ref) を使います。たとえば、`T` がビット型でない場合、`isassigned(Ref{T}())` は `false` です。`T` がビット型の場合、`isassigned(Ref{T}())` は常に true になります。

`Ref` オブジェクトを `ccall` 引数として渡すと（`Ptr` 型または `Ref` 型として）、参照先データへのネイティブポインターに変換されます。ほとんどの `T` の場合、または `Ptr{Cvoid}` に変換する場合、これはオブジェクトデータへのポインターです。`T` が `isbits` 型の場合、この値は安全に変更できます。それ以外の場合、変更は厳密に未定義動作となります。

特例として、`T = Any` を設定すると、`Ptr{Any}`（T が不変なら `jl_value_t const* const*`、そうでなければ `jl_value_t *const *`）に変換したとき、参照そのものへのポインターが作成されます。`Ptr{Cvoid}` に変換した場合は、他の `T` と同様に、引き続きデータ領域へのポインターが返されます。

`Ptr` の `C_NULL` インスタンスは、初期化するために `ccall` `Ref` 引数に渡すことができます。

# Use in broadcasting

`Ref` は、参照先の値をスカラーとして扱うため、ブロードキャストで使われることがあります。

# Examples

```jldoctest
julia> r = Ref(5) # Create a Ref with an initial value
Base.RefValue{Int64}(5)

julia> r[] # Getting a value from a Ref
5

julia> r[] = 7 # Storing a new value in a Ref
7

julia> r # The Ref now contains 7
Base.RefValue{Int64}(7)

julia> isa.(Ref([1,2,3]), [Array, Dict, Int]) # Treat reference values as scalar during broadcasting
3-element BitVector:
 1
 0
 0

julia> Ref{Function}()  # Undefined reference to a non-bitstype, Function
Base.RefValue{Function}(#undef)

julia> try
           Ref{Function}()[] # Dereferencing an undefined reference will result in an error
       catch e
           println(e)
       end
UndefRefError()

julia> Ref{Int64}()[]; # A reference to a bitstype refers to an undetermined value if not given

julia> isassigned(Ref{Int64}()) # A reference to a bitstype is always assigned
true
```
