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
	"zombi_v"
}

-- PED LIST
RandomPedPool = {
    "apu",
    "askinn",
    "a_amer",
    "a_army",
    "a_besh",
    "barney",
    "bart",
    "beeman",
    "boy1",
    "boy2",
    "boy3",
    "boy4",
    "brn_un",
    "bum",
    "burns",
    "busm1",
    "busm2",
    "busw1",
    "b_foot",
    "b_hugo",
    "b_man",
    "b_mili",
    "b_ninj",
    "b_tall",
    "captai",
    "carl",
    "cbg",
    "cletus",
    "const1",
    "const2",
    "dolph",
    "eddie",
    "farmr1",
    "fem1",
    "fem2",
    "fem3",
    "fem4",
    "franke",
    "frink",
    "gil",
    "girl1",
    "girl2",
    "girl3",
    "girl4",
    "grandp",
    "hibber",
    "homer",
    "hooker",
    "h_donu",
    "h_evil",
    "h_fat",
    "h_scuz",
    "h_stcr",
    "h_undr",
    "jasper",
    "jimbo",
    "joger1",
    "joger2",
    "kearne",
    "krusty",
    "lenny",
    "lisa",
    "louie",
    "lou",
    "l_cool",
    "l_flor",
    "l_jers",
    "male1",
    "male2",
    "male3",
    "male4",
    "male5",
    "male6",
    "marge",
    "milhou",
    "mobstr",
    "moe",
    "molema",
    "m_pink",
    "m_poli",
    "m_pris",
    "ned",
    "nelson",
    "nrivie",
    "nuclea",
    "olady1",
    "olady2",
    "olady3",
    "otto",
    "patty",
    "ralph",
    "rednk1",
    "rednk2",
    "sail1",
    "sail2",
    "sail3",
    "sail4",
    "selma",
    "skinne",
    "smithe",
    "snake",
    "teen",
    "wiggum",
    "willie",
    "witch",
    "zfem1",
    "zfem5",
    "zmale1",
    "zmale3",
    "zmale4"
}

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

-- CHAR LIST
RandomCharPool = {
	"apu",
	"bart",
	"homer",
	"lisa",
	"marge"
}

OrigChar = nil
RandomChar = nil
RandomCar = nil
RandomCarName = nil
LastLevel = nil
LastLevelMV = nil
RandomChase = nil
TrafficCars = {}
MissionVehicles = {}

-- Add the husk unless disabled
if not GetSetting("NoHusk") then
	table.insert(RandomCarPool, "huskA")
end

-- Count number of random cars
RandomCarPoolN = #RandomCarPool
RandomPedPoolN = #RandomPedPool

print("Random Cars: Using " .. RandomCarPoolN .. " cars")
print("Random Cars: Using " .. RandomPedPoolN .. " pedestrians")