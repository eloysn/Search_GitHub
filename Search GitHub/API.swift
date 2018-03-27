

import Foundation

public enum API {
    
	case listRepos(page: Int)
	case searchRepos(query:String)
   
	
}

extension API: Resource {
    
    var method: Method {
        switch self{
        case .listRepos, .searchRepos:
            return Method.GET
        }
    }
    
    var bodyObjects: [String : Any] {
       return  [:]
    }
    
	
	public var path: String {
        
		switch self {
		case .listRepos:
			return "/repositories"
        case  .searchRepos:
			return "/search/repositories"
        
		}
	}
	
	public var parameters: [String:String] {
        
		switch self {
        case  let .listRepos(page):
            return ["since": String(page)]
		case let .searchRepos(query):
            return ["q": query]
        
		}

	}
	
}
