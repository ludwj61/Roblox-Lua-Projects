local part = game.Workspace.testPart
part.Transparency = 0.7
part.Material = Enum.Material.Sand
part.Color = Color3.fromRGB(0, 0 ,0)

function doSomething()
    print("did something")
end

doSomething()

local part2 = game.Workspace["A Part"]
part2.Color = Color3.fromRGB(255, 0 , 0)