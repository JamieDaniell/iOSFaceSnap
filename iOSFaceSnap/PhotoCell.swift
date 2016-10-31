//
//  PhotoCell.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 22/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit


// Layout the PhotoCell ussesd in the selector in the main page 
class PhotoCell: UICollectionViewCell
{
    static let reuseIdentifier = "\(PhotoCell.self)"
    
    let imageView = UIImageView()
    
    override func layoutSubviews()
    {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}















