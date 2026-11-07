# Memory layout of Julia Objects

## Object layout (`jl_value_t`)

`jl_value_t` struct は、Julia のガベージコレクターが所有するメモリブロックを指す名前であり、メモリ上の Julia オブジェクトに関連付けられたデータを表します。型情報がなければ、単なる不透明なポインターです。

```c
typedef struct jl_value_t* jl_pvalue_t;
```

各 `jl_value_t` struct は、Julia オブジェクトの型やガベージコレクター（gc）からの到達可能性などのメタデータを含む `jl_typetag_t` struct に格納されています。

```c
typedef struct {
    opaque metadata;
    jl_value_t value;
} jl_typetag_t;
```

Julia オブジェクトの型は、リーフ `jl_datatype_t` オブジェクトのインスタンスです。`jl_typeof()` 関数を使って取得できます。

```c
jl_value_t *jl_typeof(jl_value_t *v);
```

オブジェクトのレイアウトは、その型によって異なります。リフレクション用のメソッドを使うと、レイアウトを調べられます。フィールドには、get-field 系のメソッドを呼び出してアクセスできます。

```c
jl_value_t *jl_get_nth_field_checked(jl_value_t *v, size_t i);
jl_value_t *jl_get_field(jl_value_t *o, char *fld);
```

フィールドの型がすべてポインターであると事前に分かっている場合は、配列アクセスによって値を直接取り出すこともできます。

```c
jl_value_t *v = value->fieldptr[n];
```

たとえば、「ボックス化」された `uint16_t` は、次のように格納されます。

```c
struct {
    opaque metadata;
    struct {
        uint16_t data;        // -- 2 bytes
    } jl_value_t;
};
```

このオブジェクトは `jl_box_uint16()` によって作成されます。`jl_value_t` ポインターが参照するのは、struct の先頭にあるメタデータではなく、データ部分であることに注意してください。

多くの場合、値は「ボックス化されずに」格納されます（メタデータを伴わないデータだけが格納され、場合によっては格納すらされず、レジスターに保持されます）。そのため、ボックスのアドレスが一意な識別子であると仮定するのは安全ではありません。代わりに、「egal」テスト（Julia の `===` 関数に相当）を使って、未知の2つのオブジェクトが等価かどうかを比較してください。

```c
int jl_egal(jl_value_t *a, jl_value_t *b);
```

この最適化は API からは比較的透過的です。`jl_value_t` ポインターが必要になれば、オブジェクトはその都度ボックス化されます。

`jl_value_t` ポインターが指すメモリ上の値を変更できるのは、オブジェクトがミュータブルな場合に限られます。それ以外の場合、値を変更するとプログラムが破損するおそれがあり、結果は未定義になります。値がミュータブルかどうかは、次の方法で確認できます。

```c
int jl_is_mutable(jl_value_t *v);
```

格納するオブジェクトが `jl_value_t` の場合は、Julia のガベージコレクターにも通知する必要があります。

```c
void jl_gc_wb(jl_value_t *parent, jl_value_t *ptr);
```

ただし、ボックス化とアンボックス化の詳細や、gc との相互作用を理解するには、マニュアルの [Embedding Julia](@ref) セクションも必ず読んでください。

一部の組み込み型に対応するミラー struct は [defined in `julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) です。対応するグローバル `jl_datatype_t` オブジェクトは、[`jl_init_types` in `jltypes.c`](https://github.com/JuliaLang/julia/blob/master/src/jltypes.c) によって作成されます。

## Garbage collector mark bits

ガベージコレクターは、`jl_typetag_t` のメタデータ部分にある複数のビットを使って、システム内の各オブジェクトを追跡します。このアルゴリズムの詳細は、[garbage collector implementation in `gc-stock.c`](https://github.com/JuliaLang/julia/blob/master/src/gc-stock.c) のコメントを参照してください。

## Object allocation

新しいオブジェクトの大半は、`jl_new_structv()` によって割り当てられます。

```c
jl_value_t *jl_new_struct(jl_datatype_t *type, ...);
jl_value_t *jl_new_structv(jl_datatype_t *type, jl_value_t **args, uint32_t na);
```

ただし、[`isbits`](@ref) オブジェクトは、メモリから直接構築することもできます。

```c
jl_value_t *jl_new_bits(jl_value_t *bt, void *data)
```

また、上記の関数ではなく、専用のコンストラクターを使わなければならないオブジェクトもあります。

型:

```c
jl_datatype_t *jl_apply_type(jl_datatype_t *tc, jl_tuple_t *params);
jl_datatype_t *jl_apply_array_type(jl_datatype_t *type, size_t dim);
```

これらは最もよく使われる方法ですが、より低レベルのコンストラクターもあります。[`julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) で宣言されているものを参照してください。これらは `jl_init_types()` で使われ、Julia のシステムイメージを作成するための初期型をブートストラップします。

タプル:

```c
jl_tuple_t *jl_tuple(size_t n, ...);
jl_tuple_t *jl_tuplev(size_t n, jl_value_t **v);
jl_tuple_t *jl_alloc_tuple(size_t n);
```

Julia のオブジェクト表現において、タプルの表現方法は非常に独特です。場合によっては、[`Base.tuple()`](@ref) オブジェクトが、タプルに含まれるオブジェクトへのポインターを並べた配列となり、次のように表されます。

```c
typedef struct {
    size_t length;
    jl_value_t *data[length];
} jl_tuple_t;
```

一方、タプルが匿名の [`isbits`](@ref) 型に変換され、ボックス化されずに格納される場合もあります。また、ジェネリックなコンテキストで `jl_value_t*` として使われない場合は、そもそも格納されないこともあります。

シンボル:

```c
jl_sym_t *jl_symbol(const char *str);
```

関数と MethodInstance:

```c
jl_value_t *jl_new_generic_function(jl_sym_t *name);
jl_method_instance_t *jl_new_method_instance(jl_value_t *ast, jl_tuple_t *sparams);
```

配列:

```c
jl_array_t *jl_new_array(jl_value_t *atype, jl_tuple_t *dims);
jl_array_t *jl_alloc_array_1d(jl_value_t *atype, size_t nr);
jl_array_t *jl_alloc_array_nd(jl_value_t *atype, size_t *dims, size_t ndims);
```

これらの多くには、さまざまな特殊用途向けの別の割り当て関数もあります。ここでは一般的な使い方を示していますが、より網羅的な一覧は [`julia.h` header file](https://github.com/JuliaLang/julia/blob/master/src/julia.h) を読んで確認できます。

Julia 内部では、通常、`newstruct()` によってストレージが割り当てられます（特殊な型の場合は `newobj()`）。

```c
jl_value_t *newstruct(jl_value_t *type);
jl_value_t *newobj(jl_value_t *type, size_t nfields);
```

最も低いレベルでは、ガベージコレクター（`gc-stock.c`）を呼び出してメモリを割り当て、その後、型をタグ付けします。

```c
jl_value_t *jl_gc_allocobj(size_t nbytes);
void jl_set_typeof(jl_value_t *v, jl_datatype_t *type);
```

!!! note "古い情報に関する警告"
    `jl_gc_allocobj` 関数のドキュメントと使用方法は、古くなっている可能性があります。


すべてのオブジェクトは4バイト単位で割り当てられ、プラットフォームのポインターサイズに合わせてアラインメントされます。小さなオブジェクトにはプールからメモリが割り当てられ、大きなオブジェクトには `malloc()` によって直接割り当てられます。

!!! sidebar "シングルトン型"
    シングルトン型にはインスタンスが1つだけあり、データフィールドを持ちません。シングルトンのインスタンスのサイズは0バイトで、メタデータだけで構成されます。例: `nothing::Nothing`。

    [Singleton Types](@ref man-singleton-types) と [Nothingness and missing values](@ref) を参照してください。

