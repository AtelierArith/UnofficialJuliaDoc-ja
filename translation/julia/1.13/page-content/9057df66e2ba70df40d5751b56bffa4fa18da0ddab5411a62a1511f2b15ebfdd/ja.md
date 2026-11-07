```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/TOML/docs/src/index.md"
```

# TOML

TOML.jlは、[TOML v1.0](https://toml.io/en/)ファイルを解析・書き込みするためのJulia標準ライブラリです。

## Parsing TOML data

```jldoctest
julia> using TOML

julia> data = """
           [database]
           server = "192.168.1.1"
           ports = [ 8001, 8001, 8002 ]
       """;

julia> TOML.parse(data)
Dict{String, Any} with 1 entry:
  "database" => Dict{String, Any}("server"=>"192.168.1.1", "ports"=>[8001, 8001…
```

ファイルを解析するには、[`TOML.parsefile`](@ref)を使います。ファイルに構文エラーがある場合は、例外がスローされます。

```jldoctest
julia> using TOML

julia> TOML.parse("""
           value = 0.0.0
       """)
ERROR: TOML Parser error:
none:1:16 error: failed to parse value
      value = 0.0.0
                 ^
[...]
```

解析エラー時に例外をスローする代わりに、情報を含む[`TOML.ParserError`](@ref)を返す解析関数もあります（[`TOML.tryparse`](@ref)および[`TOML.tryparsefile`](@ref)）。

```jldoctest
julia> using TOML

julia> err = TOML.tryparse("""
           value = 0.0.0
       """);

julia> err.type
ErrGenericValueError::ErrorType = 14

julia> err.line
1

julia> err.column
16
```

## Exporting data to TOML file

データをTOML形式で出力（シリアライズ）するには、[`TOML.print`](@ref)関数を使います。

```jldoctest; filter = r"^\s*\S+\s*=.*"m
julia> using TOML

julia> data = Dict(
          "names" => ["Julia", "Julio"],
          "age" => [10, 20],
       );

julia> TOML.print(data)
names = ["Julia", "Julio"]
age = [10, 20]

julia> fname = tempname();

julia> open(fname, "w") do io
           TOML.print(io, data)
       end

julia> TOML.parsefile(fname)
Dict{String, Any} with 2 entries:
  "names" => ["Julia", "Julio"]
  "age"   => [10, 20]
```

キーは、指定した値に従って並べ替えることができます。

```jldoctest
julia> using TOML

julia> TOML.print(Dict(
       "abc"  => 1,
       "ab"   => 2,
       "abcd" => 3,
       ); sorted=true, by=length)
ab = 2
abc = 1
abcd = 3
```

カスタム構造体の場合は、構造体をサポートされている型に変換する関数を渡します。

```jldoctest
julia> using TOML

julia> struct MyStruct
           a::Int
           b::String
       end

julia> TOML.print(Dict("foo" => MyStruct(5, "bar"))) do x
           x isa MyStruct && return [x.a, x.b]
           error("unhandled type $(typeof(x))")
       end
foo = [5, "bar"]
```

## References

```@docs
TOML.parse
TOML.parsefile
TOML.tryparse
TOML.tryparsefile
TOML.print
TOML.Parser
TOML.ParserError
```
