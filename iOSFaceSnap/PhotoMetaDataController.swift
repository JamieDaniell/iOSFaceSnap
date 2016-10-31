//
//  PhotoMetaDataController.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 19/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController
{
    
    let photo: UIImage
    
    init(photo: UIImage)
    {
        self.photo = photo
        super.init(style: .grouped)
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError()
    }
    // MARK: MetaDataFields
    lazy var photoImageView: UIImageView =
    {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    lazy var imageViewHeight: CGFloat =
    {
        let imageFactor = self.photoImageView.frame.size.height/self.photoImageView.frame.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * imageFactor
    }()
    
    lazy var locationLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView =
    {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.isHidden = true
        return view
    }()
    
    var locationManager: LocationManager!
    var location: CLLocation?
    
    
    lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Summer Vacation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        navigationItem.rightBarButtonItem = saveButton
        

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension PhotoMetadataController
{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch (indexPath.section , indexPath.row)
        {
            case (0,0):
                cell.contentView.addSubview(photoImageView)
            
                NSLayoutConstraint.activate([
                    photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    photoImageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                    photoImageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    photoImageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
                    ])
            
            case (1,0):
                cell.contentView.addSubview(locationLabel)
                cell.contentView.addSubview(activityIndicator)
                NSLayoutConstraint.activate([
                    activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    activityIndicator.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0),
                    locationLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    locationLabel.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor , constant: 16.0),
                    locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    locationLabel.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                    ])
            
            case (2,0):
                cell.contentView.addSubview(tagsTextField)
                
                NSLayoutConstraint.activate([
                    tagsTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    tagsTextField.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 16.0),
                    tagsTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    tagsTextField.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 20.0)
                    ])
            
            
            default:
                break
        }
        
        return cell
    }

}
//MARK: - HelperMethods 
extension PhotoMetadataController
{
    func tagsFromTextField() -> [String]
    {
        guard let tags = tagsTextField.text else { return [] }
        
        let commaSeperatedSubSequences = tags.characters.split { $0 == "," }
        let commaSeperatedStrings = commaSeperatedSubSequences.map(String.init)
        let lowercaseTags = commaSeperatedStrings.map { $0.lowercased() }
        
        return lowercaseTags.map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
    }
}
//MARK: - HelperMethods 
extension PhotoMetadataController
{
    func savePhotoWithMetadata()
    {
        let tags = tagsFromTextField()
        Photo.photoWith(image: photo, tags: tags, location: location)
        CoreDataController.save()
        dismiss(animated: true, completion: nil)
    }
}





//MARK: - UITableVIewDelegate
extension PhotoMetadataController
{
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch(indexPath.section, indexPath.row)
        {
            case (0,0):
                return imageViewHeight
            default:
                return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch(indexPath.section, indexPath.row)
        {
            case(1,0):
                locationLabel.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            
                locationManager = LocationManager()
                locationManager.onLocationFix = { placemark, error in
                    if let placemark = placemark
                    {
                        self.location = placemark.location
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.locationLabel.isHidden = false
                        
                        guard let name = placemark.name , let city = placemark.locality, let area = placemark.administrativeArea else { return }
                        
                        self.locationLabel.text = "\(name),  \(city), \(area)"
                    }
                    
                }
            default:
                break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section{
            case 0: return "Photo"
            case 1: return "Enter a Location"
            case 2: return "Enter tags"
            default: return nil
        }
    }
}












