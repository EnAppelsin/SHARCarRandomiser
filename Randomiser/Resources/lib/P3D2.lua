--[[
CREDITS:
	Proddy#7272				- P3D Class System
	EnAppelsin#9506			- Original P3D Lua Idea
	luca$ Cardellini#5473	- P3D Chunk Structures
]]

P3D = {}
P3D.Version = "2.3"
P3D.Identifiers = {
	Anim = 0x3F0000C,
	Animated_Object = 0x20001,
	Animated_Object_Animation = 0x20002,
	Animated_Object_Factory = 0x20000,
	Animation = 0x121000,
	Animation_Channel_Count = 0x121007,
	Animation_Group = 0x121001,
	Animation_Group_List = 0x121002,
	Animation_Header = 0x121006,
	Animation_Size = 0x121004,
	Anim_Coll = 0x3F00008,
	Anim_Dyna_Phys = 0x3F0000E,
	Anim_Dyna_Phys_Wrapper = 0x3F0000F,
	Anim_Obj_Wrapper = 0x3F00010,
	ATC = 0x3000602,
	Boolean_Channel = 0x121108,
	Bounding_Box = 0x10003,
	Bounding_Sphere = 0x10004,
	Breakable_Object = 0x3001000,
	Camera = 0x2200,
	Channel_Interpolation_Mode = 0x121110,
	Collision_Axis_Aligned_Bounding_Box = 0x7010006,
	Collision_Cylinder = 0x7010003,
	Collision_Effect = 0x3000600,
	Collision_Object = 0x7010000,
	Collision_Object_Attribute = 0x7010023,
	Collision_Oriented_Bounding_Box = 0x7010004,
	Collision_Sphere = 0x7010002,
	Collision_Vector = 0x7010007,
	Collision_Volume = 0x7010001,
	Collision_Volume_Owner = 0x7010021,
	Collision_Volume_Owner_Name = 0x7010022,
	Collision_Wall = 0x7010005,
	Colour_Channel = 0x121109,
	Colour_List = 0x10008,
	Composite_Drawable = 0x4512,
	Composite_Drawable_Effect = 0x4518,
	Composite_Drawable_Effect_List = 0x4517,
	Composite_Drawable_Prop = 0x4516,
	Composite_Drawable_Prop_List = 0x4514,
	Composite_Drawable_Skin = 0x4515,
	Composite_Drawable_Skin_List = 0x4513,
	Composite_Drawable_Sort_Order = 0x4519,
	Compressed_Quaternion_Channel = 0x121111,
	Compressed_Quaternion_Channel_2 = 0x121112,
	Dyna_Phys = 0x3F00002,
	Entity_Channel = 0x121107,
	Export_Info = 0x7030,
	Export_Info_Named_Integer = 0x7032,
	Export_Info_Named_String = 0x7031,
	Expression = 0x21000,
	Expression_Group = 0x21001,
	Expression_Mixer = 0x21002,
	Fence = 0x3F00007,
	Fence_2 = 0x3000000,
	Float_1_Channel = 0x121100,
	Float_2_Channel = 0x121101,
	Follow_Camera_Data = 0x3000100,
	Frame_Controller = 0x121201,
	Frontend_Group = 0x18004,
	Frontend_Image_Resource = 0x18100,
	Frontend_Language = 0x1800E,
	Frontend_Layer = 0x18003,
	Frontend_Multi_Sprite = 0x18006,
	Frontend_Multi_Text = 0x18007,
	Frontend_Page = 0x18002,
	Frontend_Polygon = 0x18009,
	Frontend_Project = 0x18000,
	Frontend_Pure3D_Object = 0x18008,
	Frontend_Pure3D_Resource = 0x18101,
	Frontend_Screen = 0x18001,
	Frontend_String_Hard_Coded = 0x1800C,
	Frontend_String_Text_Bible = 0x1800B,
	Frontend_Text_Bible = 0x1800D,
	Frontend_Text_Bible_Resource = 0x18105,
	Frontend_Text_Style_Resource = 0x18104,
	Game_Attr = 0x12000,
	Game_Attribute_Integer_Parameter = 0x12001,
	Game_Attribute_Float_Parameter = 0x12002,
	Game_Attribute_Colour_Parameter = 0x12003,
	Game_Attribute_Vector_Parameter = 0x12004,
	Game_Attribute_Matrix_Parameter = 0x12005,
	History = 0x7000,
	Image = 0x19001,
	Image_Data = 0x19002,
	Index_List = 0x1000A,
	Instance_List = 0x3000008,
	Inst_Particle_System = 0x3001001,
	Inst_Stat_Entity = 0x3F00009,
	Inst_Stat_Phys = 0x3F0000A,
	Integer_Channel = 0x12110E,
	Intersect = 0x3F00003,
	Intersection = 0x3000004,
	Intersect_Mesh = 0x1008,
	Intersect_Mesh_2 = 0x1009,
	Lens_Flare = 0x3F0000D,
	Light = 0x13000,
	Light_Direction = 0x13001,
	Light_Group = 0x2380,
	Light_Illumination_Type = 0x13008,
	Light_Position = 0x13002,
	Light_Shadow = 0x13004,
	Locator = 0x3000005,
	Locator_3 = 0x14000,
	Locator_Matrix = 0x300000C,
	Matrix_List = 0x1000B,
	Matrix_Palette = 0x1000D,
	Mesh = 0x10000,
	Multi_Controller = 0x48A0,
	Multi_Controller_2 = 0x121202,
	Multi_Controller_Track = 0x121203,
	Multi_Controller_Tracks = 0x48A1,
	Normal_List = 0x10006,
	Old_Base_Emitter = 0x15805,
	Old_Billboard_Display_Info = 0x17003,
	Old_Billboard_Perspective_Info = 0x17004,
	Old_Billboard_Quad = 0x17001,
	Old_Billboard_Quad_Group = 0x17002,
	Old_Colour_Offset_List = 0x121300,
	Old_Emitter_Animation = 0x15809,
	Old_Expression_Offsets = 0x10018,
	Old_Frame_Controller = 0x121200,
	Old_Generator_Animation = 0x1580A,
	Old_Index_Offset_List = 0x121303,
	Old_Offset_List = 0x1000E,
	Old_Particle_Animation = 0x15808,
	Old_Particle_Instancing_Info = 0x1580B,
	Old_Primitive_Group = 0x10002,
	Old_Scenegraph_Branch = 0x120102,
	Old_Scenegraph_Drawable = 0x120107,
	Old_Scenegraph_Light_Group = 0x120109,
	Old_Scenegraph_Root = 0x120101,
	Old_Scenegraph_Sort_Order = 0x12010A,
	Old_Scenegraph_Transform = 0x120103,
	Old_Scenegraph_Visibility = 0x120104,
	Old_Sprite_Emitter = 0x15806,
	Old_Vector_Offset_List = 0x121301,
	Old_Vector2_Offset_List = 0x121302,
	Old_Vertex_Anim_Key_Frame = 0x121304,
	Packed_Normal_List = 0x10010,
	Particle_System_2 = 0x15801,
	Particle_System_Factory = 0x15800,
	Path = 0x300000B,
	Physics_Inertia_Matrix = 0x7011001,
	Physics_Joint = 0x7011020,
	Physics_Object = 0x7011000,
	Physics_Vector = 0x7011002,
	Position_List = 0x10005,
	Quaternion_Channel = 0x121105,
	Rail_Cam = 0x300000A,
	Render_Status = 0x10017,
	Road = 0x3000003,
	Road_Data_Segment = 0x3000009,
	Road_Segment = 0x3000002,
	Scenegraph = 0x120100,
	Set = 0x3000110,
	Shader = 0x11000,
	Shader_Colour_Parameter = 0x11005,
	Shader_Float_Parameter = 0x11004,
	Shader_Integer_Parameter = 0x11003,
	Shader_Texture_Parameter = 0x11002,
	Skeleton = 0x4500,
	Skeleton_Joint = 0x4501,
	Skeleton_Joint_Bone_Preserve = 0x4504,
	Skeleton_Joint_Mirror_Map = 0x4503,
	Skin = 0x10001,
	Spline = 0x3000007,
	Sprite = 0x19005,
	State_Prop_Callback_Data = 0x8020005,
	State_Prop_Data_V1 = 0x8020000,
	State_Prop_Event_Data = 0x8020004,
	State_Prop_Frame_Controller_Data = 0x8020003,
	State_Prop_State_Data_V1 = 0x8020001,
	State_Prop_Visibilities_Data = 0x8020002,
	Static_Entity = 0x3F00000,
	Static_Phys = 0x3F00001,
	Surface_Type_List = 0x300000E,
	Texture = 0x19000,
	Texture_Animation = 0x3520,
	Texture_Font = 0x22000,
	Texture_Glyph_List = 0x22001,
	Tree = 0x3F00004,
	Tree_Node = 0x3F00005,
	Tree_Node_2 = 0x3F00006,
	Trigger_Volume = 0x3000006,
	UV_List = 0x10007,
	Vector_1D_OF_Channel = 0x121102,
	Vector_2D_OF_Channel = 0x121103,
	Vector_3D_OF_Channel = 0x121104,
	Vertex_Shader = 0x10011,
	Volume_Image = 0x19004,
	Walker_Camera_Data = 0x3000101,
	Weight_List = 0x1000C,
	World_Sphere = 0x3F0000B,
}
P3D.IdentifiersLookup = {}
P3D.IdentifierIds = {}
local IdentifierIdsN = 0
for k,v in pairs(P3D.Identifiers) do
	IdentifierIdsN = IdentifierIdsN + 1
	P3D.IdentifierIds[IdentifierIdsN] = v
	P3D.IdentifiersLookup[v] = k
end

P3D.ChunkClasses = {}

local math_atan = math.atan
local math_cos = math.cos
local math_deg = math.deg
local math_rad = math.rad
local math_sin = math.sin
local math_sqrt = math.sqrt

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_move = table.move
local table_unpack = table.unpack

local assert = assert
local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring = tostring
local type = type

function P3D.MakeP3DString(str)
	if str == nil then return nil end
	local diff = #str & 3
	if diff ~= 0 then
		return str .. string_rep("\0", 4 - diff)
	end
	return str
end

function P3D.CleanP3DString(str)
	if str == nil then return nil end
	local strLen = str:len()
	if strLen == 0 then return str end
	local null = str:find("\0", 1, true)
	if null == nil then return str end
	return str:sub(1, null-1)
end

local function DegToRad(self)
	for k,v in pairs(self) do
		if type(v) == "number" then
			self[k] = math_rad(v)
		end
	end
end

local function RadToDeg(self)
	for k,v in pairs(self) do
		if type(v) == "number" then
			self[k] = math_deg(v)
		end
	end
end

local Vector2 = setmetatable({DegToRad = DegToRad, RadToDeg = RadToDeg}, {__call = function(self, X, Y)
	assert(type(X) == "number", "Arg #1 (X) must be a number")
	assert(type(Y) == "number", "Arg #2 (Y) must be a number")
	
	local Data = {
		X = X,
		Y = Y
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
P3D.Vector2 = Vector2

local function IsVector2(obj)
	return getmetatable(obj) == Vector2
end
P3D.IsVector2 = IsVector2

function Vector2:__unm()
	return Vector2(-self.X, -self.Y)
end
function Vector2:__add(vector)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(IsVector2(vector), "Arg #1 (vector) must be a Vector2")
	
	return Vector2(self.X + vector.X, self.Y + vector.Y)
end
function Vector2:__sub(vector)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(IsVector2(vector), "Arg #1 (vector) must be a Vector2")
	
	return Vector2(self.X - vector.X, self.Y - vector.Y)
end
function Vector2:__mul(value)
	if type(self) == "number" then
		assert(IsVector2(value), "Arg #1 (value) must be a Vector2 when multiplying with a number")
		
		return Vector2(value.X * self, value.Y * self)
	elseif type(value) == "number" then
		assert(IsVector2(self), "Arg #0 (self) must be a Vector2 when multiplying with a number")
		
		return Vector2(self.X * value, self.Y * value)
	else
		assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
		assert(IsVector2(value), "Arg #1 (value) must be a Vector2")
	
		return Vector2(self.X * value.X, self.Y * value.Y)
	end
end
function Vector2:__div(value)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(type(value) == "number", "Arg #1 (value) must be a number")
	
	return Vector2(self.X / value, self.Y / value)
end
function Vector2:__eq(vector)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	
	-- Not sure if should assert or return false
	--assert(IsVector2(vector), "Arg #1 (vector) must be a Vector2")
	if not IsVector2(vector) then
		return false
	end
	
	return self.X == vector.X and self.Y == vector.Y
end
function Vector2:__tostring()
	return string.format("{ X = %.3f, Y = %.3f }", self.X, self.Y)
end
function Vector2:Set(X, Y)
	if IsVector2(X) then
		self.X = X.X
		self.Y = X.Y
	else
		assert(X == nil or type(X) == "number", "Arg #1 (X or Vector2) must be either a number or a Vector2")
		assert(Y == nil or type(Y) == "number", "Arg #2 (Y) must be a number")
		self.X = X or self.X
		self.Y = Y or self.Y
	end
end
function Vector2:Clone()
	return Vector2(self.X, self.Y)
end
function Vector2:GetMag()
	return math_sqrt(self.X^2 + self.Y^2)
end
function Vector2:GetMagSq()
	return self.X^2 + self.Y^2
end
function Vector2:SetMag(mag)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(type(mag) == "number", "Arg #1 (mag) must be a number")
	assert(self:GetMag() ~= 0, "Cannot set magnitude when direction is ambiguous")
	
	self:Norm()
	local v = self * mag
	self:Set(v)
	return self
end
function Vector2:Dist(vector)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(IsVector2(vector), "Arg #1 (vector) must be a Vector2")
	
	return math_sqrt((self.X - vector.X)^2 + (self.Y - vector.Y)^2)
end
function Vector2:Dot(vector)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(IsVector2(vector), "Arg #1 (vector) must be a Vector2")
	
	return self.X * vector.X + self.Y * vector.Y
end
function Vector2:Norm()
	local mag = self:GetMag()
	if mag ~= 0 then
		self:Set(self / mag)
	end
	return self
end
function Vector2:Heading()
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	
	return -math_atan(self.Y, self.X)
end
function Vector2:Rotate(theta)
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	assert(type(theta) == "number", "Arg #1 (theta) must be a number")
	
	local s = math_sin(theta)
	local c = math_cos(theta)
	local v = Vector2(c * self.X + s * self.Y, -(s * self.X) + c * self.Y)
	self:Set(v)
	return self
end
function Vector2:Array()
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	
	return {self.X, self.Y}
end
function Vector2:Unpack()
	assert(IsVector2(self), "Arg #0 (self) must be a Vector2")
	
	return self.X, self.Y
end

local Vector3 = setmetatable({DegToRad = DegToRad, RadToDeg = RadToDeg}, {__call = function(self, X, Y, Z)
	assert(type(X) == "number", "Arg #1 (X) must be a number")
	assert(type(Y) == "number", "Arg #2 (Y) must be a number")
	assert(type(Z) == "number", "Arg #3 (Z) must be a number")
	
	local Data = {
		X = X,
		Y = Y,
		Z = Z
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
P3D.Vector3 = Vector3

local function IsVector3(obj)
	return getmetatable(obj) == Vector3
end
P3D.IsVector3 = IsVector3

function Vector3:__tostring()
	return string.format("{ X = %.3f, Y = %.3f, Z = %.3f }", self.X, self.Y, self.Z)
end
function Vector3:Set(X, Y, Z)
	if IsVector3(X) then
		self.X = X.X
		self.Y = X.Y
		self.Z = X.Z
	else
		assert(X == nil or type(X) == "number", "Arg #1 (X or Vector3) must be either a number or a Vector3")
		assert(Y == nil or type(Y) == "number", "Arg #2 (Y) must be a number")
		assert(Z == nil or type(Z) == "number", "Arg #3 (Z) must be a number")
		self.X = X or self.X
		self.Y = Y or self.Y
		self.Z = Z or self.Z
	end
end
function Vector3:Clone()
	return Vector3(self.X, self.Y, self.Z)
end

P3D.SymmetricMatrix3x3 = setmetatable({DegToRad = DegToRad, RadToDeg = RadToDeg}, {__call = function(self, XX, XY, XZ, YY, YZ, ZZ)
	assert(type(XX) == "number", "Arg #1 (XX) must be a number")
	assert(type(XY) == "number", "Arg #2 (XY) must be a number")
	assert(type(XZ) == "number", "Arg #3 (XZ) must be a number")
	assert(type(YY) == "number", "Arg #4 (YY) must be a number")
	assert(type(YZ) == "number", "Arg #5 (YZ) must be a number")
	assert(type(ZZ) == "number", "Arg #6 (ZZ) must be a number")
	
	local Data = {
		XX = XX,
		XY = XY,
		XZ = XZ,
		YY = YY,
		YZ = YZ,
		ZZ = ZZ
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
function P3D.SymmetricMatrix3x3:__tostring()
	return string.format("{ XX = %.3f, XY = %.3f, XZ = %.3f, YY = %.3f, YZ = %.3f, ZZ = %.3f }", self.XX, self.XY, self.XZ, self.YY, self.YZ, self.ZZ)
end

P3D.Quaternion = setmetatable({DegToRad = DegToRad, RadToDeg = RadToDeg}, {__call = function(self, W, X, Y, Z)
	assert(type(W) == "number", "Arg #1 (W) must be a number")
	assert(type(X) == "number", "Arg #2 (X) must be a number")
	assert(type(Y) == "number", "Arg #3 (Y) must be a number")
	assert(type(Z) == "number", "Arg #4 (Z) must be a number")
	
	local Data = {
		W = W,
		X = X,
		Y = Y,
		Z = Z
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
function P3D.Quaternion:__tostring()
	return string.format("{ W = %.3f, X = %.3f, Y = %.3f, Z = %.3f }", self.W, self.X, self.Y, self.Z)
end

local Matrix = setmetatable({DegToRad = DegToRad, RadToDeg = RadToDeg}, {__call = function(self, M11, M12, M13, M14, M21, M22, M23, M24, M31, M32, M33, M34, M41, M42, M43, M44)
	assert(type(M11) == "number", "Arg #1 (M11) must be a number")
	assert(type(M12) == "number", "Arg #2 (M12) must be a number")
	assert(type(M13) == "number", "Arg #3 (M13) must be a number")
	assert(type(M14) == "number", "Arg #4 (M14) must be a number")
	assert(type(M21) == "number", "Arg #5 (M21) must be a number")
	assert(type(M22) == "number", "Arg #6 (M22) must be a number")
	assert(type(M23) == "number", "Arg #7 (M23) must be a number")
	assert(type(M24) == "number", "Arg #8 (M24) must be a number")
	assert(type(M31) == "number", "Arg #9 (M31) must be a number")
	assert(type(M32) == "number", "Arg #10 (M32) must be a number")
	assert(type(M33) == "number", "Arg #11 (M33) must be a number")
	assert(type(M34) == "number", "Arg #12 (M34) must be a number")
	assert(type(M41) == "number", "Arg #13 (M41) must be a number")
	assert(type(M42) == "number", "Arg #14 (M42) must be a number")
	assert(type(M43) == "number", "Arg #15 (M43) must be a number")
	assert(type(M44) == "number", "Arg #16 (M44) must be a number")
	
	local Data = {
		M11 = M11,
		M12 = M12,
		M13 = M13,
		M14 = M14,
		M21 = M21,
		M22 = M22,
		M23 = M23,
		M24 = M24,
		M31 = M31,
		M32 = M32,
		M33 = M33,
		M34 = M34,
		M41 = M41,
		M42 = M42,
		M43 = M43,
		M44 = M44
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
P3D.Matrix = Matrix

local function IsMatrix(obj)
	return getmetatable(obj) == Matrix
end
P3D.IsMatrix = Matrix

function Matrix:__tostring()
	return string.format("{ { %.3f, %.3f, %.3f, %.3f }, { %.3f, %.3f, %.3f, %.3f }, { %.3f, %.3f, %.3f, %.3f }, { %.3f, %.3f, %.3f, %.3f } }", self.M11, self.M12, self.M13, self.M14, self.M21, self.M22, self.M23, self.M24, self.M31, self.M32, self.M33, self.M34, self.M41, self.M42, self.M43, self.M44)
end

P3D.Colour = setmetatable({}, {__call = function(self, R, G, B, A)
	assert(type(R) == "number", "Arg #1 (R) must be a number")
	assert(type(G) == "number", "Arg #2 (G) must be a number")
	assert(type(B) == "number", "Arg #3 (B) must be a number")
	assert(A == nil or type(A) == "number", "Arg #4 (A) must be a number")
	A = A or 255
	
	local Data = {
		R = R & 0xFF,
		G = G & 0xFF,
		B = B & 0xFF,
		A = A & 0xFF
	}
	
	self.__index = self
	return setmetatable(Data, self)
end})
function P3D.Colour:__tostring()
	return string.format("R = %d, G = %d, B = %d, A = %d", self.R, self.G, self.B, self.A)
end
function P3D.Colour:ToArgb()
	return (self.A << 24) | (self.R << 16) | (self.G << 8) | self.B
end
function P3D.Colour:FromArgb(ARGB)
	assert(type(ARGB) == "number", "Arg #1 (ARGB) must be a number")
	
	local Data = {
		R = (ARGB >> 16) & 0xFF,
		G = (ARGB >> 8) & 0xFF,
		B = ARGB & 0xFF,
		A = (ARGB >> 24) & 0xFF
	}
	
	self.__index = self
	return setmetatable(Data, self)
end
P3D.Color = P3D.Colour

-- LZR (Lempel - Ziv - Radical) Decompression
local function DecompressBlock(Input, OutputSize, InputPos)
	local Output = {}
	local OutputPos = 1
	
	while OutputPos <= OutputSize do
		local code
		code, InputPos = string_unpack("<B", Input, InputPos)
		
		if code > 15 then
			local matchLength = code & 15
			local tmp
			
			if matchLength == 0 then
				matchLength = 15
				tmp, InputPos = string_unpack("<B", Input, InputPos)
				while tmp == 0 do
					matchLength = matchLength + 255
					tmp, InputPos = string_unpack("<B", Input, InputPos)
				end
				matchLength = matchLength + tmp
			end
			
			tmp, InputPos = string_unpack("<B", Input, InputPos)
			local offset = (code >> 4) | tmp << 4
			local matchPos = OutputPos - offset
			
			local len = matchLength >> 2
			matchLength = matchLength - (len << 2)
			
			repeat
				Output[OutputPos] = Output[matchPos]
				Output[OutputPos + 1] = Output[matchPos + 1]
				Output[OutputPos + 2] = Output[matchPos + 2]
				Output[OutputPos + 3] = Output[matchPos + 3]
				matchPos = matchPos + 4
				OutputPos = OutputPos + 4
				len = len - 1
			until len == 0
			
			while matchLength ~= 0 do
				Output[OutputPos] = Output[matchPos]
				matchPos = matchPos + 1
				OutputPos = OutputPos + 1
				matchLength = matchLength - 1
			end
		else
			local runLength = code
			
			if runLength == 0 then
				code, InputPos = string_unpack("<B", Input, InputPos)
				while code == 0 do
					runLength = runLength + 255
					code, InputPos = string_unpack("<B", Input, InputPos)
				end
				runLength = runLength + code
				
				table_move({string_unpack("<c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1", Input, InputPos)}, 1, 15, OutputPos, Output)
				InputPos = InputPos + 15
				OutputPos = OutputPos + 15
			end
			
			table_move({string_unpack(string_rep("c1", runLength), Input, InputPos)}, 1, runLength, OutputPos, Output)
			InputPos = InputPos + runLength
			OutputPos = OutputPos + runLength
		end
	end
	
	return table_concat(Output), OutputPos
end

local function Decompress(File, UncompressedLength)
	local DecompressedLength = 0
	local pos = 9
	local UncompressedTbl = {}
	local CompressedLength, UncompressedBlock
	while DecompressedLength < UncompressedLength do
		CompressedLength, UncompressedBlock, pos = string_unpack("<II", File, pos)
		UncompressedTbl[#UncompressedTbl + 1] = DecompressBlock(File, UncompressedBlock, pos)
		pos = pos + CompressedLength
		DecompressedLength = DecompressedLength + UncompressedBlock
	end
	return table_concat(UncompressedTbl)
end

local FileSignature = 0xFF443350
local CompressedFileSignature = 0x5A443350
local BigEndianFileSignature = 0x503344FF
function P3D.DecompressFile(File)
	assert(type(File) == "string", "Arg #1 (File) must be a string")
	
	local success, contents = pcall(ReadFile, File)
	assert(success, "Failed to read file at '" .. File .. "': " .. contents)
	
	local Identifier, HeaderLength = string_unpack("<II", contents)
	if Identifier ~= CompressedFileSignature then
		return contents
	end
	
	return Decompress(contents, HeaderLength)
end

local function ProcessSubChunks(Parent, Contents, Pos, EndPos)
	Parent.Chunks = Parent.Chunks or {}
	local n = 0
	while Pos < EndPos do
		local Identifier, HeaderLength, Length = string_unpack(Parent.Endian .. "III", Contents, Pos)
		
		local class = P3D.ChunkClasses[Identifier] or P3D.P3DChunk
		local Chunk, overwrittenHeaderLength = class:parse(Parent.Endian, Contents, Pos + 12, HeaderLength - 12, Identifier)
		
		HeaderLength = overwrittenHeaderLength or HeaderLength
		
		ProcessSubChunks(Chunk, Contents, Pos + HeaderLength, Pos + Length)
		
		n = n + 1
		Parent.Chunks[n] = Chunk
		Pos = Pos + Length
	end
end

local function LoadP3DFileFromData(self, contents)
	assert(type(contents) == "string" and #contents >= 12, "Contents too short")
	
	local Data = {
		Endian = "<"
	}
	
	local Identifier, HeaderLength, Length, Pos = string_unpack("<III", contents)
	if Identifier == CompressedFileSignature then
		contents = Decompress(contents, HeaderLength)
		Identifier, HeaderLength, Length, Pos = string_unpack("<III", contents)
	elseif Identifier == BigEndianFileSignature then
		Identifier, HeaderLength, Length, Pos = string_unpack(">III", contents)
		Data.Endian = ">"
	end
	assert(Identifier == FileSignature, "Contents is not a valid P3D file")
	
	ProcessSubChunks(Data, contents, Pos, Length)
	
	self.__index = self
	return setmetatable(Data, self)
end

local function LoadP3DFile(self, Path, NewOnDoesntExist)
	if Path == nil then
		self.__index = self
		return setmetatable({ Endian = "<", Chunks = {} }, self)
	else
		if not Exists(Path, true, false) then
			assert(NewOnDoesntExist, "Could not find the path specified in Arg #1: " .. Path)
			
			self.__index = self
			return setmetatable({ Endian = "<", Chunks = {} }, self)
		end
		local success, contents = pcall(ReadFile, Path)
		assert(success, string.format("Failed to read file at '%s': %s", Path, contents))
		
		return LoadP3DFileFromData(self, contents)
	end
end

local function AddChunk(self, Chunk, Index)
	assert(type(Chunk) == "table" and Chunk.Identifier, "Arg #1 (Chunk) must be a valid chunk")
	assert(Index == nil or (type(Index) == "number" and Index <= #self.Chunks + 1), "Arg #2 (Index) must be a number smaller than the chunk count")
	
	if Index then
		table.insert(self.Chunks, Index, Chunk)
	else
		self.Chunks[#self.Chunks + 1] = Chunk
	end
end

local function SetChunk(self, Chunk, Index)
	assert(type(Chunk) == "table" and Chunk.Identifier, "Arg #1 (Chunk) must be a valid chunk")
	assert(type(Index) == "number" and Index <= #self.Chunks, "Arg #2 (Index) must be a number smaller than the chunk count")
	
	self.Chunks[Index] = Chunk
end

local function RemoveChunk(self, ChunkOrIndex)
	local t = type(ChunkOrIndex)
	if t == "number" then
		assert(ChunkOrIndex <= #self.Chunks, "Arg #1 (Index) must be below chunk count")
		table.remove(self.Chunks, ChunkOrIndex)
	elseif t == "table" then
		assert(ChunkOrIndex.Identifier, "Arg #1 (Chunk) must be a valid chunk")
		for i=1,#self.Chunks do
			if self.Chunks[i] == ChunkOrIndex then
				table.remove(self.Chunks, i)
				return
			end
		end
	else
		error("Arg #1 (ChunkOrIndex) must be a number or a valid chunk")
	end
end

local function GetChunks(self, Identifier, Backwards, Name)
	assert(Identifier == nil or type(Identifier) == "number", "Arg #1 (Identifier) must be a number")
	assert(Name == nil or type(Name) == "string", "Arg #3 (Name) must be a string")
	
	local chunks = self.Chunks
	local chunkN = #chunks
	
	local index, finish, step
	if Backwards then
		index = chunkN
		finish = 0
		step = -1
	else
		index = 1
		finish = chunkN + 1
		step = 1
	end
	
	return function()
		while index ~= finish do
			assert(Backwards or chunkN == #chunks, string_format("Chunk count changed from %d to %d. To add or remove chunks whilst iterating, you must iterate backwards", chunkN, #chunks))
			local Chunk = chunks[index]
			index = index + step
			if (Identifier == nil or Chunk.Identifier == Identifier) and (Name == nil or Chunk.Name == Name) then
				return Chunk
			end
		end
		return nil
	end
end

local function GetChunk(self, Identifier, Backwards, Name)
	return GetChunks(self, Identifier, Backwards, Name)()
end

local function GetChunksIndexed(self, Identifier, Backwards, Name)
	assert(Identifier == nil or type(Identifier) == "number", "Arg #1 (Identifier) must be a number")
	assert(Name == nil or type(Name) == "string", "Arg #3 (Name) must be a string")
	
	local chunks = self.Chunks
	local chunkN = #chunks
	
	local index, finish, step
	if Backwards then
		index = chunkN
		finish = 0
		step = -1
	else
		index = 1
		finish = chunkN + 1
		step = 1
	end
	
	return function()
		while index ~= finish do
			assert(Backwards or chunkN == #chunks, string_format("Chunk count changed from %d to %d. To add or remove chunks whilst iterating, you must iterate backwards", chunkN, #chunks))
			local Chunk = chunks[index]
			index = index + step
			if (Identifier == nil or Chunk.Identifier == Identifier) and (Name == nil or Chunk.Name == Name) then
				return index - step, Chunk
			end
		end
		return nil
	end
end

local function GetChunkIndexed(self, Identifier, Backwards, Name)
	return GetChunksIndexed(self, Identifier, Backwards, Name)()
end

local function Match(self, Filters)
	for key, needle in pairs(Filters) do
		local value = self[key]
		
		local valueType = type(value)
		local needleType = type(needle)
		
		if valueType ~= needleType then
			return false
		end
		
		if needleType == "string" then
			if not value:match(needle) and value ~= needle then
				return false
			end
		elseif value ~= needle then
			return false
		end
	end
	return true
end

local function Find(self, Filters, Backwards)
	assert(type(Filters) == "table", "Arg #1 (Filters) must be a key/value table.")
	
	local chunks = self.Chunks
	local chunkN = #chunks
	
	if Backwards then
		local n = chunkN
		return function()
			while n > 0 do
				local Chunk = chunks[n]
				n = n - 1
				if Chunk:Match(Filters) then
					return n + 1, Chunk
				end
			end
			return nil
		end
	else
		local n = 1
		return function()
			while n <= chunkN do
				assert(chunkN == #chunks, string_format("Chunk count changed from %d to %d. To add or remove chunks whilst iterating, you must iterate backwards", chunkN, #chunks))
				local Chunk = chunks[n]
				n = n + 1
				if Chunk:Match(Filters) then
					return n - 1, Chunk
				end
			end
			return nil
		end
	end
end

local function FindFirst(self, Filters, Backwards)
	return Find(self, Filters, Backwards)()
end

local skip = {
	["Chunks"] = true,
	["Identifier"] = true,
	["ValueStr"] = true,
}
local function P3DChunk_stateless_iter(self, k)
	if not self.parentClass then
		if k == nil then
			return "ValueStr", self.ValueStr
		else
			return nil
		end
	end
	local v
	repeat
		k, v = next(self, k)
	until k == nil or not skip[k]
	return k, v
end
local function P3DChunk_pairs(self)
	return P3DChunk_stateless_iter, self, nil
end

local function Clone(self, seen)
	if type(self) ~= 'table' then
		return self
	end
	
	if seen and seen[self] then
		return seen[self]
	end
	
	local s = seen or {}
	local res = {}
	s[self] = res
	
	for k in pairs(skip) do
		res[k] = Clone(self[k], s)
	end
	
	for k, v in pairs(self) do
		res[Clone(k, s)] = Clone(v, s)
	end
	
	return setmetatable(res, getmetatable(self))
end

local function SetLittleEndian(self)
	self.Endian = "<"
	for i=1,#self.Chunks do
		self.Chunks[i]:SetLittleEndian()
	end
end

local function SetBigEndian(self)
	self.Endian = ">"
	for i=1,#self.Chunks do
		self.Chunks[i]:SetBigEndian()
	end
end

P3D.P3DFile = setmetatable({load = LoadP3DFile, new = LoadP3DFile, LoadFromData = LoadP3DFileFromData, AddChunk = AddChunk, SetChunk = SetChunk, RemoveChunk = RemoveChunk, GetChunks = GetChunks, GetChunk = GetChunk, GetChunksIndexed = GetChunksIndexed, GetChunkIndexed = GetChunkIndexed, Match = Match, Find = Find, FindFirst = FindFirst, Clone = Clone, SetLittleEndian = SetLittleEndian, SetBigEndian = SetBigEndian}, {__call = LoadP3DFile})

function P3D.P3DFile:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	return string_pack(self.Endian .. "III", FileSignature, 12, 12 + #chunkData) .. chunkData
end

function P3D.P3DFile:Output()
	Output(tostring(self))
end

local function P3DChunk_new(self, ...)
	if self.Identifier and self.new then
		return self:new(...)
	else
		local args = {...}
		local Identifier = args[1]
		local ValueStr = args[2]
		assert(type(Identifier) == "number", "Arg #1 (Identifier) must be a number")
		assert(type(ValueStr) == "string", "Arg #2 (ValueStr) must be a string")
		
		local Data = {
			Chunks = {},
			Identifier = Identifier,
			ValueStr = ValueStr,
		}
		
		self.__index = self
		return setmetatable(Data, self)
	end
end

local function P3DChunk_Replace(self, NewChunk)
	assert(type(NewChunk) == "table", "Arg #1 (NewChunk) must be a chunk table")
	
	for k in pairs(self) do
		self[k] = nil
	end
	
	for k,v in pairs(NewChunk) do
		self[k] = v
	end
	
	for key in pairs(skip) do
		self[key] = NewChunk[key]
	end
	
	self.__index = NewChunk.__index
	setmetatable(self, getmetatable(NewChunk))
end

P3D.P3DChunk = setmetatable({new = P3DChunk_new, __pairs = P3DChunk_pairs, AddChunk = AddChunk, SetChunk = SetChunk, RemoveChunk = RemoveChunk, GetChunks = GetChunks, GetChunk = GetChunk, GetChunksIndexed = GetChunksIndexed, GetChunkIndexed = GetChunkIndexed, Match = Match, Find = Find, FindFirst = FindFirst, Clone = Clone, SetLittleEndian = SetLittleEndian, SetBigEndian = SetBigEndian, Replace = P3DChunk_Replace}, {__call = P3DChunk_new})
function P3D.P3DChunk:parse(Endian, Contents, Pos, DataLength, Identifier)
	local Data = {}
	
	Data.Endian = Endian
	Data.Identifier = Identifier
	if DataLength > 0 then
		Data.ValueStr = Contents:sub(Pos, Pos + DataLength - 1)
	else
		Data.ValueStr = ""
	end
	
	self.__index = self
	return setmetatable(Data, self)
end

function P3D.P3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	local headerLen = 12 + #self.ValueStr
	return string_pack(self.Endian .. "III", self.Identifier, headerLen, headerLen + #chunkData) .. self.ValueStr .. chunkData
end

function P3D.P3DChunk:newChildClass(Identifier)
	assert(type(Identifier) == "number", "Identifier must be a number")
	local class = setmetatable({__pairs = P3DChunk_pairs, Identifier = Identifier, parentClass = self, AddChunk = AddChunk, SetChunk = SetChunk, RemoveChunk = RemoveChunk, GetChunks = GetChunks, GetChunk = GetChunk, GetChunksIndexed = GetChunksIndexed, GetChunkIndexed = GetChunkIndexed, Match = Match, Find = Find, FindFirst = FindFirst, Clone = Clone, SetLittleEndian = SetLittleEndian, SetBigEndian = SetBigEndian, Replace = P3DChunk_Replace}, getmetatable(self))
	P3D.ChunkClasses[Identifier] = class
	return class
end

function P3D.GetIdentifiersWithClasses()
	local identifiers = {}
	local n = 0
	for k in pairs(P3D.ChunkClasses) do
		n = n + 1
		identifiers[n] = k
	end
	return identifiers, n
end

function P3D.LoadChunks(Path)
	assert(type(Path) == "string", "Path must be a string")
	assert(Exists(Path, false, true), 'Could not find directory with path "' .. Path .. '"')
	
	local files = 0
	DirectoryGetEntries(Path, function(File, IsDirectory)
		if IsDirectory then
			return true
		end
		
		if GetFileExtension(File):lower() == ".lua" then
			dofile(string.format("%s/%s", Path, File))
			files = files + 1
		end
		
		return true
	end)
	
	local classes, classesN = P3D.GetIdentifiersWithClasses()
	print("P3D2.lua", string.format("Loaded %d file%s. Chunk classes: %d/%d.", files, files == 1 and "" or "s", classesN, IdentifierIdsN))
	return files, classes
end

print("P3D2.lua", string.format("Lua P3D Lib v%s loaded", P3D.Version))
return P3D