import XML

public struct RPCRequest {
    public let methodName: String
    public let params: [RPCValue]

    public init(methodName: String, params: [RPCValue]) {
        self.methodName = methodName
        self.params = params
    }
}

extension RPCRequest {
    public var xml: String {
        return XML.Document(rpcRequest: self).xml
    }

    public var xmlCompact: String {
        return XML.Document(rpcRequest: self).xmlCompact
    }
}

extension XML.Document {
    init(rpcRequest request: RPCRequest) {
        var root = XML.Element(name: "methodCall")

        root.children.append(name: "methodName", value: request.methodName)

        var paramsElement = XML.Element(name: "params")
        for param in request.params {
            let paramElement = XML.Element(
                name: "param",
                children: [
                    .element(XML.Element(
                        name: "value",
                        children: [.element(XML.Element(rpcValue: param))])
                    )
                ])
            paramsElement.children.append(paramElement)
        }
        root.children.append(paramsElement)

        self.init(root: root)
    }
}
