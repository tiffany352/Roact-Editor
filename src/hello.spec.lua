return function()
	local hello = require(script.Parent.hello)

	it("should issue a greeting", function()
		local greeting = hello()

		expect(greeting:find("Hello")).to.be.ok()
		expect(greeting:find("Roact Editor")).to.be.ok()
	end)
end