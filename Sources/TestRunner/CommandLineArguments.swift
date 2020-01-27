import struct CLIHelpers.Argument

public enum CommandLineArguments {
    static var platform: Argument {
        return Argument(name: "platform")
    }
    
    static var version: Argument {
        return Argument(name: "version", shortName: "v")
    }
    
    static var project: Argument {
        return Argument(name: "project")
    }
    
    static var scheme: Argument {
        return Argument(name: "scheme", shortName: "s")
    }
}
