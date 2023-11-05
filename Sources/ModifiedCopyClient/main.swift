import ModifiedCopy

@Copyable
public struct Person {
    private(set) var name: String
    
    let age: Int
    
    private var favoriteColor: String
    
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
    
    init(name: String, age: Int, favoriteColor: String, nickName: String? = nil) {
        self.name = name
        self.age = age
        self.favoriteColor = favoriteColor
        self.nickName = nickName
    }
}

print("Person copy with new age: \(Person(name: "Hank", age: 50, favoriteColor: "pink", nickName: "Hanky").copy(age: 42).age)")
