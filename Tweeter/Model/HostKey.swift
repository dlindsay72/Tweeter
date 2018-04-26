//
//  HostKey.swift
//  Tweeter
//
//  Created by Dan Lindsay on 2018-04-17.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import Foundation

enum HostKey: String {
    case uploadAva = "http://localhost:8080/TweeterBackend/uploadAva.php"
    case posts = "http://localhost:8080/TweeterBackend/posts.php"
    case login = "http://localhost:8080/TweeterBackend/login.php"
    case register = "http://localhost:8080/TweeterBackend/register.php"
    case resetPassword = "http://localhost:8080/TweeterBackend/resetPassword.php"
    case searchUsers = "http://localhost:8080/TweeterBackend/users.php"
    case updateUser = "http://localhost:8080/TweeterBackend/updateUser.php"
}
