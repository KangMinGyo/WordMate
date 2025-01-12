//
//  AuthService.swift
//  WordMate
//
//  Created by KangMingyo on 1/10/25.
//

import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    // MARK: - Singleton
    
    static let shared = AuthService()
    private init() {}
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Result<Void, Error>) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let userName = credentials.userName
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: error is \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let userData = ["email": email, "userName": userName]
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
