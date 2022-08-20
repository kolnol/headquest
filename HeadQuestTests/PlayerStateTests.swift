//
//  HeadQuestTests.swift
//  HeadQuestTests
//
//  Created by Mykola Odnoshyvkin on 09.05.22.
//

@testable import HeadQuest
import XCTest

class PlayerStateTests: XCTestCase
{
	func testAccessToHealthState() async throws
	{
		// concurrently update health
		let expect = expectation(description: "Multiple threads can access health state simulteniously")
		await withTaskGroup(of: Void.self)
		{ taskGroup in
			for _ in 1 ... 10
			{
				taskGroup.addTask
				{
					HealthState.shared.takeDamage(amount: 1)
				}
			}
			taskGroup.addTask
			{
				print("Reading HP with value \(HealthState.shared.readHp())")
			}
			taskGroup.addTask
			{
				print("Reading is Dead with vlaue \(HealthState.shared.readIsDead())")
			}
		}
		expect.fulfill()
		await waitForExpectations(timeout: 5)
		{
			error in XCTAssert(error == nil, "Concurrent expectation failed with error \(String(describing: error))")
		}
	}

	func testAccessToPlayerStateHealthState() async throws
	{
		let playerState = PlayerState.shared
		// concurrently update health
		let expect = expectation(description: "Multiple threads can access health state simulteniously")
		await withTaskGroup(of: Void.self)
		{ taskGroup in
			for _ in 1 ... 10
			{
				taskGroup.addTask
				{
					playerState.healthState.takeDamage(amount: 1)
				}
			}
			taskGroup.addTask
			{
				print("Reading HP with value \(playerState.healthState.readHp())")
			}
			taskGroup.addTask
			{
				print("Reading is Dead with vlaue \(playerState.healthState.readIsDead())")
			}
		}
		expect.fulfill()
		await waitForExpectations(timeout: 5)
		{
			error in XCTAssert(error == nil, "Concurrent expectation failed with error \(String(describing: error))")
		}
	}

	func testAccessToPlayerStateHealthState_When_heal_after_dead_Then_exception() async throws
	{
		let playerState = PlayerState.shared
		// concurrently update health
		await withTaskGroup(of: Void.self)
		{ taskGroup in
			for _ in 1 ... 10
			{
				taskGroup.addTask
				{
					playerState.healthState.takeDamage(amount: 1)
				}
			}
			taskGroup.addTask
			{
				print("Reading HP with value \(playerState.healthState.readHp())")
			}
			taskGroup.addTask
			{
				print("Reading is Dead with vlaue \(playerState.healthState.readIsDead())")
			}
		}

		do
		{
			try playerState.healthState.heal(amount: 1)
		}
		catch let PlayerStateError.CanNotHealError(message)
		{
			XCTAssert(!message.isEmpty)
		}
	}
}
