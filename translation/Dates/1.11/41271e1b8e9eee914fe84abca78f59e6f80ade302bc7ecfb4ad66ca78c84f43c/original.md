```julia
format(io::IO, tok::AbstractDateToken, dt::TimeType, locale)
```

Format the `tok` token from `dt` and write it to `io`. The formatting can be based on `locale`.

All subtypes of `AbstractDateToken` must define this method in order to be able to print a Date / DateTime object according to a `DateFormat` containing that token.
