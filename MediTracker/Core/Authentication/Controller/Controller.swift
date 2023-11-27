//
//  Controller.swift
//  MediTracker
//
//  Created by Agata Przykaza on 27/11/2023.
//

import Foundation

class Controller: ObservableObject{
    
    @Published  var userManager: UserManager
    @Published var profileListManager: ProfilesListManager
    @Published var profileManager: ProfileManager
    
    init(userManager: UserManager, profileListManager: ProfilesListManager, profileManager: ProfileManager) {
        self.userManager = userManager
        self.profileListManager = profileListManager
        self.profileManager = profileManager
    }
}
