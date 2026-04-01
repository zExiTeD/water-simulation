function GenerateBuildCommand(
    optimization,
    buildPath,
    debugBuild,
    exeName
)
    local path = string.format("%s\\%s", buildPath, exeName)

    local debugFlag = debugBuild and "-debug" or ""

    local command = string.format(
        "odin build src -out:%s -o:%s %s",
        path,
        optimization,
        debugFlag
    )

    return command
end

local cmdArg = arg[1] and string.lower(arg[1])

if cmdArg == "build" then
    print("Compiling...")
    local cmd = GenerateBuildCommand("speed", "odin-out", false, "main.exe")
    os.execute(cmd)
    print("Compilation finished...")
elseif cmdArg == "run" then
    print("Running main.exe...")
    os.execute(".\\odin-out\\main.exe")
    print("Stopped...")
end
