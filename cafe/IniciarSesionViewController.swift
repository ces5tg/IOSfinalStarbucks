//
//  IniciarSesionViewController.swift
//  cafe
//
//  Created by cesar pacho on 28/11/23.
//

import UIKit
import FirebaseAuth
class IniciarSesionViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text! , password:passwordTextField.text!){(user , error) in
            print("intentando iniciar sesion")
            if error != nil{
                print("se presneto el siguiente error \(error)")
                self.mostrarAlerta(titulo: "error al iniciar sesion", mensaje: "deseas registrarte ?", accion: "aceptar")
            }else {
                print("incio de sesion exitoro")
                self.performSegue(withIdentifier: "segueTabBar", sender: nil)
            }
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func mostrarAlerta(titulo:String , mensaje:String , accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: accion, style: .default) { _ in
            // Esta es la acción que se ejecutará cuando se presione "Aceptar"
            self.performSegue(withIdentifier: "segueRegistrarse", sender: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive , handler: nil)
        alerta.addAction(cancelar)
        alerta.addAction(accionAceptar)
        present(alerta, animated: true, completion: nil)
    }
   


}
