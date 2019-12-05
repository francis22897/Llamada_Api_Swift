//
//  ViewController.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 04/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//


import UIKit

class ViewController: UICollectionViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
       
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        initializeSearchController()
        searchController.searchBar.scopeButtonTitles = AppData.categorys
        searchController.searchBar.delegate = self
        downloadData()
    }
    
    func downloadData(){
        let urlString = "\(AppData.Domains.url)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                AppData.data = json["results"] as! [[String : Any]]
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return AppData.filteredCharacters.count
        } else {
            return AppData.data.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCell
        
        var urlImage: String = ""
        
        
        if isFiltering {
            cell.labelName.text = "Nombre: \(AppData.filteredCharacters[indexPath.row]["name"] as! String)"
            cell.labelSpecie.text = "Especie: \(AppData.filteredCharacters[indexPath.row]["species"] as! String)"
            
            urlImage = (AppData.filteredCharacters[indexPath.row]["image"] as? String)!
            
        } else {
            cell.labelName.text = "Nombre: \(AppData.data[indexPath.row]["name"] as! String)"
            cell.labelSpecie.text = "Especie: \(AppData.data[indexPath.row]["species"] as! String)"
            
            urlImage = (AppData.data[indexPath.row]["image"] as? String)!
        }
        
        let url = URL(string: urlImage)
               
        if let data = try? Data(contentsOf: url!){
            if let image = UIImage(data: data){
                cell.imageCell.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFiltering {
            Character.urlImage = AppData.filteredCharacters[indexPath.row]["image"] as! String
            Character.name = AppData.filteredCharacters[indexPath.row]["name"] as! String
            Character.specie = AppData.filteredCharacters[indexPath.row]["species"] as! String
            Character.status = AppData.filteredCharacters[indexPath.row]["status"] as! String
            Character.genre = AppData.filteredCharacters[indexPath.row]["gender"] as! String
            let origin = AppData.filteredCharacters[indexPath.row]["origin"] as! [String:Any]
            Character.origin = origin["name"] as! String
            
            Character.episodes = AppData.filteredCharacters[indexPath.row]["episode"] as! [String]

            let location = AppData.filteredCharacters[indexPath.row]["location"] as! [String:Any]
            Character.location = location["name"] as! String
        } else {
            Character.urlImage = AppData.data[indexPath.row]["image"] as! String
            Character.name = AppData.data[indexPath.row]["name"] as! String
            Character.specie = AppData.data[indexPath.row]["species"] as! String
            Character.status = AppData.data[indexPath.row]["status"] as! String
            Character.genre = AppData.data[indexPath.row]["gender"] as! String
            let origin = AppData.data[indexPath.row]["origin"] as! [String:Any]
            Character.origin = origin["name"] as! String

            let location = AppData.data[indexPath.row]["location"] as! [String:Any]
            Character.location = location["name"] as! String
            
            Character.episodes = AppData.data[indexPath.row]["episode"] as! [String]
        }

        self.performSegue(withIdentifier: "mySegue", sender: self)
    }
    
    func initializeSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String, category: Int? = nil) {
        AppData.filteredCharacters = AppData.data.filter { (character: [String:Any]) -> Bool in
            
            var result: Bool
            
            switch category {
                case 0:
                    
                    let name = character["name"] as! String
                    if name.lowercased().localizedCaseInsensitiveContains(searchText) {
                        result =  true
                    } else {
                        result =  false
                    }
                case 1:

                    let gender = character["gender"] as! String
                    if gender.lowercased().localizedCaseInsensitiveContains(searchText) {
                        result = true
                    } else {
                        result = false
                    }
                case 2:
                    
                    let specie = character["species"] as! String
                    if specie.lowercased().localizedCaseInsensitiveContains(searchText) {
                        result = true
                    } else {
                        result =  false
                    }
                default:
                    result = false
                }
            return result
        }
      
        self.collectionView.reloadData()
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = searchBar.selectedScopeButtonIndex
        filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = selectedScope
    filterContentForSearchText(searchBar.text!, category: category)
  }
}

