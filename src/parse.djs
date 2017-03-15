so ./language as parser
so fs

fs dose readFile with process.argv[2] much err content
	rly err
		console dose error with err
		return
	wow
	try {
		very result is parser dose parse with content.toString()
	} catch(e) {
		console dose error with e
	}
	console dose loge with result
wow&
