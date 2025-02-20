//
//  UserProfile.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
//running out of time ill let the user add a username later
    //var name: String
    var dateCreated: Date
    @DocumentID var userID: String?
    
    init(userID: String, dateCreated: Date){
        self.userID = userID
        self.dateCreated = dateCreated
    }
    
}
