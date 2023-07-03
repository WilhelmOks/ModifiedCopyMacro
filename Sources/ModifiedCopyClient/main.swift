import ModifiedCopy

@Copyable
struct Person {
    var name: String
    
    let age: Int
    
    /// This should not generate a copy function because it's not a stored property.
    var fullName: String {
        get {
            name
        }
        set {
            name = newValue
        }
    }
    
    /// This should not generate a copy function because it's not a stored property.
    var uppercasedName: String {
        name.uppercased()
    }
    
    var nickName: String? = "Bobby Tables" {
        didSet {
            print("nickName changed to \(nickName ?? "(nil)")")
        }
    }
}

print("Person copy with new age: \(Person(name: "Hank", age: 50, nickName: "Hanky").copy(age: 42).age)")
