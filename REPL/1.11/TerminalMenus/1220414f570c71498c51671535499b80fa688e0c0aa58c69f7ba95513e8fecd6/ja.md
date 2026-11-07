```julia
AbstractMenu
```

すべての Menu 型のスーパータイプです。

# Functions

以下の関数は、すべての <:AbstractMenu 型に対して呼び出せます。詳細は次を参照してください。

## Exported

  * `request(m::AbstractMenu)`
  * `request(msg::AbstractString, m::AbstractMenu)`

## Hidden

  * `printmenu(m::AbstractMenu, cursor::Int; init::Bool=false, oldstate=nothing)`

# Subtypes

すべてのサブタイプはミュータブルでなければならず、`pagesize::Int` と `pageoffset::Int` のフィールドを含む必要があります。また、以下の関数も実装しなければなりません。

## Necessary Functions

AbstractMenu のすべてのサブタイプで、以下の関数を実装する必要があります。

  * `pick(m::AbstractMenu, cursor::Int)`
  * `cancel(m::AbstractMenu)`
  * `options(m::AbstractMenu)`   # `numoptions` は代替手段です
  * `writeline(buf::IO, m::AbstractMenu, idx::Int, iscursor::Bool)`

`m` に `selected` というフィールドがない場合は、`selected(m)` も実装する必要があります。

## Optional Functions

以下の関数は、すべての AbstractMenu サブタイプで実装する必要はありません。

  * `header(m::AbstractMenu)`
  * `keypress(m::AbstractMenu, i::UInt32)`
  * `numoptions(m::AbstractMenu)`
  * `selected(m::AbstractMenu)`
