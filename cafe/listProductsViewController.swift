//
//  listProductsViewController.swift
//  cafe
//
//  Created by cesar pacho on 1/12/23.
//

import UIKit
import FirebaseDatabase
import SDWebImage
extension Notification.Name {
    static let datosActualizados = Notification.Name("datosActualizados")
}

class listProductsViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    
    
    @IBOutlet weak var lblCountItems: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productos.count == 0{
            return 1
        }else{
            return productos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("entro al table cell \(productos)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if productos.count == 0{
            cell.textLabel?.text = "no tienes snaps"
            cell.detailTextLabel?.text = "nada"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        } else {
                let producto = productos[indexPath.row]
                cell.textLabel?.text = " \(producto.nombre)"
                cell.detailTextLabel?.text = " S/. \(producto.precio)"
                print("zzz\(producto.imagenURL)")
//                if let imageURL = URL(string: producto.imagenURL) {
//                  
//                    print("ddddd\(producto.imagenURL)")
//                            DispatchQueue.global().async {
//                                if let imageData = try? Data(contentsOf: imageURL) {
//                                    DispatchQueue.main.async {
//                                        cell.imageView?.image = UIImage(data: imageData)
//                                    }
//                                }
//                            }
//                        }
            }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seleccionado = productos[indexPath.row]

            // Verifica si el producto ya ha sido seleccionado
            if !productosSeleccionados.contains(where: { $0.nombre == seleccionado.nombre }) {
                // El producto no está en la lista, agrégalo
                self.productosSeleccionados.append(seleccionado)
                print("\(self.productosSeleccionados)")
                self.lblCountItems.text = "\(self.productosSeleccionados.count)"
                
                
                // Realiza otras acciones después de la selección, si es necesario
            } else {
                // El producto ya ha sido seleccionado, puedes mostrar un mensaje o realizar otras acciones
                print("Producto ya seleccionado")
            }
        
        NotificationCenter.default.post(name: .datosActualizados, object: nil, userInfo: ["productos": self.productosSeleccionados])
        print("Notificación enviada desde PrimerViewController")
        
    }
   
    
    @IBOutlet weak var controlSegmento: UISegmentedControl!
    
    @IBAction func elegirSegmento(_ sender: Any) {
                cargarDatos()
                filtrarProductos()
                tableView.reloadData()
        
    }
    func filtrarProductos() {
            switch controlSegmento.selectedSegmentIndex {
            case 0:
                // Filtro para el primer segmento (por ejemplo, "Categoría A")
                productos = productos.filter { $0.categoria == "1" }
            case 1:
                // Filtro para el segundo segmento (por ejemplo, "Categoría B")
                productos = productos.filter { $0.categoria == "2" }
            default:
                // Si hay más segmentos, puedes agregar más casos aquí
                break
            }
        }
    
    var productosSeleccionados = [Productos]()
    var productos = [Productos]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cargarDatos()
                
                // Configurar el UISegmentedControl
        
        controlSegmento.addTarget(self, action: #selector(elegirSegmento(_:)), for: .valueChanged)
        
    
    }
    
    
    func cargarDatos() {
            let productosRef = Database.database().reference().child("productos")
            productosRef.observe(.value) { (snapshot) in
                self.productos.removeAll()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let productoData = childSnapshot.value as? [String: Any] {
                        let producto = Productos()
                        producto.categoria = productoData["categoria"] as? String ?? ""
                        producto.imagenURL = productoData["imagenURL"] as? String ?? ""
                        producto.nombre = productoData["nombre"] as? String ?? ""
                        producto.precio = productoData["precio"] as? Int ?? 0
                        producto.id = childSnapshot.key

                        self.productos.append(producto)
                    }
                }
                print("xxxxxxxxxxxxxxxxxxxx")
                print("\(self.productos)")
                
                // Filtrar productos según el segmento seleccionado
                self.filtrarProductos()
                
                // Recargar la tabla después de obtener los datos
                self.tableView.reloadData()
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
}
