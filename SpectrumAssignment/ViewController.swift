//
//  ViewController.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 24/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    private let networkManager = NetworkManager()
    var companyList:[CompanyDetails] = []
    var filteredList:[CompanyDetails] = []
    @IBOutlet weak var companyListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello")
        companyListTableView.register(UINib(nibName: "CompanyTableViewCell", bundle: nil), forCellReuseIdentifier: "CompanyTableViewCell")
        
        companyListTableView.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.title = "SPECTRUM"
        networkManager.getCompanyDetails { (Response, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error {
                print("Get Response error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Error in loading..."
                }
                return
            }
            guard let Response = Response  else { return }
            
            CommomManager.CompanyListArray = Response
            self.companyList = CommomManager.CompanyListArray
            print("Current Response Object:")
            print(Response)
            DispatchQueue.main.async {
                self.companyListTableView.isHidden = false
                self.companyListTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: TableView Delegates and DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return filteredList.count
        }
        return companyList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath as IndexPath) as! CompanyTableViewCell
        
        let companyDetail:CompanyDetails?
        if tableView.tag == 1 {
            companyDetail = filteredList[indexPath.row]
        }else{
            companyDetail = companyList[indexPath.row]
        }
        cell.companyName.text = companyDetail!.company
        cell.companyWebsite.text = companyDetail!.website
        cell.companyDescription.text = companyDetail!.about
        cell.followButton.tag = indexPath.row
        cell.followButton.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)

        if let favourite = companyDetail!.favorite {
            cell.favButton.isSelected = favourite
        }else{
            
            cell.favButton.isSelected = false
        }

        if let follow = companyDetail!.follow {
            cell.followButton.isSelected = follow
            if follow{
                cell.followButton.backgroundColor = UIColor.green
            }else{
                cell.followButton.backgroundColor = UIColor.black
            }
        }else{

            cell.followButton.isSelected = false
            cell.followButton.backgroundColor = UIColor.black
        }
        cell.companyImage.sd_setImage(with: URL(string: companyDetail!.logo), placeholderImage: UIImage(named: "placeholder.png"))


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let memberVC = self.storyboard?.instantiateViewController(withIdentifier: "Member") as! MemberViewController
        if companyListTableView.tag == 1 {
            memberVC.companyDetails = filteredList[indexPath.row]
        }else{
            memberVC.companyDetails = companyList[indexPath.row]
        }
//        memberVC.selectedCompanyTag = indexPath.row
        self.navigationController?.pushViewController(memberVC, animated: true)
    }
    
    // MARK: SearchBar Delegates
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()

        companyListTableView.tag = 0
        companyListTableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.isEmpty)! {
            searchBar.returnKeyType = .default
        }else{
            searchBar.returnKeyType = .search
        }

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if (searchBar.text?.isEmpty)! {
            return
        }
        filteredList = companyList.filter({ value -> Bool in
            guard let text =  searchBar.text?.uppercased() else { return false}
            return value.company.contains(text) // According to title from JSON
            
        })
        
        print(filteredList)
        companyListTableView.tag = 1
        companyListTableView.reloadData()

    }
    /// Function for Follow button tapped
    @IBAction func followTapped(_ sender: UIButton) {

        if sender.isSelected {
            
            sender.isSelected = false
            sender.backgroundColor = UIColor.black

        }else{
            
            sender.isSelected = true
            sender.backgroundColor = UIColor.green

        }
        
        if companyListTableView.tag == 0 {
            let companyDetail:CompanyDetails = companyList[sender.tag]
            companyDetail.follow = sender.isSelected

        }else{
            
            let companyDetail:CompanyDetails = filteredList[sender.tag]
            companyDetail.follow = sender.isSelected

            for obj in companyList{
                
                if obj._id == companyDetail._id{
                    obj.follow = sender.isSelected
                    return
                }
            }
            
        }

    }
    
    /// Function for favourite button tapped
    @IBAction func favoriteTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }else{
            
            sender.isSelected = true
        }
        
        if companyListTableView.tag == 0 {
            let companyDetail:CompanyDetails = companyList[sender.tag]
            companyDetail.favorite = sender.isSelected
            
        }else{
            
            let companyDetail:CompanyDetails = filteredList[sender.tag]
            companyDetail.favorite = sender.isSelected
            
            for obj in companyList{
                
                if obj._id == companyDetail._id{
                    obj.favorite = sender.isSelected
                    return
                }
            }
            
        }

    }

    /// function for Sorting button Tapped
    @IBAction func sortingTapped(_ sender: UIButton) {
        
        if companyList.count > 0{
            
            if sender.isSelected {
                sender.isSelected = false
                sender.setTitle("ASC⇧", for: .normal)
                
                companyList = companyList.sorted(by: { (item1, item2) -> Bool in
                    return item1.company.compare(item2.company) == ComparisonResult.orderedAscending
                })
                
                companyListTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                companyListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }else{
                sender.setTitle("DESC⇩", for: .normal)
                sender.isSelected = true
                companyList = companyList.sorted(by: { (item1, item2) -> Bool in
                    return item1.company.compare(item2.company) == ComparisonResult.orderedDescending
                })
                
                companyListTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                companyListTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }

        }
        
    }

}

