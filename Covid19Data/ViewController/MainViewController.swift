//
//  MainViewController.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var urlString = ""
    var isDeleting = false
    
    var casesFromCoreData = [NSManagedObject]()
    var statesFromCoreData = [NSManagedObject]()
    var testsFromCoreData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: StaticInfo.shared.caseTableViewCell, bundle: nil), forCellReuseIdentifier: StaticInfo.shared.caseTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        // get stored data from coredata
        fetchCasesFromCoreData()
        fetchStatesFromCoreData()
        fetchTestsFromCoreData()
        
        self.activity.startAnimating()
        
        // retrive from API and load into tableview
        StaticInfo.shared.getDataFromAPI(vc: self){ success in
            DispatchQueue.main.async {
                if success{
                    self.tableView.reloadData()
                }else{
                    StaticInfo.shared.showAlert(vc: self, message: "Trouble with data fetching from server. Please try again.")
                }
                self.activity.stopAnimating()
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        reloadData()
    }
    
    func fetchCasesFromCoreData(){
        casesFromCoreData.removeAll()
        if let result = getFromCoreData(entityName: "CasesEntity") {
            for i in result as! [NSManagedObject]{
                casesFromCoreData.append(i)
            }
        }
    }
    
    func fetchStatesFromCoreData(){
        statesFromCoreData.removeAll()
        if let result = getFromCoreData(entityName: "StatesEntity") {
            for i in result as! [NSManagedObject]{
                statesFromCoreData.append(i)
            }
        }
    }
    
    func fetchTestsFromCoreData(){
        if let result = getFromCoreData(entityName: "TestsEntity") {
            for i in result as! [NSManagedObject]{
                testsFromCoreData.append(i)
            }
        }
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    // Fav button tapped
    func ifFavButtonTapped(id: Int, sender: UIButton){
        print("\(id)")
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        // Create entity for Cases
        if segmentedControl.selectedSegmentIndex == 0{
            if let entity = NSEntityDescription.insertNewObject(forEntityName: "CasesEntity", into: context) as? CasesEntity {
                if let date = StaticInfo.shared.completeData?.casesTimeSeries[id].date,
                   let totalrecovered = StaticInfo.shared.completeData?.casesTimeSeries[id].totalrecovered,
                   let totalconfirmed = StaticInfo.shared.completeData?.casesTimeSeries[id].totalconfirmed,
                   let totaldeceased = StaticInfo.shared.completeData?.casesTimeSeries[id].totaldeceased{
                    entity.date = date
                    entity.totalrecovered = totalrecovered
                    entity.totalconfirmed = totalconfirmed
                    entity.totaldeceased = totaldeceased
                    
                    if self.isDeleting{
                        self.deleteFromCoreData(entityName: "CasesEntity", deletable: date)
                    }
                }else{
                    self.saveInCoreData()
                }
            }
        }
        // Create entity for States
        if segmentedControl.selectedSegmentIndex == 1{
            if let entity = NSEntityDescription.insertNewObject(forEntityName: "StatesEntity", into: context) as? StatesEntity {
                if let state = StaticInfo.shared.completeData?.statewise[id].state,
                   let active = StaticInfo.shared.completeData?.statewise[id].active,
                   let recovered = StaticInfo.shared.completeData?.statewise[id].recovered,
                   let deaths = StaticInfo.shared.completeData?.statewise[id].deaths{
                    entity.state = state
                    entity.active = active
                    entity.recovered = recovered
                    entity.deaths = deaths
                    
                    if self.isDeleting{
                        self.deleteFromCoreData(entityName: "StatesEntity", deletable: state)
                    }else{
                        self.saveInCoreData()
                    }
                }
            }
        }
        // Create entity for Tests
        if segmentedControl.selectedSegmentIndex == 2{
            if let entity = NSEntityDescription.insertNewObject(forEntityName: "TestsEntity", into: context) as? TestsEntity {
                if let testedasof = StaticInfo.shared.completeData?.tested[id].testedasof,
                   let dailyrtpcrsamplescollectedicmrapplication = StaticInfo.shared.completeData?.tested[id].dailyrtpcrsamplescollectedicmrapplication,
                   let samplereportedtoday = StaticInfo.shared.completeData?.tested[id].samplereportedtoday,
                   let totaldosesadministered = StaticInfo.shared.completeData?.tested[id].totaldosesadministered{
                    entity.testedasof = testedasof
                    entity.dailyrtpcrsamplescollectedicmrapplication = dailyrtpcrsamplescollectedicmrapplication
                    entity.samplereportedtoday = samplereportedtoday
                    entity.totaldosesadministered = totaldosesadministered
                    
                    if self.isDeleting{
                        self.deleteFromCoreData(entityName: "TestsEntity", deletable: testedasof)
                    }else{
                        self.saveInCoreData()
                    }
                }
            }
        }
    }
    
    // Link button tapped
    func ifLinkButtonTapped(id: Int, sender: UIButton){
        print("\(id)")
        if StaticInfo.shared.isConnectedToNetwork(){
            if let source = StaticInfo.shared.completeData?.tested[id].source{
                self.urlString = source
                performSegue(withIdentifier: StaticInfo.shared.cellSegue, sender: self)
            }
        }else{
            StaticInfo.shared.showAlert(vc: self, message: "Please check the internet connectivity and try again.")
        }
    }
    
    // Modal Popup
    func showModalPopup(){
        if StaticInfo.shared.isConnectedToNetwork(){
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController"){
                // Display child view for half screen size
                if let presentationController = viewController.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()]
                }
                self.present(viewController, animated: true)
            }
        }else{
            StaticInfo.shared.showAlert(vc: self, message: "Please check the internet connectivity and try again.")
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BrowserViewController{
            destination.urlString = self.urlString
        }
    }
}

// MARK: - TableView stack
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if StaticInfo.shared.isConnectedToNetwork(){
            if segmentedControl.selectedSegmentIndex == 0{
                num = StaticInfo.shared.completeData?.casesTimeSeries.count ?? 0
            }
            if segmentedControl.selectedSegmentIndex == 1{
                num = StaticInfo.shared.completeData?.statewise.count ?? 0
            }
            if segmentedControl.selectedSegmentIndex == 2{
                num = StaticInfo.shared.completeData?.tested.count ?? 0
            }
            
        }else{
            if segmentedControl.selectedSegmentIndex == 0{
                num = casesFromCoreData.count
            }
            if segmentedControl.selectedSegmentIndex == 1{
                num = statesFromCoreData.count
            }
            if segmentedControl.selectedSegmentIndex == 2{
                num = testsFromCoreData.count
            }
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StaticInfo.shared.caseTableViewCell, for: indexPath) as! CaseTableViewCell
        
        cell.stack5View.isHidden = true
        
        if StaticInfo.shared.isConnectedToNetwork(){ // Online
            
            cell.starImage.image = UIImage.init(systemName: "star")
            // Cases
            if segmentedControl.selectedSegmentIndex == 0{
                for i in casesFromCoreData{
                    if let dateInCD = i.value(forKey: "date") as? String,
                       let dateInAPI = StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row].date,
                       dateInCD == dateInAPI{
                        print(dateInCD)
                        cell.starImage.image = UIImage.init(systemName: "star.fill")
                    }
                }
                cell.stack1Label.text = DecoratedText.date.rawValue
                cell.stack1Data.setTitle(StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row].date, for: .normal)
                cell.stack2Label.text = DecoratedText.totalconfirmed.rawValue
                cell.stack2Data.setTitle(StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row].totalconfirmed, for: .normal)
                cell.stack3Label.text = DecoratedText.totaldeceased.rawValue
                cell.stack3Data.setTitle(StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row].totaldeceased, for: .normal)
                cell.stack4Label.text = DecoratedText.totalrecovered.rawValue
                cell.stack4Data.setTitle(StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row].totalrecovered, for: .normal)
            }
            // States
            if segmentedControl.selectedSegmentIndex == 1{
                for i in statesFromCoreData{
                    if let stateInCD = i.value(forKey: "state") as? String,
                       let stateInAPI = StaticInfo.shared.completeData?.statewise[indexPath.row].state,
                       stateInCD == stateInAPI{
                        print(stateInCD)
                        cell.starImage.image = UIImage.init(systemName: "star.fill")
                    }
                }
                cell.stack1Label.text = DecoratedText.state.rawValue
                cell.stack1Data.setTitle(StaticInfo.shared.completeData?.statewise[indexPath.row].state, for: .normal)
                cell.stack2Label.text = DecoratedText.active.rawValue
                cell.stack2Data.setTitle(StaticInfo.shared.completeData?.statewise[indexPath.row].active, for: .normal)
                cell.stack3Label.text = DecoratedText.recovered.rawValue
                cell.stack3Data.setTitle(StaticInfo.shared.completeData?.statewise[indexPath.row].recovered, for: .normal)
                cell.stack4Label.text = DecoratedText.deaths.rawValue
                cell.stack4Data.setTitle(StaticInfo.shared.completeData?.statewise[indexPath.row].deaths, for: .normal)
            }
            // Tests
            if segmentedControl.selectedSegmentIndex == 2{
                for i in testsFromCoreData{
                    if let testedasofInCD = i.value(forKey: "testedasof") as? String,
                       let testedasofInAPI = StaticInfo.shared.completeData?.tested[indexPath.row].testedasof,
                       testedasofInCD == testedasofInAPI{
                        print(testedasofInCD)
                        cell.starImage.image = UIImage.init(systemName: "star.fill")
                    }
                }
                cell.stack5View.isHidden = false
                cell.stack1Label.text = DecoratedText.testedasof.rawValue
                cell.stack1Data.setTitle(StaticInfo.shared.completeData?.tested[indexPath.row].testedasof, for: .normal)
                cell.stack2Label.text = DecoratedText.dailyrtpcrsamplescollectedicmrapplication.rawValue
                cell.stack2Data.setTitle(StaticInfo.shared.completeData?.tested[indexPath.row].dailyrtpcrsamplescollectedicmrapplication, for: .normal)
                cell.stack3Label.text = DecoratedText.samplereportedtoday.rawValue
                cell.stack3Data.setTitle(StaticInfo.shared.completeData?.tested[indexPath.row].samplereportedtoday, for: .normal)
                cell.stack4Label.text = DecoratedText.totaldosesadministered.rawValue
                cell.stack4Data.setTitle(StaticInfo.shared.completeData?.tested[indexPath.row].totaldosesadministered, for: .normal)
            }
        }else{ // Offline
            cell.starImage.image = UIImage.init(systemName: "star.fill")
            // Cases
            if segmentedControl.selectedSegmentIndex == 0{
                
                cell.stack1Label.text = DecoratedText.date.rawValue
                cell.stack1Data.setTitle(casesFromCoreData[indexPath.row].value(forKey: "date") as? String, for: .normal)
                cell.stack2Label.text = DecoratedText.totalconfirmed.rawValue
                cell.stack2Data.setTitle(casesFromCoreData[indexPath.row].value(forKey: "totalconfirmed") as? String, for: .normal)
                cell.stack3Label.text = DecoratedText.totaldeceased.rawValue
                cell.stack3Data.setTitle(casesFromCoreData[indexPath.row].value(forKey: "totaldeceased") as? String, for: .normal)
                cell.stack4Label.text = DecoratedText.totalrecovered.rawValue
                cell.stack4Data.setTitle(casesFromCoreData[indexPath.row].value(forKey: "totalrecovered") as? String, for: .normal)
            }
            // States
            if segmentedControl.selectedSegmentIndex == 1{
                
                cell.stack1Label.text = DecoratedText.state.rawValue
                cell.stack1Data.setTitle(statesFromCoreData[indexPath.row].value(forKey: "state") as? String, for: .normal)
                cell.stack2Label.text = DecoratedText.active.rawValue
                cell.stack2Data.setTitle(statesFromCoreData[indexPath.row].value(forKey: "active") as? String, for: .normal)
                cell.stack3Label.text = DecoratedText.recovered.rawValue
                cell.stack3Data.setTitle(statesFromCoreData[indexPath.row].value(forKey: "recovered") as? String, for: .normal)
                cell.stack4Label.text = DecoratedText.deaths.rawValue
                cell.stack4Data.setTitle(statesFromCoreData[indexPath.row].value(forKey: "deaths") as? String, for: .normal)
            }
            // Tests
            if segmentedControl.selectedSegmentIndex == 2{
                
                cell.stack5View.isHidden = false
                cell.stack1Label.text = DecoratedText.testedasof.rawValue
                cell.stack1Data.setTitle(testsFromCoreData[indexPath.row].value(forKey: "testedasof") as? String, for: .normal)
                cell.stack2Label.text = DecoratedText.dailyrtpcrsamplescollectedicmrapplication.rawValue
                cell.stack2Data.setTitle(testsFromCoreData[indexPath.row].value(forKey: "dailyrtpcrsamplescollectedicmrapplication") as? String, for: .normal)
                cell.stack3Label.text = DecoratedText.samplereportedtoday.rawValue
                cell.stack3Data.setTitle(testsFromCoreData[indexPath.row].value(forKey: "samplereportedtoday") as? String, for: .normal)
                cell.stack4Label.text = DecoratedText.totaldosesadministered.rawValue
                cell.stack4Data.setTitle(testsFromCoreData[indexPath.row].value(forKey: "totaldosesadministered") as? String, for: .normal)
            }
        }
        
        // On button tapped
        cell.favButtonCallback = {
            if cell.starImage.image == UIImage.init(systemName: "star"){
                cell.starImage.image = UIImage.init(systemName: "star.fill")
                self.isDeleting = false
            }else{
                cell.starImage.image = UIImage.init(systemName: "star")
                self.isDeleting = true
            }
            self.ifFavButtonTapped(id: indexPath.row, sender: cell.favButton)
        }
        
        cell.linkButtonCallback = {
            self.ifLinkButtonTapped(id: indexPath.row, sender: cell.stack5LinkButton)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0{
            if let data = StaticInfo.shared.completeData?.casesTimeSeries[indexPath.row]{
                StaticInfo.shared.selectedDict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: data).children.map{ ($0.label!, $0.value) })
            }
        }
        if segmentedControl.selectedSegmentIndex == 1{
            if let data = StaticInfo.shared.completeData?.statewise[indexPath.row]{
                StaticInfo.shared.selectedDict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: data).children.map{ ($0.label!, $0.value) })
            }
        }
        if segmentedControl.selectedSegmentIndex == 2{
            if let data = StaticInfo.shared.completeData?.tested[indexPath.row]{
                StaticInfo.shared.selectedDict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: data).children.map{ ($0.label!, $0.value) })
            }
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        self.showModalPopup()
    }
    
}

// MARK: - CoreData functions
extension MainViewController: NSFetchedResultsControllerDelegate{
    // Retrive
    private func getFromCoreData(entityName: String) -> [NSFetchRequestResult]?{
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
    // Insert
    private func saveInCoreData() {
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    // Delete
    private func deleteFromCoreData(entityName: String, deletable: String) {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            var predicate = NSPredicate()
            
            if entityName == "CasesEntity"{
                predicate = NSPredicate(format: "date = %@", deletable)
            }
            if entityName == "StatesEntity"{
                predicate = NSPredicate(format: "state = %@", deletable)
            }
            if entityName == "TestsEntity"{
                predicate = NSPredicate(format: "testedasof = %@", deletable)
            }
            
            fetchRequest.predicate = predicate
            
            let result = try context.fetch(fetchRequest)
            
            print(result.count)
            
            if result.count > 0{
                for object in result {
                    print(object)
                    context.delete(object as! NSManagedObject)
                }
            }
            CoreDataStack.sharedInstance.saveContext()
            
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
}
