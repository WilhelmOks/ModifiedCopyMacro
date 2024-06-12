import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import ModifiedCopyMacros
import ModifiedCopy

let testMacros: [String: Macro.Type] = [
    "Copyable": ModifiedCopyMacro.self,
]

@Copyable
struct Person: Equatable {
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

final class ModifiedCopyTests: XCTestCase {
    func testMacroExpansion() {
        assertMacroExpansion(
            #"""
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
            """#,
            expandedSource:
            #"""
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

                /// Returns a copy of the caller whose value for `name` is different.
                private func copy(name: String) -> Self {
                    .init(name: name, age: age, favoriteColor: favoriteColor, nickName: nickName)
                }

                /// Returns a copy of the caller whose value for `age` is different.
                public func copy(age: Int) -> Self {
                    .init(name: name, age: age, favoriteColor: favoriteColor, nickName: nickName)
                }

                /// Returns a copy of the caller whose value for `favoriteColor` is different.
                private func copy(favoriteColor: String) -> Self {
                    .init(name: name, age: age, favoriteColor: favoriteColor, nickName: nickName)
                }
            
                /// Returns a copy of the caller whose value for `nickName` is different.
                public func copy(nickName: String?) -> Self {
                    .init(name: name, age: age, favoriteColor: favoriteColor, nickName: nickName)
                }
            }
            """#,
            macros: testMacros
        )
    }
    
    func testNewLetValue() {
        let person = Person(name: "Walter White", age: 50, nickName: "Heisenberg")
        let copiedPerson = person.copy(age: 51)
        XCTAssertEqual(Person(name: "Walter White", age: 51, nickName: "Heisenberg"), copiedPerson)
    }
    
    func testNewVarValue() {
        let person = Person(name: "Walter White", age: 50, nickName: "Heisenberg")
        let copiedPerson = person.copy(name: "W.W.")
        XCTAssertEqual(Person(name: "W.W.", age: 50, nickName: "Heisenberg"), copiedPerson)
    }
    
    func testNewOptionalValue() {
        let person = Person(name: "Walter White", age: 50, nickName: "Heisenberg")
        let copiedPerson = person.copy(nickName: nil)
        XCTAssertEqual(Person(name: "Walter White", age: 50, nickName: nil), copiedPerson)
    }
    
    func testChainedNewValues() {
        let person = Person(name: "Walter White", age: 50, nickName: "Heisenberg")
        let copiedPerson = person.copy(name: "Skyler White").copy(age: 48)
        XCTAssertEqual(Person(name: "Skyler White", age: 48, nickName: "Heisenberg"), copiedPerson)
    }
}
