//
//  UserManagerKey.swift
//  MediTracker
//
//  Created by Agata Przykaza on 26/11/2023.
//
//  Dostęp do zmiennej
import Foundation
import SwiftUI

struct UserManagerKey: EnvironmentKey {
    static let defaultValue = UserManager()
}

extension EnvironmentValues {
    var userAuthManager: UserManager {
        get { self[UserManagerKey.self] }
        set { self[UserManagerKey.self] = newValue }
    }
}
