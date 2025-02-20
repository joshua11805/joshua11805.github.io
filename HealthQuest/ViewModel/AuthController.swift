//
//  AuthController.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/2/24.
//
import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

//using @Observable instead of @ObservableObject
//apparently it is SUPERIOR
class AuthController: ObservableObject {
    
    @Published var authState: AuthState = .undefined
    @Published var isLoading = false
    //Ignore, 
    var userProfile: UserProfile = UserProfile(userID: "pLXjvSg498dY6IML7Rd0sotWGou2", dateCreated: Date())
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init(){
        startListeningToAuthState()
        print("working console")
    }
    
    
    func startListeningToAuthState() {
        if let user = Auth.auth().currentUser {
            self.authState = .authenticated
        } else {
            self.authState = .notAuthenticated
        }
        authStateListener = Auth.auth().addStateDidChangeListener { _, user in
            self.authState = user != nil ? .authenticated : .notAuthenticated
        }
    }
    
    func stopListeningtoAuthState(){
        if let listener = authStateListener{
            Auth.auth().removeStateDidChangeListener(listener)
            authStateListener = nil
        }
    }
    
//this function is triggered from SignInView and provides a UIKit View to render the google sign-in page
//will have the user sign in, check for success, check if user exists in my Firestore, does this via call to checkUserProfile,
//checkUserProfile is a void function that simply checks if user exists, and if not calls another function createUserProfile that will generate a new user in database
    @MainActor
    func signIn() async throws {
        self.isLoading = true
        // Signing into Google
        guard let rootViewController = UIApplication.shared.firstKeyWindow?.rootViewController
        else {
            self.authState = .notAuthenticated
            self.isLoading = false
            return
        }
        guard let clientID = FirebaseApp.app()?.options.clientID
        else {
            self.authState = .notAuthenticated
            self.isLoading = false
            return
        }
        
        // Configuring Google Sign-In
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        do {
            // Present Google Sign-In
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            // Retrieve ID token and access token
            guard let idToken = result.user.idToken?.tokenString else { return }
            let accessToken = result.user.accessToken.tokenString
            
            // Create Firebase credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Sign into Firebase
            let authResult = try await Auth.auth().signIn(with: credential)
            
            // After sign-in, check if the user is successfully signed in
            if let user = Auth.auth().currentUser {
                print("Successfully signed in with Firebase UID: \(user.uid)")
                let creationDate = user.metadata.creationDate ?? Date()
                if user.metadata.creationDate == nil {
                    print("user does not have a creation date in firebaseAuth, but carrying on")
                }
                await checkUserProfile(userID: user.uid, createdOn: creationDate)
                //marking the user authenticated
            } else {
                print("User not signed in")
                self.authState = .notAuthenticated
                // Handle the case where the user is not signed in (maybe show an error message)
            }
        } catch {
            print("Error during sign-in: \(error.localizedDescription)")
            self.authState = .notAuthenticated
            // Handle the error (for example, show a message to the user)
        }
        
        self.isLoading = false
    }
        
    func signOut() throws{
        do {
            try Auth.auth().signOut()
            stopListeningtoAuthState()
            self.authState = .notAuthenticated
        } catch {
            print("Error signing out \(error.localizedDescription)")
        }
    }
        
        //User Profile
        //checks if user profile exists, and if not creates on by calling createUserProfile
    func checkUserProfile(userID: String, createdOn: Date) async{
        let userRef = db.collection("users").document(userID)
        do {
            let document = try await userRef.getDocument()
            
            if document.exists{
                print("User exists, continue on")
                self.authState = .authenticated
            } else {
                print("User does not exist, creating a new profile")
                await createUserProfile(userID: userID, dateCreated: createdOn)
            }
        } catch {
            print("Error checking user existence: \(error.localizedDescription)")
            self.authState = .notAuthenticated
        }
    }

    //not technically asynchrounous but dealing with Firestore
    //essentially makes it asynchrounous
    //need to update the launchview to run this before
    //calling load on the player
    @MainActor
    func createUserProfile(userID: String, dateCreated: Date) async{
        //creating a new user
        let userRef = db.collection("users").document(userID)
        let userProfileData: [String: Any] = [
            "userID": userID,
            "createdOn": dateCreated
        ]
        
        do {
            try await userRef.setData(userProfileData)
            print("User created successfully")
            
            self.userProfile = UserProfile(userID: userID, dateCreated: dateCreated)
            
            let plantDataRef = userRef.collection("plantData")
            for i in 1...9{
                let plantID = "plant\(i)"
                let plantData: [String: Any] = [
                    "id": plantID,
                    "plantState": PlantState.healthy.rawValue,
                    "plantType": PlantType.none.rawValue
                ]
                try await plantDataRef.document(plantID).setData(plantData)
                print("plant\(plantID) successfully added")
            }
            //there may or may not be errors here depending on if this populates firebase correctly, but the thought process is, once the data has been populated it is safe to move on, the next step would be for PVM to call load() which will access these plants
            self.authState = .authenticated
        } catch {
            print("Error creating user profile or adding plants")
            self.authState = .notAuthenticated
        }
    }
    
    func getUserID() -> String? {
        let id = userProfile.userID
        return id
    }
    
}

//use of UIKit
//UIApplication is part of UIKit,
extension UIApplication {
    var firstKeyWindow: UIWindow?{
        let scenes = connectedScenes.compactMap { $0 as? UIWindowScene }
        let activeScenes = scenes.filter{ $0.activationState == .foregroundActive }
        
        return activeScenes.first?.windows.first(where: { $0.isKeyWindow })
    }
}
