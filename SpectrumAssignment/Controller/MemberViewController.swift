//
//  MemberViewController.swift
//  SpectrumAssignment
//
//  Created by C02VM0S0HV2D on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var memberTableView: UITableView!
    var companyDetails:CompanyDetails?
    var selectedCompanyTag:Int?
    var memberList:[MemberDetails] = []
    var filteredMemberList:[MemberDetails] = []

    @IBOutlet weak var nameSOrtButton: UIButton!
    @IBOutlet weak var ageSortButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberTableViewCell")
        
        //        companyDetails = CommomManager.CompanyListArray[selectedCompanyTag!]
        if let companyName = companyDetails?.company{
            
            self.title = companyName
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let members = companyDetails?.members {
            memberList = members
            memberTableView.reloadData()
        }
        
    }
    
    // MARK: - TableView Delegates and DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return filteredMemberList.count
        }
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath as IndexPath) as! MemberTableViewCell

        let memberDetail:MemberDetails?
        if tableView.tag == 1 {
            memberDetail = filteredMemberList[indexPath.row]
        }else{
            memberDetail = memberList[indexPath.row]
        }

        cell.nameLabel.text = "\(memberDetail!.name.first) \(memberDetail!.name.last)"
        cell.PhoneText.text = "Phone : \(memberDetail!.phone)"
        cell.emailText.text = "Email : \(memberDetail!.email)"
        cell.ageLabel.text = "Age : \(memberDetail!.age)"
        if let favourite = memberDetail!.favorite {
            cell.favButton.isSelected = favourite
        }else{
            
            cell.favButton.isSelected = false
        }

        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - SearchBar Delegates

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        filteredMemberList = memberList.filter({ value -> Bool in
            guard let text =  searchBar.text?.lowercased() else { return false}
            return value.name.first.lowercased().contains(text) // According to title from JSON
            
        })
        if filteredMemberList.count == 0{
            
            filteredMemberList = memberList.filter({ value -> Bool in
                guard let text =  searchBar.text?.lowercased() else { return false}
                return value.name.last.lowercased().contains(text) // According to title from JSON
                
            })

        }
        print(filteredMemberList)
        memberTableView.tag = 1
        memberTableView.reloadData()

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        memberTableView.tag = 0
        memberTableView.reloadData()

    }
    
    ///Function for  Name Sorting button Tapped Action
    @IBAction func nameSortTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setTitle("NAME ASC⇧", for: .normal)
            
            memberList = memberList.sorted(by: { (item1, item2) -> Bool in
                return item1.name.first.compare(item2.name.first) == ComparisonResult.orderedAscending
            })
            
            memberTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            memberTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }else{
            sender.setTitle("NAME DESC⇩", for: .normal)
            sender.isSelected = true
            memberList = memberList.sorted(by: { (item1, item2) -> Bool in
                return item1.name.first.compare(item2.name.first) == ComparisonResult.orderedDescending
            })
            
            memberTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            memberTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }

    }
    /// Function for Age Sorting button tapped action
    @IBAction func ageSortTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            sender.setTitle("AGE ASC⇧", for: .normal)
            
            memberList = memberList.sorted{ $0.age > $1.age }

            memberTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            memberTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }else{
            sender.setTitle("AGE DESC⇩", for: .normal)
            sender.isSelected = true
            memberList = memberList.sorted{ $0.age < $1.age }
            
            memberTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            memberTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }

    }
    /// Function for Favourite button tapped Action
    @IBAction func favoriteTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }else{
            
            sender.isSelected = true
        }
        let memberDetail:MemberDetails = memberList[sender.tag]
        memberDetail.favorite = sender.isSelected
        
        if memberTableView.tag == 0 {
            let memberDetail:MemberDetails = memberList[sender.tag]
            memberDetail.favorite = sender.isSelected

        }else{
            
            let memberDetail:MemberDetails = filteredMemberList[sender.tag]
            memberDetail.favorite = sender.isSelected

            for obj in memberList{
                
                if obj._id == memberDetail._id{
                    obj.favorite = sender.isSelected
                    return
                }
            }
            
        }

        print(memberDetail)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
