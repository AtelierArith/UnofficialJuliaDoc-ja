# Memory layout of Julia Objects

## Object layout (`jl_value_t`)

`jl_value_t` 構造体は、Julia ガーベジコレクタによって所有されるメモリのブロックの名前であり、メモリ内の Julia オブジェクトに関連付けられたデータを表します。型情報がない場合、それは単に不透明なポインタです：

```c
typedef struct jl_value_t* jl_pvalue_t;
```

各 `jl_value_t` 構造体は、Julia オブジェクトに関するメタデータ情報（その型やガーベジコレクタ（gc）の到達可能性など）を含む `jl_typetag_t` 構造体に含まれています。

```c
typedef struct {
    opaque metadata;
    jl_value_t value;
} jl_typetag_t;
```

任意のJuliaオブジェクトの型は、葉の`jl_datatype_t`オブジェクトのインスタンスです。`jl_typeof()`関数を使用して、それを照会できます：

```c
jl_value_t *jl_typeof(jl_value_t *v);
```

オブジェクトのレイアウトはそのタイプに依存します。リフレクションメソッドを使用してそのレイアウトを検査できます。フィールドには、get-fieldメソッドのいずれかを呼び出すことでアクセスできます。

```c
jl_value_t *jl_get_nth_field_checked(jl_value_t *v, size_t i);
jl_value_t *jl_get_field(jl_value_t *o, char *fld);
```

フィールドタイプが事前にすべてポインタであることが知られている場合、値は配列アクセスとして直接抽出することもできます：

```c
jl_value_t *v = value->fieldptr[n];
```

例として、「ボックス化された」`uint16_t`は次のように格納されます：

```c
struct {
    opaque metadata;
    struct {
        uint16_t data;        // -- 2 bytes
    } jl_value_t;
};
```

このオブジェクトは `jl_box_uint16()` によって作成されます。`jl_value_t` ポインタは、構造体の上部にあるメタデータではなく、データ部分を参照していることに注意してください。

値は多くの状況で「アンボックス」されて保存される可能性があります（メタデータなしでデータのみ、場合によっては保存されずにレジスタに保持されることもあります）。したがって、ボックスのアドレスが一意の識別子であると仮定するのは安全ではありません。「egal」テスト（Juliaの`===`関数に対応する）は、2つの未知のオブジェクトの同等性を比較するために使用されるべきです：

```c
int jl_egal(jl_value_t *a, jl_value_t *b);
```

この最適化はAPIに対して比較的透明であるべきです。なぜなら、`jl_value_t`ポインタが必要なときに、オブジェクトがオンデマンドで「ボックス化」されるからです。

`jl_value_t` ポインタのメモリ内での変更は、オブジェクトがミュータブルである場合にのみ許可されます。そうでない場合、値の変更はプログラムを破損させる可能性があり、結果は未定義になります。値のミュータビリティプロパティは、次のようにして照会できます:

```c
int jl_is_mutable(jl_value_t *v);
```

もし格納されているオブジェクトが `jl_value_t` である場合、Juliaのガベージコレクタにも通知する必要があります:

```c
void jl_gc_wb(jl_value_t *parent, jl_value_t *ptr);
```

しかし、マニュアルの [Embedding Julia](@ref) セクションも、この時点での必読事項です。さまざまなタイプのボクシングとアンボクシングの詳細や、ガーベジコレクションの相互作用を理解するために必要です。

ミラー構造体は、いくつかの組み込み型に対して [defined in `julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) です。対応するグローバル `jl_datatype_t` オブジェクトは、 [`jl_init_types` in `jltypes.c`](https://github.com/JuliaLang/julia/blob/master/src/jltypes.c) によって作成されます。

## Garbage collector mark bits

ガーベジコレクタは、システム内の各オブジェクトを追跡するために、`jl_typetag_t`のメタデータ部分からいくつかのビットを使用します。このアルゴリズムに関する詳細は、[garbage collector implementation in `gc.c`](https://github.com/JuliaLang/julia/blob/master/src/gc.c)のコメントに記載されています。

## Object allocation

ほとんどの新しいオブジェクトは `jl_new_structv()` によって割り当てられます:

```c
jl_value_t *jl_new_struct(jl_datatype_t *type, ...);
jl_value_t *jl_new_structv(jl_datatype_t *type, jl_value_t **args, uint32_t na);
```

ただし、[`isbits`](@ref) オブジェクトはメモリから直接構築することもできます：

```c
jl_value_t *jl_new_bits(jl_value_t *bt, void *data)
```

いくつかのオブジェクトには、上記の関数の代わりに使用しなければならない特別なコンストラクタがあります：

タイプ:

```c
jl_datatype_t *jl_apply_type(jl_datatype_t *tc, jl_tuple_t *params);
jl_datatype_t *jl_apply_array_type(jl_datatype_t *type, size_t dim);
```

これらは最も一般的に使用されるオプションですが、[`julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) に宣言されているより低レベルのコンストラクタもあります。これらは `jl_init_types()` で使用され、Julia システムイメージの作成に必要な初期タイプを作成します。

タプル:

```c
jl_tuple_t *jl_tuple(size_t n, ...);
jl_tuple_t *jl_tuplev(size_t n, jl_value_t **v);
jl_tuple_t *jl_alloc_tuple(size_t n);
```

タプルの表現は、Juliaのオブジェクト表現エコシステムにおいて非常にユニークです。場合によっては、[`Base.tuple()`](@ref) オブジェクトは、タプルに含まれるオブジェクトへのポインタの配列である可能性があります。

```c
typedef struct {
    size_t length;
    jl_value_t *data[length];
} jl_tuple_t;
```

しかし、他のケースでは、タプルは匿名の [`isbits`](@ref) 型に変換され、アンボックスされた状態で保存されるか、または（`jl_value_t*` として一般的なコンテキストで使用されていない場合）全く保存されないことがあります。

記号:

```c
jl_sym_t *jl_symbol(const char *str);
```

関数とメソッドインスタンス:

```c
jl_function_t *jl_new_generic_function(jl_sym_t *name);
jl_method_instance_t *jl_new_method_instance(jl_value_t *ast, jl_tuple_t *sparams);
```

配列:

```c
jl_array_t *jl_new_array(jl_value_t *atype, jl_tuple_t *dims);
jl_array_t *jl_alloc_array_1d(jl_value_t *atype, size_t nr);
jl_array_t *jl_alloc_array_nd(jl_value_t *atype, size_t *dims, size_t ndims);
```

注意すべきは、これらの多くにはさまざまな特別目的のための代替割り当て関数があることです。ここに示すリストはより一般的な使用法を反映していますが、より完全なリストは [`julia.h` header file](https://github.com/JuliaLang/julia/blob/master/src/julia.h) を読むことで見つけることができます。

内部的に、Juliaではストレージは通常`newstruct()`（または特別な型の場合は`newobj()`）によって割り当てられます：

```c
jl_value_t *newstruct(jl_value_t *type);
jl_value_t *newobj(jl_value_t *type, size_t nfields);
```

最も低いレベルでは、メモリはガーベジコレクタ（`gc.c`内）への呼び出しによって割り当てられ、その後、型でタグ付けされます：

```c
jl_value_t *jl_gc_allocobj(size_t nbytes);
void jl_set_typeof(jl_value_t *v, jl_datatype_t *type);
```

!!! note "Out of date Warning"
    関数 `jl_gc_allocobj` のドキュメントと使用法は古くなっている可能性があります。


すべてのオブジェクトは4バイトの倍数で割り当てられ、プラットフォームのポインタサイズに整列されることに注意してください。メモリは、小さなオブジェクトにはプールから割り当てられ、大きなオブジェクトには直接`malloc()`で割り当てられます。

!!! sidebar "Singleton Types"
    シングルトン型はインスタンスが1つだけで、データフィールドを持ちません。シングルトンインスタンスのサイズは0バイトであり、メタデータのみで構成されています。例: `nothing::Nothing`。

    [Singleton Types](@ref man-singleton-types) と [Nothingness and missing values](@ref) を参照してください。

