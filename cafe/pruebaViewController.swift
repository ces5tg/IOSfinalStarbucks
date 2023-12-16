//
//  pruebaViewController.swift
//  cafe
//
//  Created by cesar pacho on 16/12/23.
//

import UIKit

class pruebaViewController: UIViewController {
    let tuViewController = pruebaViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Establecer el tamaño preferido (por ejemplo, 400 px de altura)
                self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
        
        tuViewController.modalPresentationStyle = .overCurrentContext  // O el estilo que prefieras
        present(tuViewController, animated: true, completion: nil)
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
