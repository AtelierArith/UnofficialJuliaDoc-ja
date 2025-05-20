```
Serialization.writeheader(s::AbstractSerializer)
```

Write an identifying header to the specified serializer. The header consists of 8 bytes as follows:

| Offset | Description                                |
|:------ |:------------------------------------------ |
| 0      | tag byte (0x37)                            |
| 1-2    | signature bytes "JL"                       |
| 3      | protocol version                           |
| 4      | bits 0-1: endianness: 0 = little, 1 = big  |
| 4      | bits 2-3: platform: 0 = 32-bit, 1 = 64-bit |
| 5-7    | reserved                                   |
