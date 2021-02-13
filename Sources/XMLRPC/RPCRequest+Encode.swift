import XML
import Stream

extension RPCRequest {
    public func encode<T: StreamWriter>(
        to stream: T,
        format: Format = .compact
    ) async throws {
        let document = XML.Document(rpcRequest: self)
        try await document.encode(to: stream, format: format)
    }
}
