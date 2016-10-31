//
//  PhotoFetchResultsController.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 22/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchResultsController: NSFetchedResultsController<NSManagedObject> , NSFetchedResultsControllerDelegate
{
    private let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView)
    {
        self.collectionView = collectionView
        super.init(fetchRequest: fetchRequest as! NSFetchRequest<NSManagedObject> , managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        executeFetch()
    }
    
    func executeFetch()
    {
        do
        {
            try performFetch()
        }
        catch let error as NSError
        {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    func performFetch(withPredicate predicate: NSPredicate?)
    {
        NSFetchedResultsController<NSManagedObject>.deleteCache(withName: nil)
        fetchRequest.predicate = predicate
        executeFetch()
    }
    //MARK - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView.reloadData()
    }
}
