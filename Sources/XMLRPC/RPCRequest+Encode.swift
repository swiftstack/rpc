import XML
import Stream

extension RPCRequest {
    public func encode(
        to stream: StreamWriter,
        format: Format = .compact
    ) async throws {
        let document = XML.Document(rpcRequest: self)
        try await document.encode(to: stream, format: format)
    }
}
