import struct CLIHelpers.Argument

public enum SelectCommandLineArguments {
    static var searchPath: Argument {
        return Argument(name: "searchPath")
    }
    
    static var printVersions: Argument {
        return Argument(name: "printVersions")
    }
}
