import XML
import Base64
import struct Foundation.Date

extension RPCValue {
    init(from element: XML.Element) throws {
        switch element.name {
        case "i4": fallthrough
        case "int": self = .int(try Int(from: element))
        case "boolean": self = .bool(try Bool(from: element))
        case "string": self = .string(try String(from: element))
        case "double": self = .double(try Double(from: element))
        case "dateTime.iso8601": self = .date(try Date(from: element))
        case "base64": self = .base64(try [UInt8](from: element))
        case "array": self = .array(try [RPCValue](from: element))
        case "struct": self = .`struct`(try [String : RPCValue](from: element))
        default: throw RPCValueError(
            reason: .notImplemented, description: element.xmlCompact)
        }
    }
}

extension Int {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            throw RPCValueError(reason: .empty, element: element)
        }
        guard let integer = Int(value) else {
            throw RPCValueError(
                reason: .invalidValue,
                description: "can't parse '\(value)' as integer")
        }
        self = integer
    }
}

extension Bool {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            throw RPCValueError(reason: .empty, element: element)
        }
        guard value == "0" || value == "1" else {
            throw RPCValueError(
                reason: .invalidValue,
                description: "can't parse '\(value)' as bool")
        }
        self = value == "1" ? true : false
    }
}

extension String {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            self = ""
            return
        }
        self = value
    }
}

extension Double {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            throw RPCValueError(reason: .empty, element: element)
        }
        guard let integer = Double(value) else {
            throw RPCValueError(
                reason: .invalidValue,
                description: "can't parse '\(value)' as double")
        }
        self = integer
    }
}

extension Date {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            throw RPCValueError(reason: .empty, element: element)
        }
        guard let date = iso8601DateFormatter.date(from: value) else {
            throw RPCValueError(
                reason: .invalidValue,
                description: "can't parse '\(value)' as iso8601 date")
        }
        self = date
    }
}

extension Array where Element == UInt8 {
    init(from element: XML.Element) throws {
        guard let value = element.value else {
            throw RPCValueError(reason: .empty, element: element)
        }
        guard let bytes = [UInt8](decodingBase64: value) else {
            throw RPCValueError(
                reason: .invalidValue,
                description: "can't decode base64 '\(value)' as [UInt8]")
        }
        self = bytes
    }
}

extension Array where Element == RPCValue {
    init(from element: XML.Element) throws {
        var array = [RPCValue]()
        for valueXml in element["data"].children {
            guard let value = valueXml.children.first else {
                throw RPCValueError(reason: .empty, element: element)
            }
            guard let childElement = XML.Element(value) else {
                throw RPCValueError(reason: .invalidValue, element: element)
            }
            array.append(try RPCValue(from: childElement))
        }
        self = array
    }
}

extension Dictionary where Key == String, Value == RPCValue {
    init(from element: XML.Element) throws {
        var `struct` = [String : RPCValue]()
        for member in element.children {
            guard let name = member["name"].value else {
                throw RPCValueError(reason: .empty, element: element)
            }
            guard let value = member["value"].children.first else {
                throw RPCValueError(reason: .empty, element: element)
            }
            guard let childElement = XML.Element(value) else {
                throw RPCValueError(reason: .invalidValue, element: element)
            }
            `struct`[name] = try RPCValue(from: childElement)
        }
        self = `struct`
    }
}
