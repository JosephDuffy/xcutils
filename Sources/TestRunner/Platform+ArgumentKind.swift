import enum TSCUtility.ShellCompletion
import protocol TSCUtility.ArgumentKind
import enum TSCUtility.ArgumentConversionError

extension Platform: ArgumentKind {

    public init(argument: String) throws {
        guard let platform = Platform(string: argument) else {
            throw ArgumentConversionError.unknown(value: argument)
        }

        self = platform
    }

    public static var completion: ShellCompletion {
        return .values(allCases.map { platform in
            return (platform.rawValue, platform.rawValue)
        })
    }


}
