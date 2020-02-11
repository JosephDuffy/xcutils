# xcutils

A collection of utilities that aid with the use of the Xcode CLI, packaged as a single SwiftPM Package.

## Usage

`xcutils` can be used as an executable, or you can include the provided frameworks to aid with your own workflow.

### `xcutils` Executable

The SwiftPM Package provides a single executable, `xcutils`, which contains subcommands for each of the utilities provided.

All flags can be passed as either `--flagName` or `-flagName`, although short names must be in the format `-f`.

#### `xcutils test`

`xcutils test` makes running tests against simulators and the local Mac more concistent and easy:

```shell
swift run xcutils test iOS --project MyFramework.xcodeproj --scheme MyFramework
```

This will test the `MyFramework` scheme from the `MyFramework.xcodeproj` project using an iOS simulator with the newest version of iOS installed, prioritising simulators that are already running.

##### Configuration

Usage: `xcutils test <platform> [options]`

| Argument | Required | Type | Default Value | Description |
|------|----------|------|---------------|-------------|
| `platform` | Yes | `iOS` \| `macOS` \| `tvOS`| N/A | The platform to test on. |
| `--project`, `-p` | Yes | `String` | N/A | The path to the project to test. |
| `--scheme`, `-s` | Yes | `String` | N/A | The name of the scheme to test. |
| `--version`, `-v` | No | `String` | `latest` | See [version specifiers](#version-specifiers). |

#### `xcutils select`

`xcutils select` makes finding and changing the changing the Xcode version used by the command line easy:

```shell
swift run xcutils select latest
```

This will run `xcode-select` to select the latest version of Xcode installed in /Applications.

##### Configuration

Usage: `xcutils select [options] <version specifier>`

| Argument | Required | Type | Default Value | Description |
|------|----------|------|---------------|-------------|
| `version` | Yes | `String` | `latest` | See [version specifiers](#version-specifiers). |
| `--printVersions`, `-p` | No | `Bool` | `false` | Only print found version(s), sorted in version order. |
| `--searchPath`, `-P` | No | `URL` | `/Applications` | The path to search for Xcode versions. |

### Version Specifiers

Special cases can be provided when specifying a version. These specifiers work against the **locally installed** versions, rather than the latest version published by Apple.

| Case | Explanation |
|------|-------------|
| `latest` | The latest stable version |
| `last-major` | The last major stable version, e.g. 10.x.x if the latest version is 11.x.x |
| `last-minor` | The last minor stable version, e.g. 11.1.x if the latest version is 11.2.x |
| `beta` | The latest beta version |
| `11.3.1` | The exact version 11.3.1 |
| `11.3` | The latest version 11.3 available (any patch) |
| `11` | The latest version 11 available (any minor; any patch) |
