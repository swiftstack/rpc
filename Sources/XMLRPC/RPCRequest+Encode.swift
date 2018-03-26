import XML
import Stream

extension RPCRequest {
    public func encode<T: StreamWriter>(
        to stream: T,
        prettify: Bool = false
    ) throws {
        let document = XML.Document(rpcRequest: self)
        try document.encode(to: stream, prettify: prettify)
    }
}
