-- CAR LIST
RandomCarPool = {
	"ambul",
	"apu_v",
	"atv_v",
	"bart_v",
	"bbman_v",
	"bookb_v",
	"burns_v",
	"burnsarm",
	"carhom_v",
	"cArmor",
	"cBlbart",
	"cBone",
	"cCellA",
	"cCellB",
	"cCellC",
	"cCellD",
	"cCola",
	"cCube",
	"cCurator",
	"cDonut",
	"cDuff",
	"cFire_v",
	"cHears",
	"cKlimo",
	"cletu_v",
	"cLimo",
	"cMilk",
	"cNerd",
	"cNonup",
	"coffin",
	"comic_v",
	"compactA",
	"cPolice",
	"cSedan",
	"cVan",
	"dune_v",
	"elect_v",
	"famil_v",
	"fishtruc",
	"fone_v",
	"frink_v",
	"garbage",
	"glastruc",
	"gramp_v",
	"gramR_v",
	"hallo",
	"hbike_v",
	"homer_v",
	"honor_v",
	"hype_v",
	"icecream",
	"IStruck",
	"knigh_v",
	"krust_v",
	"lisa_v",
	"marge_v",
	"minivanA",
	"moe_v",
	"mono_v",
	"mrplo_v",
	"nuctruck",
	"oblit_v",
	"otto_v",
	"pickupA",
	"pizza",
	"plowk_v",
	"redbrick",
	"rocke_v",
	"schoolbu",
	"scorp_v",
	"sedanA",
	"sedanB",
	"ship",
	"skinn_v",
	"smith_v",
	"snake_v",
	"sportsA",
	"sportsB",
	"SUVA",
	"taxiA",
	"tt",
	"votetruc",
	"wagonA",
	"wiggu_v",
	"willi_v",
	"witchcar",
	"zombi_v",
	"huskA"
}

CustomCarPool = {}
CustomCarSounds = {}

RandomCarPoolPlayer = {table.unpack(RandomCarPool)}
for i = #RandomCarPoolPlayer, 1, -1 do
	if not GetSetting(RandomCarPoolPlayer[i] .. "Player") then
		table.remove(RandomCarPoolPlayer, i)
	end
end
RandomCarPoolTraffic = {table.unpack(RandomCarPool)}
for i = #RandomCarPoolTraffic, 1, -1 do
	if not GetSetting(RandomCarPoolTraffic[i] .. "Traffic") then
		table.remove(RandomCarPoolTraffic, i)
	end
end
RandomCarPoolMission = {table.unpack(RandomCarPool)}
for i = #RandomCarPoolMission, 1, -1 do
	if not GetSetting(RandomCarPoolMission[i] .. "Mission") then
		table.remove(RandomCarPoolMission, i)
	end
end
RandomCarPoolChase = {table.unpack(RandomCarPool)}
for i = #RandomCarPoolChase, 1, -1 do
	if not GetSetting(RandomCarPoolChase[i] .. "Chase") then
		table.remove(RandomCarPoolChase, i)
	end
end

-- DRIVER LIST
CarDrivers = {}
CarDrivers["apu"] = {"apu_v"}
CarDrivers["bart"] = {"bart_v", "honor_v"}
CarDrivers["cletus"] = {"cletu_v"}
CarDrivers["cbg"] = {"comic_v"}
CarDrivers["lisa"] = {"elect_v", "lisa_v"}
CarDrivers["homer"] = {"famil_v", "homer_v"}
CarDrivers["frink"] = {"frink_v"}
CarDrivers["grandpa"] = {"gramp_v", "gramR_v"}
CarDrivers["marge"] = {"marge_v"}
CarDrivers["otto"] = {"otto_v"}
CarDrivers["skinner"] = {"skinn_m1", "skinn_v"}
CarDrivers["smithers"] = {"smith_v"}
CarDrivers["snake"] = {"snake_v"}
CarDrivers["wiggum"] = {"wiggu_v"}
CarDrivers["zmale1"] = {"zombi_v"}

-- PED LIST
RandomPedPool = {
	"apu",
	"askinner",
	"a_american", 
	"a_army",  
	"a_besharp", 
	"barney",  
	"bart",  
	"beeman",  
	"boy1", 
	"boy2", 
	"boy3", 
	"boy4", 
	"brn_unf", 
	"bum", 
	"burns", 
	"busm1", 
	"busm2",  
	"busw1", 
	"b_football", 
	"b_hugo", 
	"b_man",  
	"b_military", 
	"b_ninja", 
	"b_tall", 
	"captain", 
	"carl", 
	"cbg", 
	"cletus", 
	"const1", 
	"const2", 
	"dolph", 
	--"eddie", 
	"farmr1", 
	"fem1", 
	"fem2", 
	"fem3", 
	"fem4", 
	"frankenstein", 
	"frink", 
	"gil", 
	"girl1", 
	"girl2", 
	"girl3", 
	"girl4", 
	--"grandpa", 
	"hibbert", 
	"homer", 
	"hooker", 
	"h_donut", 
	"h_evil", 
	"h_fat", 
	"h_scuzzy", 
	"h_stcrobe", 
	"h_undrwr", 
	"jasper", 
	"jimbo", 
	"joger1", 
	"joger2", 
	"kearney", 
	--"krusty", 
	--"lenny", 
	"lisa", 
	"louie", 
	"lou", 
	"l_cool", 
	"l_florida", 
	"l_jersey", 
	"male1", 
	"male2", 
	"male3", 
	"male4", 
	"male5", 
	"male6", 
	"marge", 
	"milhouse", 
	"mobstr", 
	--"moe", 
	--"moleman", 
	"m_pink", 
	"m_police", 
	"m_prison", 
	"ned", 
	"nelson", 
	"nriviera", 
	"nuclear", 
	"olady1", 
	"olady2", 
	"olady3", 
	"otto", 
	--"patty", 
	--"ralph", 
	"rednk1", 
	"rednk2", 
	"sail1", 
	"sail2", 
	"sail3", 
	"sail4", 
	"selma", 
	"skinner", 
	"smithers", 
	"snake", 
	"teen", 
	"wiggum", 
	--"willie", 
	"witch", 
	"zfem1", 
	"zfem5", 
	"zmale1",  
	"zmale3", 
	"zmale4"
}

-- Char P3D List
RandomCharP3DPool = {
	"apu_m",
	"askinn_m",
	"a_amer_m",
	"a_army_m",
	"a_besh_m",
	"barney_m",
	"bart_m",
	"beeman_m",
	"boy1_m",
	"boy2_m",
	"boy3_m",
	"boy4_m",
	"brn_un_m",
	"bum_m",
	"burns_m",
	"busm1_m",
	"busm2_m",
	"busw1_m",
	"b_foot_m",
	"b_hugo_m",
	"b_man_m",
	"b_mili_m",
	"b_ninj_m",
	"b_tall_m",
	"captai_m",
	"carl_m",
	"cbg_m",
	"cletus_m",
	"const1_m",
	"const2_m",
	"dolph_m",
	"eddie_m",
	"farmr1_m",
	"fem1_m",
	"fem2_m",
	"fem3_m",
	"fem4_m",
	"franke_m",
	"frink_m",
	"gil_m",
	"girl1_m",
	"girl2_m",
	"girl3_m",
	"girl4_m",
	"grandp_m",
	"hibber_m",
	"homer_m",
	"hooker_m",
	"h_donu_m",
	"h_evil_m",
	"h_fat_m",
	"h_scuz_m",
	"h_stcr_m",
	"h_undr_m",
	"jasper_m",
	"jimbo_m",
	"joger1_m",
	"joger2_m",
	"kearne_m",
	"krusty_m",
	"lenny_m",
	"lisa_m",
	"louie_m",
	"lou_m",
	"l_cool_m",
	"l_flor_m",
	"l_jers_m",
	"male1_m",
	"male2_m",
	"male3_m",
	"male4_m",
	"male5_m",
	"male6_m",
	"marge_m",
	"milhou_m",
	"mobstr_m",
	"moe_m",
	"molema_m",
	"m_pink_m",
	"m_poli_m",
	"m_pris_m",
	"ned_m",
	"nelson_m",
	"nrivie_m",
	"nuclea_m",
	"olady1_m",
	"olady2_m",
	"olady3_m",
	"otto_m",
	"patty_m",
	"ralph_m",
	"rednk1_m",
	"rednk2_m",
	"sail1_m",
	"sail2_m",
	"sail3_m",
	"sail4_m",
	"selma_m",
	"skinne_m",
	"smithe_m",
	"snake_m",
	"teen_m",
	"wiggum_m",
	"willie_m",
	"witch_m",
	"zfem1_m",
	"zfem5_m",
	"zmale1_m",
	"zmale3_m",
	"zmale4_m"
}

RandomDialoguePool = {}

--Level interiors
l1interiors = {
	"00",
	"01",
	"02",
}

l2interiors = {
	"03",
	"04"
}

l3interiors = {
	"05",
	"06"
}

l4interiors = {
	"00",
	"01",
	"07"
}

l5interiors = {
	"03",
	"04"
}

l6interiors = {
	"05",
	"06"
}

l7interiors = {
	"00",
	"01",
	"07"
}

interiorReplace = {}

-- Random Stats Saving
PlayerStats = {}
