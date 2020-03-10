P3D = {}
P3D.BlankHeader = "P3D\255\012\000\000\000\012\000\000\000"
P3D.Identifiers = {
	ATC = 0x3000602,
	Anim = 0x3F0000C,
	Anim_Coll = 0x3F00008,
	Anim_Dyna_Phys = 0x3F0000E,
	Anim_Dyna_Phys_Wrapper = 0x3F0000F,
	Anim_Obj_Wrapper = 0x3F00010,
	Animated_Object = 0x20001,
	Animated_Object_Animation = 0x20002,
	Animated_Object_Factory = 0x20000,
	Animation = 0x121000,
	Animation_Channel_Count = 0x121007,
	Animation_Group = 0x121001,
	Animation_Group_List = 0x121002,
	Animation_Header = 0x121006,
	Animation_Size = 0x121004,
	Animation_Sync_Frame = 0x121402,
	Billboard_Quad_Group = 0x17006,
	Black_Magic = 0x1025,
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
	Composite_Drawable_2 = 0x123000,
	Composite_Drawable_Effect = 0x4518,
	Composite_Drawable_Effect_List = 0x4517,
	Composite_Drawable_Primitive = 0x123001,
	Composite_Drawable_Prop = 0x4516,
	Composite_Drawable_Prop_List = 0x4514,
	Composite_Drawable_Skin = 0x4515,
	Composite_Drawable_Skin_List = 0x4513,
	Composite_Drawable_Sort_Order = 0x4519,
	Compressed_Quaternion_Channel = 0x121111,
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
	Grid = 0x1000,
	Grid_Cell = 0x1001,
	History = 0x7000,
	Image = 0x19001,
	Image_2 = 0x3510,
	Image_Data = 0x19002,
	Image_Data_2 = 0x3511,
	Index_List = 0x1000A,
	Inst_Particle_System = 0x3001001,
	Inst_Stat_Entity = 0x3F00009,
	Inst_Stat_Phys = 0x3F0000A,
	Instance_List = 0x3000008,
	Integer_Channel = 0x12110E,
	Intersect = 0x3F00003,
	Intersect_Mesh = 0x1008,
	Intersect_Mesh_2 = 0x1009,
	Intersection = 0x3000004,
	Lens_Flare = 0x3F0000D,
	Light = 0x13000,
	Light_Direction = 0x13001,
	Light_Group = 0x2380,
	Light_Position = 0x13002,
	Light_Shadow = 0x13004,
	Locator = 0x3000005,
	Locator_2 = 0x1003,
	Locator_3 = 0x14000,
	Locator_Counts = 0x1023,
	Locator_Matrix = 0x300000C,
	Matrix_List = 0x1000B,
	Matrix_Palette = 0x1000D,
	Mesh = 0x10000,
	Mesh_Stats = 0x1001D,
	Multi_Controller = 0x48A0,
	Multi_Controller_2 = 0x121202,
	Multi_Controller_Tracks = 0x48A1,
	Normal_List = 0x10006,
	Old_Base_Emitter = 0x15805,
	Old_Billboard_Display_Info = 0x17003,
	Old_Billboard_Perspective_Info = 0x17004,
	Old_Billboard_Quad = 0x17001,
	Old_Billboard_Quad_Group = 0x17002,
	Old_Emitter_Animation = 0x15809,
	Old_Expression_Offsets = 0x10018,
	Old_Frame_Controller = 0x121200,
	Old_Generator_Animation = 0x1580A,
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
	Old_Vertex_Anim_Key_Frame = 0x121304,
	Packed_Normal_List = 0x10010,
	Particle_Point_Generator = 0x15B00,
	Particle_System = 0x15000,
	Particle_System = 0x1580C,
	Particle_System_2 = 0x15801,
	Particle_System_Factory = 0x15800,
	Path = 0x300000B,
	Ph = 0xC111,
	Ph_Axis_Aligned_Bounding_Box = 0xC007,
	Ph_Cylinder = 0xC004,
	Ph_Inertia_Matrix = 0xC001,
	Ph_Oriented_Bounding_Box = 0xC005,
	Ph_Sphere = 0xC003,
	Ph_Vector = 0xC010,
	Ph_Volume = 0xC002,
	Physics_Inertia_Matrix = 0x7011001,
	Physics_Joint = 0x7011020,
	Physics_Object = 0x7011000,
	Physics_Vector = 0x7011002,
	Position_List = 0x10005,
	Primitive_Group = 0x10020,
	Primitive_Group_Memory_Image_Index = 0x10013,
	Primitive_Group_Memory_Image_Vertex = 0x10012,
	Primitive_Group_Memory_Image_Vertex_Description = 0x10014,
	Quaternion_Channel = 0x121105,
	Render_Status = 0x10017,
	Road = 0x3000003,
	Road_2 = 0x1005,
	Road_Data_Segment = 0x3000009,
	Road_Segment = 0x3000002,
	Root = 0xFF443350,
	Scenegraph = 0x120100,
	Scenegraph_Branch = 0x12010C,
	Scenegraph_Drawable = 0x12010F,
	Scenegraph_Root = 0x12010B,
	Scenegraph_Transform = 0x12010D,
	Set = 0x3000110,
	Shader = 0x11000,
	Shader_Colour_Parameter = 0x11005,
	Shader_Float_Parameter = 0x11004,
	Shader_Integer_Parameter = 0x11003,
	Shader_Texture_Parameter = 0x11002,
	Skeleton = 0x4500,
	Skeleton_2 = 0x23000,
	Skeleton_Joint = 0x4501,
	Skeleton_Joint_2 = 0x23001,
	Skeleton_Joint_Bone_Preserve = 0x4504,
	Skeleton_Joint_Mirror_Map = 0x4503,
	Skeleton_Limb = 0x23003,
	Skeleton_Partition = 0x23002,
	Skin = 0x10001,
	Sort_Order = 0x122000,
	Spline = 0x3000007,
	Sprite = 0x19005,
	Sprite_Particle_Emitter = 0x15900,
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
	Texture_2 = 0x3500,
	Texture_Animation = 0x3520,
	Texture_Font = 0x22000,
	Texture_Glyph_List = 0x22001,
	Tree = 0x3F00004,
	Tree_Node = 0x3F00005,
	Tree_Node_2 = 0x3F00006,
	Trigger_Volume = 0x3000006,
	Trigger_Volume_2 = 0x1004,
	UV_List = 0x10007,
	Unknown1013 = 0x1013,
	Unknown1014 = 0x1014,
	Unknown1021 = 0x1021,
	Unknown1022 = 0x1022,
	Unknown1024 = 0x1024,
	Unknown121203 = 0x121203,
	Unknown121204 = 0x121204,
	Unknown13003 = 0x13003,
	Unknown13008 = 0x13008,
	Unknown15101 = 0x15101,
	Unknown15102 = 0x15102,
	Unknown15103 = 0x15103,
	Unknown15140 = 0x15140,
	Unknown15200 = 0x15200,
	Unknown15210 = 0x15210,
	Unknown15211 = 0x15211,
	Unknown15212 = 0x15212,
	Unknown15213 = 0x15213,
	Unknown15214 = 0x15214,
	Unknown15215 = 0x15215,
	Unknown15216 = 0x15216,
	Unknown15217 = 0x15217,
	Unknown15218 = 0x15218,
	Unknown15219 = 0x15219,
	Unknown1521A = 0x1521A,
	Unknown1521B = 0x1521B,
	Unknown1521C = 0x1521C,
	Unknown1521D = 0x1521D,
	Unknown1521E = 0x1521E,
	Unknown1521F = 0x1521F,
	Unknown15220 = 0x15220,
	Unknown15221 = 0x15221,
	Unknown15222 = 0x15222,
	Unknown15223 = 0x15223,
	Unknown15224 = 0x15224,
	Unknown15225 = 0x15225,
	Unknown15226 = 0x15226,
	Unknown15227 = 0x15227,
	Unknown15228 = 0x15228,
	Unknown15229 = 0x15229,
	Unknown15400 = 0x15400,
	Unknown15401 = 0x15401,
	Unknown15402 = 0x15402,
	Unknown15501 = 0x15501,
	Unknown15502 = 0x15502,
	Unknown15F00 = 0x15F00,
	Unknown17000 = 0x17000,
	Unknown17005 = 0x17005,
	Unknown17007 = 0x17007,
	Unknown17009 = 0x17009,
	Unknown1700A = 0x1700A,
	Unknown1700D = 0x1700D,
	Unknown18102 = 0x18102,
	Unknown300000A = 0x300000A,
	Unknown3521 = 0x3521,
	Unknown4201 = 0x4201,
	Unknown4216 = 0x4216,
	Unknown4290 = 0x4290,
	Unknown4291 = 0x4291,
	Unknown42A0 = 0x42A0,
	Unknown4700 = 0x4700,
	Unknown4702 = 0x4702,
	Unknown4800 = 0x4800,
	Unknown4801 = 0x4801,
	Unknown4802 = 0x4802,
	Unknown4803 = 0x4803,
	Unknown4804 = 0x4804,
	Unknown4805 = 0x4805,
	Unknown4900 = 0x4900,
	Unknown4901 = 0x4901,
	Unknown4902 = 0x4902,
	Unknown4903 = 0x4903,
	Unknown4904 = 0x4904,
	Unknown4905 = 0x4905,
	Unknown4A01 = 0x4A01,
	Unknown4A10 = 0x4A10,
	Unknown4A11 = 0x4A11,
	Unknown4A20 = 0x4A20,
	Unknown4A82 = 0x4A82,
	Unknown9150 = 0x9150,
	Unknown_1010 = 0x1010,
	Unknown_1011 = 0x1011,
	Unknown_4520 = 0x4520,
	Vector_1D_OF_Channel = 0x121102,
	Vector_2D_OF_Channel = 0x121103,
	Vector_3D_OF_Channel = 0x121104,
	Vertex_Compression_Hint = 0x10021,
	Vertex_Shader = 0x10011,
	Weight_List = 0x1000C,
	World_Sphere = 0x3F0000B,
}
local pack = string.pack
local unpack = string.unpack

function P3D.UnpackChunkHeader(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<III", str, StartPosition)
end

function P3D.String1ToInt(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<B", str, StartPosition)
end
P3D.IntToString1 = string.char
function P3D.SetInt1(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. P3D.IntToString1(NewValue) .. Chunk:sub(Offset + 1)
end

function P3D.String2ToInt(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<h", str, StartPosition)
end
function P3D.IntToString2(int)
	return pack("<h", int)
end
function P3D.SetIn2(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. P3D.IntToString2(NewValue) .. Chunk:sub(Offset + 4)
end

function P3D.String4ToInt(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<i", str, StartPosition)
end
function P3D.IntToString4(int)
	return pack("<i", int)
end
function P3D.SetInt4(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. P3D.IntToString4(NewValue) .. Chunk:sub(Offset + 4)
end
function P3D.AddInt4(Chunk, Offset, NewValue)
	local orig = P3D.String4ToInt(Chunk, Offset)
	return P3D.SetInt4(Chunk, Offset, orig + NewValue)
end

function P3D.String4ToFloat(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<f", str, StartPosition)
end
function P3D.FloatToString4(float)
	return pack("<f", float)
end
function P3D.SetFloat(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. P3D.FloatToString4(NewValue) .. Chunk:sub(Offset + 4)
end

function P3D.String4ToARGB(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	local B, G, R, A = unpack("<BBBB", str, StartPosition)
	return A, R, G, B
end
function P3D.ARGBToString4(A, R, G, B)
	return pack("<BBBB", B, G, R, A)
end
function P3D.SetARGB(Chunk, Offset, A, R, G, B)
	return Chunk:sub(1, Offset - 1) .. P3D.ARGBToString4(A, R, G, B) .. Chunk:sub(Offset + 4)
end

function P3D.String8ToVector2(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<ff", str, StartPosition)
end
function P3D.Vector2ToString8(X, Y)
	return pack("<ff", X, Y)
end
function P3D.SetVector2(Chunk, Offset, X, Y)
	return Chunk:sub(1, Offset - 1) .. P3D.Vector2ToString8(X, Y) .. Chunk:sub(Offset + 8)
end

function P3D.String12ToVector3(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<fff", str, StartPosition)
end
function P3D.Vector3ToString12(X, Y, Z)
	return pack("<fff", X, Y, Z)
end
function P3D.SetVector3(Chunk, Offset, X, Y, Z)
	return Chunk:sub(1, Offset - 1) .. P3D.Vector3ToString12(X, Y, Z) .. Chunk:sub(Offset + 12)
end

function P3D.String16ToVector4(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<ffff", str, StartPosition)
end
function P3D.Vector4ToString16(X, Y, Z, W)
	return pack("<ffff", X, Y, Z, W)
end
function P3D.SetVector4(Chunk, Offset, X, Y, Z, W)
	return Chunk:sub(1, Offset - 1) .. P3D.Vector4ToString16(X, Y, Z, W) .. Chunk:sub(Offset + 16)
end

function P3D.String64ToMatrix(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<ffffffffffffffff", str, StartPosition)
end
function P3D.MatrixToString64(M11, M12, M13, M14, M21, M22, M23, M24, M31, M32, M33, M34, M41, M42, M43, M44)
	return pack("<ffffffffffffffff", M11, M12, M13, M14, M21, M22, M23, M24, M31, M32, M33, M34, M41, M42, M43, M44)
end
function P3D.SetMatrix(Chunk, Offset, M11, M12, M13, M14, M21, M22, M23, M24, M31, M32, M33, M34, M41, M42, M43, M44)
	return Chunk:sub(1, Offset - 1) .. P3D.MatrixToString64(M11, M12, M13, M14, M21, M22, M23, M24, M31, M32, M33, M34, M41, M42, M43, M44) .. Chunk:sub(Offset + 64)
end
function P3D.MatrixIdentity()
	return {M11=1,M12=0,M13=0,M14=0,M21=0,M22=1,M23=0,M24=0,M31=0,M32=0,M33=1,M34=0,M41=0,M42=0,M43=0,M44=1}
end
function P3D.MatrixRotateY(Matrix, angle)
	angle = math.rad(angle)
	local cos = math.cos(angle)
	local sin = math.sin(angle)
	local x, y, z = Matrix.M41, Matrix.M42, Matrix.M43
	Matric = P3D.MatrixIdentity()
	Matrix.M11 = cos
	Matrix.M13 = sin * -1
	Matrix.M31 = sin
	Matrix.M33 = cos
	Matrix.M41 = x
	Matrix.M42 = y
	Matrix.M43 = z
end

function P3D.GetString(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	local output = unpack("<s1", str, StartPosition)
	return output, output:len()
end
function P3D.SetString(Chunk, Offset, NewString)
	local OrigName, OrigLen = P3D.GetString(Chunk, Offset)
	local New = Chunk:sub(1, Offset - 1) .. pack("<s1", NewString) .. Chunk:sub(Offset + OrigLen + 1)
	local Delta = NewString:len() - OrigLen
	return New, Delta, OrigName
end

function P3D.GetFourCC(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack(str, "<c4", StartPosition)
end
function P3D.SetFourCC(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. pack("<c4", NewValue) .. Chunk:sub(Offset + 4)
end

function P3D.RemoveString(str, Start, End)
	return str:sub(1, Start - 1) .. str:sub(End)
end

function P3D.MakeFourCC(str)
	str = str:sub(1, 4)
	local strLen = str:len()
	str = str .. string.rep("\0", 4 - strLen)
	return str
end

function P3D.MakeP3DString(str)
	local strLen = str:len()
	local diff = strLen % 4
	if diff > 0 then
		str = str .. string.rep("\0", 4 - diff)
	end
	return str
end

function P3D.CleanP3DString(str)
	local strLen = str:len()
	if strLen == 0 then return str end
	local l = 0
	for i=strLen,1,-1 do
		if str:byte(i) ~= 0 then
			l = i
			break
		end
	end
	return str:sub(1, l)
end

function P3D.FindSubchunks(Chunk, ID, StartPosition, EndPosition)
	if StartPosition == nil then StartPosition = 1 end
	if EndPosition == nil then EndPosition = Chunk:len() end
	
	local Position = StartPosition + P3D.String4ToInt(Chunk, StartPosition + 4)
	return function()
		while Position < EndPosition do
			local ChunkID, ChunkValueLength, ChunkLength = P3D.UnpackChunkHeader(Chunk, Position)
			Position = Position + ChunkLength
			if ID == nil or ChunkID == ID then
				return Position - ChunkLength, ChunkLength, ChunkID
			end
		end
		return nil
	end
end
function P3D.FindSubchunk(Chunk, ID, StartPosition, EndPosition)
	return P3D.FindSubchunks(Chunk, ID, StartPosition, EndPosition)()
end

-- Decompress a compressed *block* within a P3D
function P3D.DecompressBlock(Source, Length, SourceIndex)
	local Written = 0
	if SourceIndex == nil then SourceIndex = 1 end
	local DestTbl = {}
	local DestinationPos = 1
	while Written < Length do
		local Unknown = P3D.String1ToInt(Source, SourceIndex)
		SourceIndex = SourceIndex + 1
		if Unknown <= 15 then
			if Unknown == 0 then
				if P3D.String1ToInt(Source, SourceIndex) == 0 then
					local Unknown2 = 0
					repeat
						SourceIndex = SourceIndex + 1
						Unknown2 = P3D.String1ToInt(Source, SourceIndex)
						Unknown = Unknown + 255
					until Unknown2 ~= 0
				end
				Unknown = Unknown + P3D.String1ToInt(Source, SourceIndex)
				SourceIndex = SourceIndex + 1
				DestTbl[#DestTbl + 1], DestTbl[#DestTbl + 2], DestTbl[#DestTbl + 3], DestTbl[#DestTbl + 4], DestTbl[#DestTbl + 5], DestTbl[#DestTbl + 6], DestTbl[#DestTbl + 7], DestTbl[#DestTbl + 8], DestTbl[#DestTbl + 9], DestTbl[#DestTbl + 10], DestTbl[#DestTbl + 11], DestTbl[#DestTbl + 12], DestTbl[#DestTbl + 13], DestTbl[#DestTbl + 14], DestTbl[#DestTbl + 15] = unpack("<c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1", Source, SourceIndex)
				DestinationPos = DestinationPos + 15
				SourceIndex = SourceIndex + 15
				Written = Written + 15
			end
			repeat
				DestTbl[#DestTbl + 1] = Source:sub(SourceIndex, SourceIndex)
				SourceIndex = SourceIndex + 1
				DestinationPos = DestinationPos + 1
				Written = Written + 1
				Unknown = Unknown - 1
			until Unknown <= 0
		else
			local Unknown2 = Unknown % 16
			if Unknown2 == 0 then
				local Unknown3 = 15
				if P3D.String1ToInt(Source, SourceIndex) == 0 then
					local Unknown4
					repeat
						SourceIndex = SourceIndex + 1
						Unknown4 = P3D.String1ToInt(Source, SourceIndex)
						Unknown3 = Unknown3 + 255
					until Unknown4 ~= 0
				end
				Unknown2 = Unknown2 + P3D.String1ToInt(Source, SourceIndex) + Unknown3
				SourceIndex = SourceIndex + 1
			end
			local Unknown6 = DestinationPos - (math.floor(Unknown / 16) | (16 * P3D.String1ToInt(Source, SourceIndex)))
			local Unknown5 = math.floor(Unknown2 / 4)
			SourceIndex = SourceIndex + 1
			repeat
				DestTbl[#DestTbl + 1] = DestTbl[Unknown6]
				DestTbl[#DestTbl + 1] = DestTbl[Unknown6 + 1]
				DestTbl[#DestTbl + 1] = DestTbl[Unknown6 + 2]
				DestTbl[#DestTbl + 1] = DestTbl[Unknown6 + 3]
				Unknown6 = Unknown6 + 4
				DestinationPos = DestinationPos + 4
				Unknown5 = Unknown5 - 1
			until Unknown5 <= 0
			local Unknown7 = Unknown2 % 4
			while Unknown7 > 0 do
				DestTbl[#DestTbl + 1] = DestTbl[Unknown6]
				DestinationPos = DestinationPos + 1
				Unknown6 = Unknown6 + 1
				Unknown7 = Unknown7 - 1
			end
			Written = Written + Unknown2
		end
	end
	return table.concat(DestTbl), DestinationPos
end

-- Decompress a compressed P3D, returns the original P3D if not compressed
function P3D.Decompress(File)
	if File:sub(1, 4) == "P3DZ" then
		local UncompressedLength = P3D.String4ToInt(File, 5)
		local DecompressedLength = 0
		local pos = 9
		local UncompressedTbl = {}
		local CompressedLength, UncompressedBlock
		while DecompressedLength < UncompressedLength do
			CompressedLength, UncompressedBlock, pos = unpack("<ii", File, pos)
			UncompressedTbl[#UncompressedTbl + 1] = P3D.DecompressBlock(File, UncompressedBlock, pos)
			pos = pos + CompressedLength
			DecompressedLength = DecompressedLength + UncompressedBlock
		end
		return table.concat(UncompressedTbl)
	else
		return File
	end
end

-- Class data start
P3D.P3DChunk = {Raw, ChunkTypes = {}, Chunks = {}}

function P3D.P3DChunk:__tostring()
	return self:Output()
end

function P3D.P3DChunk:new(Data)
	if Data == nil then
		Data = {}
		setmetatable(Data, self)
		self.__index = self
		return Data
	end
	Data.Raw = P3D.Decompress(Data.Raw)
	Data.ChunkTypes = {}
	Data.Chunks = {}
	local ValueLen
	Data.ChunkType, ValueLen = P3D.UnpackChunkHeader(Data.Raw)
	if ValueLen > 12 then
		Data.ValueStr = Data.Raw:sub(13, ValueLen)
	else
		Data.ValueStr = ""
	end
	local i
	for ChunkPos, ChunkLen, ChunkID in P3D.FindSubchunks(Data.Raw, nil) do
		i = #Data.ChunkTypes + 1
		Data.ChunkTypes[i] = ChunkID
		Data.Chunks[i] = Data.Raw:sub(ChunkPos, ChunkPos + ChunkLen - 1)
	end
	self.__index = self
	return setmetatable(Data, self)
end

function P3D.P3DChunk:newChildClass(type)
	self.__index = self
	return setmetatable({type = type or "none", parentClass = self}, self)
end

function P3D.P3DChunk:GetChunkCount()
	return #self.ChunkTypes
end

function P3D.P3DChunk:RemoveChunkAtIndex(idx)
	local ChunkLen = self.Chunks[idx]:len()
	table.remove(self.ChunkTypes, idx)
	table.remove(self.Chunks, idx)
end

function P3D.P3DChunk:GetChunkAtIndex(idx)
	return self.Chunks[idx], self.ChunkTypes[idx]
end

function P3D.P3DChunk:SetChunkAtIndex(idx, ChunkData)
	if #self.ChunkTypes < idx then return end
	local OldLen = self.Chunks[idx]:len()
	self.ChunkTypes[idx] = P3D.UnpackChunkHeader(ChunkData)
	self.Chunks[idx] = ChunkData
end

function P3D.P3DChunk:AddChunk(ChunkData, idx)
	local ChunkID = P3D.UnpackChunkHeader(ChunkData)
	if idx then
		table.insert(self.ChunkTypes, idx, ChunkID)
		table.insert(self.Chunks, idx, ChunkData)
	else
		idx = #self.ChunkTypes + 1
		self.ChunkTypes[idx] = ChunkID
		self.Chunks[idx] = ChunkData
	end
	return idx, ChunkID
end

function P3D.P3DChunk:AddChildChunks(RootChunk)
	local i = #self.ChunkTypes + 1
	for idx in RootChunk:GetChunkIndexes() do
		self:AddChunk(RootChunk:GetChunkAtIndex(idx), i)
	end
end

function P3D.P3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local len = 12 + self.ValueStr:len()
	return pack("<III", self.ChunkType, len, len + chunks:len()) .. self.ValueStr .. chunks
end

function P3D.P3DChunk:GetName()
	local name = self.Name or P3D.GetString(self.ValueStr)
	self.Name = name
	return name
end

function P3D.P3DChunk:SetName(NewName)
	NewName = P3D.MakeP3DString(NewName)
	self.ValueStr = P3D.SetString(self.ValueStr, 1, NewName)
	self.Name = NewName
end

function P3D.P3DChunk:GetChunkIndexes(ChunkID)
	local i = #self.ChunkTypes
	return function()
		while i > 0 do
			local ChunkType = self.ChunkTypes[i]
			i = i - 1
			if ChunkID == nil or ChunkType == ChunkID then
				return i + 1, ChunkType
			end
		end
		return nil
	end
end

function P3D.P3DChunk:GetChunkIndex(ChunkID)
	return self:GetChunkIndexes(ChunkID)()
end

--Texture Chunk
P3D.TextureP3DChunk = P3D.P3DChunk:newChildClass("Texture")
function P3D.TextureP3DChunk:new(Data)
	local o = P3D.TextureP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.Width, o.Height, o.Bpp, o.AlphaDepth, o.NumMipMaps, o.TextureType, o.Usage, o.Priority = unpack("<s1iiiiiiiii", o.ValueStr)
	return o
end

function P3D.TextureP3DChunk:create(Name,Version,Width,Height,Bpp,AlphaDepth,NumMipMaps,TextureType,Usage,Priority)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return P3D.TextureP3DChunk:new{Raw = pack("<IIIs1iiiiiiiii", P3D.Identifiers.Texture, Len, Len, Name, Version, Width, Height, Bpp, AlphaDepth, NumMipMaps, TextureType, Usage, Priority)}
end

function P3D.TextureP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiiiiiiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Width, self.Height, self.Bpp, self.AlphaDepth, self.NumMipMaps, self.TextureType, self.Usage, self.Priority) .. chunks
end

--Image Chunk
P3D.ImageP3DChunk = P3D.P3DChunk:newChildClass("Image")
function P3D.ImageP3DChunk:new(Data)
	local o = P3D.ImageP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.Width, o.Height, o.Bpp, o.Palettized, o.HasAlpha, o.Format = unpack("<s1iiiiiii", o.ValueStr)
	return o
end

function P3D.ImageP3DChunk:create(Name,Version,Width,Height,Bpp,Palettized,HasAlpha,Format)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return P3D.ImageP3DChunk:new{Raw = pack("<IIIs1iiiiiii", P3D.Identifiers.Image, Len, Len, Name, Version, Width, Height, Bpp, Palettized, HasAlpha, Format)}
end

function P3D.ImageP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiiiiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Width, self.Height, self.Bpp, self.Palettized, self.HasAlpha, self.Format) .. chunks
end

--Shader Chunk
P3D.ShaderP3DChunk = P3D.P3DChunk:newChildClass("Shader")
function P3D.ShaderP3DChunk:new(Data)
	local o = P3D.ShaderP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.PDDIShader, o.HasTranslucency, o.VertexNeeds, o.VertexMask, o.NumParams = unpack("<s1is1iiii", o.ValueStr)
	return o
end

function P3D.ShaderP3DChunk:create(Name,Version,PDDIShader,HasTranslucency,VertexNeeds,VertexMask)
	local Len = 12 + Name:len() + 1 + 4 + PDDIShader:len() + 1 + 4 + 4 + 4 + 4
	return P3D.ShaderP3DChunk:new{Raw = pack("<IIIs1is1iiii", P3D.Identifiers.Shader, Len, Len, Name, Version, PDDIShader, HasTranslucency, VertexNeeds, VertexMask, 0)}
end

local ShaderParamTypes = {[P3D.Identifiers.Shader_Integer_Parameter] = true, [P3D.Identifiers.Shader_Texture_Parameter] = true, [P3D.Identifiers.Shader_Colour_Parameter] = true, [P3D.Identifiers.Shader_Float_Parameter] = true}
function P3D.ShaderP3DChunk:GetParameterCount()
	local ParamN = 0
	for i=1,#self.ChunkTypes do
		if ShaderParamTypes[self.ChunkTypes[i]] then ParamN = ParamN + 1 end
	end
	return ParamN
end

function P3D.ShaderP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + self.PDDIShader:len() + 1 + 4 + 4 + 4 + 4
	return pack("<IIIs1is1iiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.PDDIShader, self.HasTranslucency, self.VertexNeeds, self.VertexMask, self:GetParameterCount()) .. chunks
end

function P3D.ShaderP3DChunk:SetIntParameter(Name, Value)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Integer_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = P3D.SetInt4(ChunkData, 17, Value)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function P3D.ShaderP3DChunk:GetIntParameter(Name)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Integer_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return P3D.String4ToInt(ChunkData, 17)
		end
	end
	return nil
end

function P3D.ShaderP3DChunk:SetTextureParameter(Name, Value)
	Name = P3D.MakeFourCC(Name)
	Value = P3D.MakeP3DString(Value)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Texture_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			local newVal, Delta = P3D.SetString(ChunkData, 17, Value)
			newVal = P3D.AddInt4(newVal, 5, Delta)
			newVal = P3D.AddInt4(newVal, 9, Delta)
			self:SetChunkAtIndex(idx, newVal)
			return
		end
	end
end

function P3D.ShaderP3DChunk:GetTextureParameter(Name)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Texture_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return P3D.GetString(ChunkData, 17)
		end
	end
	return nil
end

function P3D.ShaderP3DChunk:SetColourParameter(Name, A, R, G, B)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Colour_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = ChunkData:sub(1, 16) .. P3D.ARGBToString4(A, R, G, B)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function P3D.ShaderP3DChunk:GetColourParameter(Name)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Colour_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return P3D.String4ToARGB(ChunkData, 17)
		end
	end
	return nil
end

function P3D.ShaderP3DChunk:SetFloatParameter(Name, Value)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Float_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = P3D.SetFloat(ChunkData, 17, Value)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function P3D.ShaderP3DChunk:GetFloatParameter(Name)
	Name = P3D.MakeFourCC(Name)
	for idx in self:GetChunkIndexes(P3D.Identifiers.Shader_Float_Parameter) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return P3D.String4ToFloat(ChunkData, 17)
		end
	end
	return nil
end

--Static Phys Chunk
P3D.StaticPhysP3DChunk = P3D.P3DChunk:newChildClass("Static Phys")
function P3D.StaticPhysP3DChunk:new(Data)
	local o = P3D.StaticPhysP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown = unpack("<s1i", o.ValueStr)
	return o
end

function P3D.StaticPhysP3DChunk:create(Name,Unknown)
	local Len = 12 + Name:len() + 1 + 4
	return P3D.StaticPhysP3DChunk:new{Raw = pack("<IIIs1i", P3D.Identifiers.Static_Phys, Len, Len, Name, Unknown)}
end

function P3D.StaticPhysP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4
	return pack("<IIIs1i", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown) .. chunks
end

--Static Entity Chunk
P3D.StaticEntityP3DChunk = P3D.P3DChunk:newChildClass("Static Entity")
function P3D.StaticEntityP3DChunk:new(Data)
	local o = P3D.StaticEntityP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.StaticEntityP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.StaticEntityP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Static_Entity, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.StaticEntityP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Inst Stat Phys Chunk
P3D.InstStatPhysP3DChunk = P3D.P3DChunk:newChildClass("Inst Stat Phys")
function P3D.InstStatPhysP3DChunk:new(Data)
	local o = P3D.InstStatPhysP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.InstStatPhysP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.InstStatPhysP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Inst_Stat_Phys, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.InstStatPhysP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Inst Stat Entity Chunk
P3D.InstStatEntityP3DChunk = P3D.P3DChunk:newChildClass("Inst Stat Entity")
function P3D.InstStatEntityP3DChunk:new(Data)
	local o = P3D.InstStatEntityP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.InstStatEntityP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.InstStatEntityP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Inst_Stat_Entity, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.InstStatEntityP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Dyna Phys Chunk
P3D.DynaPhysP3DChunk = P3D.P3DChunk:newChildClass("Dyna Phys")
function P3D.DynaPhysP3DChunk:new(Data)
	local o = P3D.DynaPhysP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.DynaPhysP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.DynaPhysP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Dyna_Phys, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.DynaPhysP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Anim Chunk
P3D.AnimP3DChunk = P3D.P3DChunk:newChildClass("Anim")
function P3D.AnimP3DChunk:new(Data)
	local o = P3D.AnimP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.AnimP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.AnimP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Anim, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.AnimP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Anim Coll Chunk
P3D.AnimCollP3DChunk = P3D.P3DChunk:newChildClass("Anim Coll")
function P3D.AnimCollP3DChunk:new(Data)
	local o = P3D.AnimCollP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.AnimCollP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.AnimCollP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Anim_Coll, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.AnimCollP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Anim Dyna Phys Chunk
P3D.AnimDynaPhysP3DChunk = P3D.P3DChunk:newChildClass("Anim Dyna Phys")
function P3D.AnimDynaPhysP3DChunk:new(Data)
	local o = P3D.AnimDynaPhysP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.AnimDynaPhysP3DChunk:create(Name,Unknown,RenderOrder)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.AnimDynaPhysP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Anim_Dyna_Phys, Len, Len, Name, Unknown, RenderOrder)}
end

function P3D.AnimDynaPhysP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.RenderOrder) .. chunks
end

--Anim Obj Wrapper Chunk
P3D.AnimObjWrapperP3DChunk = P3D.P3DChunk:newChildClass("Anim Obj Wrapper")
function P3D.AnimObjWrapperP3DChunk:new(Data)
	local o = P3D.AnimObjWrapperP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.Unknown2 = unpack("<s1BB", o.ValueStr)
	return o
end

function P3D.AnimObjWrapperP3DChunk:create(Name,Unknown,Unknown2)
	local Len = 12 + Name:len() + 1 + 1 + 1
	return P3D.AnimObjWrapperP3DChunk:new{Raw = pack("<IIIs1BB", P3D.Identifiers.Anim_Obj_Wrapper, Len, Len, Name, Unknown, Unknown2)}
end

function P3D.AnimObjWrapperP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 1 + 1
	return pack("<IIIs1BB", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self.Unknown2) .. chunks
end

--Breakable Object Chunk
P3D.BreakableObjectP3DChunk = P3D.P3DChunk:newChildClass("Breakable Object")
function P3D.BreakableObjectP3DChunk:new(Data)
	local o = P3D.BreakableObjectP3DChunk.parentClass.new(self, Data)
	o.Index, o.Count = unpack("<ii", o.ValueStr)
	return o
end

function P3D.BreakableObjectP3DChunk:create(Index,Count)
	local Len = 12 + 4 + 4
	return P3D.BreakableObjectP3DChunk:new{Raw = pack("<IIIii", P3D.Identifiers.Breakable_Object, Len, Len, Index, Count)}
end

function P3D.BreakableObjectP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + 4
	return pack("<IIIii", self.ChunkType, Len, Len + chunks:len(), self.Index, self.Count) .. chunks
end

--World Sphere Chunk
P3D.WorldSphereP3DChunk = P3D.P3DChunk:newChildClass("World Sphere")
function P3D.WorldSphereP3DChunk:new(Data)
	local o = P3D.WorldSphereP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.NumMeshes, o.NumBillboardQuadGroups = unpack("<s1iii", o.ValueStr)
	return o
end

function P3D.WorldSphereP3DChunk:create(Name,Unknown)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4
	return P3D.WorldSphereP3DChunk:new{Raw = pack("<IIIs1iii", P3D.Identifiers.World_Sphere, Len, Len, Name, Unknown, 0, 0)}
end

function P3D.WorldSphereP3DChunk:GetOldBillboardQuadGroupAndMeshCount()
	local OBQGN = 0
	local MeshN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Billboard_Quad_Group then
			OBQGN = OBQGN + 1
		elseif self.ChunkTypes[i] == P3D.Identifiers.Mesh then
			MeshN = MeshN + 1
		end
	end
	return OBQGN, MeshN
end

function P3D.WorldSphereP3DChunk:Output()
	local OBQGN, MeshN = self:GetOldBillboardQuadGroupAndMeshCount()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4
	return pack("<IIIs1iii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, MeshN, OBQGN) .. chunks
end

--Mesh Chunk
P3D.MeshP3DChunk = P3D.P3DChunk:newChildClass("Mesh")
function P3D.MeshP3DChunk:new(Data)
	local o = P3D.MeshP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.NumPrimitiveGroups = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.MeshP3DChunk:create(Name,Version)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.MeshP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Mesh, Len, Len, Name, Version, 0)}
end

function P3D.MeshP3DChunk:GetOldPrimitiveGroupCount()
	local OPGN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Primitive_Group then
			OPGN = OPGN + 1
		end
	end
	return OPGN
end

function P3D.MeshP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self:GetOldPrimitiveGroupCount()) .. chunks
end

--Old Primitive Group Chunk
P3D.OldPrimitiveGroupP3DChunk = P3D.P3DChunk:newChildClass("Old Primitive Group")
function P3D.OldPrimitiveGroupP3DChunk:new(Data)
	local o = P3D.OldPrimitiveGroupP3DChunk.parentClass.new(self, Data)
	o.Version, o.ShaderName, o.PrimitiveType, o.VertexType, o.NumVertices, o.NumIndices, o.NumMatrices = unpack("<is1iiiii", o.ValueStr)
	return o
end

function P3D.OldPrimitiveGroupP3DChunk:create(Version,ShaderName,PrimitiveType,VertexType,NumVertices,NumIndices,NumMatrices)
	local Len = 12 + 4 + ShaderName:len() + 1 + 4 + 4 + 4 + 4 + 4
	return P3D.OldPrimitiveGroupP3DChunk:new{Raw = pack("<IIIis1iiiii", P3D.Identifiers.Old_Primitive_Group, Len, Len, Version, ShaderName, PrimitiveType, VertexType, NumVertices, NumIndices, NumMatrices)}
end

function P3D.OldPrimitiveGroupP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.ShaderName:len() + 1 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIis1iiiii", self.ChunkType, Len, Len + chunks:len(), self.Version, self.ShaderName, self.PrimitiveType, self.VertexType, self.NumVertices, self.NumIndices, self.NumMatrices) .. chunks
end

--Colour List chunk
P3D.ColourListP3DChunk = P3D.P3DChunk:newChildClass("Colour List")
function P3D.ColourListP3DChunk:new(Data)
	local o = P3D.ColourListP3DChunk.parentClass.new(self, Data)
	local NumColours = unpack("<i", o.ValueStr)
	o.Colours = {}
	local idx = 5
	for i=0,NumColours - 1 do
		local col = {A=0,R=0,G=0,B=0}
		col.A, col.R, col.G, col.B = P3D.String4ToARGB(o.ValueStr, idx + i * 4)
		o.Colours[#o.Colours + 1] = col
	end
	return o
end

function P3D.ColourListP3DChunk:create(...)
	local ColoursN = #arg
	local len = 16 + ColoursN * 4
	local colours = {}
	for i=1,ColoursN do
		local col = arg[i]
		colours[#colours + 1] = ARGBToString4(col.A, col.R, col.G, col.B)
	end
	return P3D.MeshP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Colour_List, len, len, ColoursN) .. table.concat(colours)}
end

function P3D.ColourListP3DChunk:GetColoursCount()
	return #self.Colours
end

function P3D.ColourListP3DChunk:Output()
	local ColoursN = self:GetColoursCount()
	local len = 16 + ColoursN * 4
	local colours = {}
	for i=1,ColoursN do
		local col = self.Colours[i]
		colours[#colours + 1] = P3D.ARGBToString4(col.A, col.R, col.G, col.B)
	end
	return pack("<IIIi", self.ChunkType, len, len, ColoursN) .. table.concat(colours)
end

--Position List chunk
P3D.PositionListP3DChunk = P3D.P3DChunk:newChildClass("Position List")
function P3D.PositionListP3DChunk:new(Data)
	local o = P3D.PositionListP3DChunk.parentClass.new(self, Data)
	local NumPositions = unpack("<i", o.ValueStr)
	o.Positions = {}
	local idx = 5
	for i=0,NumPositions - 1 do
		local pos = {X=0,Y=0,Z=0}
		pos.X, pos.Y, pos.Z = P3D.String12ToVector3(o.ValueStr, idx + i * 12)
		o.Positions[#o.Positions + 1] = pos
	end
	return o
end

function P3D.PositionListP3DChunk:GetPositionsCount()
	return #self.Positions
end

function P3D.PositionListP3DChunk:create(...)
	local PositionsN = #arg
	local len = 16 + PositionsN * 12
	local positions = {}
	for i=1,PositionsN do
		local pos = arg[i]
		positions[#positions + 1] = P3D.Vector3ToString12(pos,X, pos.Y, pos.Z)
	end
	return P3D.MeshP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Colour_List, len, len, PositionsN) .. table.concat(positions)}
end

function P3D.PositionListP3DChunk:Output()
	local PositionsN = self:GetPositionsCount()
	local len = 16 + PositionsN * 12
	local positions = {}
	for i=1,PositionsN do
		local pos = self.Positions[i]
		positions[#positions + 1] = P3D.Vector3ToString12(pos,X, pos.Y, pos.Z)
	end
	return pack("<IIIi", self.ChunkType, len, len, PositionsN) .. table.concat(positions)
end

--Lens Flare Chunk
P3D.LensFlareP3DChunk = P3D.P3DChunk:newChildClass("Lens Flare")
function P3D.LensFlareP3DChunk:new(Data)
	local o = P3D.LensFlareP3DChunk.parentClass.new(self, Data)
	o.Name, o.Unknown, o.NumBillboardQuadGroups = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.LensFlareP3DChunk:create(Name,Unknown)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.LensFlareP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Lens_Flare, Len, Len, Name, Unknown, 0)}
end

function P3D.LensFlareP3DChunk:GetOldBillboardQuadGroupCount()
	local OBQGN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Billboard_Quad_Group then
			OBQGN = OBQGN + 1
		end
	end
	return OBQGN
end

function P3D.LensFlareP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Unknown, self:GetOldBillboardQuadGroupCount()) .. chunks
end

--Old Billboard Quad Group Chunk
P3D.OldBillboardQuadGroupP3DChunk = P3D.P3DChunk:newChildClass("Old Billboard Quad Group")
function P3D.OldBillboardQuadGroupP3DChunk:new(Data)
	local o = P3D.OldBillboardQuadGroupP3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.Shader, o.ZTest, o.ZWrite, o.Fog, o.NumQuads = unpack("<is1s1iiii", o.ValueStr)
	return o
end

function P3D.OldBillboardQuadGroupP3DChunk:create(Version,Name,Shader,ZTest,ZWrite,Fog)
	local Len = 12 + 4 + Name:len() + 1 + Shader:len() + 1 + 4 + 4 + 4 + 4
	return P3D.OldBillboardQuadGroupP3DChunk:new{Raw = pack("<IIIis1s1iiii", P3D.Identifiers.Old_Billboard_Quad_Group, Len, Len, Version, Name, Shader, ZTest, ZWrite, Fog, 0)}
end

function P3D.OldBillboardQuadGroupP3DChunk:GetOldBillboardQuadCount()
	local OBQN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Billboard_Quad then
			OBQN = OBQN + 1
		end
	end
	return OBQN
end

function P3D.OldBillboardQuadGroupP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + self.Shader:len() + 1 + 4 + 4 + 4 + 4
	return pack("<IIIis1s1iiii", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.Shader, self.ZTest, self.ZWrite, self.Fog, self:GetOldBillboardQuadCount()) .. chunks
end

--Old Billboard Quad Chunk
P3D.OldBillboardQuadP3DChunk = P3D.P3DChunk:newChildClass("Old Billboard Quad")
function P3D.OldBillboardQuadP3DChunk:new(Data)
	local o = P3D.OldBillboardQuadP3DChunk.parentClass.new(self, Data)
	o.Translate = {X=0,Y=0,Z=0}
	o.Colour = {A=0,R=0,G=0,B=0}
	o.UV1 = {X=0,Y=0}
	o.UV2 = {X=0,Y=0}
	o.UV3 = {X=0,Y=0}
	o.UV4 = {X=0,Y=0}
	o.UVOffset = {X=0,Y=0}
	o.Version, o.Name, o.BillboardMode, o.Translate.X, o.Translate.Y, o.Translate.Z, o.Colour.B, o.Colour.G, o.Colour.R, o.Colour.A, o.UV1.X, o.UV1.Y, o.UV2.X, o.UV2.Y, o.UV3.X, o.UV3.Y, o.UV4.X, o.UV4.Y, o.Width, o.Height, o.Distance, o.UVOffset.X, o.UVOffset.Y = unpack("<is1ifffBBBBfffffffffffff", o.ValueStr)
	return o
end

function P3D.OldBillboardQuadP3DChunk:create(Version,Name,BillboardMode,Translate,Colour,UV1,UV2,UV3,UV4,Width,Height,Distance,UVOffset)
	local Len = 12 + 4 + Name:len() + 1 + 4 + 12 + 4+ 8+ 8+ 8+ 8 + 4 + 4 + 4+ 8
	return P3D.OldBillboardQuadP3DChunk:new{Raw = pack("<IIIis1ifffBBBBfffffffffffff", P3D.Identifiers.Old_Billboard_Quad, Len, Len, Version, Name, BillboardMode, Translate.X, Translate.Y, Translate.Z, Colour.B, Colour.G, Colour.R, Colour.A, UV1.X, UV1.Y, UV2.X, UV2.Y, UV3.X, UV3.Y, UV4.X, UV4.Y, Width, Height, Distance, UVOffset.X, UVOffset.Y)}
end

function P3D.OldBillboardQuadP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + 4 + 12 + 4+ 8+ 8+ 8+ 8 + 4 + 4 + 4+ 8
	return pack("<IIIis1ifffBBBBfffffffffffff", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.BillboardMode, self.Translate.X, self.Translate.Y, self.Translate.Z, self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A, self.UV1.X, self.UV1.Y, self.UV2.X, self.UV2.Y, self.UV3.X, self.UV3.Y, self.UV4.X, self.UV4.Y, self.Width, self.Height, self.Distance, self.UVOffset.X, self.UVOffset.Y) .. chunks
end

--Light Chunk
P3D.LightP3DChunk = P3D.P3DChunk:newChildClass("Light")
function P3D.LightP3DChunk:new(Data)
	local o = P3D.LightP3DChunk.parentClass.new(self, Data)
	o.Colour = {A=0,R=0,G=0,B=0}
	o.Name, o.Version, o.Type, o.Colour.B, o.Colour.G, o.Colour.R, o.Colour.A, o.Constant, o.Linear, o.Squared, o.Enabled = unpack("<s1iiBBBBfffi", o.ValueStr)
	return o
end

function P3D.LightP3DChunk:create(Name,Version,Type,Colour,Constant,Linear,Squared,Enabled)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return P3D.LightP3DChunk:new{Raw = pack("<IIIs1iiBBBBfffi", P3D.Identifiers.Light, Len, Len, Name, Version, Type, Colour.B, Colour.G, Colour.R, Colour.A, Constant, Linear, Squared, Enabled)}
end

function P3D.LightP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiBBBBfffi", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Type, self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A, self.Constant, self.Linear, self.Squared, self.Enabled) .. chunks
end

--Skin Chunk
P3D.SkinP3DChunk = P3D.P3DChunk:newChildClass("Skin")
function P3D.SkinP3DChunk:new(Data)
	local o = P3D.SkinP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.SkeletonName, o.NumPrimitiveGroups = unpack("<s1is1i", o.ValueStr)
	return o
end

function P3D.SkinP3DChunk:create(Name,Version,SkeletonName)
	local Len = 12 + Name:len() + 1 + 4 + SkeletonName:len() + 1 + 4
	return P3D.SkinP3DChunk:new{Raw = pack("<IIIs1is1i", P3D.Identifiers.Skin, Len, Len, Name, Version, SkeletonName, 0)}
end

function P3D.SkinP3DChunk:GetOldPrimitiveGroupCount()
	local OPGN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Primitive_Group then
			OPGN = OPGN + 1
		end
	end
	return OPGN
end

function P3D.SkinP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + self.SkeletonName:len() + 1 + 4
	return pack("<IIIs1is1i", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.SkeletonName, self:GetOldPrimitiveGroupCount()) .. chunks
end

--Composite Drawable Chunk
P3D.CompositeDrawableP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable")
function P3D.CompositeDrawableP3DChunk:new(Data)
	local o = P3D.CompositeDrawableP3DChunk.parentClass.new(self, Data)
	o.Name, o.SkeletonName = unpack("<s1s1", o.ValueStr)
	return o
end

function P3D.CompositeDrawableP3DChunk:create(Name,SkeletonName)
	local Len = 12 + Name:len() + 1 + SkeletonName:len() + 1
	return P3D.CompositeDrawableP3DChunk:new{Raw = pack("<IIIs1s1", P3D.Identifiers.Composite_Drawable, Len, Len, Name, SkeletonName)}
end

function P3D.CompositeDrawableP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + self.SkeletonName:len() + 1
	return pack("<IIIs1s1", self.ChunkType, Len, Len + chunks:len(), self.Name, self.SkeletonName) .. chunks
end

--Composite Drawable Skin List Chunk
P3D.CompositeDrawableSkinListP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Skin List")
function P3D.CompositeDrawableSkinListP3DChunk:new(Data)
	local o = P3D.CompositeDrawableSkinListP3DChunk.parentClass.new(self, Data)
	o.NumElements = unpack("<i", o.ValueStr)
	return o
end

function P3D.CompositeDrawableSkinListP3DChunk:create()
	local Len = 12 + 4
	return P3D.CompositeDrawableSkinListP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Composite_Drawable_Skin_List, Len, Len, 0)}
end

function P3D.CompositeDrawableSkinListP3DChunk:GetElementCount()
	return #self.Chunks
end

function P3D.CompositeDrawableSkinListP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4
	return pack("<IIIi", self.ChunkType, Len, Len + chunks:len(), self:GetElementCount()) .. chunks
end

--Composite Drawable Skin Chunk
P3D.CompositeDrawableSkinP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Skin")
function P3D.CompositeDrawableSkinP3DChunk:new(Data)
	local o = P3D.CompositeDrawableSkinP3DChunk.parentClass.new(self, Data)
	o.Name, o.IsTranslucent = unpack("<s1i", o.ValueStr)
	return o
end

function P3D.CompositeDrawableSkinP3DChunk:create(Name,IsTranslucent)
	local Len = 12 + Name:len() + 1 + 4
	return P3D.CompositeDrawableSkinP3DChunk:new{Raw = pack("<IIIs1i", P3D.Identifiers.Composite_Drawable_Skin, Len, Len, Name, IsTranslucent)}
end

function P3D.CompositeDrawableSkinP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4
	return pack("<IIIs1i", self.ChunkType, Len, Len + chunks:len(), self.Name, self.IsTranslucent) .. chunks
end

--Composite Drawable Prop List Chunk
P3D.CompositeDrawablePropListP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Prop List")
function P3D.CompositeDrawablePropListP3DChunk:new(Data)
	local o = P3D.CompositeDrawablePropListP3DChunk.parentClass.new(self, Data)
	o.NumElements = unpack("<i", o.ValueStr)
	return o
end

function P3D.CompositeDrawablePropListP3DChunk:create()
	local Len = 12 + 4
	return P3D.CompositeDrawablePropListP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Composite_Drawable_Prop_List, Len, Len, 0)}
end

function P3D.CompositeDrawablePropListP3DChunk:GetElementCount()
	return #self.Chunks
end

function P3D.CompositeDrawablePropListP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4
	return pack("<IIIi", self.ChunkType, Len, Len + chunks:len(), self:GetElementCount()) .. chunks
end

--Composite Drawable Prop Chunk
P3D.CompositeDrawablePropP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Prop")
function P3D.CompositeDrawablePropP3DChunk:new(Data)
	local o = P3D.CompositeDrawablePropP3DChunk.parentClass.new(self, Data)
	o.Name, o.IsTranslucent, o.SkeletonJointID = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.CompositeDrawablePropP3DChunk:create(Name,IsTranslucent,SkeletonJointID)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.CompositeDrawablePropP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Composite_Drawable_Prop, Len, Len, Name, IsTranslucent, SkeletonJointID)}
end

function P3D.CompositeDrawablePropP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.IsTranslucent, self.SkeletonJointID) .. chunks
end

--Composite Drawable Effect List Chunk
P3D.CompositeDrawableEffectListP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Effect List")
function P3D.CompositeDrawableEffectListP3DChunk:new(Data)
	local o = P3D.CompositeDrawableEffectListP3DChunk.parentClass.new(self, Data)
	o.NumElements = unpack("<i", o.ValueStr)
	return o
end

function P3D.CompositeDrawableEffectListP3DChunk:create()
	local Len = 12 + 4
	return P3D.CompositeDrawableEffectListP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Composite_Drawable_Effect_List, Len, Len, 0)}
end

function P3D.CompositeDrawableEffectListP3DChunk:GetElementCount()
	return #self.Chunks
end

function P3D.CompositeDrawableEffectListP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4
	return pack("<IIIi", self.ChunkType, Len, Len + chunks:len(), self:GetElementCount()) .. chunks
end

--Composite Drawable Effect Chunk
P3D.CompositeDrawableEffectP3DChunk = P3D.P3DChunk:newChildClass("Composite Drawable Effect")
function P3D.CompositeDrawableEffectP3DChunk:new(Data)
	local o = P3D.CompositeDrawableEffectP3DChunk.parentClass.new(self, Data)
	o.Name, o.IsTranslucent, o.SkeletonJointID = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.CompositeDrawableEffectP3DChunk:create(Name,IsTranslucent,SkeletonJointID)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.CompositeDrawableEffectP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Composite_Drawable_Effect, Len, Len, Name, IsTranslucent, SkeletonJointID)}
end

function P3D.CompositeDrawableEffectP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.IsTranslucent, self.SkeletonJointID) .. chunks
end

--Collision Effect Chunk
P3D.CollisionEffectP3DChunk = P3D.P3DChunk:newChildClass("Collision Effect")
function P3D.CollisionEffectP3DChunk:new(Data)
	local o = P3D.CollisionEffectP3DChunk.parentClass.new(self, Data)
	o.Classtype, o.ATCEntry, o.SoundResourceDataName = unpack("<iis1", o.ValueStr)
	return o
end

function P3D.CollisionEffectP3DChunk:create(Classtype,ATCEntry,SoundResourceDataName)
	local Len = 12 + 4 + 4 + SoundResourceDataName:len() + 1
	return P3D.CollisionEffectP3DChunk:new{Raw = pack("<IIIiis1", P3D.Identifiers.Collision_Effect, Len, Len, Classtype, ATCEntry, SoundResourceDataName)}
end

function P3D.CollisionEffectP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + 4 + self.SoundResourceDataName:len() + 1
	return pack("<IIIiis1", self.ChunkType, Len, Len + chunks:len(), self.Classtype, self.ATCEntry, self.SoundResourceDataName) .. chunks
end

--State Prop Data V1 Chunk
P3D.StatePropDataV1P3DChunk = P3D.P3DChunk:newChildClass("State Prop Data V1")
function P3D.StatePropDataV1P3DChunk:new(Data)
	local o = P3D.StatePropDataV1P3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.ObjectFactoryName, o.NumStates = unpack("<is1s1i", o.ValueStr)
	return o
end

function P3D.StatePropDataV1P3DChunk:create(Version,Name,ObjectFactoryName)
	local Len = 12 + 4 + Name:len() + 1 + ObjectFactoryName:len() + 1 + 4
	return P3D.StatePropDataV1P3DChunk:new{Raw = pack("<IIIis1s1i", P3D.Identifiers.State_Prop_Data_V1, Len, Len, Version, Name, ObjectFactoryName, 0)}
end

function P3D.StatePropDataV1P3DChunk:GetStateCount()
	local StateN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.State_Prop_State_Data_V1 then
			StateN = StateN + 1
		end
	end
	return StateN
end

function P3D.StatePropDataV1P3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + self.ObjectFactoryName:len() + 1 + 4
	return pack("<IIIis1s1i", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.ObjectFactoryName, self:GetStateCount()) .. chunks
end

--State Prop State Data V1 Chunk
P3D.StatePropStateDataV1P3DChunk = P3D.P3DChunk:newChildClass("State Prop State Data V1")
function P3D.StatePropStateDataV1P3DChunk:new(Data)
	local o = P3D.StatePropStateDataV1P3DChunk.parentClass.new(self, Data)
	o.Name, o.AutoTransition, o.OutState, o.NumDrawables, o.NumFrameControllers, o.NumEvents, o.NumCallbacks, o.OutFrame = unpack("<s1iiiiiif", o.ValueStr)
	return o
end

function P3D.StatePropStateDataV1P3DChunk:create(Name,AutoTransition,OutState,OutFrame)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return P3D.StatePropStateDataV1P3DChunk:new{Raw = pack("<IIIs1iiiiiif", P3D.Identifiers.State_Prop_State_Data_V1, Len, Len, Name, AutoTransition, OutState, 0, 0, 0, 0, OutFrame)}
end

function P3D.StatePropStateDataV1P3DChunk:GetCounts()
	local DrawableN = 0
	local FrameControllerN = 0
	local EventN = 0
	local CallbackN = 0
	for i=1,#self.ChunkTypes do
		local type = self.ChunkTypes[i]
		if type == P3D.Identifiers.State_Prop_Visibilities_Data then
			DrawableN = DrawableN + 1
		elseif type == P3D.Identifiers.State_Prop_Frame_Controller_Data then
			FrameControllerN = FrameControllerN + 1
		elseif type == P3D.Identifiers.State_Prop_Event_Data then
			EventN = EventN + 1
		elseif type == P3D.Identifiers.State_Prop_Callback_Data then
			CallbackN = CallbackN + 1
		end
	end
	return DrawableN, FrameControllerN, EventN, CallbackN
end

function P3D.StatePropStateDataV1P3DChunk:Output()
	local DrawableN, FrameControllerN, EventN, CallbackN = self:GetCounts()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiiiiif", self.ChunkType, Len, Len + chunks:len(), self.Name, self.AutoTransition, self.OutState, DrawableN, FrameControllerN, EventN, CallbackN, self.OutFrame) .. chunks
end

--Locator Chunk TODO: Handle types
P3D.LocatorP3DChunk = P3D.P3DChunk:newChildClass("Locator")
function P3D.LocatorP3DChunk:new(Data)
	local o = P3D.LocatorP3DChunk.parentClass.new(self, Data)
	o.Name, o.Type, o.DataLen = unpack("<s1ii", o.ValueStr)
	local idx = o.Name:len() + 1 + 4 + 4 + 1
	o.Position = {X=0,Y=0,Z=0}
	o.Data, o.Position.X, o.Position.Y, o.Position.Z, o.NumTriggers = unpack("<c" .. o.DataLen * 4 .. "fffi", o.ValueStr, idx)
	return o
end

function P3D.LocatorP3DChunk:createType9(Name, Position, Type, UnknownStr1, UnknownStr2, Unknown1, Unknown2)
	local dataTbl = {UnknownStr1}
	for i=1,4 - UnknownStr1:len() % 4 do
		dataTbl[#dataTbl + 1] = "\0"
	end
	dataTbl[#dataTbl + 1] = UnknownStr2
	for i=1,4 - UnknownStr2:len() % 4 do
		dataTbl[#dataTbl + 1] = "\0"
	end
	dataTbl[#dataTbl + 1] = Type
	for i=1,4 - Type:len() % 4 do
		dataTbl[#dataTbl + 1] = "\0"
	end
	local data = table.concat(dataTbl)
	local Len = 12 + Name:len() + 1 + 4 + 4 + data:len() + 4 + 4 + 12 + 4
	return P3D.LocatorP3DChunk:new{Raw = pack("<IIIs1iic" .. data:len() .. "iifffi", P3D.Identifiers.Locator, Len, Len, Name, 9, data:len() / 4 + 2, data, Unknown1, Unknown2, Position.X, Position.Y, Position.Z, 0)}
end

function P3D.LocatorP3DChunk:GetType0Data()
	local Event, idx = unpack("<I", self.ValueStr, self.Name:len() + 1 + 4 + 4 + 1)
	local Parameter = nil
	if self.DataLen >= 2 then Parameter = unpack("<I", self.ValueStr, idx) end
	return Event, Parameter
end

function P3D.LocatorP3DChunk:GetType9Data()
	local data, Unknown1, Unknown2 = unpack("<c" .. (self.DataLen - 2) * 4 .. "ii", self.ValueStr, self.Name:len() + 1 + 4 + 4 + 1)
	local UnknownStr1, UnknownStr2, Type
	local index = 1
	local position = 1
	local buffer = {}
	for i=1,#data do
		if data:byte(i) ~= 0 then
			buffer[#buffer + 1] = data:sub(i, i)
		else
			if #buffer > 0 then
				if index == 1 then
					UnknownStr1 = table.concat(buffer)
				elseif index == 2 then
					UnknownStr2 = table.concat(buffer)
				elseif index == 3 then
					Type = table.concat(buffer)
				end
				buffer = {}
				index = index + 1
			end
		end
	end
	return Type, UnknownStr1, UnknownStr2, Unknown1, Unknown2
end

function P3D.LocatorP3DChunk:GetTriggerCount()
	local TriggerN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Trigger_Volume then
			TriggerN = TriggerN + 1
		end
	end
	return TriggerN
end

function P3D.LocatorP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + self.Data:len() + 12 + 4
	return pack("<IIIs1iic" .. self.DataLen * 4 .."fffi", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Type, self.DataLen, self.Data, self.Position.X, self.Position.Y, self.Position.Z, self:GetTriggerCount()) .. chunks
end

--Skeleton Chunk
P3D.SkeletonP3DChunk = P3D.P3DChunk:newChildClass("Skeleton")
function P3D.SkeletonP3DChunk:new(Data)
	local o = P3D.SkeletonP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.NumJoints = unpack("<s1ii", o.ValueStr)
	return o
end

function P3D.SkeletonP3DChunk:create(Name,Version)
	local Len = 12 + Name:len() + 1 + 4 + 4
	return P3D.SkeletonP3DChunk:new{Raw = pack("<IIIs1ii", P3D.Identifiers.Skeleton, Len, Len, Name, Version, 0)}
end

function P3D.SkeletonP3DChunk:GetJointCount()
	local JointN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Skeleton_Joint then
			JointN = JointN + 1
		end
	end
	return JointN
end

function P3D.SkeletonP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIs1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self:GetJointCount()) .. chunks
end

--Skeleton Joint Chunk
P3D.SkeletonJointP3DChunk = P3D.P3DChunk:newChildClass("Skeleton Joint")
function P3D.SkeletonJointP3DChunk:new(Data)
	local o = P3D.SkeletonJointP3DChunk.parentClass.new(self, Data)
	o.RestPose = P3D.MatrixIdentity()
	o.Name, o.Parent, o.DOF, o.FreeAxis, o.PrimaryAxis, o.SecondaryAxis, o.TwistAxis, o.RestPose.M11, o.RestPose.M12, o.RestPose.M13, o.RestPose.M14, o.RestPose.M21, o.RestPose.M22, o.RestPose.M23, o.RestPose.M34, o.RestPose.M31, o.RestPose.M32, o.RestPose.M33, o.RestPose.M34, o.RestPose.M41, o.RestPose.M42, o.RestPose.M43, o.RestPose.M44 = unpack("<s1iiiiiiffffffffffffffff", o.ValueStr)
	return o
end

function P3D.SkeletonJointP3DChunk:create(Name,Parent,DOF,FreeAxis,PrimaryAxis,SecondaryAxis,TwistAxis,RestPose)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 64
	return P3D.SkeletonJointP3DChunk:new{Raw = pack("<IIIs1iiiiiiffffffffffffffff", P3D.Identifiers.Skeleton_Joint, Len, Len, Name, Parent, DOF, FreeAxis, PrimaryAxis, SecondaryAxis, TwistAxis, RestPose.M11, RestPose.M12, RestPose.M13, RestPose.M14, RestPose.M21, RestPose.M22, RestPose.M23, RestPose.M34, RestPose.M31, RestPose.M32, RestPose.M33, RestPose.M34, RestPose.M41, RestPose.M42, RestPose.M43, RestPose.M44)}
end

function P3D.SkeletonJointP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 64
	return pack("<IIIs1iiiiiiffffffffffffffff", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Parent, self.DOF, self.FreeAxis, self.PrimaryAxis, self.SecondaryAxis, self.TwistAxis, self.RestPose.M11, self.RestPose.M12, self.RestPose.M13, self.RestPose.M14, self.RestPose.M21, self.RestPose.M22, self.RestPose.M23, self.RestPose.M34, self.RestPose.M31, self.RestPose.M32, self.RestPose.M33, self.RestPose.M34, self.RestPose.M41, self.RestPose.M42, self.RestPose.M43, self.RestPose.M44) .. chunks
end

--Old Frame Controller Chunk
P3D.OldFrameControllerP3DChunk = P3D.P3DChunk:newChildClass("Old Frame Controller")
function P3D.OldFrameControllerP3DChunk:new(Data)
	local o = P3D.OldFrameControllerP3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.Type, o.FrameOffset, o.HierarchyName, o.AnimationName = unpack("<is1c4fs1s1", o.ValueStr)
	return o
end

function P3D.OldFrameControllerP3DChunk:create(Version,Name,Type,FrameOffset,HierarchyName,AnimationName)
	local Len = 12 + 4 + Name:len() + 1 + 4 + 4 + HierarchyName:len() + 1 + AnimationName:len() + 1
	return P3D.OldFrameControllerP3DChunk:new{Raw = pack("<IIIis1c4fs1s1", P3D.Identifiers.Old_Frame_Controller, Len, Len, Version, Name, Type, FrameOffset, HierarchyName, AnimationName)}
end

function P3D.OldFrameControllerP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + 4 + 4 + self.HierarchyName:len() + 1 + self.AnimationName:len() + 1
	return pack("<IIIis1c4fs1s1", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.Type, self.FrameOffset, self.HierarchyName, self.AnimationName) .. chunks
end

--Physics Object Chunk
P3D.PhysicsObjectP3DChunk = P3D.P3DChunk:newChildClass("Physics Object")
function P3D.PhysicsObjectP3DChunk:new(Data)
	local o = P3D.PhysicsObjectP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.MaterialName, o.NumJoints, o.Volume, o.RestingSensitivity = unpack("<s1is1iff", o.ValueStr)
	return o
end

function P3D.PhysicsObjectP3DChunk:create(Name,Version,MaterialName,Volume,RestingSensitivity)
	local Len = 12 + Name:len() + 1 + 4 + MaterialName:len() + 1 + 4 + 4 + 4
	return P3D.PhysicsObjectP3DChunk:new{Raw = pack("<IIIs1is1iff", P3D.Identifiers.Physics_Object, Len, Len, Name, Version, MaterialName, 0, Volume, RestingSensitivity)}
end

function P3D.PhysicsObjectP3DChunk:GetJointCount()
	local JointN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Physics_Joint then
			JointN = JointN + 1
		end
	end
	return JointN
end

function P3D.PhysicsObjectP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + self.MaterialName:len() + 1 + 4 + 4 + 4
	return pack("<IIIs1is1iff", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.MaterialName, self:GetJointCount(), self.Volume, self.RestingSensitivity) .. chunks
end

--Collision Object Chunk
P3D.CollisionObjectP3DChunk = P3D.P3DChunk:newChildClass("Collision Object")
function P3D.CollisionObjectP3DChunk:new(Data)
	local o = P3D.CollisionObjectP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.MaterialName, o.NumSubObject, o.NumOwner = unpack("<s1is1ii", o.ValueStr)
	return o
end

function P3D.CollisionObjectP3DChunk:create(Name,Version,MaterialName)
	local Len = 12 + Name:len() + 1 + 4 + MaterialName:len() + 1 + 4 + 4
	return P3D.CollisionObjectP3DChunk:new{Raw = pack("<IIIs1is1ii", P3D.Identifiers.Collision_Object, Len, Len, Name, Version, MaterialName, 0, 0)}
end

function P3D.CollisionObjectP3DChunk:GetOwnerCount()
	local OwnerN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Collision_Volume_Owner then
			OwnerN = OwnerN + 1
		end
	end
	return OwnerN
end

function P3D.CollisionObjectP3DChunk:Output()
	local OwnerN = self:GetOwnerCount()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + self.MaterialName:len() + 1 + 4 + 4
	return pack("<IIIs1is1ii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.MaterialName, #self.Chunks - OwnerN, OwnerN) .. chunks
end

--Collision Volume Chunk
P3D.CollisionVolumeP3DChunk = P3D.P3DChunk:newChildClass("Collision Volume")
function P3D.CollisionVolumeP3DChunk:new(Data)
	local o = P3D.CollisionVolumeP3DChunk.parentClass.new(self, Data)
	o.ObjectReferenceIndex, o.OwnerIndex, o.NumSubVolume = unpack("<iii", o.ValueStr)
	return o
end

function P3D.CollisionVolumeP3DChunk:create(ObjectReferenceIndex,OwnerIndex)
	local Len = 12 + 4 + 4 + 4
	return P3D.CollisionVolumeP3DChunk:new{Raw = pack("<IIIiii", P3D.Identifiers.Collision_Volume, Len, Len, ObjectReferenceIndex, OwnerIndex, 0)}
end

function P3D.CollisionVolumeP3DChunk:GetVolumeCount()
	local VolumeN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Collision_Volume then
			VolumeN = VolumeN + 1
		end
	end
	return VolumeN
end

function P3D.CollisionVolumeP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + 4 + 4
	return pack("<IIIiii", self.ChunkType, Len, Len + chunks:len(), self.ObjectReferenceIndex, self.OwnerIndex, self:GetVolumeCount()) .. chunks
end

--Multi Controller Chunk
P3D.MultiControllerP3DChunk = P3D.P3DChunk:newChildClass("Multi Controller")
function P3D.MultiControllerP3DChunk:new(Data)
	local o = P3D.MultiControllerP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.Length, o.Framerate, o.NumTracks = unpack("<s1iffi", o.ValueStr)
	return o
end

function P3D.MultiControllerP3DChunk:create(Name,Version,Length,Framerate)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4
	return P3D.MultiControllerP3DChunk:new{Raw = pack("<IIIs1iffi", P3D.Identifiers.Multi_Controller, Len, Len, Name, Version, Length, Framerate, 0)}
end

function P3D.MultiControllerP3DChunk:GetTrackCount()
	local TrackN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Multi_Controller_Tracks then
			TrackN = TrackN + 1
		end
	end
	return TrackN
end

function P3D.MultiControllerP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4
	return pack("<IIIs1iffi", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Length, self.Framerate, self:GetTrackCount()) .. chunks
end

--Multi Controller Tracks chunk
P3D.MultiControllerTracksP3DChunk = P3D.P3DChunk:newChildClass("Multi Controller Tracks")
function P3D.MultiControllerTracksP3DChunk:new(Data)
	local o = P3D.MultiControllerTracksP3DChunk.parentClass.new(self, Data)
	local NumTracks = unpack("<i", o.ValueStr)
	o.Tracks = {}
	local idx = 5
	for i=0,NumTracks - 1 do
		local track = {Name="",StartTime=0,EndTime=0,Scale=0}
		track.Name, track.StartTime, track.EndTime, track.Scale = unpack("<s1fff", o.ValueStr, idx)
		idx = idx + track.Name:len() + 1 + 4 + 4 + 4
		o.Tracks[#o.Tracks + 1] = track
	end
	return o
end

function P3D.MultiControllerTracksP3DChunk:create(...)
	local TracksN = #arg
	local len = 16
	local tracks = {}
	for i=1,TracksN do
		local track = arg[i]
		tracks[#tracks + 1] = pack("<s1fff", track.Name, track.StartTime, track.EndTime, track.Scale)
		len = len + track.Name:len() + 1 + 4 + 4 + 4
	end
	return P3D.MeshP3DChunk:new{Raw = pack("<IIIi", P3D.Identifiers.Multi_Controller_Tracks, len, len, TracksN) .. table.concat(tracks)}
end

function P3D.MultiControllerTracksP3DChunk:GetTrackCount()
	return #self.Tracks
end

function P3D.MultiControllerTracksP3DChunk:Output()
	local TracksN = self:GetTrackCount()
	local len = 16
	local tracks = {}
	for i=1,TracksN do
		local track = self.Tracks[i]
		tracks[#tracks + 1] = pack("<s1fff", track.Name, track.StartTime, track.EndTime, track.Scale)
		len = len + track.Name:len() + 1 + 4 + 4 + 4
	end
	return pack("<IIIi", P3D.Identifiers.Multi_Controller_Tracks, len, len, TracksN) .. table.concat(tracks)
end

--Animation Chunk
P3D.AnimationP3DChunk = P3D.P3DChunk:newChildClass("Animation")
function P3D.AnimationP3DChunk:new(Data)
	local o = P3D.AnimationP3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.AnimationType, o.NumFrames, o.FrameRate, o.Cyclic = unpack("<is1c4ffi", o.ValueStr)
	return o
end

function P3D.AnimationP3DChunk:create(Version,Name,AnimationType,NumFrames,FrameRate,Cyclic)
	local Len = 12 + 4 + Name:len() + 1 + AnimationType:len() + 4 + 4 + 4
	return P3D.AnimationP3DChunk:new{Raw = pack("<IIIis1c4ffi", P3D.Identifiers.Animation, Len, Len, Version, Name, AnimationType, NumFrames, FrameRate, Cyclic)}
end

function P3D.AnimationP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + self.AnimationType:len() + 4 + 4 + 4
	return pack("<IIIis1c4ffi", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.AnimationType, self.NumFrames, self.FrameRate, self.Cyclic) .. chunks
end

--Particle System 2 Chunk
P3D.ParticleSystem2P3DChunk = P3D.P3DChunk:newChildClass("Particle System 2")
function P3D.ParticleSystem2P3DChunk:new(Data)
	local o = P3D.ParticleSystem2P3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.Unknown = unpack("<is1s1", o.ValueStr)
	return o
end

function P3D.ParticleSystem2P3DChunk:create(Version,Name,Unknown)
	local Len = 12 + 4 + Name:len() + 1 + Unknown:len() + 1
	return P3D.ParticleSystem2P3DChunk:new{Raw = pack("<IIIis1s1", P3D.Identifiers.Particle_System_2, Len, Len, Version, Name, Unknown)}
end

function P3D.ParticleSystem2P3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + self.Unknown:len() + 1
	return pack("<IIIis1s1", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.Unknown) .. chunks
end

--Particle System Factory Chunk
P3D.ParticleSystemFactoryP3DChunk = P3D.P3DChunk:newChildClass("Particle System Factory")
function P3D.ParticleSystemFactoryP3DChunk:new(Data)
	local o = P3D.ParticleSystemFactoryP3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.FrameRate, o.NumAnimFrames, o.NumOLFrames, o.CycleAnim, o.EnableSorting, o.NumEmitters = unpack("<is1fiihhi", o.ValueStr)
	return o
end

function P3D.ParticleSystemFactoryP3DChunk:create(Version,Name,FrameRate,NumAnimFrames,NumOLFrames,CycleAnim,EnableSorting)
	local Len = 12 + 4 + Name:len() + 1 + 4 + 4 + 4 + 2 + 2 + 4
	return P3D.ParticleSystemFactoryP3DChunk:new{Raw = pack("<IIIis1fiihhi", P3D.Identifiers.Particle_System_Factory, Len, Len, Version, Name, FrameRate, NumAnimFrames, NumOLFrames, CycleAnim, EnableSorting, 0)}
end

function P3D.ParticleSystemFactoryP3DChunk:GetEmitterCount()
	local EmitterN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Old_Sprite_Emitter then
			EmitterN = EmitterN + 1
		end
	end
	return EmitterN
end

function P3D.ParticleSystemFactoryP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + 4 + 4 + 4 + 2 + 2 + 4
	return pack("<IIIis1fiihhi", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.FrameRate, self.NumAnimFrames, self.NumOLFrames, self.CycleAnim, self.EnableSorting, self:GetEmitterCount()) .. chunks
end

--Instance List Chunk
P3D.InstanceListP3DChunk = P3D.P3DChunk:newChildClass("Instance List")
function P3D.InstanceListP3DChunk:new(Data)
	local o = P3D.InstanceListP3DChunk.parentClass.new(self, Data)
	o.Name = unpack("<s1", o.ValueStr)
	o.Data = o.ValueStr:sub(o.Name:len() + 1)
	return o
end

function P3D.InstanceListP3DChunk:create(Name,Data)
	local Len = 12 + Name:len() + 1 + Data:len()
	return P3D.InstanceListP3DChunk:new{Raw = pack("<IIIs1i", P3D.Identifiers.Instance_List, Len, Len, Name) .. Data}
end

function P3D.InstanceListP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + self.Data:len()
	return pack("<IIIs1", self.ChunkType, Len, Len + chunks:len(), self.Name) .. self.Data .. chunks
end

--Scenegraph Chunk
P3D.ScenegraphP3DChunk = P3D.P3DChunk:newChildClass("Scenegraph")
function P3D.ScenegraphP3DChunk:new(Data)
	local o = P3D.ScenegraphP3DChunk.parentClass.new(self, Data)
	o.Name = unpack("<s1", o.ValueStr)
	o.Data = o.ValueStr:sub(o.Name:len() + 1)
	return o
end

function P3D.ScenegraphP3DChunk:create(Name,Data)
	local Len = 12 + Name:len() + 1 + Data:len()
	return P3D.ScenegraphP3DChunk:new{Raw = pack("<IIIs1", P3D.Identifiers.Scenegraph, Len, Len, Name) .. Data}
end

function P3D.ScenegraphP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + self.Data:len()
	return pack("<IIIs1", self.ChunkType, Len, Len + chunks:len(), self.Name) .. self.Data .. chunks
end

--Old Scenegraph Root Chunk
P3D.OldScenegraphRootP3DChunk = P3D.P3DChunk:newChildClass("Old Scenegraph Root")
function P3D.OldScenegraphRootP3DChunk:new(Data)
	local o = P3D.OldScenegraphRootP3DChunk.parentClass.new(self, Data)
	return o
end

--Old Scenegraph Branch Chunk
P3D.OldScenegraphBranchP3DChunk = P3D.P3DChunk:newChildClass("Old Scenegraph Branch")
function P3D.OldScenegraphBranchP3DChunk:new(Data)
	local o = P3D.OldScenegraphBranchP3DChunk.parentClass.new(self, Data)
	o.Name, o.NumChildren = unpack("<s1i", o.ValueStr)
	return o
end

function P3D.OldScenegraphBranchP3DChunk:create(Name)
	local Len = 12 + Name:len() + 1 + 4
	return P3D.OldScenegraphBranchP3DChunk:new{Raw = pack("<IIIs1i", P3D.Identifiers.Old_Scenegraph_Branch, Len, Len, Name, 0)}
end

function P3D.OldScenegraphBranchP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4
	return pack("<IIIs1i", self.ChunkType, Len, Len + chunks:len(), self.Name, #self.Chunks) .. chunks
end

--Old Scenegraph Transform Chunk
P3D.OldScenegraphTransformP3DChunk = P3D.P3DChunk:newChildClass("Old Scenegraph Transform")
function P3D.OldScenegraphTransformP3DChunk:new(Data)
	local o = P3D.OldScenegraphTransformP3DChunk.parentClass.new(self, Data)
	o.Transform = P3D.MatrixIdentity()
	o.Name, o.NumChildren, o.Transform.M11, o.Transform.M12, o.Transform.M13, o.Transform.M14, o.Transform.M21, o.Transform.M22, o.Transform.M23, o.Transform.M34, o.Transform.M31, o.Transform.M32, o.Transform.M33, o.Transform.M34, o.Transform.M41, o.Transform.M42, o.Transform.M43, o.Transform.M44 = unpack("<s1iffffffffffffffff", o.ValueStr)
	return o
end

function P3D.OldScenegraphTransformP3DChunk:create(Name,Transform)
	local Len = 12 + Name:len() + 1 + 4 + 64
	return P3D.OldScenegraphTransformP3DChunk:new{Raw = pack("<IIIs1iffffffffffffffff", P3D.Identifiers.Old_Scenegraph_Transform, Len, Len, Name, 0, Transform.M11, Transform.M12, Transform.M13, Transform.M14, Transform.M21, Transform.M22, Transform.M23, Transform.M34, Transform.M31, Transform.M32, Transform.M33, Transform.M34, Transform.M41, Transform.M42, Transform.M43, Transform.M44)}
end

function P3D.OldScenegraphTransformP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 64
	return pack("<IIIs1iffffffffffffffff", self.ChunkType, Len, Len + chunks:len(), self.Name, #self.Chunks, self.Transform.M11, self.Transform.M12, self.Transform.M13, self.Transform.M14, self.Transform.M21, self.Transform.M22, self.Transform.M23, self.Transform.M34, self.Transform.M31, self.Transform.M32, self.Transform.M33, self.Transform.M34, self.Transform.M41, self.Transform.M42, self.Transform.M43, self.Transform.M44) .. chunks
end

--Old Scenegraph Drawable Chunk
P3D.OldScenegraphDrawableP3DChunk = P3D.P3DChunk:newChildClass("Old Scenegraph Drawable")
function P3D.OldScenegraphDrawableP3DChunk:new(Data)
	local o = P3D.OldScenegraphDrawableP3DChunk.parentClass.new(self, Data)
	o.Name, o.DrawableName, o.IsTranslucent = unpack("<s1s1i", o.ValueStr)
	return o
end

function P3D.OldScenegraphDrawableP3DChunk:create(Name,DrawableName,IsTranslucent)
	local Len = 12 + Name:len() + 1 + DrawableName:len() + 1 + 4
	return P3D.OldScenegraphDrawableP3DChunk:new{Raw = pack("<IIIs1s1i", P3D.Identifiers.Old_Scenegraph_Drawable, Len, Len, Name, DrawableName, IsTranslucent)}
end

function P3D.OldScenegraphDrawableP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + self.DrawableName:len() + 1 + 4
	return pack("<IIIs1s1i", self.ChunkType, Len, Len + chunks:len(), self.Name, self.DrawableName, self.IsTranslucent) .. chunks
end

--Animation Group List Chunk
P3D.AnimationGroupListP3DChunk = P3D.P3DChunk:newChildClass("Animation Group List")
function P3D.AnimationGroupListP3DChunk:new(Data)
	local o = P3D.AnimationGroupListP3DChunk.parentClass.new(self, Data)
	o.Version, o.NumGroups = unpack("<ii", o.ValueStr)
	return o
end

function P3D.AnimationGroupListP3DChunk:create(Version)
	local Len = 12 + 4 + 4
	return P3D.AnimationGroupListP3DChunk:new{Raw = pack("<IIIii", P3D.Identifiers.Animation_Group_List, Len, Len, Version, 0)}
end

function P3D.AnimationGroupListP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + 4
	return pack("<IIIii", self.ChunkType, Len, Len + chunks:len(), self.Version, #self.Chunks) .. chunks
end

--Animation Group Chunk
P3D.AnimationGroupP3DChunk = P3D.P3DChunk:newChildClass("Animation Group")
function P3D.AnimationGroupP3DChunk:new(Data)
	local o = P3D.AnimationGroupP3DChunk.parentClass.new(self, Data)
	o.Version, o.Name, o.GroupId, o.NumChannels = unpack("<is1ii", o.ValueStr)
	return o
end

function P3D.AnimationGroupP3DChunk:create(Version,Name,GroupId)
	local Len = 12 + 4 + Name:len() + 1 + 4 + 4
	return P3D.AnimationGroupP3DChunk:new{Raw = pack("<IIIis1ii", P3D.Identifiers.Animation_Group, Len, Len, Version, Name, GroupId, 0)}
end

function P3D.AnimationGroupP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + self.Name:len() + 1 + 4 + 4
	return pack("<IIIis1ii", self.ChunkType, Len, Len + chunks:len(), self.Version, self.Name, self.GroupId, #self.Chunks) .. chunks
end

--Compressed Quaternion Channel Chunk
P3D.CompressedQuaternionChannelP3DChunk = P3D.P3DChunk:newChildClass("Compressed Quaternion Channel")
function P3D.CompressedQuaternionChannelP3DChunk:new(Data)
	local o = P3D.CompressedQuaternionChannelP3DChunk.parentClass.new(self, Data)
	o.Version, o.Param, o.NumFrames = unpack("<ic4i", o.ValueStr)
	local idx = 1 + 4 + 4 + 4
	o.Frames = {unpack("<" .. string.rep("h", o.NumFrames), o.ValueStr, idx)}
	o.Frames[#o.Frames] = nil
	idx = idx + o.NumFrames * 2
	o.Values = {}
	for i=1,o.NumFrames do
		local value = {X=0,Y=0,Z=0,W=0}
		value.W, value.X, value.Y, value.Z = unpack("<hhhh", o.ValueStr, idx)
		value.X = value.X / 32767
		value.Y = value.Y / 32767
		value.Z = value.Z / 32767
		value.W = value.W / 32767
		o.Values[#o.Values + 1] = value
		idx = idx + 8
	end
	return o
end

--TODO: Create

function P3D.CompressedQuaternionChannelP3DChunk:GetFrameCount()
	return #self.Frames
end

function P3D.CompressedQuaternionChannelP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local FramesN = self:GetFrameCount()
	local values = {}
	for i=1,FramesN do
		local value = self.Values[i]
		values[#values + 1] = pack("hhhh", math.floor(value.W * 32767), math.floor(value.X * 32767), math.floor(value.Y * 32767), math.floor(value.X * 32767))
	end
	local Len = 12 + 4 + 4 + 4 + FramesN * 2 + FramesN * 8
	return pack("<IIIic4i" .. string.rep("h", #self.Frames), self.ChunkType, Len, Len + chunks:len(), self.Version, self.Param, FramesN, table.unpack(self.Frames)) .. table.concat(values) .. chunks
end

--Follow Camera Data Chunk
P3D.FollowCameraDataP3DChunk = P3D.P3DChunk:newChildClass("Follow Camera Data")
function P3D.FollowCameraDataP3DChunk:new(Data)
	local o = P3D.FollowCameraDataP3DChunk.parentClass.new(self, Data)
	o.Look = {X=0,Y=0,Z=0}
	o.Index, o.Unknown, o.Angle, o.Distance, o.Look.X, o.Look.Y, o.Look.Z = unpack("<iffffff", o.ValueStr)
	return o
end

function P3D.FollowCameraDataP3DChunk:create(Index,Unknown,Angle,Distance,Look)
	local Len = 12 + 4 + 4 + 4 + 4 + 12
	return P3D.FollowCameraDataP3DChunk:new{Raw = pack("<IIIiffffff", P3D.Identifiers.Follow_Camera_Data, Len, Len, Index, Unknown, Angle, Distance, Look.X, Look.Y, Look.Z)}
end

function P3D.FollowCameraDataP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + 4 + 4 + 4 + 4 + 12
	return pack("<IIIiffffff", self.ChunkType, Len, Len + chunks:len(), self.Index, self.Unknown, self.Angle, self.Distance, self.Look.X, self.Look.Y, self.Look.Z) .. chunks
end

--Sprite Chunk
P3D.SpriteP3DChunk = P3D.P3DChunk:newChildClass("Sprite")
function P3D.SpriteP3DChunk:new(Data)
	local o = P3D.SpriteP3DChunk.parentClass.new(self, Data)
	o.Name, o.NativeX, o.NativeY, o.Shader, o.ImageWidth, o.ImageHeight, o.ImageCount, o.BlitBorder = unpack("<s1iis1iiii", o.ValueStr)
	return o
end

function P3D.SpriteP3DChunk:create(Name,NativeX,NativeY,Shader,ImageWidth,ImageHeight,ImageCount,BlitBorder)
	local Len = 12 + Name:len() + 1 + 4 + 4 + Shader:len() + 1 + 4 + 4 + 4 + 4
	return P3D.SpriteP3DChunk:new{Raw = pack("<IIIs1iis1iiii", P3D.Identifiers.Sprite, Len, Len, Name, NativeX, NativeY, Shader, ImageWidth, ImageHeight, ImageCount, BlitBorder)}
end

function P3D.SpriteP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + self.Shader:len() + 1 + 4 + 4 + 4 + 4
	return pack("<IIIs1iis1iiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.NativeX, self.NativeY, self.Shader, self.ImageWidth, self.ImageHeight, self.ImageCount, self.BlitBorder) .. chunks
end

function P3D.SpriteP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	P3D.SpriteP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == P3D.Identifiers.Image then
		self.ImageCount = self.ImageCount - 1
	end
end

function P3D.SpriteP3DChunk:AddChunk(ChunkData, idx)
	local _, ID = P3D.SpriteP3DChunk.parentClass.AddChunk(self, ChunkData, idx)
	if ID == P3D.Identifiers.Image then
		self.ImageCount = self.ImageCount + 1
	end
end

--Image Chunk
P3D.ImageP3DChunk = P3D.P3DChunk:newChildClass("Image")
P3D.ImageP3DChunk.Formats = {
	Raw = 0,
	PNG = 1,
	TGA = 2,
	BMP = 3,
	IPU = 4,
	DXT = 5,
	DXT1 = 6,
	DXT2 = 7,
	DXT3 = 8,
	DXT4 = 9,
	DXT5 = 10,
	PS24Bit = 11,
	PS28Bit = 12,
	PS216Bit = 13,
	PS232Bit = 14,
	GC4Bit = 15,
	GC8Bit = 16,
	GC16Bit = 17,
	GC32Bit = 18,
	GCDXT1 = 19,
	Other = 20,
	Invalid = 21,
	PSP4Bit = 25,
}
function P3D.ImageP3DChunk:new(Data)
	local o = P3D.ImageP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.Width, o.Height, o.Bpp, o.Palettized, o.HasAlpha, o.Format = unpack("<s1iiiiiii", o.ValueStr)
	return o
end

function P3D.ImageP3DChunk:create(Name,Version,Width,Height,Bpp,Palettized,HasAlpha,Format)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return P3D.ImageP3DChunk:new{Raw = pack("<IIIs1iiiiiii", P3D.Identifiers.Image, Len, Len, Name, Version, Width, Height, Bpp, Palettized, HasAlpha, Format)}
end

function P3D.ImageP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiiiiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Width, self.Height, self.Bpp, self.Palettized, self.HasAlpha, self.Format) .. chunks
end

--Image Data Chunk
P3D.ImageDataP3DChunk = P3D.P3DChunk:newChildClass("Image Data")
function P3D.ImageDataP3DChunk:new(Data)
	local o = P3D.ImageDataP3DChunk.parentClass.new(self, Data)
	o.ImageDataSize = unpack("<i", o.ValueStr)
	o.ImageData = unpack("<c" .. o.ImageDataSize, o.ValueStr, 5)
	return o
end

function P3D.ImageDataP3DChunk:create(ImageData)
	local ImageDataSize = ImageData:len()
	local Len = 12 + 4 + ImageDataSize
	return P3D.ImageDataP3DChunk:new{Raw = pack("<IIIic" .. ImageDataSize, P3D.Identifiers.Image_Data, Len, Len, ImageDataSize, ImageData)}
end

function P3D.ImageDataP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local ImageDataSize = self.ImageData:len()
	local Len = 12 + 4 + ImageDataSize
	return pack("<IIIic" .. ImageDataSize, self.ChunkType, Len, Len + chunks:len(), ImageDataSize, self.ImageData) .. chunks
end

--Frontend Text Bible Chunk
P3D.FrontendTextBibleP3DChunk = P3D.P3DChunk:newChildClass("Frontend Text Bible")
function P3D.FrontendTextBibleP3DChunk:new(Data)
	local o = P3D.FrontendTextBibleP3DChunk.parentClass.new(self, Data)
	o.Name, o.NumLanguages, o.Languages = unpack("<s1is1", o.ValueStr)
	return o
end

--TODO: Handle create and addition/removal of languages

function P3D.FrontendTextBibleP3DChunk:GetLanguageCount()
	local LanguageN = 0
	for i=1,#self.ChunkTypes do
		if self.ChunkTypes[i] == P3D.Identifiers.Frontend_Language then
			LanguageN = LanguageN + 1
		end
	end
	return LanguageN
end

function P3D.FrontendTextBibleP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + self.Languages:len() + 1
	return pack("<IIIs1is1", self.ChunkType, Len, Len + chunks:len(), self.Name, self:GetLanguageCount(), self.Languages) .. chunks
end

--Frontend Language Chunk
P3D.FrontendLanguageP3DChunk = P3D.P3DChunk:newChildClass("Frontend Language")
function P3D.FrontendLanguageP3DChunk:new(Data)
	local o = P3D.FrontendLanguageP3DChunk.parentClass.new(self, Data)
	o.Name, o.Language, o.NumEntries, o.Modulo, o.BufferSize = unpack("<s1c1iii", o.ValueStr)
	local idx = 1 + o.Name:len() + 1 + 1 + 4 + 4 + 4
	o.Hashes = {unpack("<" .. string.rep("I", o.NumEntries), o.ValueStr, idx)}
	o.Hashes[#o.Hashes] = nil
	idx = idx + 4 * o.NumEntries
	o.Offsets = {unpack("<" .. string.rep("I", o.NumEntries), o.ValueStr, idx)}
	o.Offsets[#o.Offsets] = nil
	idx = idx + 4 * o.NumEntries
	o.Buffer = unpack("<c" .. o.BufferSize, o.ValueStr, idx)
	return o
end

function P3D.FrontendLanguageP3DChunk:GetValueFromHash(Hash)
	local index = nil
	for i=1,#self.Hashes do
		if self.Hashes[i] == Hash then
			index = i
			break
		end
	end
	if not index then return nil end
	local out = {}
	for i=self.Offsets[index] + 1,#self.Buffer,2 do
		local s = unpack("<H", self.Buffer, i)
		if s == 0 then break end
		out[#out + 1] = s
	end
	return utf8.char(table.unpack(out))
end

function P3D.FrontendLanguageP3DChunk:GetValueFromName(Name)
	local Hash = self:GetNameHash(Name)
	return self:GetValueFromHash(Hash)
end

function P3D.FrontendLanguageP3DChunk:GetNameHash(Name)
	local Hash = 0
	local chars = {unpack("<" .. string.rep("B", #Name), Name)}
	for i=1,#Name do
		local c = chars[i]
		Hash = (c + (Hash << 6)) % self.Modulo
	end
	return Hash
end

function P3D.FrontendLanguageP3DChunk:AddValue(Name, String)
	local ucs2 = {}
	for p,c in utf8.codes(String) do
		if c == 0 then break end
		ucs2[#ucs2 + 1] = c
	end
	ucs2[#ucs2 + 1] = 0
	String = pack("<" .. string.rep("H", #ucs2), table.unpack(ucs2))
	self.Hashes[#self.Hashes + 1] = self:GetNameHash(Name)
	self.Offsets[#self.Offsets + 1] = #self.Buffer
	self.Buffer = self.Buffer .. String
end
--TODO: Handle create, handle remove, handle insert, handle edit, handle bulk add

function P3D.FrontendLanguageP3DChunk:GetEntryCount()
	return #self.Hashes
end

function P3D.FrontendLanguageP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local EntriesN = self:GetEntryCount()
	local BufferSize = self.Buffer:len()
	local Len = 12 + self.Name:len() + 1 + 1 + 4 + 4 + 4 + 4 * EntriesN + 4 * EntriesN + BufferSize
	local output = {}
	output[1] = pack("<IIIs1c1iii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Language, EntriesN, self.Modulo, BufferSize)
	output[2] = pack("<" .. string.rep("I", EntriesN), table.unpack(self.Hashes))
	output[3] = pack("<" .. string.rep("I", EntriesN), table.unpack(self.Offsets))
	output[4] = pack("<c" .. BufferSize, self.Buffer)
	output[5] = chunks
	return table.concat(output)
end

--Trigger Volume Chunk
P3D.TriggerVolumeP3DChunk = P3D.P3DChunk:newChildClass("Trigger Volume")
function P3D.TriggerVolumeP3DChunk:new(Data)
	local o = P3D.TriggerVolumeP3DChunk.parentClass.new(self, Data)
	o.HalfExtents = {X=0,Y=0,Z=0}
	o.Matrix = P3D.MatrixIdentity()
	o.Name, o.IsRect, o.HalfExtents.X, o.HalfExtents.Y, o.HalfExtents.Z, o.Matrix.M11, o.Matrix.M12, o.Matrix.M13, o.Matrix.M14, o.Matrix.M21, o.Matrix.M22, o.Matrix.M23, o.Matrix.M34, o.Matrix.M31, o.Matrix.M32, o.Matrix.M33, o.Matrix.M34, o.Matrix.M41, o.Matrix.M42, o.Matrix.M43, o.Matrix.M44 = unpack("<s1ifffffffffffffffffff", o.ValueStr)
	return o
end

function P3D.TriggerVolumeP3DChunk:create(Name,IsRect,HalfExtents,Matrix)
	local Len = 12 + Name:len() + 1 + 4 + 12 + 64
	return P3D.TriggerVolumeP3DChunk:new{Raw = pack("<IIIs1ifffffffffffffffffff", P3D.Identifiers.Trigger_Volume, Len, Len, Name, IsRect, HalfExtents.X, HalfExtents.Y, HalfExtents.Z, Matrix.M11, Matrix.M12, Matrix.M13, Matrix.M14, Matrix.M21, Matrix.M22, Matrix.M23, Matrix.M34, Matrix.M31, Matrix.M32, Matrix.M33, Matrix.M34, Matrix.M41, Matrix.M42, Matrix.M43, Matrix.M44)}
end

function P3D.TriggerVolumeP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 12 + 64
	return pack("<IIIs1ifffffffffffffffffff", self.ChunkType, Len, Len + chunks:len(), self.Name, self.IsRect, self.HalfExtents.X, self.HalfExtents.Y, self.HalfExtents.Z, self.Matrix.M11, self.Matrix.M12, self.Matrix.M13, self.Matrix.M14, self.Matrix.M21, self.Matrix.M22, self.Matrix.M23, self.Matrix.M34, self.Matrix.M31, self.Matrix.M32, self.Matrix.M33, self.Matrix.M34, self.Matrix.M41, self.Matrix.M42, self.Matrix.M43, self.Matrix.M44) .. chunks
end

--Frontend Project Chunk
P3D.FrontendProjectP3DChunk = P3D.P3DChunk:newChildClass("Frontend Project")
function P3D.FrontendProjectP3DChunk:new(Data)
	local o = P3D.FrontendProjectP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.ResolutionX, o.ResolutionY, o.Platform, o.PagePath, o.ResourcePath, o.ScreenPath = unpack("<s1iiis1s1s1s1", o.ValueStr)
	return o
end

function P3D.FrontendProjectP3DChunk:create(Name,Version,ResolutionX,ResolutionY,Platform,PagePath,ResourcePath,ScreenPath)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + Platform:len() + 1 + PagePath:len() + 1 + ResourcePath:len() + 1 + ScreenPath:len() + 1
	return P3D.FrontendProjectP3DChunk:new{Raw = pack("<IIIs1iiis1s1s1s1", P3D.Identifiers.Frontend_Project, Len, Len, Name, Version, ResolutionX, ResolutionY, Platform, PagePath, ResourcePath, ScreenPath)}
end

function P3D.FrontendProjectP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + self.Platform:len() + 1 + self.PagePath:len() + 1 + self.ResourcePath:len() + 1 + self.ScreenPath:len() + 1
	return pack("<IIIs1iiis1s1s1s1", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.ResolutionX, self.ResolutionY, self.Platform, self.PagePath, self.ResourcePath, self.ScreenPath) .. chunks
end

--Frontend Page Chunk
P3D.FrontendPageP3DChunk = P3D.P3DChunk:newChildClass("Frontend Page")
function P3D.FrontendPageP3DChunk:new(Data)
	local o = P3D.FrontendPageP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.ResolutionX, o.ResolutionY = unpack("<s1iii", o.ValueStr)
	return o
end

function P3D.FrontendPageP3DChunk:create(Name,Version,ResolutionX,ResolutionY)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4
	return P3D.FrontendPageP3DChunk:new{Raw = pack("<IIIs1iii", P3D.Identifiers.Frontend_Page, Len, Len, Name, Version, ResolutionX, ResolutionY)}
end

function P3D.FrontendPageP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4
	return pack("<IIIs1iii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.ResolutionX, self.ResolutionY) .. chunks
end

--Frontend Layer Chunk
P3D.FrontendLayerP3DChunk = P3D.P3DChunk:newChildClass("Frontend Layer")
function P3D.FrontendLayerP3DChunk:new(Data)
	local o = P3D.FrontendLayerP3DChunk.parentClass.new(self, Data)
	o.Name, o.Version, o.Visible, o.Editable, o.Alpha = unpack("<s1iiii", o.ValueStr)
	return o
end

function P3D.FrontendLayerP3DChunk:create(Name,Version,Visible,Editable,Alpha)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4
	return P3D.FrontendLayerP3DChunk:new{Raw = pack("<IIIs1iiii", P3D.Identifiers.Frontend_Layer, Len, Len, Name, Version, Visible, Editable, Alpha)}
end

function P3D.FrontendLayerP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.Visible, self.Editable, self.Alpha) .. chunks
end

--Frontend Multi Text Chunk
P3D.FrontendMultiTextP3DChunk = P3D.P3DChunk:newChildClass("Frontend Multi Text")
P3D.FrontendMultiTextP3DChunk.Justifications = {
	Left = 0,
	Right = 1,
	Top = 2,
	Bottom = 3,
	Centre = 4,
}
function P3D.FrontendMultiTextP3DChunk:new(Data)
	local o = P3D.FrontendMultiTextP3DChunk.parentClass.new(self, Data)
	o.Colour = {A=0,R=0,G=0,B=0}
	o.ShadowColour = {A=0,R=0,G=0,B=0}
	o.Name, o.Version, o.PositionX, o.PositionY, o.DimensionX, o.DimensionY, o.JustificationX, o.JustificationY, o.Colour.B, o.Colour.G, o.Colour.R, o.Colour.A, o.Translucency, o.RotationValue, o.TextStyleName, o.ShadowEnabled, o.ShadowColour.B, o.ShadowColour.G, o.ShadowColour.R, o.ShadowColour.A, o.ShadowOffsetX, o.ShadowOffsetY, o.CurrentText = unpack("<s1iiiiiiiBBBBifs1BBBBBiii", o.ValueStr)
	return o
end

function P3D.FrontendMultiTextP3DChunk:create(Name,Version,PositionX,PositionY,DimensionX,DimensionY,JustificationX,JustificationY,Colour,Translucency,RotationValue,TextStyleName,ShadowEnabled,ShadowColour,ShadowOffsetX,ShadowOffsetY,CurrentText)
	local Len = 12 + Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + TextStyleName:len() + 1 + 1 + 4 + 4 + 4 + 4
	return P3D.FrontendMultiTextP3DChunk:new{Raw = pack("<IIIs1iiiiiiiBBBBifs1BBBBBiii", P3D.Identifiers.Frontend_Multi_Text, Len, Len, Name, Version, PositionX, PositionY, DimensionX, DimensionY, JustificationX, JustificationY, Colour.B, Colour.G, Colour.R, Colour.A, Translucency, RotationValue, TextStyleName, ShadowEnabled, ShadowColour.B, ShadowColour.G, ShadowColour.R, ShadowColour.A, ShadowOffsetX, ShadowOffsetY, CurrentText)}
end

function P3D.FrontendMultiTextP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.Name:len() + 1 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + self.TextStyleName:len() + 1 + 1 + 4 + 4 + 4 + 4
	return pack("<IIIs1iiiiiiiBBBBifs1BBBBBiii", self.ChunkType, Len, Len + chunks:len(), self.Name, self.Version, self.PositionX, self.PositionY, self.DimensionX, self.DimensionY, self.JustificationX, self.JustificationY, self.Colour.B, self.Colour.G, self.Colour.R, self.Colour.A, self.Translucency, self.RotationValue, self.TextStyleName, self.ShadowEnabled, self.ShadowColour.B, self.ShadowColour.G, self.ShadowColour.R, self.ShadowColour.A, self.ShadowOffsetX, self.ShadowOffsetY, self.CurrentText) .. chunks
end

--Frontend String Text Bible Chunk
P3D.FrontendStringTextBibleP3DChunk = P3D.P3DChunk:newChildClass("Frontend String Text Bible")
function P3D.FrontendStringTextBibleP3DChunk:new(Data)
	local o = P3D.FrontendStringTextBibleP3DChunk.parentClass.new(self, Data)
	o.BibleName, o.StringId = unpack("<s1s1", o.ValueStr)
	return o
end

function P3D.FrontendStringTextBibleP3DChunk:create(BibleName,StringId)
	local Len = 12 + BibleName:len() + 1 + StringId:len() + 1
	return P3D.FrontendStringTextBibleP3DChunk:new{Raw = pack("<IIIs1s1", P3D.Identifiers.Frontend_String_Text_Bible, Len, Len, BibleName, StringId)}
end

function P3D.FrontendStringTextBibleP3DChunk:Output()
	local chunks = table.concat(self.Chunks)
	local Len = 12 + self.BibleName:len() + 1 + self.StringId:len() + 1
	return pack("<IIIs1s1", self.ChunkType, Len, Len + chunks:len(), self.BibleName, self.StringId) .. chunks
end