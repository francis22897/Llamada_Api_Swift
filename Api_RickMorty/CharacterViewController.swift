//
//  CharacterViewController.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 04/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTableLabel: UILabel!
    
    override func viewDidLoad() {
        
        titleTableLabel.text = "Episodios"
        Episode.dataCharacters = []
        Episode.episodeCharacters = []
        Character.episodesData = []
        
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
        
        for url in Character.episodes {
            downloadEpisodeData(urlApi: url)
        }
        
    }
    
    func downloadEpisodeData(urlApi: String){
        let urlString = urlApi
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                Character.episodesData.append(json)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }
    
    func downloadCharacterData(urlApi: String){
        let urlString = urlApi
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                Episode.dataCharacters.append(json)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
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
    
    @IBAction func shareURLAction(_ sender: Any) {

        if let url = NSURL(string: "Api://\(Character.id)") {
            
            let arrayParaCompartir: [Any] = [url]
            
            let activityVC = UIActivityViewController(activityItems: arrayParaCompartir, applicationActivities: nil)
                   
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Episode.episodeCharacters.count > 0 {
            return Episode.episodeCharacters.count
        } else {
            return Character.episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        
        
        if(Episode.episodeCharacters.count > 0){
            if Episode.episodeCharacters.count == Episode.dataCharacters.count {
                cell.episodeLabel.text = (Episode.dataCharacters[indexPath.row]["name"] as! String)
            }
        } else {
            if Character.episodesData.count == Character.episodes.count {
                cell.episodeLabel.text = "\(Character.episodesData[indexPath.row]["name"] as! String) -> \(Character.episodesData[indexPath.row]["episode"] as! String)"
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if Episode.episodeCharacters.count == 0 {
            titleTableLabel.text = "Personajes"
            Episode.episodeCharacters = Character.episodesData[indexPath.row]["characters"] as! [String];
            
            for url in Episode.episodeCharacters {
                downloadCharacterData(urlApi: url)
            }
            
        }
        
    }
   
}
