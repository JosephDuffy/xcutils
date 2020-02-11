import class TSCUtility.ArgumentParser
import class TSCUtility.ArgumentBinder
import struct TSCBasic.AbsolutePath
import struct TSCUtility.PathArgument
import enum VersionSpecifier.VersionSpecifier
import func Foundation.exit
import class XcodeSelect.XcodeSelect

struct SelectOptions {
    var versionSpecifier: VersionSpecifier?
    var printVersions: Bool = false
    var searchPath: AbsolutePath = AbsolutePath("/Applications")
}

public class SelectCommand {

    public static func run(args: [String]) throws {
        let parser = ArgumentParser(commandName: "select", usage: "[options] <version specifier>", overview: "Find and select Xcode versions")

        let binder = ArgumentBinder<SelectOptions>()

        binder.bind(
            positional: parser.add(
                positional: "version",
                kind: VersionSpecifier.self,
                optional: true,
                usage: VersionSpecifier.helpText
            ),
            to: { $0.versionSpecifier = $1 }
        )

        binder.bind(
            option: parser.add(
                option: "--printVersions",
                shortName: "-p",
                kind: Bool.self,
                usage: "Only print found version(s), sorted in version order"
            ),
            to: { $0.printVersions = $1 }
        )

        binder.bind(
            option: parser.add(
                option: "--searchPath",
                shortName: "-P",
                kind: PathArgument.self,
                usage: "The path to search for Xcode versions. Defaults to /Applications"
            ),
            to: { $0.searchPath = $1.path }
        )

        let result = try parser.parse(args)

        var options = SelectOptions()
        try binder.fill(parseResult: result, into: &options)

        if options.printVersions {
            if let versionSpecifier = options.versionSpecifier {
                if let version = try XcodeSelect.findVersion(matching: versionSpecifier, from: options.searchPath.asURL) {
                    print(version)
                } else {
                    print("No versions found matching", versionSpecifier)
                }
            } else {
                let versions = try XcodeSelect.findVersions(in: options.searchPath.asURL)

                if !versions.isEmpty {
                    print(versions.sorted(by: >).map { version in
                        version.description
                    }.joined(separator: "\n"))
                } else {
                    throw SelectCommandError.foundNoVersions(path: options.searchPath.asURL)
                }
            }
        } else if let versionSpecifier = options.versionSpecifier {
            try XcodeSelect.selectVersion(specifier: versionSpecifier, from: options.searchPath.asURL)
        } else {
            print("Either a version specifier or the --printVersions flag is required. See --help.")
            exit(1)
        }
    }

}
