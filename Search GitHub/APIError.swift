import Foundation

enum APIError: Error {
    case errorClient //400
    case errorServer(_ error: Error)//500
    case errorNotDecodeResponse//200 but bad response
    case errorUnknown//error, but bad error response
    case errorParseToken
    case errorParseResponse
}
