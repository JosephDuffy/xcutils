import class TSCUtility.ArgumentParser
import class TSCUtility.ArgumentBinder
import struct TSCUtility.PathArgument
import enum VersionSpecifier.VersionSpecifier
import enum TestRunner.Platform
import class TestRunner.TestRunner

public class TestCommand {

    public static func run(args: [String]) throws {
        let parser = ArgumentParser(commandName: "xcutils test", usage: "<platform> [options]", overview: "Find and select Xcode versions")

        let binder = ArgumentBinder<TestOptions>()

        binder.bind(
            positional: parser.add(positional: "platform", kind: Platform.self, optional: false, usage: "The platform to test"),
            to: { $0.platform = $1 }
        )

        binder.bind(
            option: parser.add(option: "--version", shortName: "-v", kind: VersionSpecifier.self, usage: "The platform version to test. Defaults to latest"),
            to: { $0.versionSpecifier = $1 }
        )

        binder.bind(
            option: parser.add(option: "--project", shortName: "-p", kind: PathArgument.self, usage: "The path to the Xcode Project"),
            to: { $0.projectPath = $1.path }
        )

        binder.bind(
            option: parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The scheme to test"),
            to: { $0.scheme = $1 }
        )

        let result = try parser.parse(args)

        var options = TestOptions()
        try binder.fill(parseResult: result, into: &options)

        guard let projectPath = options.projectPath else {
            // TODO: Try to find project in local directory
            throw TestCommandError.projectRequired
        }

        guard let scheme = options.scheme else {
            // TODO: Try to find schemes in project
            throw TestCommandError.schemeRequired
        }

        try TestRunner.runTests(
            platform: options.platform!,
            versionSpecifier: options.versionSpecifier,
            project: projectPath.asURL,
            scheme: scheme
        )
    }

}
