
import UIKit

class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    var model: Repositories? {
        didSet {
            populateModel()
            
        }
    }

    func populateModel() {
        // Update the user interface for the detail item.
        if let model = model {
            if let lblName = lblName, let lblLogin = lblLogin, let lblType = lblType, let lblDescription = lblDescription {
                
                lblName.text = model.name
                lblLogin.text = model.owner.login ?? ""
                lblType.text = model.owner.type ?? ""
                lblDescription.text = model.description ?? ""
                if let imgAvatar = imgAvatar, let ima = model.owner.ima, let url = URL(string: ima) {
                    imgAvatar.kf.setImage(with: url)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateModel()
    }

    
}

