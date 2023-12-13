//
//  listLocalesViewController.swift
//  cafe
//
//  Created by cesar pacho on 5/12/23.
//

import UIKit
import FirebaseDatabase
class listLocalesViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if locales1.count == 0 {
            
            cell.textLabel?.text =  "nada"
            
            cell.detailTextLabel?.text =  "nada"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        }else {
            let local = locales1[indexPath.row]
            cell.textLabel?.text = "\( local.nombre)"
            
            cell.detailTextLabel?.text = "\( local.direccion)"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locales1.count == 0{
            return 1
        }else{
            return locales1.count
        }
        
    }

    var locales1 = [locales]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.cargarDatos()
        // Do any additional setup after loading the view.
    }
    func cargarDatos() {
            let productosRef = Database.database().reference().child("locales")
            productosRef.observe(.value) { (snapshot) in
                self.locales1.removeAll()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let productoData = childSnapshot.value as? [String: Any] {
                        let local = locales()
                        local.nombre = productoData["nombre"] as? String ?? ""
                        local.imagenURL = productoData["imagenURL"] as? String ?? ""
                        local.direccion = productoData["direccion"] as? String ?? ""
                        local.coordenada1 = productoData["coordenada1"] as? String ?? ""
                        local.coordenada2 = productoData["coordenada2"] as? String ?? ""
                        local.id = childSnapshot.key

                        self.locales1.append(local)
                    }
                }
                print("xxxxxxxxxxxxxxxxxxxx")
                print("\(self.locales1)")
                
               
    
                self.tableView.reloadData()
            }
        
    }



}
