//
//  SearchViewCell.swift
//  Search GitHub
//
//  Created by appsistemas on 27/3/18.
//  Copyright © 2018 appsistemas. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    
    func populate(model: Repositories)  {
        
        lblName.text = model.name
        lblFullName.text = model.fullName
        guard let ima = model.owner.ima, let url = URL(string: ima) else{
            return
        }
        imgAvatar.kf.setImage(with: url)
        
        
    }

}
