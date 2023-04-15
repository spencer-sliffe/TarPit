//
//  AccountViewModel.swift
//  TARpit
//
//  Created by Spencer SLiffe on 4/14/23.
//

import Firebase
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var account: Account?
    @Published var isLoading3 = true
    @Published var userPosts: [Post] = []
    
    init() {
        fetchAccount()
    }
    
    func fetchAccount() {
        guard let user = Auth.auth().currentUser else {
            print("Error: No user is currently signed in.")
            return
        }
        // Make API call to fetch account data from backend using the user's ID
        let db = Firestore.firestore()
        let ref = db.collection("Accounts").document(user.uid)
        ref.getDocument { (document, error) in
            guard let document = document, document.exists, error == nil else {
                print("Error fetching account data: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let data = document.data()!
            let email = user.email ?? ""
            let subscription = data["subscription"] as? Bool ?? false
            var account = Account(id: user.uid, email: email, subscription: subscription, packageData: nil, profilePicture: nil)
            
            self.account = account
            self.isLoading3 = false
        }
    }
}