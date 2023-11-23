--!strict

local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

local remodel = require("./remodel")

local MAX_TRIES: number = 5

local placeIds: {[string]: {number}?} = net.jsonDecode(fs.readFile("place_ids.json"))

local function attempt<T>(id: number, callback: () -> T): T?
	for count: number = 1, MAX_TRIES do
		print(`Attempt {count}/{MAX_TRIES}`)

		local result: T
		local success: boolean, errorMessage: string | T = pcall(function()
			result = callback()
		end)
		if success then
			return result
		end

		warn(`Failed due to reason:\n{errorMessage}`)
	end

	warn(`Id {id} was skipped due to running out of attempts`)
	return nil
end

local identifier: string = process.args[1] or "default"
if string.sub(identifier, 1, 1) == "-" then
	identifier = "default"
end

local idArray: {number}? = placeIds[identifier]
if not idArray then
	error(`No place id list found for {identifier}`)
end

print(`Publishing the following ids: {table.concat(idArray, ", ")}`)

local failedIds: {number} = {}
for _, id: number in ipairs(idArray) do
	print("\n")
	print(`Beginning id {id}`)

	print("\n")
	print("Retrieving current saved version")
	local savedVersion: remodel.LuneDataModel? = attempt(id, function(): remodel.LuneDataModel
		return remodel.readPlaceAsset(id)
	end)

	if not savedVersion then
		table.insert(failedIds, id)
		continue
	end

	print("\n")
	print("Publishing retrieved version")
	local publishSuccess: boolean? = attempt(id, function(): boolean
		remodel.writeExistingPlaceAsset(savedVersion, id)
		return true
	end)

	if not publishSuccess then
		table.insert(failedIds, id)
		continue
	end

	print("\n")
	print(`Successfully published id {id}`)
end

if failedIds[1] then
	print("\n")
	warn(`Could not publish the following ids: {table.concat(failedIds, ", ")}`)
else
	print("\n")
	print("Successfully published all ids")
end