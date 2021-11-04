//
//  ViewController.swift
//  Thiyagarajan
//
//  Created by Vj Ay on 02/11/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var listView: UIBarButtonItem!
    @IBOutlet var gridView: UIBarButtonItem!
    var activityView: UIActivityIndicatorView?
    
    @IBOutlet var tableView: UITableView!
    
    let Jsondata = [NestedJSONModel]()
    
    var obtainedData = [followChess]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.register(UINib(nibName: "GridTableViewCell", bundle: nil), forCellReuseIdentifier: "GridTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
               
        let urlString1 = "https://followchess.com/config.json"
        let url = URL(string: urlString1)
        guard url != nil else {
            return
        }
        
        
        self.getData(fileurl: url!)
        tableView.delegate = self
        tableView.dataSource = self
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
         hideActivityIndicator()
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return obtainedData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
       
        _ = "\(obtainedData[indexPath.row].nameresponse) - \(obtainedData[indexPath.row].slugrsponse)"
        let counting = "\(obtainedData[indexPath.row].slugrsponse)"
        let counted = count(textLine: counting)
        cell.heading.text = "\(obtainedData[indexPath.row].nameresponse) \(obtainedData[indexPath.row].slugrsponse)"
        
        cell.count.text = "Dashes : \(counted)"
        let yearObtained = getYear(getText: obtainedData[indexPath.row].slugrsponse)
        cell.YearLabel.text = yearObtained
        
        if let fileURL = obtainedData[indexPath.row].imgresponse {
            cell.imageDisplay.image = getImage(fileURL: fileURL)
        }

        return cell
       
            
        } else   if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight  {
        
                 let cell = self.tableView.dequeueReusableCell(withIdentifier: "GridTableViewCell", for: indexPath) as! GridTableViewCell
     //            cell.gridImage.image = UIImage(systemName: "folder.fill")
                 cell.gridLabel.text = obtainedData[indexPath.row].nameresponse
                 
                 if let fileURL = obtainedData[indexPath.row].imgresponse {
                     cell.gridImage.image = getImage(fileURL: fileURL)
                 }
                 return cell
            
       
        }
        
        else {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            
            _ = "\(obtainedData[indexPath.row].nameresponse) - \(obtainedData[indexPath.row].slugrsponse)"
            let counting = "\(obtainedData[indexPath.row].slugrsponse)"
            let counted = count(textLine: counting)
            cell.heading.text = "\(obtainedData[indexPath.row].nameresponse) \(obtainedData[indexPath.row].slugrsponse)"
            
            cell.count.text = "Dashes : \(counted)"
            let yearObtained = getYear(getText: obtainedData[indexPath.row].slugrsponse)
            cell.YearLabel.text = yearObtained
            
            if let fileURL = obtainedData[indexPath.row].imgresponse {
                cell.imageDisplay.image = getImage(fileURL: fileURL)
            }
            return cell
            
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300.0;
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        tableView.reloadData()
//
//    }
    
    
    func count(textLine : String) -> Int{
        
        let occurrencies = textLine.filter { $0 == "-" }.count // 0
        return occurrencies
    }
    
    
    func getData (fileurl : URL) {
        
//        showActivityIndicator()
        
        let dataTask = URLSession.shared.dataTask(with: fileurl) { (data, _, _) in
            
            //            print(data)
            
            if let data1 = data {
                
                print(data1)
                
                let json = try! JSONDecoder().decode(NestedJSONModel.self, from: data1)
                
                
                let dataArray = json.trns
                
                for item in dataArray {
                    // ID
                    
                    let status1 = String(item.status)
                    
                    let imageData = item.img ?? "n/a"
                    
                    let receivedData = followChess(nameresponse: item.name, slugrsponse: item.slug, imgresponse: imageData, statusresponse: status1)
                    
                    self.obtainedData.append(receivedData)
                    
                    
                }
            }
            
        }
        dataTask.resume()
//        tableView.reloadData()
//        hideActivityIndicator()
      
    }
    
    func getImage(fileURL : String) -> UIImage {
        
        var downloadedImage : UIImage
        
        if fileURL == "n/a" {
            downloadedImage = UIImage(systemName: "trash")!
            
        } else {
            let url = URL(string: fileURL)
            let data = try? Data(contentsOf: url!)
            downloadedImage = UIImage(data: data!)!
        }

        return downloadedImage
    }
    
    func getYear(getText : String) -> String {
      
        var resultText : String?
        let yearRE = try! NSRegularExpression(pattern: "(?:\\b)[0-9]{4}(?:\\b)")
            yearRE.enumerateMatches(in: getText, range: NSRange(getText.startIndex..<getText.endIndex, in: getText)) { (result, flags, stop) in
                if let result = result {
                     resultText = String(getText[Range(result.range(at: 0), in: getText)!])
                    // Set whatever range you wish to accept
                  
                }
            }

        return resultText!
    }
    
    func showActivityIndicator() {
   
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
        activityView?.hidesWhenStopped = true
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
}

struct NestedJSONModel: Codable {
    let trns: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case trns
    }
}

// MARK: - Datum
struct Datum: Codable {
    
    let name: String
    let slug : String
    let img : String?
    let status : Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case slug = "slug"
        case img = "img"
        case status = "status"
    }
}
