//
//  ItemsTableViewController.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 6.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class ItemsTableViewController: UITableViewController {

    var category: Category?
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.title = category?.name
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           if category != nil {
               loadItems()
           }
       }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        // Configure the cell...
            cell.generateCell(itemArray[indexPath.row])


        return cell
    }
    

    //MARK: - TableView Delegate
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           tableView.deselectRow(at: indexPath, animated: true)
           showItemView(itemArray[indexPath.row])
       }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToitemsSegu" {
            let vs = segue.destination as! AddItemViewController
            vs.category = category!
        }
    }
    
    private func showItemView(_ item: Item) {
          
          let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
          
          itemVC.item = item
          
          self.navigationController?.pushViewController(itemVC, animated: true)
      }
    
    //MARK: Load Items
       private func loadItems() {
           downloadItemsFromFirebase(category!.id) { (allItems) in
               self.itemArray = allItems
               self.tableView.reloadData()
           }
       }
}

extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No items to diplay!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later")
    }
    
}
