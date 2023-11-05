//
//  Medicine.swift
//  MediTracker
//
//  Created by Agata Przykaza on 05/11/2023.
//

import Foundation

struct Medicine: Identifiable {
    var id = UUID()
    var name: String
    var time: String
    var quantity: Float
    var type: String
    var jednostka: String?
}
