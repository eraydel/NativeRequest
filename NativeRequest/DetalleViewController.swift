//
//  DetalleViewController.swift
//  NativeRequest
//
//  Created by Erick Ayala Delgadillo on 14/05/22.
//

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var especie: UILabel!
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    var tmpImage: String!
    var personaje = [String: Any]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nombre.text = personaje["name"] as? String
        tmpImage = (personaje["image"] as? String)!
        if let url = NSURL(string: tmpImage ) {
            if let data = NSData(contentsOf: url as URL) {
                imagen?.image = UIImage(data: data as Data)
          }
        }
        especie.text = personaje["species"] as? String
        tipo.text = personaje["created"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nombre.text = personaje["name"] as? String
        // Do any additional setup after loading the view.
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
