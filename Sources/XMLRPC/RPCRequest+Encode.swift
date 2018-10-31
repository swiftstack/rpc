import XML
import Stream

extension RPCRequest {
    public func encode<T: StreamWriter>(
        to stream: T,
        format: Format = .compact
    ) throws {
        let document = XML.Document(rpcRequest: self)
        try document.encode(to: stream, format: format)
    }
}
