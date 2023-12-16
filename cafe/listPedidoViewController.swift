//
//  listPedidoViewController.swift
//  cafe
//
//  Created by cesar pacho on 1/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
extension Notification.Name {
    static let borrarSeleccionados = Notification.Name("borrarSeleccionados")
    static let updateSeleccionados = Notification.Name("udpateSeleccionados")
}
class listPedidoViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    
    
    
    var listaDetalles = [detalleProductos]()
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func btnHacerPedido(_ sender: Any)  {
        
        let currentDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        print("Fecha actual: \(formattedDate)")
                var idenificador = NSUUID().uuidString
                var usuario = Auth.auth().currentUser?.uid ?? ""
        var pedido: [String: Any] = [:]

        pedido["user"] = "\(usuario)"
        pedido["dia"] = "\(formattedDate)"
        
        var suma = 0
        for detalleProducto in self.listaDetalles {
            let item = [
                "idProducto": "\(detalleProducto.idProducto)",
                "nombre": "\(detalleProducto.nombre)",
                "precio": detalleProducto.precio,
                "cantidad": detalleProducto.cantidad,
                "total": detalleProducto.total
            ] as [String : Any]

            pedido["detalles"] = (pedido["detalles"] as? [[String: Any]] ?? []) + [item]
            suma += detalleProducto.total
            pedido["total"] = "\(suma)"
        }

        
        print("inicio de database")

        let pedidosRef = Database.database().reference().child("pedidos").child("\(idenificador)").setValue(pedido)

    
        print("se inserto")
        NotificationCenter.default.post(name: .borrarSeleccionados, object: nil, userInfo: ["productos": self.productosSeleccionados2])
        self.listaDetalles = []
        self.countPrecio = 0
        lblTotal.text = "\(countPrecio)"
        
        tableView.reloadData()
        self.listaDetalles.removeAll()
        //self.performSegue(withIdentifier: "seguePedidoEnviado", sender: nil)
        print("Notificación enviada desde PrimerViewController")
    }
    var productosSeleccionados2 = [Productos]()//vacio
        
    var listaProductos = [Productos]()
    var countPrecio = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaDetalles.count == 0{
            return 1
        }else{
            return listaDetalles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("zzzzz entro al table cell \(listaDetalles)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if listaDetalles.count == 0{
            cell.textLabel?.text = "no tienes snaps"
            cell.detailTextLabel?.text = "nada"
            cell.imageView?.image = UIImage(systemName: "circle.fill")
        } else {
                let producto = listaDetalles[indexPath.row]
                cell.textLabel?.text = " \(producto.nombre)"
            cell.detailTextLabel?.text = " S/. \(producto.precio)      und : \(producto.cantidad)"
                
            self.countPrecio = self.countPrecio + (Int(producto.precio) ?? 0)
            lblTotal.text = "\(self.countPrecio)"
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(datosActualizados(_:)), name: .datosActualizados, object: nil)
    }
    deinit {
            // Desinscribirse de la notificación
            NotificationCenter.default.removeObserver(self)
        }
    @objc func datosActualizados(_ notification: Notification) {
        print("Ç44-44444  esta entrando a datos ACTUALIZADOS  $$$$$$$$$$$$$$$")
        if let productosSeleccionados = notification.userInfo?["productos"] as? [Productos] {
//
//            print("\(productosSeleccionados)")
//            print("recibido")
//
//
//            let detalle = detalleProductos()
//            detalle.nombre = productosSeleccionados.nombre
//            detalle.precio = productosSeleccionados.precio
//            detalle.cantidad = 1 // Puedes ajustar esto según tus necesidades
//            detalle.total = 1    // Puedes ajustar esto según tus necesidades
//            detalle.idProducto = productosSeleccionados.id
//
//            self.listaDetalles.append(detalle)
//            tableView.reloadData()
//            print("termino dsafdjalñ")
//
//            self.listaProductos = productosSeleccionados
            // Procesa la lista de productos seleccionados
//            print("Productos seleccionados actualizados:")
            self.listaDetalles.removeAll()
            for producto in self.listaProductos {
                let detalle = detalleProductos()

                // Asigna valores desde el producto actual
                detalle.nombre = producto.nombre
                detalle.precio = producto.precio
                detalle.cantidad = 1 // Puedes ajustar esto según tus necesidades
                detalle.total = 1    // Puedes ajustar esto según tus necesidades
                detalle.idProducto = producto.id

                // Agrega el detalle a la lista
                self.listaDetalles.append(detalle)
            }
            print("==========================================================")
            print(self.listaDetalles)
            print("==========================================================")

            tableView.reloadData()

        }
        print("aqui no habia ndad")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Elimina el elemento del array
            let seleccionado = listaDetalles[indexPath.row]
            listaDetalles.remove(at: indexPath.row)
            self.countPrecio = 0
            self.lblTotal.text = "0"
            
            // Actualiza la tabla para reflejar los cambios
            tableView.reloadData()
            
            // Envia la notificación sin el error de sintaxis
            NotificationCenter.default.post(name: .updateSeleccionados, object: nil, userInfo: ["productos": seleccionado.idProducto])
            
            print("Has presionado")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listaDetalles.count > 0{
            let detalleSeleccionado = listaDetalles[indexPath.row]

                // Aumenta la cantidad
                detalleSeleccionado.cantidad += 1

                // Actualiza el total multiplicando la cantidad por el precio
                detalleSeleccionado.total = detalleSeleccionado.cantidad * detalleSeleccionado.precio

                // Actualiza la celda en la interfaz
                tableView.reloadRows(at: [indexPath], with: .automatic)
            print(" +++++   \(detalleSeleccionado.cantidad)")
            print(" +++++   \(detalleSeleccionado.precio)")
            print(" +++++   \(detalleSeleccionado.total)")
            print(" +++++   \(detalleSeleccionado.nombre)")
        }else{
            print("no hay datos")
        }
        
        }
}
