import CLIHelpers
import Foundation

public final class AppArchiver {
    /**
     Builds a zip archive containing the app at the provided URL.

     This uses the `ditto` command line tool to create an archive similar to Finder's "Compress MyApp.app", which is suitable for
     upload to Apple's servers, notarization, etc.

     - Parameters:
       - appURL: The URL of the app to archive.
       - outputURL: The URL to save the archive. If `nil` archive will be saved in same directory as app.
       - enableVerboseLogging: If `true` will output verbose logs. Defaults to `false`.
     */
    public static func archiveApp(
        at appURL: URL,
        outputTo outputURL: URL? = nil,
        enableVerboseLogging: Bool = false
    ) throws {
        let archivePath = outputURL ?? appURL.appendingPathExtension("zip")
        let command: [String] = [
            "ditto",
            "-c",
            "-k",
            "--sequesterRsrc",
            "--keepParent",
            appURL.path,
            archivePath.path
        ]

        try run(enableVerboseLogging: enableVerboseLogging, command, streamOutputTo: .standardOut)
    }
    
}
