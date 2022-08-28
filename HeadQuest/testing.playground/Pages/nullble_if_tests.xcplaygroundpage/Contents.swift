//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

var optBool: [String]?

if optBool == nil || optBool!.isEmpty
{
	print("no error")
}

optBool = []

if optBool == nil || optBool!.isEmpty
{
	print("no error")
}

print("Done")



let s1 = Set(["t1", "t2", "t3"])
let s2 = Set(["t2", "t3", "t1"])

print(s1 == s2)
