//
//  LogInViewController.swift
//  Cinemapp
//
//  Created by Hilario Cuervo on 22/01/2022.
//

import UIKit
import FirebaseAuth


class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    private let viewModel = LogInViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
}


// MARK: - @IBActions

extension LogInViewController {
    
    @IBAction func logInPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email != "" && password != "" {
                
                viewModel.logIn(email: email, password: password) { error in
                    
                    if let e = error {
                        self.reportError(error: "Ocurrio un error en el inicio de sesion.", message: e.localizedDescription)
                    } else {
                        self.validateAccess()
                    }
                }
                
            } else {
                warningLabel.isHidden = false
            }
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email != "" && password != "" {
                
                viewModel.signUp(email: email, password: password) { error in
                    
                    if let e = error {
                        self.reportError(error: "Ocurrio un error en el registro.", message: e.localizedDescription)
                    } else {
                        self.validateAccess()
                    }
                }
                
            } else {
                warningLabel.isHidden = false
            }
        }
    }
    
}


// MARK: - SetUp

extension LogInViewController {
    
    private func setUpUI() {
        logInButton.layer.cornerRadius = logInButton.frame.size.height / 8
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 8
        warningLabel.isHidden = true
    }
    
}


// MARK: - Auxiliary methods & Error report

extension LogInViewController {
    
    private func validateAccess() {
        warningLabel.isHidden = true
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    private func reportError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
