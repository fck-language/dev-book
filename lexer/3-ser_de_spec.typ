#import "../prelude.typ": *

== NFA table serialization <lex-nfa-serde>

== Saving pre-compressed tables

Compressing tables is a fairly intensive task when compared to using the tables. As such, we want to limit the number of times we do this. When using custom languages, we have the following file structure under `$FCK/languages`#footnote[*`languages`* is a language specific term. This will depend on the language set in `$FCK/.fck`]:

```
- languages
  - language_files.fckl
  - comp
    - language_files.bin
```

This directory (`languages`) includes all the custom language files with the `.fckl` extension. Let's assume that one of these language files is `eg.fckl` as an example. The firs time we use `!!eg` in code, the lexer looks for `eg.fckl` in the `languages` directory. If it's not there, then we can't load the language so we get an error. If it is there, the lexer then looks for `eg.bin` in the `comp` directory#footnote[`comp` is not language specific since it's only intended for the lexer and anyone wanting to make some strange custom languages]. If it finds this file, it will read it and deserialize it into the three tables (assuming it doesn't find any errors). If it does not exist, it will compress the language it just read and write the tables to `comp/eg.bin`. It can then parse the input using the tables.

=== Serialization specification

This section describes the serialization of several types:

#grid(columns: (100% / 3,) * 3,
	list(raw(lang: "rust", "u8"), raw(lang: "rust", "usize"), raw(lang: "rust", "UStream")),
	list(raw(lang: "rust", "u16"), raw(lang: "rust", "[T; 256]")),
	list(raw(lang: "rust", "u32"), raw(lang: "rust", "Vec<T>"))
)

Serialization is handled by the following trait

```rust
pub trait SerializeBin {
    fn serialize(&self, out: &mut Vec<u8>);
}
```

where `out` is the buffer being written to with each element being a single byte. This will be referred to as "the buffer" from now on, with "written to the buffer" meaning elements being appended to this vector.

Firstly, the types #raw(lang: "rust", "u8"), #raw(lang: "rust", "u16"), and #raw(lang: "rust", "u32") are all written to the buffer in their respective sizes (2 bytes for #raw(lang: "rust", "u16") for example). It is up to the deserialization to know what type it's deserializing and take the appropriate number of bytes to do this.

#raw(lang: "rust", "usize") is serialized by casting it as a #raw(lang: "rust", "u32") then serializing that. This is done because any serialized #raw(lang: "rust", "usize") is never expected to exceed #raw(lang: "rust", "u32::MAX") in this case, but still needs to be kept as a #raw(lang: "rust", "usize") in code.

#raw(lang: "rust", "[T; 256]") and #raw(lang: "rust", "Vec<T>") are serialized by serializing each element with no break. This is only implemented where #raw(lang: "rust", "T: SerializeBin"). As with the primitive types, it's up to the deserialization to know what type is being deserialized and act accordingly.

Finally, to serialize #raw(lang: "rust", "UStream"), we do the following for the stream, origin, then offsets in that order where all the types are vectors:

1. Serialize the length of the vector
2. Serialize the vector by serializing each row for which we know the length

==== Deserialization

Deserialization is fairly simple since we defined the serialization process above. Deserialization is used to read a compressed table (`UStream`) from a binary file. This is done with a deserialization trait

```rust
pub(crate) trait Deserialize<'a> {
    fn deserialize<T>(s: &mut T) -> Result<Self, String> where
        Self: Sized,
        T: Iterator<Item = &'a str>;
}
```

This is only a #raw(lang: "rust", "pub(crate)") because it has a public function to deserialize `UStream`s since that's all that needs to be public.
