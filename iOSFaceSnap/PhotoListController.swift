//
//  ViewController.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 11/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData

class PhotoListController: UIViewController, MediaPickerManagerDelegate
{
    
    // create camera button and describe its action
    lazy var cameraButton: UIButton =
    {
            // Set the type of button
            let button = UIButton(type: .system)
            // Camera Button Customization
        
            button.setTitle("Camera", for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor(red: 64/255.0, green: 174/255.0, blue: 42/255.0, alpha: 1.0)
            // set the functionality of the button -> present the photoListController
            button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)
            return button
    }()
    lazy var mediaPickerManager: MediaPickerManager =
    {
        // initalise MediaPickerManger with a view controller ( this one )
        let manager = MediaPickerManager(presentingViewController: self)
        // initalise the delegate 
        manager.delegate = self
        return manager
    }()
    
    lazy var dataSource: PhotoDataSource =
    {
        // request form the Photo data source
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView: self.collectionView)
    }()
    
    // define how the collection view looks
    lazy var collectionView: UICollectionView =
    {
        /*
        The UICollectionViewFlowLayout class is a concrete layout object that organizes
        items into a grid with optional header and footer views for each section
        */
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        // get the size of the screen and workout constraints
        let screenWidth = UIScreen.main.bounds.size.width
        let paddingDistance: CGFloat = 12.0 
        let itemSize = (screenWidth - paddingDistance)/2.0
        
        // set the size of the items for entry into the collection view
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        //layout the views
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white// set backround color
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier) // get the the photocell as deifned in the PhotoCell class
        
        return collectionView
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNavigationBar()   
        // defined collectionView given data from the datasource
        collectionView.dataSource = dataSource
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Layout
    // layout subviews
    override func viewDidLayoutSubviews()
    {
        // add the collection view an array of UIView
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        // add button to the naviagation controller
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Layouts for the camera and the collectionView
        NSLayoutConstraint.activate([
            // Layout Code
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
            ])
    }
    
    //MARK: - Image Picker Controller
    
    // present the image picker --> the result of a button press 
    @objc private func presentImagePickerController()
    {
        mediaPickerManager.presentImagePickerController(animated: true)
    }


}

//MARK: - MediaPickerManagerDelegate

extension PhotoListController
{
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
    {
        let eaglContext = EAGLContext(api: .openGLES2)
        let ciContext = CIContext(eaglContext: eaglContext!)
        
        let photoFilterController = PhotoFilterController(image: image, context: ciContext , eaglContext: eaglContext!)
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        
        manager.dismissImagePickerController(animated: true)
        {
            self.present(navigationController, animated: true, completion: nil)
        }
        
    }
}

//MARK - Navigation
extension PhotoListController
{
    //set up the navigationbar
    func setupNavigationBar()
    {
        // create the button and action
        let sortTagsButton = UIBarButtonItem(title: "Tags", style: .plain, target: self, action: #selector(PhotoListController.presentSortController))
        // add the right bar buttton item
        navigationItem.setRightBarButtonItems([sortTagsButton], animated: true)
    }
    func presentSortController()
    {
        // get the tags
        // fetch Request -> gets all the tags in the system 
        // managedObjectContext -> get the datacontroller environment
        let tagDataSource = SortableDataSource<Tag>(fetchRequest: Tag.allTagsRequest , managedObjectContext: CoreDataController.sharedInstance.managedObjectContext)
        let sortItemSelector = SortItemSelector(sortItems: tagDataSource.results)
        let sortController = PhotoSortListController(dataSource: tagDataSource, sortItemSelector: sortItemSelector)
        
        // checked items from sortController is a Set<Tags>
        sortController.onSortSelection = { checkedItems in
            
            if !checkedItems.isEmpty
            {
                var predicates = [NSPredicate]()
                for tag in checkedItems
                {
                    // %K means the subsitutoin for a key path
                    // %@ an argument substition for a value
                    // get the title property andd make sure it matches the one provided
                    let predicate = NSPredicate(format: "%K CONTAINS %@", "tags.title", tag.title)
                    predicates.append(predicate)
                    
                }
                let compoundPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: predicates)
                self.dataSource.performFetch(withPredicate: compoundPredicate)
            }
            else
            {
                self.dataSource.performFetch(withPredicate: nil)

            }
            
        }
        let navigationController = UINavigationController(rootViewController: sortController)
        
        present(navigationController, animated: true,   completion: nil)
    }
}





















