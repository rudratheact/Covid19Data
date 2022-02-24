//
//  DetailsViewController.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var keyArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let recDict = StaticInfo.shared.selectedDict{
            print(recDict)
            keyArr = Array(recDict.keys)
        }
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        StaticInfo.shared.selectedDict?.removeAll()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StaticInfo.shared.detailsTableViewCell, for: indexPath)
        
        cell.textLabel?.text = keyArr[indexPath.row]
        if let data = StaticInfo.shared.selectedDict?[keyArr[indexPath.row]] as? String{
            cell.detailTextLabel?.text = data
        }
        return cell
    }
    
    
}
