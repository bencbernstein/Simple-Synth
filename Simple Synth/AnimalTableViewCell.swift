//
//  AnimalTableViewCell.swift
//  Simple Synth
//
//  Created by Benjamin Bernstein on 4/24/17.
//  Copyright © 2017 Burning Flowers. All rights reserved.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    
    static let reuseID = "animalCell"
    var animalView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       //animalView.image = #imageLiteral(resourceName: "frog")
        animalView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animalView)
        animalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        animalView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        animalView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        animalView.widthAnchor.constraint(equalTo:  animalView.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
