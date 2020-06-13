import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return "\(self)"
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}


extension UICollectionViewCell: ReusableCell {}
extension UITableViewCell: ReusableCell {}

