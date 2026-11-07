```julia
escape_raw_string(s::AbstractString, delim='"')::AbstractString
escape_raw_string(io, s::AbstractString, delim='"')
```

raw文字列リテラルの解析で使われる方法で、文字列をエスケープします。入力文字列 `s`（指定されている場合は `delim`）に含まれる各二重引用符（`"`）について、この関数はその直前にあるバックスラッシュ（`\`）の数 *n* を数え、その数を *n* から 2*n*+1 に増やします（*n* = 0 の場合も同様です）。また、文字列末尾に連続するバックスラッシュも2倍にします。

このエスケープ規則は、raw文字列やその他の非標準文字列リテラルで使われます。（また、Microsoft C/C++コンパイラのランタイムがコマンドライン文字列を解析して argv[] 配列に格納する際に必要とするエスケープ規則でもあります。）

関連項目: [`Base.escape_string()`](@ref)。
