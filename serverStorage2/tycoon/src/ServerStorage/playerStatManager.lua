-- Set up table to return to any script that requires this module script
local PlayerStatManager = {}

local DataStoreService = game:GetService("DataStoreService")
local playerData = DataStoreService:GetDataStore("PlayerData")

-- Table to hold player information for the current session
local sessionData = {}

local AUTOSAVE_INTERVAL = 60

-- Function that other scripts can call to change a player's stats
function PlayerStatManager.ChangeStat(player, statName, value)
    local playerUserId = "Player_" .. player.UserId
    assert(typeof(sessionData[playerUserId][statName]) == typeof(value),
           "ChangeStat error: types do not match")
    if typeof(sessionData[playerUserId][statName]) == "number" then
        sessionData[playerUserId][statName] =
            sessionData[playerUserId][statName] + value
    else
        sessionData[playerUserId][statName] = value
    end
end

function PlayerStatManager.GetStat(player, statName)
    local playerUserId = "Player_" .. player.UserId
    return sessionData[playerUserId][statName]
end

-- Function to add player to the "sessionData" table
local function setupPlayerData(player)
    local playerUserId = "Player_" .. player.UserId
    local data = playerData:GetAsync(playerUserId)
    if data then
        -- Data exists for this player
        sessionData[playerUserId] = data
    else
        -- Data store is working, but no current data for this player
        sessionData[playerUserId] = {Money = 0, Experience = 0}
    end
end

local function savePlayerData(playerUserId)
    if sessionData[playerUserId] then
        playerData:SetAsync(playerUserId, sessionData[playerUserId])
    end
end

-- Function to periodically save player data
local function autoSave()
    while wait(AUTOSAVE_INTERVAL) do
        for playerUserId, _ in pairs(sessionData) do
            savePlayerData(playerUserId)
        end
    end
end

-- Start running "autoSave()" function in the background
spawn(autoSave)

-- Function to save player data on exit
local function saveOnExit(player)
    local playerUserId = "Player_" .. player.UserId
    savePlayerData(playerUserId)
end

function PlayerStatManager.ManualSave(player)
    local playerUserId = "Player_" .. player.UserId
    savePlayerData(playerUserId)
end

-- Connect "setupPlayerData()" function to "PlayerAdded" event
game.Players.PlayerAdded:Connect(setupPlayerData)

-- Connect "saveOnExit()" function to "PlayerRemoving" event
game.Players.PlayerRemoving:Connect(saveOnExit)

return PlayerStatManager
