

import Foundation
import RxSwift



enum ErrorSessionAPI: Error {
    case responseError(error: Error)
    case errorNotDecodeJson
    case errorBadStatusCode
    case errorContentPayload(code: Int, message: String)
}

final class SessionAPI {
    // MARK: - API Private
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    func send<T: Codable>(request: Resource) -> Observable<T> {
        return Observable<T>.create { [unowned self ] observer in
            let request = request.requestWithBaseURL()
            let task = self.session.dataTask(with: request) { (data, response, error) in
                do {
                    //print(String(data: data ?? Data(), encoding: .utf8))
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    print(error.localizedDescription)
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }



}


    
    
    





