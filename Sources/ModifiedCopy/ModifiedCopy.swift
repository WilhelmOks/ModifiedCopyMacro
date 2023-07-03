// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that adds a `copy` function to a struct for each stored property that the struct contains.
/// Each `copy` function returns a copy of the struct that the macro is attached on, but one property can be set to a differnet value.
@attached(member, names: named(copy))
public macro Copyable() = #externalMacro(module: "ModifiedCopyMacros", type: "ModifiedCopyMacro")
