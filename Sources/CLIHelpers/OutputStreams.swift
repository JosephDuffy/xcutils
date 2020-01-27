import func Darwin.fputs
import var Darwin.stderr
import struct Darwin.FILE

private struct FileOutputStream: TextOutputStream {
    
    private let stream: UnsafeMutablePointer<FILE>
    
    init(stream: UnsafeMutablePointer<FILE>) {
        self.stream = stream
    }
    
    mutating func write(_ string: String) {
        fputs(string, stream)
    }
}

private var stderrOutput = FileOutputStream(stream: stderr)

private func _print<Output: TextOutputStream>(_ items: [Any], separator: String = " ", terminator: String = "\n", to output: inout Output) {
    var prefix = ""
    
    for item in items {
        output.write(prefix)
        if case let streamableObject as TextOutputStreamable = item {
          streamableObject.write(to: &output)
        } else if case let printableObject as CustomStringConvertible = item {
          printableObject.description.write(to: &output)
        } else if case let debugPrintableObject as CustomDebugStringConvertible = item {
          debugPrintableObject.debugDescription.write(to: &output)
        } else {
            let string = String(describing: item)
            string.write(to: &output)
        }
    
        prefix = separator
    }
    output.write(terminator)
}

public func printError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    _print(items, separator: separator, terminator: terminator, to: &stderrOutput)
}
