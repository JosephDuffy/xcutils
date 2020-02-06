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
swift run xcutils test --platform iOS --scheme MyFramework --project MyFramework.xcodeproj
```

This will test the `MyFramework` scheme from the `MyFramework.xcodeproj` project using an iOS simulator with the newest version of iOS installed, prioritising simulators that are already running.

##### Configuration

| Flag | Required | Type | Default Value | Description |
|------|----------|------|---------------|-------------|
| `platform` | Yes | `iOS` \| `macOS` \| `tvOS`| N/A | The platform to test on. |
| `project` | Yes | `String` | N/A | The path to the project to test. |
| `scheme` | Yes | `String` | N/A | The name of the scheme to test. |
| `version` | No | `String` | `latest` | See [version specifiers](#version-specifiers). |

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
