import XML

public struct RPCResponse {
    public let params: [RPCValue]

    public init(params: [RPCValue]) {
        self.params = params
    }
}

extension RPCResponse: Equatable {
    public static func ==(lhs: RPCResponse, rhs: RPCResponse) -> Bool {
        return lhs.params == rhs.params
    }
}
