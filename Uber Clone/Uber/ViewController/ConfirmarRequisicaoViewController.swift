//
//  ConfirmarRequisicaoViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 24/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class ConfirmarRequisicaoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var botaoAceitarCorrida: UIButton!
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    var nomePassageiro = ""
    var emailPassageiro = ""
    var localPassageiro = CLLocationCoordinate2D()
    var localMotorista = CLLocationCoordinate2D()
    var localDestino = CLLocationCoordinate2D()
    var status: StatusCorrida = .EmRequisicao

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        gerenciadorLocalizacao.allowsBackgroundLocationUpdates = true
        
        let regiao = MKCoordinateRegionMakeWithDistance(self.localPassageiro, 200, 200)
        mapa.setRegion(regiao, animated: true)
        
        let anotacaoPassageiro = MKPointAnnotation()
        anotacaoPassageiro.coordinate = self.localPassageiro
        anotacaoPassageiro.title = self.nomePassageiro
        mapa.addAnnotation(anotacaoPassageiro)
        
        let database = Database.database().reference()
        let requisicoes = database.child("requisicoes")
        let consultaRequisicao = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: self.emailPassageiro)
        
        consultaRequisicao.observe(.childChanged) { (snapshot) in
            if let dados = snapshot.value as? [String: Any] {
                if let statusR = dados["status"] as? String {
                    self.recarregarTelaStatus(status: statusR, dados: dados)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let database = Database.database().reference()
        
        let requisicoes = database.child("requisicoes")
        let consultaRequisicao = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: self.emailPassageiro)
        
        consultaRequisicao.observeSingleEvent(of: .childAdded) { (snapshot) in
            if let dados = snapshot.value as? [String: Any] {
                if let statusR = dados["status"] as? String {
                    self.recarregarTelaStatus(status: statusR, dados: dados)
                }
            }
        }
    }
    
    func recarregarTelaStatus(status: String, dados: [String: Any]) {
        if status == StatusCorrida.PegarPassageiro.rawValue {
            self.pegarPassageiro()
            self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localPassageiro, tPartida: "Meu local", tDestino: "Passageiro")
        } else if status == StatusCorrida.IniciarViagem.rawValue {
            self.status = .IniciarViagem
            self.alternaBotaoIniciarViagem()
            
            self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localPassageiro, tPartida: "Motorista", tDestino: "Passageiro")
            if let latDestino = dados["destinoLatitude"] as? Double {
                if let lonDestino = dados["destinoLongitude"] as? Double {
                    self.localDestino = CLLocationCoordinate2D(latitude: latDestino, longitude: lonDestino)
                }
            }
        } else if status == StatusCorrida.EmViagem.rawValue {
            self.status = .EmViagem
            self.alternaBotaoPendenteFinalizarViagem()
            
            if let latDestino = dados["destinoLatitude"] as? Double {
                if let lonDestino = dados["destinoLongitude"] as? Double {
                    self.localDestino = CLLocationCoordinate2D(latitude: latDestino, longitude: lonDestino)
                    self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localDestino, tPartida: "Motorista", tDestino: "Destino")
                }
            }
        } else if status == StatusCorrida.ViagemFinalizada.rawValue {
            self.status = .ViagemFinalizada
            if let preco = dados["precoViagem"] as? Double {
                self.alternaBotaoViagemFinalizada(preco: preco)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordenadas = manager.location?.coordinate {
            self.localMotorista = coordenadas
            self.atualizarLocalMotorista()
        }
    }
    
    func atualizarLocalMotorista() {
        let database = Database.database().reference()
        
        if self.emailPassageiro != "" {
            let requisicoes = database.child("requisicoes")
            let consultaRequisicao = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: emailPassageiro)
            
            consultaRequisicao.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let dados = snapshot.value as? [String: Any] {
                    if let statusR = dados["status"] as? String {
                        if statusR == StatusCorrida.PegarPassageiro.rawValue {
                            let motoristaLocation = CLLocation(latitude: self.localMotorista.latitude, longitude: self.localMotorista.longitude)
                            let passageiroLocation = CLLocation(latitude: self.localPassageiro.latitude, longitude: self.localPassageiro.longitude)
                            
                            let distancia = motoristaLocation.distance(from: passageiroLocation)
                            let distanciaKM = distancia / 1000
                            
                            if distanciaKM <= 0.5 {
                                self.atualizaStatusRequisicao(status: StatusCorrida.IniciarViagem.rawValue)
                            }
                            self.pegarPassageiro()
                            
                            self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localPassageiro, tPartida: "Meu local", tDestino: "Passageiro")
                        } else if statusR == StatusCorrida.IniciarViagem.rawValue {
                            //self.alternaBotaoIniciarViagem()
                            
                            self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localPassageiro, tPartida: "Motorista", tDestino: "Passageiro")
                        } else if statusR == StatusCorrida.EmViagem.rawValue {
                            if let latDestino = dados["destinoLatitude"] as? Double {
                                if let lonDestino = dados["destinoLongitude"] as? Double {
                                    self.localDestino = CLLocationCoordinate2D(latitude: latDestino, longitude: lonDestino)
                                    self.exibeMotoristaPassageiro(lPartida: self.localMotorista, lDestino: self.localDestino, tPartida: "Motorista", tDestino: "Destino")
                                }
                            }
                        }
                        
                        let dadosMotorista = [
                            "motoristaLatitude" : self.localMotorista.latitude,
                            "motoristaLongitude" : self.localMotorista.longitude
                            ] as [String : Any]
                        
                        snapshot.ref.updateChildValues(dadosMotorista)
                    }
                }
                
            }
        }
    }
    
    @IBAction func aceitarCorrida(_ sender: Any) {
        
        if self.status == StatusCorrida.EmRequisicao {
            let autenticacao = Auth.auth()
            let database = Database.database().reference()
            let requisicoes = database.child("requisicoes")
            
            if let emailMotorista = autenticacao.currentUser?.email {
                requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: self.emailPassageiro).observeSingleEvent(of: .childAdded) { (snapshot) in
                    
                    let dadosMotorista = [
                        "motoristaEmail" : emailMotorista,
                        "motoristaLatitude" : self.localMotorista.latitude,
                        "motoristaLongitude" : self.localMotorista.longitude,
                        "status" : StatusCorrida.PegarPassageiro.rawValue
                        ] as [String : Any]
                    snapshot.ref.updateChildValues(dadosMotorista)
                    self.pegarPassageiro()
                }
            }
            
            let passageiroCLL = CLLocation(latitude: self.localPassageiro.latitude, longitude: self.localPassageiro.longitude)
            CLGeocoder().reverseGeocodeLocation(passageiroCLL) { (local, erro) in
                if erro == nil {
                    if let dadosLocal = local?.first {
                        let placemark = MKPlacemark(placemark: dadosLocal)
                        
                        let mapaItem = MKMapItem(placemark: placemark)
                        mapaItem.name = self.nomePassageiro
                        
                        let opcoes = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        mapaItem.openInMaps(launchOptions: opcoes)
                    }
                }
            }
            
        } else if self.status == StatusCorrida.IniciarViagem {
            self.iniciarViagemDestino()
        } else if self.status == StatusCorrida.EmViagem {
            self.finalizarViagem()
        }
        
        
    }
    
    func iniciarViagemDestino() {
        self.status = .EmViagem
        self.atualizaStatusRequisicao(status: self.status.rawValue)
        
        let destinoCLL = CLLocation(latitude: self.localDestino.latitude, longitude: self.localDestino.longitude)
        CLGeocoder().reverseGeocodeLocation(destinoCLL) { (local, erro) in
            if erro == nil {
                if let dadosLocal = local?.first {
                    let placemark = MKPlacemark(placemark: dadosLocal)
                    
                    let mapaItem = MKMapItem(placemark: placemark)
                    mapaItem.name = "Destino passageiro"
                    
                    let opcoes = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapaItem.openInMaps(launchOptions: opcoes)
                }
            }
        }
    }
    
    func finalizarViagem() {
        self.status = .ViagemFinalizada
        
        let database = Database.database().reference()
        let preco = database.child("preco")
        let requisicoes = database.child("requisicoes")
        preco.observeSingleEvent(of: .value) { (snapshot) in
            let dados = snapshot.value as? NSDictionary
            let precoKM = dados!["km"] as? Double
            
            let consultaRequisicoes = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: self.emailPassageiro)
            consultaRequisicoes.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                if let dados = snapshot.value as? [String: Any] {
                    if let latI = dados["latitude"] as? Double {
                        if let lonI = dados["longitude"] as? Double {
                            if let lonD = dados["destinoLongitude"] as? Double {
                                if let latD = dados["destinoLatitude"] as? Double {
                                    let inicioLocation = CLLocation(latitude: latI, longitude: lonI)
                                    let destinoLocation = CLLocation(latitude: latD, longitude: lonD)
                                    
                                    let distancia = inicioLocation.distance(from: destinoLocation)
                                    let distanciaKM = distancia / 1000
                                    let precoViagem = distanciaKM * precoKM!
                                    
                                    let dadosAtualizar = [
                                        "precoViagem": precoViagem,
                                        "distanciaPercorrida" : distanciaKM
                                    ]
                                    
                                    snapshot.ref.updateChildValues(dadosAtualizar)
                                    
                                    self.atualizaStatusRequisicao(status: self.status.rawValue)
                                    
                                    self.alternaBotaoViagemFinalizada(preco: precoViagem)
                                    
                                }
                            }
                        }
                    }
                }
                
            })
        }
    }
    
    func atualizaStatusRequisicao(status: String) {
        if status != "" && self.emailPassageiro != "" {
            let database = Database.database().reference()
            let requisicoes = database.child("requisicoes")
            let consultaRequisicao = requisicoes.queryOrdered(byChild: "email").queryEqual(toValue: self.emailPassageiro)
            
            consultaRequisicao.observeSingleEvent(of: .childAdded) { (snapshot) in
                if let dados = snapshot.value as? [String: Any] {
                    let dadosAtualizar = [
                        "status" : status
                    ]
                    
                    snapshot.ref.updateChildValues(dadosAtualizar)
                }
            }
        }
    }
    
    func exibeMotoristaPassageiro(lPartida: CLLocationCoordinate2D, lDestino: CLLocationCoordinate2D, tPartida: String, tDestino: String) {
        mapa.removeAnnotations(mapa.annotations)
        
        let latDiferenca = abs(lPartida.latitude - lDestino.latitude) * 300000
        let lonDiferenca = abs(lPartida.longitude - lDestino.longitude) * 300000
        
        let regiao = MKCoordinateRegionMakeWithDistance(lPartida, latDiferenca, lonDiferenca)
        mapa.setRegion(regiao, animated: true)
        
        let anotacaoPartida = MKPointAnnotation()
        anotacaoPartida.coordinate = lPartida
        anotacaoPartida.title = tPartida
        mapa.addAnnotation(anotacaoPartida)
        
        let anotacaoDestino = MKPointAnnotation()
        anotacaoDestino.coordinate = lDestino
        anotacaoDestino.title = tDestino
        mapa.addAnnotation(anotacaoDestino)
    }
    
    func pegarPassageiro() {
        self.status = .PegarPassageiro
        self.alternaBotaoPegarPassageiro()
    }
    
    func alternaBotaoPegarPassageiro() {
        self.botaoAceitarCorrida.setTitle("A caminho do passageiro", for: .normal)
        self.botaoAceitarCorrida.isEnabled = false
        self.botaoAceitarCorrida.backgroundColor = UIColor(displayP3Red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
    }
    
    func alternaBotaoIniciarViagem() {
        self.botaoAceitarCorrida.setTitle("Iniciar viagem", for: .normal)
        self.botaoAceitarCorrida.isEnabled = true
        self.botaoAceitarCorrida.backgroundColor = UIColor(displayP3Red: 0.067, green: 0.576, blue: 0.604, alpha: 1)
    }
    
    func alternaBotaoPendenteFinalizarViagem() {
        self.botaoAceitarCorrida.setTitle("Finalizar viagem", for: .normal)
        self.botaoAceitarCorrida.isEnabled = true
        self.botaoAceitarCorrida.backgroundColor = UIColor(displayP3Red: 0.067, green: 0.576, blue: 0.604, alpha: 1)
    }
    
    func alternaBotaoViagemFinalizada(preco: Double) {
        self.botaoAceitarCorrida.isEnabled = false
        self.botaoAceitarCorrida.backgroundColor = UIColor(displayP3Red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.locale = Locale(identifier: "pt_BR")
        let precoFinal = nf.string(from: NSNumber(value: preco))
        
        self.botaoAceitarCorrida.setTitle("Viagem finalizada - R$ " + precoFinal!, for: .normal)
    }
    
}
