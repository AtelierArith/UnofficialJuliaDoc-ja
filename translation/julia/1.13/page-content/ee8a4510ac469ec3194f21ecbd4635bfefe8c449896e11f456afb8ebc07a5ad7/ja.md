# Reflection and introspection

Juliaには、さまざまな実行時リフレクション機能が用意されています。

## Module bindings

`Module`の公開名は[`names(m::Module)`](@ref)で取得できます。この関数は、公開バインディングを表す[`Symbol`](@ref)要素の配列を返します。`names(m::Module, all = true)`は、公開されているかどうかにかかわらず、`m`内のすべてのバインディングのシンボルを返します。

## DataType fields

`DataType`のフィールド名は、[`fieldnames`](@ref)で調べられます。たとえば、次の型に対して`fieldnames(Point)`を実行すると、フィールド名を表す[`Symbol`](@ref)のタプルが返されます。

```jldoctest struct_point
julia> struct Point
           x::Int
           y
       end

julia> fieldnames(Point)
(:x, :y)
```

`Point`オブジェクトの各フィールドの型は、`Point`変数自体の`types`フィールドに格納されています。

```jldoctest struct_point
julia> Point.types
svec(Int64, Any)
```

`x`には`Int`という注釈が付いています。一方、型定義では`y`に注釈が付いていなかったため、`y`はデフォルトで`Any`型になります。

型自体は、`DataType`という構造体で表されます。

```jldoctest struct_point
julia> typeof(Point)
DataType
```

`fieldnames(DataType)`は、`DataType`自体の各フィールド名を返します。そのフィールドの1つが、上の例で確認した`types`フィールドです。

## Subtypes

任意の`DataType`の*直接の*サブタイプは、[`subtypes`](@ref)で一覧表示できます。たとえば、抽象型`DataType`である[`AbstractFloat`](@ref)には、（具象）サブタイプが4つあります。

```jldoctest; setup = :(using InteractiveUtils)
julia> InteractiveUtils.subtypes(AbstractFloat)
5-element Vector{Any}:
 BigFloat
 Core.BFloat16
 Float16
 Float32
 Float64
```

抽象サブタイプもこの一覧に含まれますが、その下位のサブタイプは含まれません。[`subtypes`](@ref)を再帰的に適用すれば、型ツリー全体を調べられます。

[`subtypes`](@ref)は[`InteractiveUtils`](@ref man-interactive-utils)内にありますが、REPLでは自動的にエクスポートされることに注意してください。

## DataType layout

`DataType`の内部表現は、Cコードとの連携において非常に重要です。その詳細を調べるための関数がいくつか用意されています。[`isbitstype(T::DataType)`](@ref)は、`T`がC互換のアラインメントで格納されている場合にtrueを返します。[`fieldoffset(T::DataType, i::Integer)`](@ref)は、型の先頭から見たフィールド*i*のオフセット（バイト単位）を返します。

## Function methods

任意のジェネリック関数のメソッドは、[`methods`](@ref)で一覧表示できます。[`methodswith`](@ref)を使うと、指定した型を受け取るメソッドをメソッドディスパッチテーブルから検索できます。

## Expansion and lowering

[Metaprogramming](@ref)の節で説明したように、[`macroexpand`](@ref)関数は、指定したマクロの、引用符が付かず補間された式（[`Expr`](@ref)）形式を返します。`macroexpand`を使うには、式ブロック自体を`quote`してください（そうしないとマクロが評価され、その結果が渡されてしまいます）。たとえば、次のようになります。

```jldoctest
julia> macroexpand(@__MODULE__, :(@invoke identity(1::Int)))
:(Core.invoke(identity, Base.Tuple{Int}, 1))
```

`Base.Meta.show_sexpr`と[`dump`](@ref)は、任意の式をS式形式で表示したり、指定した深さまでネストした詳細を表示したりするために使います。

最後に、[`Meta.lower`](@ref)関数は、任意の式の`lowered`形式を返します。代入、分岐、呼び出しなどの言語構文が、どのように基本操作へ対応付けられるかを理解するうえで特に役立ちます。

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

関数の低水準化形式を調べるには、表示するメソッドを指定する必要があります。ジェネリック関数には、型シグネチャの異なるメソッドが多数存在する場合があるためです。この目的には、メソッドごとのコード低水準化を行う[`code_lowered`](@ref)と、型推論後の形式を表示する[`code_typed`](@ref)を使えます。[`code_warntype`](@ref)は、[`code_typed`](@ref)の出力にハイライトを加えます。

さらに機械語に近い段階では、[`code_llvm`](@ref)を使って関数のLLVM中間表現を出力できます。最終的なコンパイル済み機械語は[`code_native`](@ref)で取得できます（まだ呼び出されていない関数の場合、JITコンパイル／コード生成が実行されます）。

利便性のため、上記の関数にはマクロ版も用意されています。これらのマクロでは通常の関数呼び出しを渡すと、引数の型が自動的に展開されます。

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

詳しくは、[`@code_lowered`](@ref)、[`@code_typed`](@ref)、[`@code_warntype`](@ref)、[`@code_llvm`](@ref)、[`@code_native`](@ref)を参照してください。

### Printing of debug information

前述の関数とマクロには、出力するデバッグ情報のレベルを制御するキーワード引数`debuginfo`があります。

```jldoctest; setup = :(using InteractiveUtils), filter = r"int.jl:\d+"
julia> InteractiveUtils.@code_typed debuginfo=:source +(1,1)
CodeInfo(
    @ int.jl:87 within `+`
1 ─ %1 = intrinsic Base.add_int(x, y)::Int64
└──      return %1
) => Int64
```

`debuginfo`に指定できる値は、`:none`、`:source`、`:default`です。デフォルトではデバッグ情報は出力されませんが、`Base.IRShow.default_debuginfo[] = :source`を設定すれば変更できます。
