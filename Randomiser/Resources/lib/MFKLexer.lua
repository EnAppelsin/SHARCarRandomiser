--[[
Credits: 
	Lucas: Figuring out the token system
	Proddy: Lua optimisations and class system
]]
MFKLexer = {}

local Char_Tab = 9
local Char_LF = 10
local Char_CR = 13
local Char_Space = 32
local Char_Quote = 34
local Char_Asterisk = 42
local Char_FWSlash = 47
local Char_Backslash = 92
local WhiteSpaceCharacters = {
	[9] = true, -- Tab
	[10] = true, -- \n
	[13] = true, -- \r
	[32] = true, -- Space
}

local TokenEndCharacters = {
	[9] = true, -- Tab
	[10] = true, -- \n
	[13] = true, -- \r
	[32] = true, --  Space
	[33] = true, -- !
	[34] = true, -- "
	[35] = true, -- #
	[36] = true, -- $
	[37] = true, -- %
	[38] = true, -- &
	[39] = true, -- '
	[40] = true, -- (
	[41] = true, -- )
	[42] = true, -- *
	[43] = true, -- +
	[44] = true, -- ,
	[47] = true, -- /
	[58] = true, -- :
	[59] = true, -- ;
	[60] = true, -- <
	[62] = true, -- >
	[63] = true, -- ?
	[64] = true, -- @
	[91] = true, -- [
	[92] = true, -- \
	[93] = true, -- ]
	[94] = true, -- ^
	[96] = true, -- `
	[123] = true, -- {
	[125] = true, -- }
	[126] = true, -- ~
}

local tblconcat = table.concat
local strbyte = string.byte


MFKLexer.MFKFunction = {}
function MFKLexer.MFKFunction:New(Name, Arguments, Conditional, Not)
	Arguments = Arguments or {}
	if type(Arguments) ~= "table" then Arguments = {Arguments} end
	local cmd = {}
	cmd.Name, cmd.Arguments, cmd.Conditional, cmd.Not, cmd.Children = Name, Arguments, Conditional, Not, {}
	self.__index = self
	return setmetatable(cmd, self)
end

function MFKLexer.MFKFunction:AddChildFunction(Func)
	assert(Conditional, "Adding child function to a not-conditional function")
	self.Children[#self.Children + 1] = Func
end

function MFKLexer.MFKFunction:SetArg(Index, Value)
	self.Arguments[Index] = Value
end

function MFKLexer.MFKFunction:SetArgIf(Index, Value, Condition)
	if tostring(self.Arguments[Index]) == tostring(Condition) then self.Arguments[Index] = Value end
end

function MFKLexer.MFKFunction:__tostring(Clean)
	local output = {}
	if self.Not then output[1] = "!" end
	output[#output + 1] = "\"" .. self.Name .. "\"("
	for i=1,#self.Arguments do
		if i > 1 then output[#output + 1] = "," end
		output[#output + 1] = "\"" .. self.Arguments[i] .. "\""
	end
	output[#output + 1] = ")"
	if self.Conditional then
		output[#output + 1] = "{"
		if Clean then output[#output + 1] = "\r\n" end
		for i=1,#self.Children do
			output[#output + 1] = self.Children[i]:__tostring(Clean)
		end
		if Clean then output[#output + 1] = "\r\n" end
		output[#output + 1] = "}"
	else
		output[#output + 1] = ";"
	end
	if Clean then output[#output + 1] = "\r\n" end
	return tblconcat(output)
end
function MFKLexer.MFKFunction:Output(Clean)
	Output("\"" .. self.Name .. "\"(")
	for i=1,#self.Arguments do
		if i > 1 then Output(",") end
		Output("\"" .. self.Arguments[i] .. "\"")
	end
	Output(")")
	if self.Conditional then
		Output("{")
		if Clean then Output("\r\n") end
		for i=1,#self.Children do
			self.Children[i]:Output()
		end
		if Clean then Output("\r\n") end
		Output("}")
	else
		Output(";")
	end
	if Clean then Output("\r\n") end
end


MFKLexer.Lexer = {}
function MFKLexer.Lexer:New()
	local RetVal = {}
	RetVal.Functions = {}
	
	self.__index = self
	return setmetatable(RetVal, self)
end

function MFKLexer.Lexer:Parse(Text)
	local RetVal = {}
	local TextBytes = {strbyte(Text, 1, #Text)}
	local TextOffset = 0
	local Line = 1
	local Character
	
	local function Advance()
		TextOffset = TextOffset + 1
		if TextOffset <= #TextBytes then
			Character = TextBytes[TextOffset]
		else
			Character = 0
		end
		
		if Character == Char_LF then Line = Line + 1 end
	end
	
	Advance()
	
	local function SkipWhiteSpace()
		while Character ~= 0 and WhiteSpaceCharacters[Character] do
			Advance()
		end
	end

	local function SkipComment()
		if Character == Char_FWSlash then
			Advance()
			
			if Character == Char_FWSlash then
				while Character ~= Char_LF and Character ~= Char_CR and Character ~= 0 do
					Advance()
				end
				
				return true
			elseif Character == Char_Asterisk then
				while true do
					Advance()
					
					if Character == Char_Asterisk then
						Advance()
						
						if Character == Char_FWSlash then
							Advance()
							
							break
						end
					elseif Character == 0 then
						break
					end
				end
				
				return true
			end
		end
		
		return false
	end

	local function SkipWhiteSpaceAndComments()
		repeat
			SkipWhiteSpace()
		until not SkipComment()
	end

	local function ReadToTokenEndOrCharacter()
		local StartOffset = TextOffset
		
		while Character ~= 0 and not TokenEndCharacters[Character] do
			Advance()
		end
		
		if TextOffset == StartOffset then
			Advance()
		end
		
		return Text:sub(StartOffset, TextOffset - 1)
	end

	local function ReadToQuoteEnd()
		local StartOffset = TextOffset
		local EndOffset = StartOffset
		
		while Character ~= 0 do
			if Character == Char_Backslash then
				Advance()
				
				EndOffset = TextOffset
				
				if Character == Char_Quote then
					Advance()
					
					EndOffset = TextOffset
					
					goto Continue
				end
				
				goto Continue
			end
			
			if Character == Char_Quote then
				Advance()
				
				break
			end
			
			Advance()
			
			EndOffset = TextOffset
			
			::Continue::
		end
		
		return Text:sub(StartOffset, EndOffset - 1)
	end

	local function ReadToken()
		SkipWhiteSpaceAndComments()
		
		if Character == 0 then return nil end
		
		if Character == Char_Quote then
			Advance()
			
			return ReadToQuoteEnd()
		end
		
		return ReadToTokenEndOrCharacter()
	end

	local function ReadTokenNotEndOfFile()
		local Result = ReadToken()
		assert(Result, "Result == nil")
		return Result
	end

	local function ExpectToken(Token)
		local Token2 = ReadToken()
		assert(Token == Token2, "Expected token: " .. Token .. "\nGot token: " .. Token2)
	end
	
	local ConditionalLevel = 0
	local ConditionalParents = {}
	RetVal.Functions = {}
	
	while true do
		local FunctionName = ReadToken()
		if FunctionName == nil then break end
		
		if FunctionName == "}" then
			ConditionalLevel = ConditionalLevel - 1
			ConditionalParents[#ConditionalParents] = nil
		else
			local Not = FunctionName == "!"
			if Not then
				FunctionName = ReadTokenNotEndOfFile()
			end
			
			ExpectToken("(")
			
			local Arguments = {}
			while true do
				local Token = ReadTokenNotEndOfFile()
				if Token == ")" then break end
				
				if #Arguments > 0 then
					assert(Token == ",", "Expected token: ,\nGot token: " .. Token)
					Token = ReadTokenNotEndOfFile()
				end
				
				Arguments[#Arguments + 1] = Token
			end
			
			local Conditional = false
			local Token2 = ReadToken()
			if Token2 == "{" then
				Conditional = true
				ConditionalLevel = ConditionalLevel + 1
			else
				assert(Token2 == ";", "Expected token: ;\nGot token: " .. Token2)
			end
			
			if not Conditional then
				assert(not Not, "! but not conditional")
			end
			
			local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
			if #ConditionalParents > 0 then
				ConditionalParents[#ConditionalParents]:AddChildFunction(Func)
			else
				RetVal.Functions[#RetVal.Functions + 1] = Func
			end
			if Conditional then
				ConditionalParents[#ConditionalParents + 1] = Func
			end
		end
	end
	
	self.__index = self
	return setmetatable(RetVal, self)
end

function MFKLexer.Lexer:AddFunction(FunctionName, Arguments, Conditional, Not)
	local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
	self.Functions[#self.Functions + 1] = Func
	return Func
end

function MFKLexer.Lexer:InsertFunction(Index, FunctionName, Arguments, Conditional, Not)
	local Func = MFKLexer.MFKFunction:New(FunctionName, Arguments, Conditional, Not)
	table.insert(self.Functions, Index, Func)
	return Func
end

local function SetFunctionArgument(FunctionName, Function, Index, Value)
	if Function.Name:lower() == FunctionName then
		Function:SetArg(Index, Value)
	end
	if Function.Conditional then
		for i=1,#Function.Children do
			SetFunctionArgument(FunctionName, Function.Children[i], Index, Value)
		end
	end
end
function MFKLexer.Lexer:SetAll(FunctionName, Index, Value)
	FunctionName = FunctionName:lower()
	for i=1,#self.Functions do
		SetFunctionArgument(FunctionName, self.Functions[i], Index, Value)
	end
end

local function SetFunctionArgumentIf(FunctionName, Function, Index, Value, Condition)
	if Function.Name:lower() == FunctionName then
		Function:SetArgIf(Index, Value, Condition)
	end
	if Function.Conditional then
		for i=1,#Function.Children do
			SetFunctionArgumentIf(FunctionName, Function.Children[i], Index, Value, Condition)
		end
	end
end
function MFKLexer.Lexer:SetAllIf(FunctionName, Index, Value, Condition)
	FunctionName = FunctionName:lower()
	Condition = tostring(Condition)
	for i=1,#self.Functions do
		SetFunctionArgumentIf(FunctionName, self.Functions[i], Index, Value, Condition)
	end
end

function MFKLexer.Lexer:__tostring(Clean)
	local output = {}
	for i=1,#self.Functions do
		output[i] = self.Functions[i]:__tostring(Clean)
	end
	return tblconcat(output)
end
function MFKLexer.Lexer:Output(Clean)
	for i=1,#self.Functions do
		self.Functions[i]:Output(Clean)
	end
end


return MFKLexer