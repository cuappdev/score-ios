//
//  ProfileViewModel.swift
//  score-ios
//
//  Created by Duru Alayli on 3/11/26.
//

import SwiftUI

// MARK: - ViewModel
class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    static let shared = ProfileViewModel()
    
    // MARK: - Functions
    init() {
        let name = UserDefaults.standard.string(forKey: "name") ?? "Name"
        let username = UserDefaults.standard.string(forKey: "username") ?? "username"
        let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? "profile0"
        
        self.user = User(name: name, username: username, profileImage: profileImage)
    }
    
    func saveUser(name: String, username: String, profileImage: String) {
        user.name = name
        user.username = username
        user.profileImage = profileImage
        
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(profileImage, forKey: "profileImage")
    }
}
