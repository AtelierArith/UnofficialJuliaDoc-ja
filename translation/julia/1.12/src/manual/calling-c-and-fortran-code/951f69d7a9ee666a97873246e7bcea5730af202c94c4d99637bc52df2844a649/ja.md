# Calling C and Fortran Code

ほとんどのコードはJuliaで書くことができますが、すでにCやFortranで書かれた高品質で成熟した数値計算用のライブラリが多数存在します。この既存のコードを簡単に利用できるように、JuliaはCおよびFortranの関数を呼び出すのを簡単かつ効率的にします。Juliaには「ボイラープレートなし」の哲学があります：関数は「グルー」コード、コード生成、またはコンパイルなしで、直接Juliaから呼び出すことができます - インタラクティブプロンプトからでも同様です。これは、適切な呼び出しを[`@ccall`](@ref)マクロ（または、あまり便利ではない[`ccall`](@ref)構文、詳細は[`ccall` syntax section](@ref ccall-interface)を参照）を使うことで実現されます。

呼び出されるコードは、共有ライブラリとして利用可能でなければなりません。ほとんどのCおよびFortranライブラリは、すでに共有ライブラリとしてコンパイルされて出荷されますが、GCC（またはClang）を使用して自分でコードをコンパイルする場合は、`-shared`および`-fPIC`オプションを使用する必要があります。JuliaのJITによって生成される機械命令は、ネイティブC呼び出しと同じであるため、結果としてのオーバーヘッドはCコードからライブラリ関数を呼び出すのと同じです。 [^1]

デフォルトでは、Fortran コンパイラは [generate mangled names](https://en.wikipedia.org/wiki/Name_mangling#Fortran) （例えば、関数名を小文字または大文字に変換し、しばしばアンダースコアを追加します）を使用します。そのため、Fortran 関数を呼び出すには、使用している Fortran コンパイラによって従われるルールに対応するマングルされた識別子を渡す必要があります。また、Fortran 関数を呼び出す際には、すべての入力をヒープまたはスタック上の割り当てられた値へのポインタとして渡す必要があります。これは、通常ヒープに割り当てられる配列や他の可変オブジェクトだけでなく、通常スタックに割り当てられ、C や Julia の呼び出し規約を使用する際に一般的にレジスタに渡される整数や浮動小数点数などのスカラー値にも適用されます。

[`@ccall`](@ref)を使用してライブラリ関数を呼び出すための構文は次のとおりです：

```julia
@ccall library.function_name(argvalue1::argtype1, ...)::returntype
@ccall function_name(argvalue1::argtype1, ...)::returntype
@ccall $function_pointer(argvalue1::argtype1, ...)::returntype
```

`library` は文字列定数またはリテラルです（ただし、以下の [Non-constant Function Specifications](@ref) を参照してください）。ライブラリは省略可能で、その場合、関数名は現在のプロセスで解決されます。この形式は、Cライブラリ関数、Juliaランタイム内の関数、またはJuliaにリンクされたアプリケーション内の関数を呼び出すために使用できます。ライブラリへのフルパスも指定できます。あるいは、`@ccall` を使用して、`Libdl.dlsym` によって返されるような関数ポインタ `$function_pointer` を呼び出すこともできます。`argtype` はC関数のシグネチャに対応し、`argvalue` は関数に渡される実際の引数値です。

!!! note
    以下は、[map C types to Julia types](@ref mapping-c-types-to-julia)の方法です。


完全でありながらシンプルな例として、以下はほとんどのUnix系システムの標準Cライブラリから`clock`関数を呼び出します：

```julia-repl
julia> t = @ccall clock()::Int32
2292761

julia> typeof(t)
Int32
```

`clock` は引数を取らず、`Int32` を返します。環境変数の値へのポインタを取得するために `getenv` 関数を呼び出すには、次のように呼び出します:

```julia-repl
julia> path = @ccall getenv("SHELL"::Cstring)::Cstring
Cstring(@0x00007fff5fbffc45)

julia> unsafe_string(path)
"/bin/bash"
```

実際には、特に再利用可能な機能を提供する際に、一般的に `@ccall` の使用を引数を設定し、その後CまたはFortran関数が指定する方法でエラーをチェックするJulia関数にラップします。そして、エラーが発生した場合は、通常のJulia例外としてスローされます。これは、CおよびFortranのAPIがエラー条件を示す方法について非常に一貫性がないため、特に重要です。たとえば、`getenv` Cライブラリ関数は、次のJulia関数にラップされており、これは [`env.jl`](https://github.com/JuliaLang/julia/blob/master/base/env.jl) からの実際の定義の簡略版です。

```julia
function getenv(var::AbstractString)
    val = @ccall getenv(var::Cstring)::Cstring
    if val == C_NULL
        error("getenv: undefined variable: ", var)
    end
    return unsafe_string(val)
end
```

Cの`getenv`関数は、エラーを示すために`C_NULL`を返しますが、他の標準C関数は、-1、0、1、その他の特別な値を返すなど、異なる方法でエラーを示します。このラッパーは、呼び出し元が存在しない環境変数を取得しようとした場合に、問題を示す例外をスローします：

```julia-repl
julia> getenv("SHELL")
"/bin/bash"

julia> getenv("FOOBAR")
ERROR: getenv: undefined variable: FOOBAR
```

ここに、ローカルマシンのホスト名を発見する少し複雑な例があります。

```julia
function gethostname()
    hostname = Vector{UInt8}(undef, 256) # MAXHOSTNAMELEN
    err = @ccall gethostname(hostname::Ptr{UInt8}, sizeof(hostname)::Csize_t)::Int32
    Base.systemerror("gethostname", err != 0)
    hostname[end] = 0 # ensure null-termination
    return GC.@preserve hostname unsafe_string(pointer(hostname))
end
```

この例では、最初にバイトの配列を割り当てます。次に、Cライブラリ関数`gethostname`を呼び出して、配列にホスト名を格納します。最後に、ホスト名バッファへのポインタを取得し、そのポインタをヌル終端のC文字列であると仮定して、Juliaの文字列に変換します。

Cライブラリが呼び出し元にメモリを割り当てることを要求し、それを呼び出し先に渡して populated するというパターンを使用することは一般的です。このようにしてJuliaからメモリを割り当てることは、初期化されていない配列を作成し、そのデータへのポインタをC関数に渡すことで一般的に達成されます。これが、ここで`Cstring`型を使用しない理由です：配列が初期化されていないため、ヌルバイトを含む可能性があります。`@ccall`の一部として`Cstring`に変換すると、含まれているヌルバイトをチェックし、そのため変換エラーが発生する可能性があります。

`pointer(hostname)`を`unsafe_string`で逆参照することは、安全でない操作です。これは、`hostname`のために割り当てられたメモリにアクセスする必要があり、そのメモリはその間にガーベジコレクションされている可能性があります。マクロ[`GC.@preserve`](@ref)は、これが発生するのを防ぎ、したがって無効なメモリ位置にアクセスすることを防ぎます。

最後に、パスを指定してライブラリを指定する例を示します。次の内容で共有ライブラリを作成します。

```c
#include <stdio.h>

void say_y(int y)
{
    printf("Hello from C: got y = %d.\n", y);
}
```

`gcc -fPIC -shared -o mylib.so mylib.c`を使用してコンパイルします。ライブラリ名として（絶対）パスを指定することで呼び出すことができます：

```julia-repl
julia> @ccall "./mylib.so".say_y(5::Cint)::Cvoid
Hello from C: got y = 5.
```

## Creating C-Compatible Julia Function Pointers

Juliaの関数を、関数ポインタ引数を受け入れるネイティブC関数に渡すことが可能です。例えば、次のようなCプロトタイプに一致させるために:

```c
typedef returntype (*functiontype)(argumenttype, ...)
```

マクロ [`@cfunction`](@ref) は、Julia関数への呼び出しのためのC互換の関数ポインタを生成します。 `4d61726b646f776e2e436f64652822222c2022406366756e6374696f6e2229_40726566` への引数は：

1. ジュリアの関数
2. 関数の戻り値の型
3. 関数シグネチャに対応する入力タイプのタプル

!!! note
    `@ccall`と同様に、戻り値の型と入力の型はリテラル定数でなければなりません。


!!! note
    現在、プラットフォームデフォルトのC呼び出し規約のみがサポートされています。これは、`@cfunction`で生成されたポインタが、32ビットWindowsでWINAPIが`stdcall`関数を期待する呼び出しに使用できないことを意味しますが、WIN64では使用できます（ここでは`stdcall`がC呼び出し規約と統一されています）。


!!! note
    `@cfunction`を介して公開されるコールバック関数はエラーをスローしてはいけません。そうすると、予期せずにJuliaランタイムに制御が戻り、プログラムが未定義の状態になる可能性があります。


クラシックな例は、標準Cライブラリの`qsort`関数で、次のように宣言されています：

```c
void qsort(void *base, size_t nitems, size_t size,
           int (*compare)(const void*, const void*));
```

`base` 引数は、各要素が `size` バイトの長さ `nitems` の配列へのポインタです。`compare` はコールバック関数で、2 つの要素 `a` と `b` へのポインタを受け取り、`a` が `b` の前に/後に出現すべき場合はゼロより小さい/大きい整数を返します（または、任意の順序が許可される場合はゼロ）。

さて、1次元配列 `A` の値を Julia で `qsort` 関数を使用してソートしたいとします（Julia の組み込み `sort` 関数ではなく）。`qsort` を呼び出して引数を渡すことを考える前に、比較関数を書く必要があります：

```jldoctest mycompare
julia> function mycompare(a, b)::Cint
           return (a < b) ? -1 : ((a > b) ? +1 : 0)
       end;
```

`qsort` は C の `int` を返す比較関数を期待するため、戻り値の型を `Cint` として注釈を付けます。

この関数をCに渡すために、マクロ `@cfunction` を使用してそのアドレスを取得します:

```jldoctest mycompare
julia> mycompare_c = @cfunction(mycompare, Cint, (Ref{Cdouble}, Ref{Cdouble}));
```

[`@cfunction`](@ref) は、3つの引数を必要とします: Julia 関数（`mycompare`）、戻り値の型（`Cint`）、および入力引数の型のリテラルタプル。この場合、`Cdouble`（[`Float64`](@ref)）の要素をソートするためのものです。

最終的な`qsort`への呼び出しは次のようになります:

```jldoctest mycompare
julia> A = [1.3, -2.7, 4.4, 3.1];

julia> @ccall qsort(A::Ptr{Cdouble}, length(A)::Csize_t, sizeof(eltype(A))::Csize_t, mycompare_c::Ptr{Cvoid})::Cvoid

julia> A
4-element Vector{Float64}:
 -2.7
  1.3
  3.1
  4.4
```

例に示すように、元のJulia配列 `A` は現在ソートされています: `[-2.7, 1.3, 3.1, 4.4]`。Julia [takes care of converting the array to a `Ptr{Cdouble}`](@ref automatic-type-conversion))、要素型のサイズをバイト単位で計算することなど。

楽しむために、`mycompare`に`println("mycompare($a, $b)")`の行を挿入してみてください。これにより、`qsort`が実行している比較を確認でき（実際に渡したJulia関数が呼び出されていることを確認するため）、便利です。

## [Mapping C Types to Julia](@id mapping-c-types-to-julia)

宣言されたC型とJuliaでの宣言を正確に一致させることが重要です。不一致があると、あるシステムで正しく動作するコードが別のシステムで失敗したり、不確定な結果を生じる可能性があります。

C関数を呼び出すプロセスでは、どこにもCヘッダーファイルは使用されていないことに注意してください。あなたは、Juliaの型と呼び出しシグネチャがCヘッダーファイルのものと正確に一致するようにする責任があります。[^2]

### [Automatic Type Conversion](@id automatic-type-conversion)

Juliaは、各引数を指定された型に変換するために、[`Base.cconvert`](@ref)関数への呼び出しを自動的に挿入します。たとえば、次の呼び出し：

```julia
@ccall "libfoo".foo(x::Int32, y::Float64)::Cvoid
```

そのように書かれたかのように振る舞います:

```julia
c_x = Base.cconvert(Int32, x)
c_y = Base.cconvert(Float64, y)
GC.@preserve c_x c_y begin
    @ccall "libfoo".foo(
        Base.unsafe_convert(Int32, c_x)::Int32,
        Base.unsafe_convert(Float64, c_y)::Float64
    )::Cvoid
end
```

[`Base.cconvert`](@ref) は通常 [`convert`](@ref) を呼び出しますが、Cに渡すのにより適した任意の新しいオブジェクトを返すように定義できます。これは、Cコードによってアクセスされるすべてのメモリの割り当てを行うために使用されるべきです。例えば、これはオブジェクトの `Array`（例えば、文字列）をポインタの配列に変換するために使用されます。

[`Base.unsafe_convert`](@ref) は [`Ptr`](@ref) タイプへの変換を処理します。これは、オブジェクトをネイティブポインタに変換することで、ガーベジコレクタからオブジェクトが隠され、早期に解放される可能性があるため、安全ではないと見なされます。

### Type Correspondences

まず、いくつかの関連するJuliaの型用語を見てみましょう：

| Syntax / Keyword        | Example                                    | Description                                                                                                                                                                                                                                                                                                  |
|:----------------------- |:------------------------------------------ |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `mutable struct`        | `BitSet`                                   | "Concrete Type" :: A group of related data that includes a type-tag, is managed by the Julia GC, and is defined by object-identity. The type parameters of a concrete type must be fully defined (no `TypeVars` are allowed) in order for the instance to be constructed. Also see [`isconcretetype`](@ref). |
| `abstract type`         | `Any`, `AbstractArray{T, N}`, `Complex{T}` | "Super Type" :: A super-type (not a concrete type) that cannot be instantiated, but can be used to describe a group of types. Also see [`isabstracttype`](@ref).                                                                                                                                             |
| `T{A}`                  | `Vector{Int}`                              | "Type Parameter" :: A specialization of a type (typically used for dispatch or storage optimization).                                                                                                                                                                                                        |
|                         |                                            | "TypeVar" :: The `T` in the type parameter declaration is referred to as a TypeVar (short for type variable).                                                                                                                                                                                                |
| `primitive type`        | `Int`, `Float64`                           | "Primitive Type" :: A type with no fields, but a size. It is stored and defined by-value.                                                                                                                                                                                                                    |
| `struct`                | `Pair{Int, Int}`                           | "Struct" :: A type with all fields defined to be constant. It is defined by-value, and may be stored with a type-tag.                                                                                                                                                                                        |
|                         | `ComplexF64` (`isbits`)                    | "Is-Bits"   :: A `primitive type`, or a `struct` type where all fields are other `isbits` types. It is defined by-value, and is stored without a type-tag.                                                                                                                                                   |
| `struct ...; end`       | `nothing`                                  | "Singleton" :: a concrete Type or Struct with no fields.                                                                                                                                                                                                                                                     |
| `(...)` or `tuple(...)` | `(1, 2, 3)`                                | "Tuple" :: an immutable data-structure similar to an anonymous struct type, or a constant array. Represented as either an array or a struct.                                                                                                                                                                 |

### [Bits Types](@id man-bits-types)

特別なタイプがいくつかあり、他のタイプが同じように振る舞うように定義されることはありません。

  * `Float32`

    Cの`float`型（またはFortranの`REAL*4`）に正確に対応します。
  * `Float64`

    Cの`double`型（またはFortranの`REAL*8`）に正確に対応します。
  * `ComplexF32`

    Cの`complex float`型（またはFortranの`COMPLEX*8`）に正確に対応します。
  * `ComplexF64`

    Cの`complex double`型（またはFortranの`COMPLEX*16`）に正確に対応します。
  * `署名済み`

    `signed` 型注釈は C の `signed` 型（または Fortran の任意の `INTEGER` 型）に正確に対応します。[`Signed`](@ref) のサブタイプでない任意の Julia 型は、符号なしであると見なされます。

  * `Ref{T}`

    `Ptr{T}`のように振る舞い、JuliaのGCを介してメモリを管理できる。

  * `Array{T,N}`

    配列がCに`Ptr{T}`引数として渡されるとき、それは再解釈キャストされません：Juliaは配列の要素型が`T`と一致することを要求し、最初の要素のアドレスが渡されます。

    したがって、`Array` が間違った形式のデータを含んでいる場合、`trunc.(Int32, A)` のような呼び出しを使用して明示的に変換する必要があります。

    配列 `A` を異なる型のポインタとして*変換せずに*渡すには（例えば、`Float64` 配列を解釈されていないバイトで動作する関数に渡す場合）、引数を `Ptr{Cvoid}` として宣言できます。

    配列の要素型 `Ptr{T}` が `Ptr{Ptr{T}}` 引数として渡されると、[`Base.cconvert`](@ref) は、各要素がその `4d61726b646f776e2e436f64652822222c2022426173652e63636f6e766572742229_40726566` バージョンに置き換えられた配列のヌル終端コピーを最初に作成しようとします。これにより、例えば、`Vector{String}` 型の `argv` ポインタ配列を `Ptr{Ptr{Cchar}}` 型の引数に渡すことが可能になります。

現在サポートしているすべてのシステムにおいて、基本的なC/C++の値型は次のようにJulia型に変換される場合があります。すべてのC型には、同じ名前の対応するJulia型があり、Cでプレフィックスが付けられています。これは、ポータブルなコードを書く際に役立ちます（Cの`int`がJuliaの`Int`と同じではないことを思い出すため）。

**システム独立型**

| C name                                                  | Fortran name             | Standard Julia Alias | Julia Base Type                                                                                             |
|:------------------------------------------------------- |:------------------------ |:-------------------- |:----------------------------------------------------------------------------------------------------------- |
| `unsigned char`                                         | `CHARACTER`              | `Cuchar`             | `UInt8`                                                                                                     |
| `bool` (_Bool in C99+)                                  |                          | `Cuchar`             | `UInt8`                                                                                                     |
| `short`                                                 | `INTEGER*2`, `LOGICAL*2` | `Cshort`             | `Int16`                                                                                                     |
| `unsigned short`                                        |                          | `Cushort`            | `UInt16`                                                                                                    |
| `int`, `BOOL` (C, typical)                              | `INTEGER*4`, `LOGICAL*4` | `Cint`               | `Int32`                                                                                                     |
| `unsigned int`                                          |                          | `Cuint`              | `UInt32`                                                                                                    |
| `long long`                                             | `INTEGER*8`, `LOGICAL*8` | `Clonglong`          | `Int64`                                                                                                     |
| `unsigned long long`                                    |                          | `Culonglong`         | `UInt64`                                                                                                    |
| `intmax_t`                                              |                          | `Cintmax_t`          | `Int64`                                                                                                     |
| `uintmax_t`                                             |                          | `Cuintmax_t`         | `UInt64`                                                                                                    |
| `float`                                                 | `REAL*4i`                | `Cfloat`             | `Float32`                                                                                                   |
| `double`                                                | `REAL*8`                 | `Cdouble`            | `Float64`                                                                                                   |
| `complex float`                                         | `COMPLEX*8`              | `ComplexF32`         | `Complex{Float32}`                                                                                          |
| `complex double`                                        | `COMPLEX*16`             | `ComplexF64`         | `Complex{Float64}`                                                                                          |
| `ptrdiff_t`                                             |                          | `Cptrdiff_t`         | `Int`                                                                                                       |
| `ssize_t`                                               |                          | `Cssize_t`           | `Int`                                                                                                       |
| `size_t`                                                |                          | `Csize_t`            | `UInt`                                                                                                      |
| `void`                                                  |                          |                      | `Cvoid`                                                                                                     |
| `void` and `[[noreturn]]` or `_Noreturn`                |                          |                      | `Union{}`                                                                                                   |
| `void*`                                                 |                          |                      | `Ptr{Cvoid}` (or similarly `Ref{Cvoid}`)                                                                    |
| `T*` (where T represents an appropriately defined type) |                          |                      | `Ref{T}` (T may be safely mutated only if T is an isbits type)                                              |
| `char*` (or `char[]`, e.g. a string)                    | `CHARACTER*N`            |                      | `Cstring` if null-terminated, or `Ptr{UInt8}` if not                                                        |
| `char**` (or `*char[]`)                                 |                          |                      | `Ptr{Ptr{UInt8}}`                                                                                           |
| `jl_value_t*` (any Julia Type)                          |                          |                      | `Any`                                                                                                       |
| `jl_value_t* const*` (a reference to a Julia value)     |                          |                      | `Ref{Any}` (const, since mutation would require a write barrier, which is not possible to insert correctly) |
| `va_arg`                                                |                          |                      | Not supported                                                                                               |
| `...` (variadic function specification)                 |                          |                      | `T...` (where `T` is one of the above types, when using the `ccall` function)                               |
| `...` (variadic function specification)                 |                          |                      | `; va_arg1::T, va_arg2::S, etc.` (only supported with `@ccall` macro)                                       |

[`Cstring`](@ref) 型は、基本的に `Ptr{UInt8}` の同義語ですが、Juliaの文字列に埋め込まれたヌル文字が含まれている場合、`Cstring` への変換はエラーをスローします（これは、Cルーチンがヌルを終端子として扱う場合、文字列が静かに切り捨てられる原因となります）。ヌル終端を仮定しないCルーチンに `char*` を渡す場合（例えば、明示的な文字列の長さを渡す場合）や、Juliaの文字列にヌルが含まれていないことが確実であり、チェックをスキップしたい場合は、引数の型として `Ptr{UInt8}` を使用できます。`Cstring` は [`ccall`](@ref) の戻り値の型としても使用できますが、その場合は明らかに追加のチェックを導入せず、呼び出しの可読性を向上させるためだけに意図されています。

**システム依存型**

| C name          | Standard Julia Alias | Julia Base Type                              |
|:--------------- |:-------------------- |:-------------------------------------------- |
| `char`          | `Cchar`              | `Int8` (x86, x86_64), `UInt8` (powerpc, arm) |
| `long`          | `Clong`              | `Int` (UNIX), `Int32` (Windows)              |
| `unsigned long` | `Culong`             | `UInt` (UNIX), `UInt32` (Windows)            |
| `wchar_t`       | `Cwchar_t`           | `Int32` (UNIX), `UInt16` (Windows)           |

!!! note
    Fortranを呼び出す際は、すべての入力をヒープまたはスタックに割り当てられた値へのポインタとして渡す必要があるため、上記のすべての型対応には、その型仕様の周りに追加の `Ptr{..}` または `Ref{..}` ラッパーが含まれている必要があります。


!!! warning
    文字列引数（`char*`）の場合、Juliaの型は`Cstring`（ヌル終端データが期待される場合）であるべきです。それ以外の場合は、`Ptr{Cchar}`または`Ptr{UInt8}`のいずれか（これらの2つのポインタ型は同じ効果があります）であるべきです。上記のように、`String`ではありません。同様に、配列引数（`T[]`または`T*`）の場合、Juliaの型は再び`Ptr{T}`であるべきであり、`Vector{T}`ではありません。


!!! warning
    Juliaの`Char`型は32ビットであり、すべてのプラットフォームでワイドキャラクター型（`wchar_t`または`wint_t`）とは異なります。


!!! warning
    `Union{}`の戻り値の型は、関数が戻らないことを意味します。つまり、C++11の`[[noreturn]]`やC11の`_Noreturn`（例：`jl_throw`や`longjmp`）です。この型は、戻り値がない（`void`）が実際には戻る関数には使用しないでください。その場合は、代わりに`Cvoid`を使用してください。


!!! note
    `wchar_t*` 引数の場合、Julia の型は [`Cwstring`](@ref) （C ルーチンがヌル終端文字列を期待する場合）または `Ptr{Cwchar_t}` であるべきです。また、Julia の UTF-8 文字列データは内部的にヌル終端されているため、ヌル終端データを期待する C 関数にコピーを作成せずに渡すことができます（ただし、`Cwstring` 型を使用すると、文字列自体にヌル文字が含まれている場合にエラーが発生します）。


!!! note
    Cの関数で`char**`型の引数を取るものは、Julia内で`Ptr{Ptr{UInt8}}`型を使用して呼び出すことができます。例えば、次のようなC関数：

    ```c
    int main(int argc, char **argv);
    ```

    次のJuliaコードを介して呼び出すことができます:

    ```julia
    argv = [ "a.out", "arg1", "arg2" ]
    @ccall main(length(argv)::Int32, argv::Ptr{Ptr{UInt8}})::Int32
    ```


!!! note
    Fortranの関数が可変長文字列の型 `character(len=*)` を受け取る場合、文字列の長さは*隠れた引数*として提供されます。これらの引数の型と位置はコンパイラによって異なり、コンパイラベンダーは通常、`Csize_t` を型として使用し、隠れた引数を引数リストの最後に追加することをデフォルトとしています。この動作は一部のコンパイラ（GNU）では固定されていますが、他のコンパイラ（Intel、PGI）は*オプションで*隠れた引数を文字引数の直後に配置することを許可しています。例えば、次のような形式のFortranサブルーチンが考えられます。

    ```fortran
    subroutine test(str1, str2)
    character(len=*) :: str1,str2
    ```

    次のJuliaコードを介して呼び出すことができ、長さが追加されます。

    ```julia
    str1 = "foo"
    str2 = "bar"
    ccall(:test, Cvoid, (Ptr{UInt8}, Ptr{UInt8}, Csize_t, Csize_t),
                        str1, str2, sizeof(str1), sizeof(str2))
    ```


!!! warning
    Fortran コンパイラは、ポインタ、仮定形 (`:`) および仮定サイズ (`*`) 配列のために他の隠れた引数を追加することがあります。このような動作は、`ISO_C_BINDING` を使用し、サブルーチンの定義に `bind(c)` を含めることで回避できます。これは相互運用可能なコードに対して強く推奨されます。この場合、隠れた引数は存在せず、いくつかの言語機能（例：文字列を渡すためには `character(len=1)` のみが許可されます）のコストがかかります。


!!! note
    Cで宣言された`Cvoid`を返す関数は、Juliaでは値`nothing`を返します。


### Struct Type Correspondences

Cの`struct`やFortran90の`TYPE`（またはF77のいくつかのバリアントでの`STRUCTURE` / `RECORD`）のような複合型は、同じフィールドレイアウトを持つ`struct`定義を作成することでJuliaでミラーリングできます。

再帰的に使用される場合、`isbits` 型はインラインで保存されます。他のすべての型はデータへのポインタとして保存されます。Cの中で値として使用される構造体をミラーリングする際には、フィールドを手動でコピーしようとしないことが重要です。そうしないと、正しいフィールドのアライメントが保持されません。代わりに、`isbits` 構造体型を宣言し、それを使用してください。無名構造体はJuliaへの翻訳では不可能です。

Juliaでは、パックされた構造体および共用体の宣言はサポートされていません。

`union`の近似値を得ることができます。事前に、最大のサイズを持つフィールド（パディングを含む可能性があります）を知っている場合です。フィールドをJuliaに変換する際には、Juliaのフィールドをその型のみに宣言してください。

パラメータの配列は `NTuple` を使って表現できます。例えば、C表記の構造体は次のように書かれます。

```c
struct B {
    int A[3];
};

b_a_2 = B.A[2];
```

ジュリアでは次のように書くことができます。

```julia
struct B
    A::NTuple{3, Cint}
end

b_a_2 = B.A[3]  # note the difference in indexing (1-based in Julia, 0-based in C)
```

サイズが不明な配列（`[]` または `[0]` で指定された C99 準拠の可変長構造体）は直接サポートされていません。これらに対処する最良の方法は、バイトオフセットを直接扱うことです。たとえば、C ライブラリが適切な文字列型を宣言し、それへのポインタを返した場合：

```c
struct String {
    int strlen;
    char data[];
};
```

Juliaでは、文字列の部分に独立してアクセスして、その文字列のコピーを作成することができます：

```julia
str = from_c::Ptr{Cvoid}
len = unsafe_load(Ptr{Cint}(str))
unsafe_string(str + Core.sizeof(Cint), len)
```

### Type Parameters

`@ccall` と `@cfunction` への型引数は、使用が定義されるときに静的に評価されます。したがって、リテラルタプルの形でなければならず、変数ではなく、ローカル変数を参照することはできません。

これは奇妙な制限のように聞こえるかもしれませんが、CはJuliaのような動的言語ではないため、その関数は静的に知られた固定のシグネチャを持つ引数の型のみを受け入れることを覚えておいてください。

しかし、C ABIを計算するためには型レイアウトが静的に知られている必要がありますが、関数の静的パラメータはこの静的環境の一部と見なされます。関数の静的パラメータは、型のレイアウトに影響を与えない限り、呼び出しシグネチャの型パラメータとして使用できます。例えば、`f(x::T) where {T} = @ccall valid(x::Ptr{T})::Ptr{T}`は有効です。なぜなら、`Ptr`は常にワードサイズのプリミティブ型だからです。しかし、`g(x::T) where {T} = @ccall notvalid(x::T)::T`は無効です。なぜなら、`T`の型レイアウトは静的に知られていないからです。

### SIMD Values

もしC/C++のルーチンが引数または戻り値としてネイティブのSIMD型を持っている場合、対応するJulia型はSIMD型に自然にマッピングされる`VecElement`の均一なタプルです。具体的には：

>   * タプルはSIMDタイプと同じサイズと要素でなければなりません。たとえば、x86上の`__m128`を表すタプルは、サイズが16バイトでFloat32要素を持っている必要があります。
>   * タプルの要素タイプは、`VecElement{T}`のインスタンスでなければならず、`T`は2の累乗のバイト数を持つプリミティブ型（例：1、2、4、8、16など）でなければなりません。例えば、Int8やFloat64などです。


例えば、AVXインストリンシックを使用するこのCルーチンを考えてみてください：

```c
#include <immintrin.h>

__m256 dist( __m256 a, __m256 b ) {
    return _mm256_sqrt_ps(_mm256_add_ps(_mm256_mul_ps(a, a),
                                        _mm256_mul_ps(b, b)));
}
```

次のJuliaコードは`ccall`を使用して`dist`を呼び出します：

```julia
const m256 = NTuple{8, VecElement{Float32}}

a = m256(ntuple(i -> VecElement(sin(Float32(i))), 8))
b = m256(ntuple(i -> VecElement(cos(Float32(i))), 8))

function call_dist(a::m256, b::m256)
    @ccall "libdist".dist(a::m256, b::m256)::m256
end

println(call_dist(a,b))
```

ホストマシンは必要なSIMDレジスタを持っている必要があります。たとえば、上記のコードはAVXサポートのないホストでは動作しません。

### Memory Ownership

**`malloc`/`free`**

メモリの割り当てと解放は、使用しているライブラリの適切なクリーンアップルーチンへの呼び出しによって処理されなければなりません。これは、任意のCプログラムと同様です。Juliaで[`Libc.free`](@ref)から受け取ったオブジェクトを解放しようとしないでください。これは、誤ったライブラリを介して`free`関数が呼び出され、プロセスが中止される原因となる可能性があります。逆に、Juliaで割り当てられたオブジェクトを外部ライブラリによって解放させることも同様に無効です。

### When to use `T`, `Ptr{T}` and `Ref{T}`

In Julia code wrapping calls to external C routines, ordinary (non-pointer) data should be declared to be of type `T` inside the `@ccall`, as they are passed by value. For C code accepting pointers, [`Ref{T}`](@ref) should generally be used for the types of input arguments, allowing the use of pointers to memory managed by either Julia or C through the implicit call to [`Base.cconvert`](@ref). In contrast, pointers returned by the C function called should be declared to be of the output type [`Ptr{T}`](@ref), reflecting that the memory pointed to is managed by C only. Pointers contained in C structs should be represented as fields of type `Ptr{T}` within the corresponding Julia struct types designed to mimic the internal structure of corresponding C structs.

外部Fortranルーチンへの呼び出しをラップするJuliaコードでは、すべての入力引数は`Ref{T}`型として宣言する必要があります。Fortranはすべての変数をメモリ位置へのポインタとして渡すためです。戻り値の型は、Fortranサブルーチンの場合は`Cvoid`、または型`T`を返すFortran関数の場合は`T`である必要があります。

## Mapping C Functions to Julia

### `@ccall` / `@cfunction` argument translation guide

Cの引数リストをJuliaに翻訳するには：

  * `T`は、原始型のいずれかである：`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`またはそれらの`typedef`の同等物。

      * `T`は、上記の表に従った同等のJulia Bits型です。
      * `T`が`enum`である場合、引数の型は`Cint`または`Cuint`と同等である必要があります。
      * 引数の値はコピーされます（値渡し）。
  * `struct T`（構造体へのtypedefを含む）

      * `T`、ここで `T` は具体的なJulia型です
      * 引数の値はコピーされます（値渡し）。
  * `vector T`（または `__attribute__ vector_size`、または `__m128` のような typedef）

      * `NTuple{N, VecElement{T}}`、ここで `T` は正しいサイズのプリミティブなJulia型であり、Nはベクター内の要素数（`vector_size / sizeof T` に等しい）です。
  * `void*`

      * このパラメータがどのように使用されるかによります。まず、これを意図されたポインタ型に翻訳し、その後、このリストの残りのルールを使用してJuliaの同等のものを決定します。
      * この引数は、実際に未知のポインタである場合、`Ptr{Cvoid}`として宣言される可能性があります。
  * `jl_value_t*`

      * `任意`
      * 引数の値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t* const*`

      * `Ref{Any}`
      * 引数リストは有効なJuliaオブジェクト（または`C_NULL`）でなければなりません。
      * 出力パラメータとして使用することはできません。ユーザーがオブジェクトをGCで保持するために別途手配できる場合を除きます。
  * `T*`

      * `Ref{T}`は、`T`に対応するJulia型の`T`です。
      * 引数の値は、`inlinealloc` タイプの場合にコピーされます（`isbits` を含む）。それ以外の場合、値は有効な Julia オブジェクトでなければなりません。
  * `T (*)(...)`（例：関数へのポインタ）

      * `Ptr{Cvoid}`（このポインタを作成するには、[`@cfunction`](@ref)を明示的に使用する必要があるかもしれません）
  * `...` (例: vararg)

      * [for `ccall`]: `T...`、ここで `T` は残りのすべての引数の単一のJulia型です。
      * [for `@ccall`]: `; va_arg1::T, va_arg2::S, etc`、ここで `T` と `S` はJuliaの型（すなわち、通常の引数と可変引数を `;` で区切ります）
      * 現在、`@cfunction`によってサポートされていません。
  * `va_arg`

      * `ccall` または `@cfunction` によってサポートされていません

### `@ccall` / `@cfunction` return type translation guide

Cの戻り値の型をJuliaに翻訳するには：

  * `void`

      * `Cvoid`（これはシングルトンインスタンス `nothing::Cvoid` を返します）
  * `T`は、原始型のいずれかである：`char`、`int`、`long`、`short`、`float`、`double`、`complex`、`enum`またはそれらの`typedef`の同等物。

      * Cの引数リストと同じ
      * 引数の値はコピーされます（値渡しで返されます）
  * `struct T`（構造体へのtypedefを含む）

      * Cの引数リストと同じ
      * 引数の値はコピーされます（値渡しで返されます）
  * `ベクトル T`

      * Cの引数リストと同じ
  * `void*`

      * このパラメータがどのように使用されるかによります。まず、これを意図されたポインタ型に翻訳し、その後、このリストの残りのルールを使用してJuliaの同等のものを決定します。
      * この引数は、実際に未知のポインタである場合、`Ptr{Cvoid}`として宣言される可能性があります。
  * `jl_value_t*`

      * `任意`
      * 引数の値は有効なJuliaオブジェクトでなければなりません。
  * `jl_value_t**`

      * `Ptr{Any}`（`Ref{Any}`は戻り値の型として無効です）
  * `T*`

      * もしメモリがすでにJuliaによって所有されているか、`isbits`型であり、非nullであることが知られている場合：

          * `Ref{T}`は、`T`に対応するJulia型です。
          * `Ref{Any}`の戻り値の型は無効です。`Any`（`jl_value_t*`に対応）または`Ptr{Any}`（`jl_value_t**`に対応）である必要があります。
          * C **は絶対に** `isbits` 型の `T` の場合、`Ref{T}` を介して返されたメモリを変更してはいけません。
      * Cがメモリを所有している場合:

          * `Ptr{T}`は、`T`が`T`に対応するJulia型であることを示します。
  * `T (*)(...)`（例：関数へのポインタ）

      * `Ptr{Cvoid}`を直接Juliaから呼び出すには、これを`@ccall`の最初の引数として渡す必要があります。[Indirect Calls](@ref)を参照してください。

### Passing Pointers for Modifying Inputs

Cは複数の戻り値をサポートしていないため、Cの関数はしばしば関数が修正するデータへのポインタを受け取ります。これを`@ccall`内で実現するには、まず適切な型の[`Ref{T}`](@ref)の中に値をカプセル化する必要があります。この`Ref`オブジェクトを引数として渡すと、Juliaは自動的にカプセル化されたデータへのCポインタを渡します：

```julia
width = Ref{Cint}(0)
range = Ref{Cfloat}(0)
@ccall foo(width::Ref{Cint}, range::Ref{Cfloat})::Cvoid
```

戻ると、`width` と `range` の内容は（`foo` によって変更された場合）`width[]` と `range[]` で取得できます。つまり、それらはゼロ次元配列のように動作します。

## C Wrapper Examples

Cラッパーの簡単な例を始めましょう。これは`Ptr`型を返します：

```julia
mutable struct gsl_permutation
end

# The corresponding C signature is
#     gsl_permutation * gsl_permutation_alloc (size_t n);
function permutation_alloc(n::Integer)
    output_ptr = @ccall "libgsl".gsl_permutation_alloc(n::Csize_t)::Ptr{gsl_permutation}
    if output_ptr == C_NULL # Could not allocate memory
        throw(OutOfMemoryError())
    end
    return output_ptr
end
```

[GNU Scientific Library](https://www.gnu.org/software/gsl/)（ここでは`:libgsl`を通じてアクセス可能であると仮定）では、C関数`gsl_permutation_alloc`の戻り値の型として不透明ポインタ`gsl_permutation *`が定義されています。ユーザーコードは`gsl_permutation`構造体の内部を見なくてよいため、対応するJuliaラッパーは、内部フィールドを持たず、`Ptr`型の型パラメータに配置されることを唯一の目的とする新しい型宣言`gsl_permutation`が必要です。[`ccall`](@ref)の戻り値の型は`Ptr{gsl_permutation}`として宣言されており、`output_ptr`によって指されるメモリはCによって制御されています。

入力 `n` は値渡しされるため、関数の入力シグネチャは単に `::Csize_t` と宣言され、`Ref` や `Ptr` は必要ありません。（ラッパーが Fortran 関数を呼び出している場合、対応する関数の入力シグネチャは `::Ref{Csize_t}` になります。なぜなら、Fortran の変数はポインタで渡されるからです。）さらに、`n` は `Csize_t` 整数に変換可能な任意の型であることができます；[`ccall`](@ref) は暗黙的に [`Base.cconvert(Csize_t, n)`](@ref) を呼び出します。

ここに対応するデストラクタをラップする第二の例があります：

```julia
# The corresponding C signature is
#     void gsl_permutation_free (gsl_permutation * p);
function permutation_free(p::Ptr{gsl_permutation})
    @ccall "libgsl".gsl_permutation_free(p::Ptr{gsl_permutation})::Cvoid
end
```

ここにジュリア配列を渡す第三の例があります：

```julia
# The corresponding C signature is
#    int gsl_sf_bessel_Jn_array (int nmin, int nmax, double x,
#                                double result_array[])
function sf_bessel_Jn_array(nmin::Integer, nmax::Integer, x::Real)
    if nmax < nmin
        throw(DomainError())
    end
    result_array = Vector{Cdouble}(undef, nmax - nmin + 1)
    errorcode = @ccall "libgsl".gsl_sf_bessel_Jn_array(
                    nmin::Cint, nmax::Cint, x::Cdouble, result_array::Ref{Cdouble})::Cint
    if errorcode != 0
        error("GSL error code $errorcode")
    end
    return result_array
end
```

C関数wrappedは整数エラーコードを返します。Bessel J関数の実際の評価の結果は、Julia配列`result_array`に格納されます。この変数は`Ref{Cdouble}`として宣言されており、そのメモリはJuliaによって割り当てられ、管理されています。暗黙の呼び出し[`Base.cconvert(Ref{Cdouble}, result_array)`](@ref)は、JuliaポインタをCが理解できる形式のJulia配列データ構造に展開します。

## Fortran Wrapper Example

以下の例では、`ccall`を使用して一般的なFortranライブラリ（libBLAS）の関数を呼び出し、ドット積を計算します。引数のマッピングは、JuliaからFortranにマッピングする必要があるため、上記とは少し異なることに注意してください。すべての引数タイプに対して、`Ref`または`Ptr`を指定します。このマングリング規則は、使用しているFortranコンパイラやオペレーティングシステムに特有であり、文書化されていない可能性があります。ただし、各引数を`Ref`（または同等の`Ptr`）でラップすることは、Fortranコンパイラの実装において一般的な要件です。

```julia
function compute_dot(DX::Vector{Float64}, DY::Vector{Float64})
    @assert length(DX) == length(DY)
    n = length(DX)
    incx = incy = 1
    product = @ccall "libLAPACK".ddot(
        n::Ref{Int32}, DX::Ptr{Float64}, incx::Ref{Int32}, DY::Ptr{Float64}, incy::Ref{Int32})::Float64
    return product
end
```

## Garbage Collection Safety

データを `@ccall` に渡す際は、[`pointer`](@ref) 関数の使用を避けるのが最善です。代わりに、[`Base.cconvert`](@ref) メソッドを定義し、変数を直接 `@ccall` に渡してください。`@ccall` は、自動的にすべての引数が呼び出しが返るまでガーベジコレクションから保護されるように手配します。C API が Julia によって割り当てられたメモリへの参照を保存する場合、`@ccall` が返った後にオブジェクトがガーベジコレクタに見える状態を保つ必要があります。これを行うための推奨方法は、C ライブラリがそれらを使い終わったことを通知するまで、これらの値を保持するために `Vector{Ref}` 型のグローバル変数を作成することです。

ポインタをJuliaデータに作成した場合、ポインタの使用が終了するまで元のデータが存在することを確認する必要があります。[`unsafe_load`](@ref)や[`String`](@ref)など、Juliaの多くのメソッドはバッファの所有権を取得するのではなくデータのコピーを作成するため、元のデータを解放（または変更）してもJuliaに影響を与えずに安全です。注目すべき例外は[`unsafe_wrap`](@ref)で、パフォーマンスの理由から、基盤となるバッファの所有権を取得するように指示することができます。

ガーベジコレクタはファイナライズの順序を保証しません。つまり、`a` が `b` への参照を含んでいて、`a` と `b` の両方がガーベジコレクションの対象である場合、`b` が `a` の後にファイナライズされる保証はありません。`a` の適切なファイナライズが `b` の有効性に依存する場合は、他の方法で処理する必要があります。

## Non-constant Function Specifications

必要なライブラリの正確な名前やパスが事前にわからない場合があり、実行時に計算する必要があります。そのような場合に対処するために、ライブラリコンポーネントの仕様は関数呼び出しであることができます。例えば、`find_blas().dgemm`のようにです。この呼び出し式は、`ccall`自体が実行されるときに実行されます。ただし、一度決定されたライブラリの場所は変更されないと仮定されているため、呼び出しの結果はキャッシュされ再利用されることができます。したがって、式が実行される回数は不明であり、複数回の呼び出しで異なる値を返すことは未定義の動作を引き起こします。

もしさらに柔軟性が必要な場合、次のように [`eval`](@ref) を通じて計算された値を関数名として使用することが可能です：

```julia
@eval @ccall "lib".$(string("a", "b"))()::Cint
```

この式は `string` を使用して名前を構築し、その後この名前を新しい `@ccall` 式に置き換え、評価されます。`eval` はトップレベルでのみ動作するため、この式内ではローカル変数は利用できません（その値が `$` で置き換えられない限り）。このため、`eval` は通常、ライブラリをラップする際のように、多くの類似関数を含むトップレベルの定義を形成するためにのみ使用されます。[`@cfunction`](@ref) に対しても同様の例を構築できます。

しかし、これを行うと非常に遅くなり、メモリが漏れる可能性があるため、通常はこれを避け、代わりに読み続けるべきです。次のセクションでは、間接呼び出しを使用して効率的に同様の効果を達成する方法について説明します。

## Indirect Calls

`@ccall` の最初の引数は、実行時に評価される式でも構いません。この場合、式は `Ptr` に評価される必要があり、呼び出すネイティブ関数のアドレスとして使用されます。この動作は、最初の `@ccall` 引数がローカル変数、関数引数、または非定数のグローバル変数などの非定数への参照を含む場合に発生します。

例えば、`dlsym`を介して関数を検索し、そのセッションのために共有参照にキャッシュすることができます。例えば：

```julia
macro dlsym(lib, func)
    z = Ref{Ptr{Cvoid}}(C_NULL)
    quote
        let zlocal = $z[]
            if zlocal == C_NULL
                zlocal = dlsym($(esc(lib))::Ptr{Cvoid}, $(esc(func)))::Ptr{Cvoid}
                $z[] = zlocal
            end
            zlocal
        end
    end
end

mylibvar = Libdl.dlopen("mylib")
@ccall $(@dlsym(mylibvar, "myfunc"))()::Cvoid
```

## Closure cfunctions

最初の引数 [`@cfunction`](@ref) は `$` でマークすることができ、その場合、戻り値は引数を閉じ込める `struct CFunction` になります。この戻りオブジェクトがすべての使用が完了するまで生き続けることを確認する必要があります。cfunction ポインタの内容とコードは、この参照がドロップされ、atexit で [`finalizer`](@ref) によって消去されます。これは通常必要ありませんが、この機能は C には存在しないため、別のクロージャ環境パラメータを提供しない設計の悪い API を扱う際に便利です。

```julia
function qsort(a::Vector{T}, cmp) where T
    isbits(T) || throw(ArgumentError("this method can only qsort isbits arrays"))
    callback = @cfunction $cmp Cint (Ref{T}, Ref{T})
    # Here, `callback` isa Base.CFunction, which will be converted to Ptr{Cvoid}
    # (and protected against finalization) by the ccall
    @ccall qsort(a::Ptr{T}, length(a)::Csize_t, Base.elsize(a)::Csize_t, callback::Ptr{Cvoid})
    # We could instead use:
    #    GC.@preserve callback begin
    #        use(Base.unsafe_convert(Ptr{Cvoid}, callback))
    #    end
    # if we needed to use it outside of a `ccall`
    return a
end
```

!!! note
    Closure [`@cfunction`](@ref) は、すべてのプラットフォーム（例えば ARM や PowerPC）で利用できない LLVM トランポリンに依存しています。


## Closing a Library

ライブラリを閉じて（アンロード）再ロードできるようにすることは、時には便利です。たとえば、Juliaで使用するCコードを開発しているとき、Cコードをコンパイルし、JuliaからCコードを呼び出し、その後ライブラリを閉じて、編集を行い、再コンパイルし、新しい変更をロードする必要があるかもしれません。Juliaを再起動するか、`Libdl`関数を使用してライブラリを明示的に管理することができます。例えば：

```julia
lib = Libdl.dlopen("./my_lib.so") # Open the library explicitly.
sym = Libdl.dlsym(lib, :my_fcn)   # Get a symbol for the function to call.
@ccall $sym(...) # Use the pointer `sym` instead of the library.symbol tuple.
Libdl.dlclose(lib) # Close the library explicitly.
```

`@ccall`を使用する際、入力（例：`@ccall "./my_lib.so".my_fcn(...)::Cvoid`）に注意してください。このライブラリは暗黙的に開かれ、明示的に閉じられない場合があります。

## Variadic function calls

可変引数のC関数を呼び出すには、引数リスト内で`セミコロン`を使用して必須引数と可変引数を区切ることができます。以下に`printf`関数の例を示します:

```julia-repl
julia> @ccall printf("%s = %d\n"::Cstring ; "foo"::Cstring, foo::Cint)::Cint
foo = 3
8
```

## [`ccall` interface](@id ccall-interface)

別の代替インターフェースがあります `@ccall`。このインターフェースは少し便利さに欠けますが、[calling convention](@ref calling-convention) を指定することができます。

[`ccall`](@ref)への引数は次のとおりです：

1. `(:function, "library")` ペア（最も一般的な）、

    OR

    `:function` 名のシンボルまたは `"function"` 名の文字列（現在のプロセスまたは libc のシンボル用）、

    OR

    関数ポインタ（例えば、`dlsym`から）。
2. 関数の戻り値の型
3. 関数シグネチャに対応する入力タイプのタプル。一般的な間違いの一つは、引数タイプの1タプルは末尾にカンマを付けて書かなければならないことを忘れることです。
4. 関数に渡される実際の引数値（ある場合）；それぞれが別々のパラメータです。

!!! note
    `(:function, "library")` ペア、戻り値の型、および入力型はリテラル定数でなければなりません（つまり、変数ではなく、ただし [Non-constant Function Specifications](@ref) を参照してください）。

    残りのパラメータは、含まれているメソッドが定義されるときにコンパイル時に評価されます。


マクロと関数インターフェース間の翻訳の表は以下に示されています。

|                                                                     `@ccall` |                                                                     `ccall` |
| ----------------------------------------------------------------------------:| ---------------------------------------------------------------------------:|
|                                                      `@ccall clock()::Int32` |                                                  `ccall(:clock, Int32, ())` |
|                                                    `@ccall f(a::Cint)::Cint` |                                               `ccall(:a, Cint, (Cint,), a)` |
|                               `@ccall "mylib".f(a::Cint, b::Cdouble)::Cvoid` |                        `ccall((:f, "mylib"), Cvoid, (Cint, Cdouble), a, b)` |
|                                                    `@ccall $fptr.f()::Cvoid` |                                                 `ccall(fptr, f, Cvoid, ())` |
|      `@ccall printf("%s = %d\n"::Cstring ; "foo"::Cstring, foo::Cint)::Cint` |                                                             `<unavailable>` |
| `@ccall printf("%s = %s\n"::Cstring ; "2 + 2"::Cstring, "5"::Cstring)::Cint` |    `ccall(:printf, Cint, (Cstring, Cstring...), "%s = %s\n", "2 + 2", "5")` |
|                                                              `<unavailable>` | `ccall(:gethostname, stdcall, Int32, (Ptr{UInt8}, UInt32), hn, length(hn))` |

## [Calling Convention](@id calling-convention)

`ccall`の第二引数（戻り値の型の直前）は、オプションで呼び出し規約の指定子を指定できます（現在の`@ccall`マクロは呼び出し規約を指定することをサポートしていません）。指定子がない場合、プラットフォームのデフォルトのC呼び出し規約が使用されます。他にサポートされている規約は、`stdcall`、`cdecl`、`fastcall`、および`thiscall`（64ビットWindowsではノーオプ）です。例えば（`base/libc.jl`から）、上記と同じ`gethostname``ccall`が見られますが、Windows用の正しいシグネチャが付いています：

```julia
hn = Vector{UInt8}(undef, 256)
err = ccall(:gethostname, stdcall, Int32, (Ptr{UInt8}, UInt32), hn, length(hn))
```

詳細については、[LLVM Language Reference](https://llvm.org/docs/LangRef.html#calling-conventions)を参照してください。

特別な呼び出し規約 [`llvmcall`](@ref Base.llvmcall) があり、これによりLLVMのインストリンシックを直接呼び出すことができます。これは、GPGPUのような珍しいプラットフォームをターゲットにする際に特に便利です。例えば、[CUDA](https://llvm.org/docs/NVPTXUsage.html) の場合、スレッドインデックスを読み取る必要があります。

```julia
ccall("llvm.nvvm.read.ptx.sreg.tid.x", llvmcall, Int32, ())
```

`ccall`を使用する際は、引数のシグネチャを正確に指定することが重要です。また、`Core.Intrinsics`によって公開されている同等のJulia関数とは異なり、現在のターゲットで意味があり、機能することを保証する互換性レイヤーは存在しないことに注意してください。

## Accessing Global Variables

ネイティブライブラリによってエクスポートされたグローバル変数は、[`cglobal`](@ref) 関数を使用して名前でアクセスできます。`4d61726b646f776e2e436f64652822222c202263676c6f62616c2229_40726566` への引数は、[`ccall`](@ref) で使用されるのと同じシンボル仕様と、変数に格納されている値を説明する型です：

```julia-repl
julia> cglobal((:errno, :libc), Int32)
Ptr{Int32} @0x00007f418d0816b8
```

結果は、値のアドレスを示すポインタです。このポインタを使用して、[`unsafe_load`](@ref) および [`unsafe_store!`](@ref) を介して値を操作できます。

!!! note
    この `errno` シンボルは、「libc」というライブラリには見つからないかもしれません。これは、システムコンパイラの実装の詳細です。通常、標準ライブラリのシンボルは名前だけでアクセスされるべきであり、コンパイラが正しいものを補完します。しかし、この例に示されている `errno` シンボルはほとんどのコンパイラで特別なものであり、ここで見られる値はおそらくあなたが期待するものや望むものではありません。任意のマルチスレッド対応システムで同等のコードをCでコンパイルすると、通常は異なる関数（マクロプリプロセッサのオーバーロードを介して）を実際に呼び出し、ここに表示されているレガシー値とは異なる結果を返す可能性があります。


## Accessing Data through a Pointer

以下のメソッドは「安全でない」として説明されています。なぜなら、悪いポインタや型宣言が原因でJuliaが突然終了する可能性があるからです。

`Ptr{T}`を考えると、型`T`の内容は、`unsafe_load(ptr, [index])`を使用して参照されたメモリからJuliaオブジェクトに一般的にコピーできます。インデックス引数はオプションで（デフォルトは1）、Juliaの1ベースのインデックス付けの規則に従います。この関数は、[`getindex`](@ref)および[`setindex!`](@ref)の動作に意図的に似ています（例：`[]`アクセス構文）。

戻り値は、参照されたメモリの内容のコピーを含むように初期化された新しいオブジェクトになります。参照されたメモリは安全に解放またはリリースできます。

もし `T` が `Any` の場合、メモリにはJuliaオブジェクトへの参照（`jl_value_t*`）が含まれていると仮定され、結果はこのオブジェクトへの参照となり、オブジェクトはコピーされません。この場合、オブジェクトが常にガーベジコレクタに見えるように注意する必要があります（ポインタはカウントされませんが、新しい参照はカウントされます）ので、メモリが早期に解放されないようにしてください。オブジェクトが元々Juliaによって割り当てられていなかった場合、新しいオブジェクトは決してJuliaのガーベジコレクタによって最終化されることはありません。もし `Ptr` 自体が実際に `jl_value_t*` である場合、[`unsafe_pointer_to_objref(ptr)`](@ref) を使用して再びJuliaオブジェクト参照に変換できます。（Juliaの値 `v` は、[`pointer_from_objref(v)`](@ref) を呼び出すことで、`Ptr{Cvoid}` ポインタに変換できます。）

逆の操作（`Ptr{T}` にデータを書き込むこと）は、[`unsafe_store!(ptr, value, [index])`](@ref) を使用して実行できます。現在、これはプリミティブ型または他のポインタフリー（`isbits`）の不変構造体型にのみサポートされています。

エラーをスローする操作は、おそらく現在未実装であり、解決できるようにバグとして報告されるべきです。

もし関心のあるポインタがプレーンデータ配列（プリミティブ型または不変構造体）の場合、関数 [`unsafe_wrap(Array, ptr,dims, own = false)`](@ref) がより便利かもしれません。最終パラメータは、Julia が基盤となるバッファの「所有権を取得」し、返された `Array` オブジェクトが最終化されるときに `free(ptr)` を呼び出すべきであれば true であるべきです。`own` パラメータが省略されるか false の場合、呼び出し元はすべてのアクセスが完了するまでバッファが存在し続けることを保証しなければなりません。

Juliaの`Ptr`型における算術（例えば`+`を使用すること）は、Cのポインタ算術とは異なります。Juliaでは、`Ptr`に整数を加えると、常にポインタが*バイト*単位で移動します。これにより、ポインタ算術から得られるアドレス値は、ポインタの要素型に依存しません。

## Thread-safety

いくつかのCライブラリは、異なるスレッドからコールバックを実行します。Juliaはスレッドセーフではないため、いくつかの追加の注意が必要です。特に、2層のシステムを設定する必要があります：Cコールバックは、あなたの「実際の」コールバックの実行を*スケジュール*するだけでなければなりません（Juliaのイベントループを介して）。これを行うには、[`AsyncCondition`](@ref Base.AsyncCondition)オブジェクトを作成し、それに対して[`wait`](@ref)を呼び出します：

```julia
cond = Base.AsyncCondition()
wait(cond)
```

Cに渡すコールバックは、[`ccall`](@ref)を`:uv_async_send`に実行するだけで、`cond.handle`を引数として渡し、Juliaランタイムとの割り当てやその他の相互作用を避けるようにしてください。

イベントは統合される可能性があるため、`uv_async_send`への複数の呼び出しが条件への単一のウェイクアップ通知につながる場合があります。

## More About Callbacks

Cライブラリにコールバックを渡す方法の詳細については、次のリンクを参照してください [blog post](https://julialang.org/blog/2013/05/callback)。

## C++

C++ バインディングを作成するためのツールについては、[CxxWrap](https://github.com/JuliaInterop/CxxWrap.jl) パッケージを参照してください。

[^1]: Non-library function calls in both C and Julia can be inlined and thus may have even less overhead than calls to shared library functions. The point above is that the cost of actually doing foreign function call is about the same as doing a call in either native language.

[^2]: The [Clang package](https://github.com/ihnorton/Clang.jl) can be used to auto-generate Julia code from a C header file.
