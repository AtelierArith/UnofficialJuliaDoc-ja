```julia
ImmutableDict
```

`ImmutableDict` is a dictionary implemented as an immutable linked list, which is optimal for small dictionaries that are constructed over many individual insertions. Note that it is not possible to remove a value, although it can be partially overridden and hidden by inserting a new value with the same key.

```julia
ImmutableDict(KV::Pair)
```

Create a new entry in the `ImmutableDict` for a `key => value` pair

  * use `(key => value) in dict` to see if this particular combination is in the properties set
  * use `get(dict, key, default)` to retrieve the most recent value for a particular key
