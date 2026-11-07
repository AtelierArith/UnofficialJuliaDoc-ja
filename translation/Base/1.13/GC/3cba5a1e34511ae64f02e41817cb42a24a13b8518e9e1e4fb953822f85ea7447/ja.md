```julia
GC.@preserve x1 x2 ... xn expr
```

式 `expr` の評価中、オブジェクト `x1, x2, ...` を「使用中」としてマークします。これは、`expr` が `x` のいずれかが所有するメモリやその他のリソースを「暗黙的に使用する」安全でないコードでのみ必要です。

`x` の「暗黙的な使用」とは、コンパイラが認識できない、`x` が論理的に所有するリソースの間接的な使用を指します。例を挙げます。

  * `Ptr` を介してオブジェクトのメモリに直接アクセスする
  * `x` へのポインターを `ccall` に渡す
  * ファイナライザーによってクリーンアップされる `x` のリソースを使用する

通常のユースケースでは、`@preserve` によってオブジェクトの寿命が一時的に延びても、一般にパフォーマンスへの影響はありません。実装上、`@preserve` には、動的に割り当てられたオブジェクトをガベージコレクションから保護するなどの効果があります。

# Examples

`unsafe_load` を使ってポインターから読み込む場合、参照先のオブジェクトは暗黙的に使用されます。たとえば、次の例では `unsafe_load(p)` によって `x` が暗黙的に使用されます。

```jldoctest
julia> let
           x = Ref{Int}(101)
           p = Base.unsafe_convert(Ptr{Int}, x)
           GC.@preserve x unsafe_load(p)
       end
101
```

`ccall` にポインターを渡す場合、ポインターが指すオブジェクトは暗黙的に使用されるため、保持しておく必要があります。ただし通常は、`x` を `ccall` に直接渡せば十分です。これは明示的な使用として扱われます。

```jldoctest
julia> let
           x = "Hello"
           p = pointer(x)
           Int(GC.@preserve x @ccall strlen(p::Cstring)::Csize_t)
           # Preferred alternative
           Int(@ccall strlen(x::Cstring)::Csize_t)
       end
5
```
