import Foundation
import RxSwift
import Alamofire

final class SessionAPI {
    // MARK: - API Private
    
    func sendWithError<T: APIRequest>(request: T, isAuthentication: Bool = false) -> Single<T.Response> {
        let req = request.requestWithBaseURL()
        
        return Single<T.Response>.create { observer in
            let task = AF.request(req).validate().responseData { data in
                if let err = data.error {
                    observer(.error(APIError.errorServer(err)))
                }
                if let data = data.data {
                    do {
                        let model = try JSONDecoder().decode(T.Response.self, from: data)
                        observer(.success(model))
                    } catch let error {
                        print(error)
                        observer(.error(APIError.errorParseResponse))
                    }
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


    
    
    





