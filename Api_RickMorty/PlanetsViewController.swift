//
//  PlanetsViewController.swift
//  Api_RickMorty
//
//  Created by francisco.adan on 05/12/2019.
//  Copyright © 2019 francisco.adan. All rights reserved.
//

import UIKit

class PlanetsViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
          
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        initializeSearchController()
        downloadPlanetsData()
    }
    
    func downloadPlanetsData(){
        let urlString = "\(Planets.url)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                Planets.data = json["results"] as! [[String : Any]]
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return Planets.filteredPlanets.count
        }else {
            return Planets.data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetsCell", for: indexPath) as! PlanetsTableCell
        
        if isFiltering {
            cell.nameLabel.text = (Planets.filteredPlanets[indexPath.row]["name"] as! String)
        } else {
            cell.nameLabel.text = (Planets.data[indexPath.row]["name"] as! String)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering {
            Planets.planetsCharacters = Planets.filteredPlanets[indexPath.row]["residents"] as! [String];
        } else {
            Planets.planetsCharacters = Planets.data[indexPath.row]["residents"] as! [String];
        }
        
        self.performSegue(withIdentifier: "charactersSegue", sender: self)

    }
    
    func initializeSearchController(){
           searchController.searchResultsUpdater = self
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Buscar"
           navigationItem.searchController = searchController
           definesPresentationContext = true
       }
    
    func filterContentForSearchText(_ searchText: String) {
        Planets.filteredPlanets = Planets.data.filter { (planet: [String:Any]) -> Bool in
            
           let name = planet["name"] as! String
            if name.lowercased().localizedCaseInsensitiveContains(searchText) {
                return true
            } else {
                return false
            }
        }
      
        self.tableView.reloadData()
    }

}

extension PlanetsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

