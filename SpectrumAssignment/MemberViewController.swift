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
    var memberList:[MemberDetails] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath as IndexPath) as! MemberTableViewCell

        let memberDetail:MemberDetails = memberList[indexPath.row]
        cell.nameLabel.text = "\(memberDetail.name.first) \(memberDetail.name.last),\(memberDetail.age)"
        cell.PhoneText.text = "Phone:\(memberDetail.phone)"
        cell.emailText.text = "Email:\(memberDetail.email)"
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memberTableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberTableViewCell")

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
