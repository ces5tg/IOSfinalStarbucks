//
//  historialViewController.swift
//  cafe
//
//  Created by cesar pacho on 16/12/23.
//

import UIKit
import FirebaseDatabase
class historialViewController: UIViewController,UITableViewDataSource , UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if listaPedidos.count == 0 {
            
            cell.textLabel?.text =  "nada"
            
            cell.detailTextLabel?.text =  "nada"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        }else {
            let local = listaPedidos[indexPath.row]
            cell.textLabel?.text = "\( local.dia)"
            
            cell.detailTextLabel?.text = "\( local.total)"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaPedidos.count == 0{
            return 1
        }else{
            return listaPedidos.count
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seleccionado = listaPedidos[indexPath.row]
        print("\(seleccionado.dia)")
        print("\(seleccionado.detalles)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.cargarDatos()
        // Do any additional setup after loading the view.
    }
    
    var listaPedidos = [historial]()
    func cargarDatos() {
            let productosRef = Database.database().reference().child("pedidos")
            productosRef.observe(.value) { (snapshot) in
                self.listaPedidos.removeAll()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let productoData = childSnapshot.value as? [String: Any] {
                        
                        print("productoData: \(productoData)")
                        
                        let local = historial()
                        local.dia = productoData["dia"] as? String ?? ""
                        local.total = productoData["total"] as? String ?? ""
                        local.user = productoData["user"] as? String ?? ""
                        
                        var detallesArray: [historialDetalles] = []
                        if let detallesData = productoData["detalles"] as? [String: [String: Any]] {
                            print("detallesData: \(detallesData)")
                            
                            for (_, detalle) in detallesData {
                                
                                let historialDetalle = historialDetalles()
                                historialDetalle.cantidad = detalle["cantidad"] as? Int ?? 0
                                historialDetalle.idProducto = detalle["idProducto"] as? String ?? ""
                                historialDetalle.nombre = detalle["nombre"] as? String ?? ""
                                historialDetalle.precio = detalle["precio"] as? Int ?? 0
                                historialDetalle.total = detalle["total"] as? Int ?? 0
                                
                                detallesArray.append(historialDetalle)
                            }
                        }
                        
                        local.detalles = detallesArray
                        print("detalles ARRAY \(local.detalles)")
                        self.listaPedidos.append(local)
                    }
                }

                print("xxxxxxxxxxxxxxxxxxxx")
                print("\(self.listaPedidos)")
                
               
    
                self.tableView.reloadData()
            }
        
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
