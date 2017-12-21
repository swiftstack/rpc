import XML
import Stream

public struct RPCResponse {
    public let params: [RPCValue]

    public init(params: [RPCValue]) {
        self.params = params
    }
}

extension RPCResponse {
    public init<T: UnsafeStreamReader>(from stream: T) throws {
        let document = try XML.Document(from: stream)
        guard let root = document.root, root.name == "methodResponse" else {
            throw RPCError.invalidXML
        }

        var params = [RPCValue]()

        for param in root["params"].children {
            guard let value = param["value"].children.first else {
                throw RPCValueError(
                    reason: .empty,
                    description: "xml element has no content")
            }
            guard let element = XML.Element(value) else {
                throw RPCValueError(
                    reason: .invalidValue,
                    description: "xml element was expected")
            }
            params.append(try RPCValue(from: element))
        }
        self.params = params
    }
}

extension RPCResponse: Equatable {
    public static func ==(lhs: RPCResponse, rhs: RPCResponse) -> Bool {
        return lhs.params == rhs.params
    }
}
