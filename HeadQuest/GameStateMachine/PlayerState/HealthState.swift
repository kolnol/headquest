//
//  HealthState.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 15.08.22.
//

import Foundation
// NOT USED YET
public final class HealthState
{
	// Singleton implementation
	public static let shared = HealthState()
	private let serialQueue = DispatchQueue(label: "healthStateSerialQueue")

	private final let maxHp = 3
	private var hp: Int
	private var isDead = false

	private init()
	{
		hp = maxHp
	}

	public func readHp() -> Int
	{
		var value: Int?
		serialQueue.sync
		{
			value = hp
		}
		return value!
	}

	public func takeDamage(amount: Int)
	{
		serialQueue.sync
		{
			hp = hp - amount
			if hp <= 0
			{
				hp = 0
				isDead = true
			}
		}
	}

	public func heal(amount: Int) throws
	{
		try serialQueue.sync
		{
			if isDead
			{
				throw PlayerStateError.CanNotHealError(message: "Trying to heal dead body.")
			}

			let newHp = hp + amount
			if newHp >= maxHp
			{
				hp = maxHp
			}
			else
			{
				hp = newHp
			}
		}
	}

	public func readIsDead() -> Bool
	{
		var value: Bool?
		serialQueue.sync
		{
			value = isDead
		}
		return value!
	}

	public func updateIsDead(newIsDead: Bool)
	{
		serialQueue.sync
		{
			isDead = newIsDead
		}
	}
    
    
}
