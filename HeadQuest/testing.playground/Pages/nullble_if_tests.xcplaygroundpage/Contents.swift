//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

var optBool:[String]? = nil

if optBool == nil || optBool!.isEmpty {
    print("no error")
}

optBool = []

if optBool == nil || optBool!.isEmpty {
    print("no error")
}

print("Done")
