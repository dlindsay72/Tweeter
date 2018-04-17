//
//  HomeVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-03-29.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

public var parseJSONKey = "parseJSON"
public let localHostKey = "http://localhost:8080/TweeterBackend/uploadAva.php"

class HomeVC: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    //MARK: - Class Properties
    
    let picker = UIImagePickerController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: - Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        let username = (user!["username"] as AnyObject).uppercased
        let fullname = user!["fullname"] as? String
        let email = user!["email"] as? String
        let ava = user!["ava"] as? String
        
        usernameLbl.text = username
        
        fullNameLbl.text = fullname
        
        emailLbl.text = email
//        editProfileBtn.layer.cornerRadius = 5.0
        
        // get user profile pic
        
        if ava != "" {
            // url path to image
            let imageURL = URL(string: ava!)!

            // communicate back user as main queue
            DispatchQueue.main.async(execute: {

                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)

                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.avatarImage.image = UIImage(data: imageData!)
                    })
                }
            })
        }
        
        self.navigationItem.title = username
        

    }
    
    
    
    //MARK: - Custom Class Methods
    @objc func createBodyWith(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData()

        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }

        let filename = "ava.jpg"
        let mimeType = "image/jpg"

        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")

        return body as Data
    }
    
    @objc func uploadAva() {

        let id = user!["id"] as! String
        let url = URL(string: localHostKey)!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        let param = ["id": id]
        let boundary = "Boundary-\(UUID().uuidString)"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = UIImageJPEGRepresentation(avatarImage.image!, 0.5)

        if imageData == nil {
            return
        }

        request.httpBody = createBodyWith(parameters: param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        guard let parseJSON = json else {
                            print("Error while parsing: \(error.debugDescription)")
                            return
                        }
        
                        let id = parseJSON["id"]

                        if id != nil {
                            UserDefaults.standard.set(parseJSON, forKey: parseJSONKey)
                            user = UserDefaults.standard.value(forKey: parseJSONKey) as? NSDictionary
                        } else {
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                appDelegate.showInfoView(message: message, color: customOrange)
                            })
                        }
                    } catch {
                        DispatchQueue.main.async(execute: {
                            let message = error as! String
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
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func editProfileBtnWasPressed(_ sender: Any) {
        
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: parseJSONKey)
        UserDefaults.standard.synchronize()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    

}

//MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension HomeVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadAva()
    }
}

// MARK: - NSMutableData

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}















