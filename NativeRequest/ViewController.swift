//
//  ViewController.swift
//  NativeRequest
//
//  Created by Erick Ayala Delgadillo on 13/05/22.
//

import UIKit

class ViewController: UIViewController {

    //decalaramos objeto table view
    var tablev = UITableView()
    var personajes = [[String: Any]]()
    let ri = "reuseId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //esta llamada es para que comience el monitoreo de internet, y cuando la vista ya se muestra el status ya esté actualizado
        let _ = InternetStatus.instance
        
        // Establece el frame para que la tabla ocupe el tamaño de la vista
        /*
        self.view.frame     // propiedades "generales" respecto al superview
        self.view.bounds    // propiedades "especificas" respeco a la horientación del dispositivo
         */
        tablev.frame = self.view.bounds
        self.view.addSubview(tablev)
        tablev.register(UITableViewCell.self, forCellReuseIdentifier: ri) //se debe registrar la celda a reciclar
        tablev.delegate = self
        tablev.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if InternetStatus.instance.internetType == .none {
            let alert = UIAlertController(title: "ERRRORRRRRR!!!", message: "no hay conexión a internet!!!!!!", preferredStyle: .alert)
            let boton = UIAlertAction(title: "Ok", style: .default) { alert in
                // se cierra el app (es como provocar un crash)
                exit(666)
            }
            alert.addAction(boton)
            self.present(alert, animated:true)
        }
        else if InternetStatus.instance.internetType == .cellular {
            let alert = UIAlertController(title: "Confirme", message: "Solo hay conexión a internet por datos celulares", preferredStyle: .alert)
            let boton1 = UIAlertAction(title: "Continuar", style: .default) { alert in
                self.descargar()
            }
            let boton2 = UIAlertAction(title: "Cancelar", style: .cancel)
            alert.addAction(boton1)
            alert.addAction(boton2)
            self.present(alert, animated:true)
        }
        else {
            self.descargar()
        }
    }
    
    func descargar() {
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            //clases que empiezan en NS se basan en NS foundation
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            //definimos el objeto task
            let tarea = sesion.dataTask(with: request as URLRequest) { datos, respuesta, error in
                if error != nil {
                    print ("algo salio mal \(error?.localizedDescription)")
                }
                else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: datos!, options: .fragmentsAllowed) as! [String: Any]
                        print(json)
                        //datos = json["results"]
                        self.personajes = json["results"] as! [[String: Any]]
                        // se debe especificar que ocupe el hilo
                        DispatchQueue.main.async {
                            self.tablev.reloadData()
                        }
                        
                    }
                    catch {
                        print("algo salio mal\(error.localizedDescription)")
                    }
                    
                }
            }
            //indicamos que la tarea está lista para iniciar, en el momento que el objeto URL Session le de prioridad
            tarea.resume()
        }
    }
     
}


// para utilizar los protocolos del tableview
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ri, for: indexPath)
        let dict = personajes[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String ?? "Un personaje"
        cell.detailTextLabel?.text = dict["name"] as? String ?? "Un personaje"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detalles", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            case "detalles":
                let detailsVC = segue.destination as! DetalleViewController
                if let indexPath = tablev.indexPathForSelectedRow {
                    let personaje = personajes[indexPath.row]
                    detailsVC.personaje = personaje //agregar como miembro de la clase VC a drinkName
                    tablev.deselectRow(at: indexPath, animated: true)
                }

            default:
                print("reloading data...")//self.tableView.reloadData()
        }
        
    }
    
    
}

