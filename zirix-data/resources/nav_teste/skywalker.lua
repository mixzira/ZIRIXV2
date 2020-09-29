local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

nav = {}
Tunnel.bindInterface("nav_teste",nav)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local gunsList = {
    { itemIndex = "wbody|WEAPON_PISTOL", itemIndexX = "pt92af", itemName = "PT92AF", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 5, ingredientFive = "maquininha", ingredientFiveAmount = 4 },
    { itemIndex = "wbody|WEAPON_SMG", itemIndexX = "mp5", itemName = "MP5", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 4, ingredientFive = "maquininha", ingredientFiveAmount = 4 },
    { itemIndex = "wbody|WEAPON_SMG", itemIndexX = "mp5", itemName = "MP5", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 4, ingredientFive = "maquininha", ingredientFiveAmount = 4 }
}

local gunsListTwo = {
    { itemIndex = "wbody|WEAPON_PISTOL_MK2", itemIndexX = "czp09", itemName = "CZ P-09", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 5, ingredientFive = "maquininha", ingredientFiveAmount = 4 },
    { itemIndex = "wbody|WEAPON_ASSAULTSMG", itemIndexX = "p90", itemName = "P90", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 4, ingredientFive = "maquininha", ingredientFiveAmount = 4 },
    { itemIndex = "wbody|WEAPON_ASSAULTSMG", itemIndexX = "p90", itemName = "P90", ingredientOne = "mochila", ingredientOneAmount = 1, ingredientTwo = "celular", ingredientTwoAmount = 2, ingredientThree = "cartao-debito", ingredientThreeAmount = 3, ingredientFour = "radio", ingredientFourAmount = 4, ingredientFive = "maquininha", ingredientFiveAmount = 4 },
}

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function nav.openNav()
	local source = source
    local user_id = vRP.getUserId(source)
    local guns = {}
    local gunsTwo = {}

	if user_id then
        for k,v in pairs(gunsList) do
            table.insert(guns, { index = v.itemIndex, anotherindex = v.itemIndexX, name = v.itemName, ingrOne = v.ingredientOne, ingrOneAmount = parseInt(v.ingredientOneAmount), ingrTwo = v.ingredientTwo, ingrTwoAmount = parseInt(v.ingredientTwoAmount), ingrThree = v.ingredientThree, ingrThreeAmount = parseInt(v.ingredientThreeAmount), ingrFour = v.ingredientFour, ingrFourAmount = parseInt(v.ingredientFourAmount), ingrFive = v.ingredientFive, ingrFiveAmount = parseInt(v.ingredientFiveAmount) })
        end

        for k,v in pairs(gunsListTwo) do
            table.insert(gunsTwo, { index = v.itemIndex, anotherindex = v.itemIndexX, name = v.itemName, ingrOne = v.ingredientOne, ingrOneAmount = parseInt(v.ingredientOneAmount), ingrTwo = v.ingredientTwo, ingrTwoAmount = parseInt(v.ingredientTwoAmount), ingrThree = v.ingredientThree, ingrThreeAmount = parseInt(v.ingredientThreeAmount), ingrFour = v.ingredientFour, ingrFourAmount = parseInt(v.ingredientFourAmount), ingrFive = v.ingredientFive, ingrFiveAmount = parseInt(v.ingredientFiveAmount) })
        end
        return guns, gunsTwo
	end
end