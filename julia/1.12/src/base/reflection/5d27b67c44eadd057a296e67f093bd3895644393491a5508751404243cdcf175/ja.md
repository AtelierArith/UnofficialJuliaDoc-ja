# Reflection and introspection

Juliaはさまざまなランタイムリフレクション機能を提供します。

## Module bindings

`Module`の公開名は、[`names(m::Module)`](@ref)を使用して取得でき、これは公開バインディングを表す[`Symbol`](@ref)要素の配列を返します。`names(m::Module, all = true)`は、公開ステータスに関係なく、`m`内のすべてのバインディングのシンボルを返します。

## DataType fields

`DataType` フィールドの名前は [`fieldnames`](@ref) を使用して照会できます。たとえば、次の型がある場合、`fieldnames(Point)` はフィールド名を表す [`Symbol`](@ref) のタプルを返します：

```jldoctest struct_point
julia> struct Point
           x::Int
           y
       end

julia> fieldnames(Point)
(:x, :y)
```

`Point`オブジェクトの各フィールドの型は、`Point`変数自体の`types`フィールドに格納されています：

```jldoctest struct_point
julia> Point.types
svec(Int64, Any)
```

`x`は`Int`として注釈されていますが、`y`は型定義で注釈が付けられていないため、`y`は`Any`型にデフォルト設定されます。

型は `DataType` と呼ばれる構造体として表されます:

```jldoctest struct_point
julia> typeof(Point)
DataType
```

`fieldnames(DataType)` は `DataType` 自体の各フィールドの名前を返し、上記の例で観察された `types` フィールドの1つが含まれています。

## Subtypes

任意の `DataType` の *直接* サブタイプは [`subtypes`](@ref) を使用してリストできます。例えば、抽象 `DataType` [`AbstractFloat`](@ref) には4つの（具体的な）サブタイプがあります：

```jldoctest; setup = :(using InteractiveUtils)
julia> InteractiveUtils.subtypes(AbstractFloat)
5-element Vector{Any}:
 BigFloat
 Core.BFloat16
 Float16
 Float32
 Float64
```

このリストには任意の抽象サブタイプも含まれますが、そのさらなるサブタイプは含まれません。[`subtypes`](@ref) の再帰的な適用を使用して、完全な型ツリーを検査することができます。

[`subtypes`](@ref)は[`InteractiveUtils`](@ref man-interactive-utils)の中にありますが、REPLを使用すると自動的にエクスポートされます。

## DataType layout

`DataType`の内部表現は、Cコードとインターフェースを取る際に非常に重要であり、これらの詳細を調査するためのいくつかの関数が利用可能です。[`isbitstype(T::DataType)`](@ref)は、`T`がC互換のアライメントで格納されている場合にtrueを返します。[`fieldoffset(T::DataType, i::Integer)`](@ref)は、型の開始からフィールド*i*までの（バイト）オフセットを返します。

## Function methods

任意のジェネリック関数のメソッドは、[`methods`](@ref)を使用してリストできます。メソッドディスパッチテーブルは、[`methodswith`](@ref)を使用して、特定の型を受け入れるメソッドを検索できます。

## Expansion and lowering

[Metaprogramming](@ref) セクションで議論されたように、[`macroexpand`](@ref) 関数は、与えられたマクロのための引用されていないおよび補間された式 ([`Expr`](@ref)) を提供します。`macroexpand` を使用するには、式ブロック自体を `quote` してください（さもなければ、マクロが評価され、その結果が代わりに渡されます！）。例えば：

```jldoctest; setup = :(using InteractiveUtils)
julia> InteractiveUtils.macroexpand(@__MODULE__, :(@edit println("")) )
:(InteractiveUtils.edit(println, (Base.typesof)("")))
```

`Base.Meta.show_sexpr` と [`dump`](@ref) は、任意の式の S-expr スタイルのビューと深さネストされた詳細ビューを表示するために使用されます。

最後に、[`Meta.lower`](@ref) 関数は、任意の式の `lowered` 形式を提供し、言語構造が代入、分岐、呼び出しなどの原始的な操作にどのようにマッピングされるかを理解する上で特に重要です。

```jldoctest; setup = (using Base: +, sin)
julia> Meta.lower(@__MODULE__, :( [1+2, sin(0.5)] ))
:($(Expr(:thunk, CodeInfo(
1 ─ %1 = :+
│   %2 =   dynamic (%1)(1, 2)
│   %3 = sin
│   %4 =   dynamic (%3)(0.5)
│   %5 =   dynamic Base.vect(%2, %4)
└──      return %5
))))
```

## Intermediate and compiled representations

関数の低下した形式を検査するには、特定のメソッドを表示するための選択が必要です。なぜなら、一般的な関数には異なる型シグネチャを持つ多くのメソッドがあるからです。この目的のために、メソッド固有のコード低下が [`code_lowered`](@ref) を使用して利用可能であり、型推論された形式は [`code_typed`](@ref) を使用して利用可能です。 [`code_warntype`](@ref) は、`4d61726b646f776e2e436f64652822222c2022636f64655f74797065642229_40726566` の出力にハイライトを追加します。

マシンに近いところでは、関数のLLVM中間表現は [`code_llvm`](@ref) を使用して印刷できます。そして、最終的にコンパイルされたマシンコードは [`code_native`](@ref) を使用して入手可能です（これにより、以前に呼び出されていない関数のJITコンパイル/コード生成がトリガーされます）。

便利のために、上記の関数のマクロバージョンがあり、標準の関数呼び出しを受け取り、引数の型を自動的に展開します：

```julia-repl
julia> @code_llvm +(1,1)
;  @ int.jl:87 within `+`
; Function Attrs: sspstrong uwtable
define i64 @"julia_+_476"(i64 signext %0, i64 signext %1) #0 {
top:
  %2 = add i64 %1, %0
  ret i64 %2
}
```

詳細については、[`@code_lowered`](@ref)、[`@code_typed`](@ref)、[`@code_warntype`](@ref)、[`@code_llvm`](@ref)、および[`@code_native`](@ref)を参照してください。

### Printing of debug information

前述の関数とマクロは、出力されるデバッグ情報のレベルを制御するキーワード引数 `debuginfo` を取ります。

```jldoctest; setup = :(using InteractiveUtils), filter = r"int.jl:\d+"
julia> InteractiveUtils.@code_typed debuginfo=:source +(1,1)
CodeInfo(
    @ int.jl:87 within `+`
1 ─ %1 = intrinsic Base.add_int(x, y)::Int64
└──      return %1
) => Int64
```

`debuginfo` の可能な値は `:none`、`:source`、および `:default` です。デフォルトではデバッグ情報は表示されませんが、`Base.IRShow.default_debuginfo[] = :source` を設定することで変更できます。
