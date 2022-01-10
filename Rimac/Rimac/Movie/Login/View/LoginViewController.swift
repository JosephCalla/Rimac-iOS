//
//  LoginViewController.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var validarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showMovies() {
        let validUser = "Admin"
        let code = "Password*123"
        if userText.text == validUser && passwordText.text == code {
            goToMovies()
        }
    }
    
    func goToMovies() {
        let vc = UIStoryboard.init(name: "MovieViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    @IBAction func validarPressedButton(_ sender: UIButton) {
        showMovies()
    }
}
