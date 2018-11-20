public protocol RPCValueInitializable {
    init?(_ value: RPCValue)
}

extension Int: RPCValueInitializable {
    public init?(_ value: RPCValue) {
        switch value {
        case let .int(value): self.init(value)
        default: return nil
        }
    }
}

extension Bool: RPCValueInitializable {
    public init?(_ value: RPCValue) {
        guard case let .bool(value) = value else {
            return nil
        }
        self.init(value)
    }
}

extension String: RPCValueInitializable {
    public init?(_ value: RPCValue) {
        guard case let .string(string) = value else {
            return nil
        }
        self.init(string)
    }
}

extension Double: RPCValueInitializable {
    public init?(_ value: RPCValue) {
        switch value {
        case let .double(value): self.init(value)
        default: return nil
        }
    }
}


extension Array where Element == UInt8 {
    public init?(_ value: RPCValue) {
        guard case let .base64(bytes) = value else {
            return nil
        }
        self = bytes
    }
}

extension Array where Element == RPCValue {
    public init?(_ value: RPCValue) {
        guard case let .array(items) = value else {
            return nil
        }
        self = items
    }
}

extension Dictionary where Key == String, Value == RPCValue {
    public init?(_ value: RPCValue) {
        guard case let .struct(items) = value else {
            return nil
        }
        self = items
    }
}

// MARK: Optionals

extension RPCValueInitializable {
    public init?(_ optional: RPCValue?) {
        guard case let .some(some) = optional,
            let value = Self(some) else {
                return nil
        }
        self = value
    }
}

extension Array where Element == RPCValue {
    public init?(_ optional: RPCValue?) {
        guard case let .some(some) = optional,
            let value = Array(some) else {
                return nil
        }
        self = value
    }
}

extension Dictionary where Key == String, Value == RPCValue {
    public init?(_ optional: RPCValue?) {
        guard case let .some(some) = optional,
            let value = Dictionary(some) else {
                return nil
        }
        self = value
    }
}
