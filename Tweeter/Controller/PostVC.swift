//
//  PostVC.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-11.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

public let pathToPosts = "http://localhost:8080/TweeterBackend/posts.php"

class PostVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var charactersLbl: UILabel!
    @IBOutlet weak var selectPicBtn: CustomRoundedButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postBtn: CustomRoundedButton!
    
    //MARK: - Class Properties
    var uuid = String()
    var imageSelected = false
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.layer.cornerRadius = 5.0
        postTextView.contentInsetAdjustmentBehavior = .never
        
        configurePostButton(alpha: 0.5, isEnabled: false)
    }
    
    //MARK: - Custom Methods
    func configurePostButton(alpha: CGFloat, isEnabled: Bool) {
        postBtn.isEnabled = isEnabled
        postBtn.alpha = alpha
    }
    
    @objc func createBodyWith(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        var filename = ""
        
        if imageSelected == true {
            filename = "post-\(uuid).jpg"
        }
        
        let mimeType = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
    }
    
    func uploadPost() {
        let id = user!["id"] as! String
        uuid = UUID().uuidString
        let text = postTextView.text.trunc(140) as String
        let url = URL(string: pathToPosts)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let param = [
            "id": id,
            "uuid": uuid,
            "text": text
        ]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        
        if postImageView.image != nil {
            imageData = UIImageJPEGRepresentation(postImageView.image!, 0.5)!
        }
        
        request.httpBody = createBodyWith(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard let parseJSON = json else {
                            print("Error while parsing in PostVC")
                            return
                        }
                        print(parseJSON)
                        let message = parseJSON["message"]
                        
                        if message != nil {
                            print("Successfully posted!")
                            self.charactersLbl.text = "140"
                            self.postTextView.text = ""
                            self.postImageView.image = nil
                            self.postBtn.isEnabled = false
                            self.postBtn.alpha = 0.4
                            self.imageSelected = false
                            
                            self.tabBarController?.selectedIndex = 0
                        }
                    } catch {
                        DispatchQueue.main.async(execute: {
                            let message = String(error.localizedDescription)
                            appDelegate.showInfoView(message: message, color: customOrange)
                        })
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        let message = String(error.debugDescription)
                        appDelegate.showInfoView(message: message, color: customOrange)
                    })
                }
            })
        }.resume()
    }
    
    //MARK: - IBActions
    @IBAction func postBtnWasPressed(_ sender: Any) {
        if !postTextView.text.isEmpty && postTextView.text.count <= 140 {
            uploadPost()
        }
    }
    
    @IBAction func selectPicBtnWasPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
}

//MARK: - UITextFieldDelegate

extension PostVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text.count
        let spacing = CharacterSet.whitespacesAndNewlines
        charactersLbl.text = String(140 - chars)
        
        if chars > 140 {
            charactersLbl.textColor = colorSmoothRed
            configurePostButton(alpha: 0.5, isEnabled: false)
        } else if postTextView.text.trimmingCharacters(in: spacing).isEmpty {
            configurePostButton(alpha: 0.5, isEnabled: false)
        } else {
            charactersLbl.textColor = customBlue
            configurePostButton(alpha: 1.0, isEnabled: true)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension PostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        postImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // cast as a true to save image file in server
        if postImageView.image == info[UIImagePickerControllerEditedImage] as? UIImage {
            imageSelected = true
        }
    }
}

//MARK: - String extension

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.count > length {
            return self.substring(to: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}








