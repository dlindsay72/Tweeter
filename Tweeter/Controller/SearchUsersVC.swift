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
    var avas = [UIImage]()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.tintColor = customBlue
        searchBar.showsCancelButton = false
        
        search(for: "")
        
    }
    
    //MARK: - Custom MEthods
    func search(for word: String) {
        let word = searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = user!["username"] as! String
        let url = URL(string: HostKey.searchUsers.rawValue)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "word=\(word)&username=\(username)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        self.users.removeAll(keepingCapacity: false)
                        self.avas.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()
                        
                        guard let parseJSON = json else {
                            print("Error while parsing in guard statement")
                            return
                        }
                        
                        guard let parseUSERS = parseJSON["users"] else {
                            print(parseJSON["message"] ?? [NSDictionary]())
                            return
                        }
                        
                        print(parseUSERS)
                        
                        self.users = parseUSERS as! [AnyObject]
                        
                        for i in 0..<self.users.count {
                            if let ava = self.users[i]["ava"] as? String {
                                if !ava.isEmpty {
                                    let url = URL(string: ava)!
                                    if let imageData = try? Data(contentsOf: url) {
                                        if let image = UIImage(data: imageData) {
                                            self.avas.append(image)
                                        }
                                    }
                                } else {
                                    let image = UIImage(named: "fadeprofile.png")!
                                    self.avas.append(image)
                                }
                            }
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        print("Error in the catch block: \(error.localizedDescription)")
                    }
                } else {
                    print("There was an error: \(error.debugDescription)")
                }
            })
        }.resume()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectUserCellIdentifier, for: indexPath) as! UsersCell
        let user = users[indexPath.row]
        let ava = avas[indexPath.row]
        
        let username = user["username"] as? String
        let fullname = user["fullname"] as? String
        
        cell.usernameLbl.text = username
        cell.fullNameLbl.text = fullname
        cell.userImage.image = ava
        
        return cell
    }

}

//MARK: - UISearchBarDelegate

extension SearchUsersVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search php request
            search(for: searchBar.text!)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        users.removeAll(keepingCapacity: false)
        avas.removeAll(keepingCapacity: false)
        tableView.reloadData()
        search(for: "")
    }
}











