//
//  Global.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 04/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

struct AppData {
    struct Domains {
        static let url = "https://rickandmortyapi.com/api/character/"
    }
    static var data: [[String:Any]] = []
    static var filteredCharacters: [[String: Any]] = []
    static var categorys: [String] = ["Nombre", "Sexo", "Especie"]
}

struct Character {
    static var id = ""
    static var urlImage = ""
    static var name = ""
    static var specie = ""
    static var status = ""
    static var genre = ""
    static var origin = ""
    static var location = ""
    static var episodes: [String] = []
    static var episodesData: [[String:Any]] = []
}

struct Episode {
    static var episodeCharacters: [String] = []
    static var dataCharacters: [[String:Any]] = []
}
