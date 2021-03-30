//
//  OrderViewController.swift
//  Protrips
//
//  Created by mac on 12/16/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var currentUser : User?
    var order : [Order] = []
    
    var keyArray: [String] = []
    
    var databaseRef = Database.database().reference()
    
    
    var hastagArray = [NSDictionary?]()
    var filteredHastag = [NSDictionary?]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredHastag.count
        }
        return self.hastagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomCell
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredHastag[indexPath.row]
            
        }else{
            user = self.hastagArray[indexPath.row]
        }

        
        cell?.contentLabel.text = user?["content"] as? String
        cell?.secondContentLabel.text = user?["secondContent"] as? String
        cell?.priceLabel.text = user?["time"] as? String
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete{
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                Database.database().reference().child("order").child(self.keyArray[indexPath.row]).removeValue()
                self.order.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.keyArray = []
                
                
            })
        
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        navigationController?.pushViewController(chatVC, animated: true)
        
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        
        currentUser = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        let parent = Database.database().reference().child("order")
        parent.observe(.value) { [weak self](snapshot) in
            self?.order.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot{
                    let orders = Order(snapshot: snap)
                    self?.order.append(orders)
                }
            }
            self?.order.reverse()
            self?.myTableView.reloadData()
            
           
        }
        print(order.count)
        // Do any additional setup after loading the view.
        
        
        
        databaseRef.child("order").queryOrdered(byChild: "content").observe(.childAdded) { (snapshot) in
            self.hastagArray.append(snapshot.value as? NSDictionary)
            
            //insert rows
            self.myTableView.insertRows(at: [IndexPath(row: self.hastagArray.count - 1, section: 0)], with: .automatic)
        }
    }
    

    @IBAction func addOrderPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Order", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "From?"
        }
        alert.addTextField { (textField2) in
            textField2.placeholder = "Where?"
        }
        alert.addTextField { (textField3) in
            textField3.placeholder = "Time"
        }
        alert.addAction(UIAlertAction(title: "Order", style: .default, handler: { [ weak alert] (_) in
            let textField1 = alert?.textFields![0]// Force unwrapping because we know it exists.
            let textField2 = alert?.textFields![1]
            let textField3 = alert?.textFields![2]
            let orders = Order(textField1!.text!, (self.currentUser?.email)!, textField3!.text!, textField2!.text!)
            Database.database().reference().child("order").childByAutoId().setValue(orders.dict)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {  (_) in
             // Force unwrapping because we know it exists.
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func getAllKeys(){
        Database.database().reference().child("order").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
                self.keyArray.reverse()
                self.myTableView.reloadData()
                print(self.keyArray[0])
                print(self.order[0])
            }
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String){
        self.filteredHastag = self.hastagArray.filter{ user in
            let username = user!["content"] as? String
            let content = user!["secondContent"] as? String
            
            
            return(username?.lowercased().contains(searchText.lowercased()))! || (content?.lowercased().contains(searchText.lowercased()))!
        }
        myTableView.reloadData()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        navigationController?.pushViewController(infoVC, animated: true)
        
    }
    @IBAction func hideButton(_ sender: UIButton) {
    }
    
    
    

}
