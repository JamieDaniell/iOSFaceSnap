//
//  SortableDataSource.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 23/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CustomTitleConvertible
{
    var title: String { get }
}

extension Tag: CustomTitleConvertible {}

class SortableDataSource<SortType: CustomTitleConvertible where SortType: NSManagedObject>: NSObject, UITableViewDataSource
{
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    
    var results: [SortType]
    {
        return fetchedResultsController.fetchedObjects as! [SortType]
    }
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext moc: NSManagedObjectContext)
    {
        self.fetchedResultsController  = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext:  moc, sectionNameKeyPath: nil , cacheName: nil)
        super.init()
        
        executeFetch()
    }
    
    func executeFetch()
    {
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError
        {
            print("Unresolved Error: \(error)")
        }
    }
    
    //MARK: UITableVeiwDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
            case 0: return 1
            case 1: return fetchedResultsController.fetchedObjects?.count ?? 0
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "sortableItemCell")
        cell.selectionStyle = .none
        switch(indexPath.section, indexPath.row)
        {
            case (0,0):
                cell.textLabel?.text = "All \(SortType.self)s"
                cell.accessoryType = .checkmark
            case (1,_):
                guard let sortItem = fetchedResultsController.fetchedObjects?[indexPath.row] as? SortType else
                {
                    break
                }
                cell.textLabel?.text = sortItem.title
            default:
                break
        }
        return cell
        
    }
}
























