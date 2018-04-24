//
//  GuestVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-24.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

public var guestSegueIdentifier = "guestSegue"

class GuestVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avaImage: CustomRoundedImage!
    
    //MARK: - Properties
    @objc var tweets = [AnyObject]()
    @objc var images = [UIImage]()
    @objc var guest = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let username = guest["username"] as? String
        let fullname = guest["fullname"] as? String
        let email = guest["email"] as? String
        let ava = guest["ava"] as? String
        
        usernameLbl.text = username
        fullnameLbl.text = fullname
        emailLbl.text = email
        
        if ava != "" {
            if let imageURL = URL(string: ava!) {
                DispatchQueue.main.async(execute: {
                    let imageData = try? Data(contentsOf: imageURL)
                    
                    if imageData != nil {
                        DispatchQueue.main.async(execute: {
                            self.avaImage.image = UIImage(data: imageData!)
                        })
                    }
                })
            }
        }
        
        self.navigationItem.title = username?.uppercased()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    func loadPosts() {
        let id = guest["id"]!
        let url = URL(string: HostKey.posts.rawValue)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let body = "id=\(id)&text=&uuid="
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        self.tweets.removeAll(keepingCapacity: false)
                        self.images.removeAll(keepingCapacity: false)
                        self.tableView.reloadData()
                        guard let parseJSON = json else {
                            print("Error while parsing in loadPosts")
                            return
                        }
                        
                        guard let posts = parseJSON["posts"] as? [AnyObject] else {
                            print("Error parsing posts form parseJSON")
                            return
                        }
                        
                        self.tweets = posts
                        print("These are the posts: \(posts)")
                        
                        //get images from url paths
                        for i in 0..<self.tweets.count {
                            if let path = self.tweets[i]["path"] as? String {
                                if !path.isEmpty {
                                    let url = URL(string: path)!
                                    if let imageData = try? Data(contentsOf: url) {
                                        if let image = UIImage(data: imageData) {
                                            self.images.append(image)
                                        }
                                    }
                                } else {
                                    let image = UIImage()
                                    self.images.append(image)
                                }
                            }
                        }
                        
                        self.tableView.reloadData()
                        
                    } catch {
                        DispatchQueue.main.async(execute: {
                            let message = error.localizedDescription
                            print("This is the error spot")
                            appDelegate.showInfoView(message: message, color: customOrange)
                        })
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        appDelegate.showInfoView(message: message, color: customOrange)
                    })
                }
            })
        }.resume()
        
    }

}

extension GuestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath) as! PostCell
        
        let tweet = tweets[indexPath.row]
        let image = images[indexPath.row]
        let username = tweet["username"] as? String
        let text = tweet["text"] as? String
        let date = tweet["date"] as! String
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let newDate = dateFormater.date(from: date)!
        
        let from = newDate
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth, .year]
        let difference = (Calendar.current as NSCalendar).components(components, from: from, to: now, options: [])
        print(difference)
        // calculate date
        if difference.second! <= 0 {
            cell.timeStampLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.timeStampLbl.text = "\(difference.second!)s." // 12s.
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            if let minuteDif = difference.minute {
                cell.timeStampLbl.text = "\(minuteDif)m."
            }
        }
        if difference.hour! > 0 && difference.day! == 0 {
            if let hourDif = difference.hour {
                cell.timeStampLbl.text = "\(hourDif)h."
            }
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            if let dayDif = difference.day {
                cell.timeStampLbl.text = "\(dayDif)d."
            }
        }
        if difference.weekOfMonth! > 0 {
            if let monthDif = difference.month {
                cell.timeStampLbl.text = "\(monthDif)w."
            }
        }
        
        if difference.year! > 0 {
            if let yearDif = difference.year {
                cell.timeStampLbl.text = "\(yearDif)y."
            }
        }
        
        cell.usernameLbl.text = username
        cell.postLbl.text = text
        cell.postImage.image = images[indexPath.row]
        
        DispatchQueue.main.async {
            
            if image.size.width == 0 && image.size.height == 0 {
                // uncomment the two lines below to shift the post label over to the left if there is no image posted
                //           cell.postLbl.frame.origin.x = self.view.frame.size.width / 16
                //           cell.postLbl.frame.size.width = self.view.frame.size.width / 8
                cell.postLbl.sizeToFit()
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
}
