import Foundation

import OSLog

class LoggingComponent: NSObject
{
	let logger = Logger(subsystem: "com.mykola.headquest.DemoView", category: String(describing: type(of: self)))
}

class TestingClass: LoggingComponent
{
	let testingVar: String = "test"

	override init()
	{
		super.init()
		logger.info("Testing logging")
	}
}

class Testing2
{
	let testingVar: String = "test"
	var logger = Logger()

	init()
	{
		logger = Logger(subsystem: "com.mykola.headquest.DemoView", category: String(describing: type(of: self)))
		logger.info("Testing logging")
	}
}

var test = Testing2()
