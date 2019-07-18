//
//  ViewController.swift
//  Milestone-Project13-15
//
//  Created by Denis Goldberg on 18.07.19.
//  Copyright © 2019 Denis Goldberg. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var searchBar: UISearchBar!
    var countries = [Country]()
    var selectedCountries = [Country]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        title = "Browse Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for any country"
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return selectedCountries.count
        }
        
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let countryName: String
        if isFiltering() {
            countryName = selectedCountries[indexPath.row].name
        } else {
            countryName = countries[indexPath.row].name
        }
        
        cell.textLabel?.text = countryName
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let selectedCountry: Country
        
        if isFiltering() {
            selectedCountry = selectedCountries[indexPath.row]
        } else {
            selectedCountry = countries[indexPath.row]
        }
        
        vc.detailItem = selectedCountry
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fetchJSON() {

        
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the JSON.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in self?.fetchJSON() })
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let jsonCountries = try decoder.decode([Country].self, from: json)
            countries = jsonCountries
            selectedCountries = countries
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            return
            
        } catch {
            print(error)
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            selectedCountries = countries
            tableView.reloadData()
            return
        }
        filterContentForSearchText(text)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        selectedCountries = countries.filter({(Country) -> Bool in
            Country.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

