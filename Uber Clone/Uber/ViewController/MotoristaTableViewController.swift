//
//  MotoristaTableViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 24/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class MotoristaTableViewController: UITableViewController, CLLocationManagerDelegate {

    var listaRequisicoes : [DataSnapshot] = []
    var gerenciadorLocalizacao = CLLocationManager()
    var localMotorista = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        let database = Database.database().reference()
        let requisicoes = database.child("requisicoes")
        
        requisicoes.observe(.value) { (snapshot) in
            self.listaRequisicoes = []
            if snapshot.value != nil {
                for filho in snapshot.children {
                    self.listaRequisicoes.append(filho as! DataSnapshot)
                }
            }
            
            self.tableView.reloadData()
        }
        
        requisicoes.observe(.childRemoved) { (snapshot) in
            var indice = 0
            for requisicao in self.listaRequisicoes {
                if requisicao.key == snapshot.key {
                    self.listaRequisicoes.remove(at: indice)
                }
                indice = indice + 1
            }
            
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordenadas = manager.location?.coordinate {
            self.localMotorista = coordenadas
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listaRequisicoes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaMotorista", for: indexPath)
        
        let snapshot = self.listaRequisicoes[indexPath.row]
        if let dados = snapshot.value as? [String: Any] {
            
            if let latPassageiro = dados["latitude"] as? Double {
                if let lonPassageiro = dados["longitude"] as? Double {
                    
                    let motoristaLocation = CLLocation(latitude: self.localMotorista.latitude, longitude: self.localMotorista.longitude)
                    let passageiroLocation = CLLocation(latitude: latPassageiro, longitude: lonPassageiro)
                    let distanciaMetros = motoristaLocation.distance(from: passageiroLocation)
                    
                    let distanciaKM = round(distanciaMetros / 1000)
                    
                    var requisicaoMotorista = ""
                    if let emailMotoristaR = dados["motoristaEmail"] as? String {
                        let autenticao = Auth.auth()
                        if let emailM = autenticao.currentUser?.email {
                            if emailMotoristaR == emailM {
                                requisicaoMotorista = " {ANDAMENTO}"
                                if let status = dados["status"] as? String {
                                    if status == StatusCorrida.ViagemFinalizada.rawValue {
                                        requisicaoMotorista = " {FINALIZADA}"
                                    }
                                }
                            }
                        }
                    }
                    
                    if let nomePassageiro = dados["nome"] as? String {
                        celula.textLabel?.text = "\(nomePassageiro) \(requisicaoMotorista)"
                        celula.detailTextLabel?.text = "\(distanciaKM) KM de distância"
                    }
                }
            }
            
        }

        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = self.listaRequisicoes[indexPath.row]
        self.performSegue(withIdentifier: "segueAceitarCorrida", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAceitarCorrida" {
            if let confirmarVC = segue.destination as? ConfirmarRequisicaoViewController {
                confirmarVC.localMotorista = self.localMotorista
                
                if let snapshot = sender as? DataSnapshot {
                    if let dados = snapshot.value as? [String: Any] {
                        confirmarVC.nomePassageiro = (dados["nome"] as? String)!
                        confirmarVC.emailPassageiro = (dados["email"] as? String)!
                        confirmarVC.localPassageiro = CLLocationCoordinate2D(latitude: (dados["latitude"] as? Double)!, longitude: (dados["longitude"] as? Double)!)
                    }
                }
                
                
            }
        }
    }
    
    @IBAction func deslogarMotorista(_ sender: Any) {
        let autenticacao = Auth.auth()
        do {
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("não foi possível deslogar!")
        }
    }
}
