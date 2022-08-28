//: [Previous](@previous)

import Foundation

let hs = HealthState.shared

print(hs.readHp())
print(HealthState.shared.readHp())

HealthState.shared.takeDamage(amount: 1)

print(hs.readHp())
print(HealthState.shared.readHp())

hs.takeDamage(amount: 1)

print(hs.readHp())
print(HealthState.shared.readHp())
