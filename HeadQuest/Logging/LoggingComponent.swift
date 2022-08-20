//
//  LoggingComponent.swift
//  HeadQuest
//
//  Created by Mykola Odnoshyvkin on 13.08.22.
//

import Foundation
import OSLog

public class LoggingComponent
{
	let logger: Logger

	init()
	{
		logger = Logger(subsystem: "com.mykola.headquest.DemoView", category: String(describing: type(of: self)))
	}
}
