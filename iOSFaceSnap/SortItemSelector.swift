//
//  SortItemSelector.swift
//  iOSFaceSnap
//
//  Created by James Daniell on 25/10/2016.
//  Copyright © 2016 JamesDaniell. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SortItemSelector<SortType: NSManagedObject>: NSObject, UITableViewDelegate
{
    
    private let sortItems: [SortType]
    // We want to know which tags are checked so that later on we might be able to search by those tags 
    // checked items is a Set of type Tag
    var checkedItems: Set<SortType> = []
    
    init(sortItems: [SortType])
    {
        self.sortItems = sortItems
        super.init()
    }
    
    //MARK: - UITableViewDelegate
    
    // fuction for if the items are checked
    // on selection of a row
    // pass in the required table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // select based on the index of the row section
        // indexPath represents the path to a specific node in a tree of nested arrays
        switch indexPath.section // section indentifies the section in a table view or colection view
        {
            // if the 0th element is picked (All Tags) then we want to reset the tags selected in the selction below ( section 1)
            case 0:
                guard let cell = tableView.cellForRow(at: indexPath) else {return} // check if there is a cell at the given indexPath
                if cell.accessoryType == .none // if the part is not included / if the cell is not checked
                {
                    cell.accessoryType = .checkmark // give a check
                    let nextSection = indexPath.section.advanced(by: 1)// increase the current selction of section to the next one
                    // a section seperates rows into parts 
                    // want to find the number of rows in the next section
                    let numberOfRowsInSubsequentSection = tableView.numberOfRows(inSection: nextSection)
                    
                    // loop through the rows in the subsequent section
                    for row in 0..<numberOfRowsInSubsequentSection
                    {
                        // for each indexpath for each row in the section
                        let indexPath = IndexPath( row: row , section: nextSection)
                        // get the cell at that coordinate
                        let cell = tableView.cellForRow(at: indexPath)
                        // if it exsits mark it as none
                        cell?.accessoryType = .none
                        
                        checkedItems = []
                    }
                }
            // When a row is pressed and it is in the second section find the value of the cell
            case 1:
                let allItemsIndexPath = IndexPath(row: 0 , section: 0) // get the index Path for  all items
                let allItemsCell = tableView.cellForRow(at: allItemsIndexPath) // get the first cell( the one selected)
                allItemsCell?.accessoryType = .none// set the cell accessoory type to .none
            
                guard let cell = tableView.cellForRow(at: indexPath) else {return}
                // we have an item that we view (TAGS)
                
                let item = sortItems[indexPath.row]
                //toggle accessory type on and off
                // if making a cell -> checked add it to the checkedItems array
                if cell.accessoryType == .none
                {
                    cell.accessoryType = .checkmark
                    checkedItems.insert(item)
                }
                else if cell.accessoryType == .checkmark // if unchecking remove from checkedItems
                {
                    cell.accessoryType = .none
                    checkedItems.remove(item)
                }
        default:
            break
        }
        print(checkedItems.description)
    }
}
























