# ModifiedCopyMacro
A Swift macro for making inline copies of a struct by modifying a property.<br/>
The syntax is similar to Kotlin's copy function for data classes: https://kotlinlang.org/docs/data-classes.html#copying

## Usage

Apply the `@Copyable` macro to a struct:

```
@Copyable
struct Person {
    let name: String
    let age: Int
}
```

and it will add a copy function for each stored property and constant.

In this case:
```
struct Person {
    let name: String
    let age: Int

    /// Returns a copy of the caller whose value for `name` is different.
    func copy(name: String) -> Self {
        .init(name: name, age: age)
    }
    
    /// Returns a copy of the caller whose value for `age` is different.
    func copy(age: Int) -> Self {
        .init(name: name, age: age)
    }
}
```

## Installation

Add the url `https://github.com/WilhelmOks/ModifiedCopyMacro.git` as a Swift Package to your project.

When prompted, select the Package Product `ModifiedCopy` (Kind: Library) to add to your target.

Make a clean build.

`import ModifiedCopy` in the file where you want to attach the `@Copyable` macro.
