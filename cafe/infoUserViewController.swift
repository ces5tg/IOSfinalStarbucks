//
//  infoUserViewController.swift
//  cafe
//
//  Created by cesar pacho on 28/11/23.
//

import UIKit
import FirebaseAuth

class infoUserViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBAction func AgregarProductoButton(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "segueInsertarProducto", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            // El usuario está autenticado
            lblEmail.text = user.email
            
        } else {
            // No hay usuario autenticado
            print("No hay usuario autenticado.")
        }
        // Do any additional setup after loading the view.
    }

}
