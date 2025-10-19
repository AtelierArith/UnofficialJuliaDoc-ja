```julia
format(dt::TimeType, format::AbstractString; locale="english") -> AbstractString
```

Construct a string by using a `TimeType` object and applying the provided `format`. The following character codes can be used to construct the `format` string:

| Code | Examples | Comment                                                   |
|:---- |:-------- |:--------------------------------------------------------- |
| `y`  | 6        | Numeric year with a fixed width                           |
| `Y`  | 1996     | Numeric year with a minimum width                         |
| `m`  | 1, 12    | Numeric month with a minimum width                        |
| `u`  | Jan      | Month name shortened to 3-chars according to the `locale` |
| `U`  | January  | Full month name according to the `locale` keyword         |
| `d`  | 1, 31    | Day of the month with a minimum width                     |
| `H`  | 0, 23    | Hour (24-hour clock) with a minimum width                 |
| `M`  | 0, 59    | Minute with a minimum width                               |
| `S`  | 0, 59    | Second with a minimum width                               |
| `s`  | 000, 500 | Millisecond with a minimum width of 3                     |
| `e`  | Mon, Tue | Abbreviated days of the week                              |
| `E`  | Monday   | Full day of week name                                     |

The number of sequential code characters indicate the width of the code. A format of `yyyy-mm` specifies that the code `y` should have a width of four while `m` a width of two. Codes that yield numeric digits have an associated mode: fixed-width or minimum-width. The fixed-width mode left-pads the value with zeros when it is shorter than the specified width and truncates the value when longer. Minimum-width mode works the same as fixed-width except that it does not truncate values longer than the width.

When creating a `format` you can use any non-code characters as a separator. For example to generate the string "1996-01-15T00:00:00" you could use `format`: "yyyy-mm-ddTHH:MM:SS". Note that if you need to use a code character as a literal you can use the escape character backslash. The string "1996y01m" can be produced with the format raw"yyyy\ymm\m".
