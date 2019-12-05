//
//  CharacterViewController.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 04/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        
        let url = URL(string: Character.urlImage)
               
        if let data = try? Data(contentsOf: url!){
            if let img = UIImage(data: data){
                image.image = img
            }
        }
        
        nameLabel.text = Character.name
        specieLabel.text = Character.specie
        statusLabel.text = Character.status
        genreLabel.text = Character.genre
        originLabel.text = Character.origin
        locLabel.text = Character.location
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let textToShare = Character.name
        
        if let url = NSURL(string: Character.urlImage) {
            
            let arrayParaCompartir: [Any] = [textToShare, url]
            
            let activityVC = UIActivityViewController(activityItems: arrayParaCompartir, applicationActivities: nil)
                   
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)

        }
        
        
    }
}
