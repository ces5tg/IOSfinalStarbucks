//
//  listPedidoViewController.swift
//  cafe
//
//  Created by cesar pacho on 1/12/23.
//

import UIKit

class tableViewCellNuevo :UITableViewCell{
    
    var contador = 1
    var delegate: TableViewCellDelegate?
    
    @IBOutlet weak var imageCellView: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblContador: UILabel!
    
    @IBAction func btnMenos(_ sender: Any) {
        if contador > 1 {
            self.contador -= 1
            lblContador.text = "\(self.contador)"
            
            //        if let tableView = superview as? UITableView, let viewController = tableView.delegate as? listPedidoViewController {
            //            viewController.countPrecio += 1
            //            viewController.actualizarPrecio() // Llamada al método de actualización de precio
            //        }
        } else {
            self.mostrarAlerta(titulo: "ELIMINAR", mensaje: "Esta seguro de eliminar el producto", accion: "aceptar")
        }
    }
    
    @IBAction func btnMas(_ sender: Any) {
        self.contador += 1
        print(self.contador)
        lblContador.text = "\(self.contador)"
        
        if let tableView = superview as? UITableView {
            if let indexPath = tableView.indexPath(for: self) {
                delegate?.actualizarContadorEnCelda(self)
            }
        }
    }



    func mostrarAlerta(titulo:String , mensaje:String , accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: accion, style: .default) { _ in
            if let tableView = self.superview as? UITableView, let viewController = tableView.delegate as? listPedidoViewController {
                // Eliminar el producto de la lista
                if let indexPath = tableView.indexPath(for: self) {
                    viewController.listaProductos.remove(at: indexPath.row)
                    viewController.actualizarTabla()  // Método para actualizar la interfaz de usuario
                }
            }
            
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive){ _ in
            self.contador = 1
            self.lblContador.text = "\(self.contador)"
            
        }
        alerta.addAction(cancelar)
        alerta.addAction(accionAceptar)
        if let tableView = superview as? UITableView, let viewController = tableView.delegate as? listPedidoViewController {
            viewController.present(alerta, animated: true, completion: nil)
        }
    }
    
}

protocol TableViewCellDelegate: AnyObject {
    func actualizarContadorEnCelda(_ cell: tableViewCellNuevo)
}

class listPedidoViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate ,  TableViewCellDelegate {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var listaProductos = [Productos]()
    var listaDetalles = [detalleProductos]()
    var countPrecio = 0
    
    func actualizarTabla() {
        tableView.reloadData()
    }
    func actualizarPrecio() {
        self.lblTotal.text = "\(countPrecio)"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaProductos.count == 0{
            return 1
        }else{
            return listaDetalles.count
        }
        
    }
    func actualizarContadorEnCelda(_ cell: tableViewCellNuevo) {
           // Aquí actualiza la cantidad y el total en la listaDetalles según tu lógica
           if let indexPath = tableView.indexPath(for: cell) {
               // Obtén el producto correspondiente desde tu listaProductos
               let producto = listaDetalles[indexPath.row]
               
               // Filtra y modifica el array listaDetalles
               listaDetalles = listaDetalles.map { detalle in
                   var detalleModificado = detalle
                   if detalleModificado.nombre == producto.nombre {
                       detalleModificado.cantidad = cell.contador
                       
                       let cantidad = detalleModificado.cantidad
                       let precio = producto.precio
                       let total = cantidad * precio
                       detalleModificado.total = total
                   }
                   return detalleModificado
               }
              
 
                   tableView.reloadData()
            
               
               // Actualiza la interfaz según sea necesario
               tableView.reloadRows(at: [indexPath], with: .none)
           }
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("entro al table cell \(listaProductos)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! tableViewCellNuevo
        cell.delegate = self
        if listaDetalles.count == 0{
            cell.lblNombre.text = "no hay nada"
            cell.lblPrice.text = "01"
            cell.lblContador.text  = "22"
            cell.imageCellView.image = UIImage(systemName: "circle.fill")
        }else {
            let producto = listaDetalles[indexPath.row]
            cell.lblNombre.text = producto.nombre
            cell.lblPrice.text = "\(producto.precio)"
            cell.lblContador.text  = "\(cell.contador)"
            cell.imageCellView.image = UIImage(systemName: "circle.fill")
            self.countPrecio = self.countPrecio + (producto.precio ?? 0)
            lblTotal.text = "\(self.countPrecio)"
            
            
        }
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        if listaProductos.count == 0{
        //            cell.textLabel?.text = "no tienes snaps"
        //            cell.detailTextLabel?.text = "nada"
        //            cell.imageView?.image = UIImage(systemName: "circle.fill")
        //        } else {
        //                let producto = listaProductos[indexPath.row]
        //                cell.textLabel?.text = " \(producto.nombre)"
        //                cell.detailTextLabel?.text = " S/. \(producto.precio)"
        //                print("zzz\(producto.imagenURL)")
        //            self.countPrecio = self.countPrecio + (Int(producto.precio) ?? 0)
        //            lblTotal.text = "\(self.countPrecio)"
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
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Establece un valor estimado, puede ser ajustado según tus necesidades
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        NotificationCenter.default.addObserver(self, selector: #selector(datosActualizados(_:)), name: .datosActualizados, object: nil)
        tableView.reloadData()
    }
    deinit {
        // Desinscribirse de la notificación
        NotificationCenter.default.removeObserver(self)
    }
    @objc func datosActualizados(_ notification: Notification) {
        if let productosSeleccionados = notification.userInfo?["productos"] as? [Productos] {
            self.listaProductos = productosSeleccionados
            // Procesa la lista de productos seleccionados
            for producto in self.listaProductos {
                let detalle = detalleProductos()
                
                // Asigna valores desde el producto actual
                detalle.nombre = producto.nombre
                detalle.precio = producto.precio
                detalle.cantidad = 0 // Puedes ajustar esto según tus necesidades
                detalle.total = 0    // Puedes ajustar esto según tus necesidades
                detalle.idProducto = producto.id
                 
                // Agrega el detalle a la lista
                self.listaDetalles.append(detalle)
            }
            print("==========================================================")
            print(self.listaDetalles)
            print("==========================================================")
            print("Productos seleccionados actualizados:")
//            for producto in productosSeleccionados {
//                print("Nombre: \(producto.nombre), Precio: \(producto.precio)")
//            }
            tableView.reloadData()
            
            // Puedes actualizar la interfaz de usuario o realizar otras acciones según sea necesario
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
