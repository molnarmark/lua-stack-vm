local stack = {}
local sp = 0
local ip = 0

-- Utility stuff that no one should bother with
function split(s, delimiter)
    local result = {}

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    	local fixed = match:gsub("\t", "")
      table.insert(result, fixed)
    end

    return result
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Stack

local function push(value)
	table.insert(stack, value)
	if type(value) ~= "number" then
		ip = ip + 1
	end

	sp = #stack
end

local function pop()
	local latest = stack[#stack]
	table.remove(stack, #stack)
	ip = #stack
	sp = #stack
	return latest
end

local function halt()
	stopResource(getThisResource())
end

local function list()
	outputChatBox("Stack starts")
	for _, value in pairs(stack) do
		outputChatBox(value)
	end
	outputChatBox("Stack ends")
end

local function execute(code)
	local lines = split(code, "\n")

	for _, line in pairs(lines) do
		local words = split(line, " ")
		local ins = trim(words[1])

		if ins == "PUSH" then
			push(tonumber(words[2]))
		elseif ins == "POP" then
			pop()
		elseif ins == "ADD" then
			local value1 = pop()
			local value2 = pop()
			push(value1 + value2)
		elseif ins == "SUB" then
			local value1 = pop()
			local value2 = pop()
			push(value2 - value1)
		elseif ins == "MUL" then
			local value1 = pop()
			local value2 = pop()
			push(value1 * value2)
		elseif ins == "DIV" then
			local value1 = pop()
			local value2 = pop()
			push(value2 / value1)
		elseif ins == "HALT" then
			halt()
		end
	end
end

local function VM(code)
	execute(code)
	list()
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local code = [[
PUSH 5
PUSH 4
ADD
PUSH 1
PUSH 2
ADD
PUSH 10
PUSH 5
SUB
PUSH 10
PUSH 10
MUL
PUSH 50
PUSH 2
DIV
		]]
		VM(code)
	end
)