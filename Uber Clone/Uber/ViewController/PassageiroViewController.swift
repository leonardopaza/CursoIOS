//
//  PassageiroViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 23/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class PassageiroViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var enderecoDestinoCampo: UITextField!
    @IBOutlet weak var areaEndereco: UIView!
    @IBOutlet weak var marcadorLocalPassageiro: UIView!
    @IBOutlet weak var marcadorLocalDestino: UIView!
    
    @IBOutlet weak var botaoChamar: UIButton!
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var localUsuario = CLLocationCoordinate2D()
    var localMotorista = CLLocationCoordinate2D()
    var uberChamado = false
    var uberACaminho = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        self.marcadorLocalPassageiro.layer.cornerRadius = 7.5
        self.marcadorLocalPassageiro.clipsToBounds = true
        self.marcadorLocalDestino.layer.cornerRadius = 7.5
        self.marcadorLocalDestino.clipsToBounds = true
        self.areaEndereco.layer.cornerRadius = 10
        self.areaEndereco.clipsToBounds = true
        
        let database = Database.database().reference()
        let autenticacao = Auth.auth()
        
        if let emailUsuario = autenticacao.currentUser?.email {
            let requisicoes = database.child("requisicoes")
            let consultaRequisicoes = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: emailUsuario)
            
            consultaRequisicoes.observe(.childAdded) { (snapshot) in
                if snapshot.value != nil {
                    self.alternaBotaoCancelarUber()
                }
            }
            
            consultaRequisicoes.observe(.childChanged) { (snapshot) in
                if let dados = snapshot.value as? [String: Any] {
                    if let status = dados["status"] as? String {
                        if status == StatusCorrida.PegarPassageiro.rawValue {
                            if let latMotorista = dados["motoristaLatitude"] {
                                if let lonMotorista = dados["motoristaLongitude"] {
                                    self.localMotorista = CLLocationCoordinate2D(latitude: latMotorista as! CLLocationDegrees, longitude: lonMotorista as! CLLocationDegrees)
                                    self.exibirMotoristaPassageiro()
                                }
                            }
                        } else if status == StatusCorrida.EmViagem.rawValue {
                            self.alternaBotaoEmViagem()
                        } else if status == StatusCorrida.ViagemFinalizada.rawValue {
                            if let preco = dados["precoViagem"] as? Double {
                                self.alternaBotaoViagemFinalizada(preco: preco)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordenadas = manager.location?.coordinate {
            self.localUsuario = coordenadas
            
            if self.uberACaminho {
                self.exibirMotoristaPassageiro()
            } else {
                let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 200, 200)
                mapa.setRegion(regiao, animated: true)
                
                mapa.removeAnnotations(mapa.annotations)
                
                let anotacaoUsuario = MKPointAnnotation()
                anotacaoUsuario.coordinate = coordenadas
                anotacaoUsuario.title = "Seu Local"
                mapa.addAnnotation(anotacaoUsuario)
            }
        }
    }
    
    @IBAction func chamarUber(_ sender: Any) {
        let autenticacao = Auth.auth()
        let database = Database.database().reference()
        let requisicao = database.child("requisicoes")
        
        if let emailUsuario = autenticacao.currentUser?.email {
            if self.uberChamado {
                self.alternaBotaoChamarUber()
                
                let requisicao = database.child("requisicoes")
                requisicao.queryOrdered(byChild: "email")
                    .queryEqual(toValue: emailUsuario)
                    .observeSingleEvent(of: .childAdded) { (snapshot) in
                        snapshot.ref.removeValue()
                }
            } else {
                self.salvarRequisicao()
            }
        }
    }
    
    func salvarRequisicao() {
        let autenticacao = Auth.auth()
        let database = Database.database().reference()
        
        if let idUsuario = autenticacao.currentUser?.uid {
            if let emailUsuario = autenticacao.currentUser?.email {
                let usuarios = database.child("usuarios").child(idUsuario)
                let requisicao = database.child("requisicoes")
                
                if let enderecoDestino = self.enderecoDestinoCampo.text {
                    if enderecoDestino != "" {
                        CLGeocoder().geocodeAddressString(enderecoDestino) { (local, erro) in
                            if erro == nil {
                                if let dadosLocal = local?.first {
                                    
                                    var rua = ""
                                    if dadosLocal.thoroughfare != nil {
                                        rua = dadosLocal.thoroughfare!
                                    }
                                    
                                    var numero = ""
                                    if dadosLocal.subThoroughfare != nil {
                                        numero = dadosLocal.subThoroughfare!
                                    }
                                    
                                    var bairro = ""
                                    if dadosLocal.subLocality != nil {
                                        bairro = dadosLocal.subLocality!
                                    }
                                    
                                    var cidade = ""
                                    if dadosLocal.locality != nil {
                                        cidade = dadosLocal.locality!
                                    }
                                    
                                    var cep = ""
                                    if dadosLocal.postalCode != nil {
                                        cep = dadosLocal.postalCode!
                                    }
                                    
                                    let enderecoCompleto = "\(rua), \(numero), \(bairro) - \(cidade) - \(cep)"
                                    
                                    if let latDestino = dadosLocal.location?.coordinate.latitude {
                                        
                                        if let lonDestino = dadosLocal.location?.coordinate.longitude {
                                            let alerta = UIAlertController(title: "Confirme seu endereço!", message: enderecoCompleto, preferredStyle: .alert)
                                            
                                            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                                            let acaoConfirmar = UIAlertAction(title: "Confirmar", style: .default, handler: { (alertAction) in
                                                
                                                usuarios.observeSingleEvent(of: .value) { (snapshot) in
                                                    let dados = snapshot.value as? NSDictionary
                                                    let nomeUsuario = dados!["nome"] as? String
                                                    
                                                    let dadosUsuario = [
                                                        "destinoLatitude" : latDestino,
                                                        "destinoLongitude" : lonDestino,
                                                        "email" : emailUsuario,
                                                        "nome" : nomeUsuario,
                                                        "latitude" : self.localUsuario.latitude,
                                                        "longitude" : self.localUsuario.longitude
                                                        ] as [String : Any]
                                                    requisicao.childByAutoId().setValue(dadosUsuario)
                                                    
                                                    self.alternaBotaoCancelarUber()
                                                }
                                                
                                            })
                                            alerta.addAction(acaoCancelar)
                                            alerta.addAction(acaoConfirmar)
                                            
                                            self.present(alerta, animated: true, completion: nil)
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                    } else {
                        print("Endereco nao digitado")
                    }
                }
            }
        }
    }
    
    @IBAction func deslogarUsuario(_ sender: Any) {
        
        let autenticacao = Auth.auth()
        do {
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("não foi possível deslogar!")
        }
    }
    
    func alternaBotaoCancelarUber() {
        self.botaoChamar.setTitle("Cancelar Uber", for: .normal)
        self.botaoChamar.backgroundColor = UIColor(displayP3Red: 0.831, green: 0.237, blue: 0.146, alpha: 1)
        self.uberChamado = true
    }
    
    func alternaBotaoChamarUber() {
        self.botaoChamar.setTitle("Chamar Uber", for: .normal)
        self.botaoChamar.backgroundColor = UIColor(displayP3Red: 0.067, green: 0.576, blue: 0.604, alpha: 1)
        self.uberChamado = false
    }
    
    func alternaBotaoEmViagem() {
        self.botaoChamar.setTitle("Em viagem", for: .normal)
        self.botaoChamar.isEnabled = false
        self.botaoChamar.backgroundColor = UIColor(displayP3Red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
    }
    
    func alternaBotaoViagemFinalizada(preco: Double) {
        self.botaoChamar.isEnabled = false
        self.botaoChamar.backgroundColor = UIColor(displayP3Red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.locale = Locale(identifier: "pt_BR")
        let precoFinal = nf.string(from: NSNumber(value: preco))
        
        self.botaoChamar.setTitle("Viagem finalizada - R$ " + precoFinal!, for: .normal)
    }
    
    func exibirMotoristaPassageiro() {
        self.uberACaminho = true
        
        let motoristaLocation = CLLocation(latitude: self.localMotorista.latitude, longitude: self.localMotorista.longitude)
        let passageiroLocation = CLLocation(latitude: self.localUsuario.latitude, longitude: self.localUsuario.longitude)
        
        var mensagem = ""
        let distancia = motoristaLocation.distance(from: passageiroLocation)
        let distanciaKM = round(distancia / 1000)
        mensagem = "Motorista \(distanciaKM) KM distante"
        
        if distanciaKM < 1 {
            let distanciaM = round(distancia)
            mensagem = "Motorista \(distanciaM) M distante"
        }
        
        self.botaoChamar.backgroundColor = UIColor(displayP3Red: 0.067, green: 0.576, blue: 0.604, alpha: 1)
        self.botaoChamar.setTitle(mensagem, for: .normal)
        mapa.removeAnnotations(mapa.annotations)
        
        let latDiferenca = abs(self.localUsuario.latitude - self.localMotorista.latitude) * 300000
        let lonDiferenca = abs(self.localUsuario.longitude - self.localMotorista.longitude) * 300000
        
        let regiao = MKCoordinateRegionMakeWithDistance(self.localUsuario, latDiferenca, lonDiferenca)
        mapa.setRegion(regiao, animated: true)
        
        let anotacaoMotorista = MKPointAnnotation()
        anotacaoMotorista.coordinate = self.localMotorista
        anotacaoMotorista.title = "Motorista"
        mapa.addAnnotation(anotacaoMotorista)
        
        let anotacaoPassageiro = MKPointAnnotation()
        anotacaoPassageiro.coordinate = self.localUsuario
        anotacaoPassageiro.title = "Passageiro"
        mapa.addAnnotation(anotacaoPassageiro)
    }
}
