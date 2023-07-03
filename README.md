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

## Capabilities, Limitations and Design Choices

### Chains for multiple changes

To make a copy of a struct and modify multiple properties, you can chain the `copy` calls like this:<br/>
`Person(name: "Walter White", age: 50).copy(age: 52).copy(name: "Heisenberg")`<br/>

This is different than Kotlin's version of `copy`, which allows multiple parameters to pass in a single call.<br/>
It's not possible to implement it like that in Swift because it's not possible to have default values for parameters which refer to the current values of the properties of the struct (or class).<br/>
And we also can't use nil as a marker for the old/current value, because nil might be a valid new value that we want the property to set to when we make a copy.<br/>
There might be a way that I'm not aware of, to still make it possible. So if you know how to do it, please let me know.<br/>

### Stored properties and constants

A copy function will be generated for each stored property (`var`) and each constant (`let`) of the struct.<br/>
The macro recognizes computed properties by checking if they have `get` or `set` accessors.<br/>

### Only for struct

This macro works only for structs.<br/>
It doesn't make sense for enums because enums can't have stored properties.<br/>
Classes and actors have reference semantics and I don't want this library to provide a copy function for reference types. I just want to augment the natural copy capability of structs with modified properties.<br/>
This macro emits a Diagnostic Message when you try to apply it to anything but a struct.<br/>

### Only with default init

The generated copy functions produce the copies by calling the synthesized default initializer.<br/>
So, if you provide a custom initializer, no default initializer will be synthesized and the copy functions won't work.<br/>
You can still have synthesized default initializers if you define your custom initializers in an extension.<br/>

### No struct extensions

You can't apply this macro on an extension of a struct.<br/>
This seems to be a limitation of the macro system.<br/>
If you know how to make it possible, please let me know :)

## Installation

Add the url `https://github.com/WilhelmOks/ModifiedCopyMacro.git` as a Swift Package to your project.

When prompted, select the Package Product `ModifiedCopy` (Kind: Library) to add to your target.

Make a clean build.

`import ModifiedCopy` in the file where you want to attach the `@Copyable` macro.
