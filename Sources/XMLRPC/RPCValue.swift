import XML
import struct Foundation.Date

public enum RPCValue {
    case int(Int)
    case bool(Bool)
    case double(Double)
    case string(String)
    case date(Date)
    case base64([UInt8])
    case `struct`([String : RPCValue])
    case array([RPCValue])
}

extension RPCValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let value): return String(value)
        case .bool(let value): return String(value)
        case .double(let value): return String(value)
        case .string(let value): return "\"\(value)\""
        case .date(let value): return String(describing: value)
        case .base64(let value): return "<base64>:" + String(describing: value)
        case .struct(let values): return String(describing: values)
        case .array(let values): return String(describing: values)
        }
    }
}

extension RPCValue: Equatable {
    public static func ==(lhs: RPCValue, rhs: RPCValue) -> Bool {
        switch (lhs, rhs) {
        case let (.int(lhs), .int(rhs)): return lhs == rhs
        case let (.bool(lhs), .bool(rhs)): return lhs == rhs
        case let (.double(lhs), .double(rhs)): return lhs == rhs
        case let (.string(lhs), .string(rhs)): return lhs == rhs
        case let (.date(lhs), .date(rhs)): return lhs == rhs
        case let (.base64(lhs), .base64(rhs)): return lhs == rhs
        case let (.struct(lhs), .struct(rhs)): return lhs == rhs
        case let (.array(lhs), .array(rhs)): return lhs == rhs
        default: return false
        }
    }
}

public struct RPCValueError: Error {
    public let reason: Reason
    public let description: String?

    public enum Reason {
        case empty
        case invalidValue
        case notImplemented
    }

    init(reason: Reason, description: String? = nil) {
        self.reason = reason
        self.description = description
    }

    init(reason: Reason, element: XML.Element) {
        self.reason = reason
        self.description = element.xmlCompact
    }
}
