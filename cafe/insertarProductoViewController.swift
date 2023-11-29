//
//  insertarProductoViewController.swift
//  
//
//  Created by cesar pacho on 28/11/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
class insertarProductoViewController: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet var txtPrecio: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var imagenID = NSUUID().uuidString
    
    
    @IBAction func AgregarImagen(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true , completion: nil)
    }
    
    @IBAction func agregarProductoButton(_ sender: Any) {
        var urlImage = ""
        let imagesFolder = Storage.storage().reference().child("imagenes")
        let dataImagen = imageView.image?.jpegData(compressionQuality: 0.5)
        let cargarImagen = imagesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(dataImagen!, metadata: nil){
            (metadata , error ) in
            if error != nil {
                self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al subir la iagen", accion: "aceptar")
                print("ocurrio un error al subir la imagen \(error)")
                return
            }else{
                cargarImagen.downloadURL(completion:{(url , error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "error", mensaje: "se produjo un erro al obetener informacion de la imagen", accion: "cancelar")
                        //self.elegirContactoBoton.isEnabled = true
                        print("ocurrio un erro al obtener inforamcion de imgen \(error)")
                        return
                        
                    }
                    print("rrrrrr\(url!.absoluteString)")
                   // self.performSegue(withIdentifier: "seleccionarContactoSegue", sender:url?.absoluteString)
                    urlImage = url!.absoluteString
                    var nombre = self.txtNombre.text!
                    var categoria = self.txtCategoria.text!
                    var precio = self.txtCategoria.text!
                    var usuario = Auth.auth().currentUser
                    let snap = ["nombre": nombre , "categoria": categoria , "precio":precio , "imagenURL": urlImage]
                    Database.database().reference().child("productos").child(usuario!.uid).childByAutoId().setValue(snap)
                    self.performSegue(withIdentifier: "segueInsertarProductoRegresar", sender: nil)
                })
                
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true ,completion: nil)
        
    }
    func mostrarAlerta(titulo:String , mensaje:String , accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCancelok = UIAlertAction(title: accion, style: .default , handler: nil)
        alerta.addAction(btnCancelok)
        present(alerta , animated:  true  , completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
