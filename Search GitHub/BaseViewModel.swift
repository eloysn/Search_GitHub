import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
    
class BaseViewModel {
    
    init() {}
    
    deinit {
        print("----Deinit----\(type(of: self))")
    }
}

