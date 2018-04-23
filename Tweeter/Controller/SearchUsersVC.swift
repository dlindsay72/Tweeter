//
//  SearchUsersVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-23.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

public let selectUserCellIdentifier = "selectUser"

class SearchUsersVC: UITableViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    var users = [AnyObject]()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.tintColor = customBlue
        searchBar.showsCancelButton = false
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectUserCellIdentifier, for: indexPath) as! UsersCell
        
        return cell
    }

}

//MARK: - UISearchBarDelegate

extension SearchUsersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search php request
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
}











