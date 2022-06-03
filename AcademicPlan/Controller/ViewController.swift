//
//  ViewController.swift
//  AcademicPlan
//
//  Created by Акбала Тлеугалиева on 5/27/22.
//  Copyright © 2022 Akbala Tleugaliyeva. All rights reserved.
//


import UIKit

extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor(red: 0.9725, green: 0.9765, blue: 0.9843, alpha: 1.0).cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor(red: 0.9725, green: 0.9765, blue: 0.9843, alpha: 1.0).cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 163/255, green: 176/255, blue: 205/255, alpha: 1.0)], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 19/255, green: 6/255, blue: 22/255, alpha: 1.0)], for: .selected)
    }
    
    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 4.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 242/255, green: 189/255, blue: 67/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDownloadDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var academicYearLabel: UILabel!
     
    var discipline: Root?
    var docURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FetchStudentInfo()
        configureView()
    }
      //MARK: - Configure View
      func configureView() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addUnderlineForSelectedSegment()
          navigationItem.title = "Индивидуальный учебный план"
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = UIColor(red: 1, green: 0.3725, blue: 0.3529, alpha: 1.0)
          appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

          navigationController?.navigationBar.standardAppearance = appearance;
          navigationController?.navigationBar.scrollEdgeAppearance = appearance;
          navigationController?.navigationBar.isTranslucent = true
    }
    
        //MARK: - Fetch Student Data
        func FetchStudentInfo() {
            if let filePath = Bundle.main.url(forResource: "Data", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: filePath)
                     let studentData = try JSONDecoder().decode(Root.self, from: data)
                        discipline = studentData

                    DispatchQueue.main.async { [weak self] in
                        self?.academicYearLabel.text = "ИНДИВИУАЛЬНЫЙ УЧЕБЫЙ ПЛАН НА \(studentData.academicYear.uppercased())"
                         self?.tableView.reloadData()
                             self?.segmentedControl.setTitle("Семестр \(String(describing: self?.discipline!.semesters[0].Number))", forSegmentAt: 0)
                                    self?.segmentedControl.setTitle("Семестр \(String(describing: self?.discipline!.semesters[1].Number))", forSegmentAt: 1)
                    }
                } catch let error as NSError{
                    print("Parse Error\(error)")
                }
            }
        }
     //MARK: - Download File
    @IBAction func DownloadFile(_ sender: Any) {
        guard let url = URL(string: discipline!.documentURL) else {
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File location", location)
        
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationPath)
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            self.docURL = destinationPath
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func SegmentedControlDidChange(_ sender: UISegmentedControl) {
        segmentedControl.changeUnderlinePosition()
    }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let discipline = discipline else {
            return 0
        }
        return discipline.semesters[0].disciplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlanTableViewCell
        switch(segmentedControl.selectedSegmentIndex) {
          
        case 0:
            cell.lessonNameLabel.text = discipline?.semesters[0].disciplines[indexPath.row].disciplineName.nameRu
            cell.lessonType1.text = "\(discipline!.semesters[0].disciplines[indexPath.row].lesson[0].realHours) / \(discipline!.semesters[0].disciplines[indexPath.row].lesson[0].hours)"
            cell.lessonType2.text = "\(discipline!.semesters[0].disciplines[indexPath.row].lesson[1].realHours) / \(discipline!.semesters[0].disciplines[indexPath.row].lesson[1].hours)"
            cell.lessonType3.text = "\(discipline?.semesters[0].disciplines[indexPath.row].lesson[2].realHours ?? 0) / \(discipline?.semesters[0].disciplines[indexPath.row].lesson[2].hours ?? 0)"
            break
        case 1:
            cell.lessonNameLabel.text = discipline?.semesters[1].disciplines[indexPath.row].disciplineName.nameRu
             cell.lessonType1.text = "\(discipline!.semesters[1].disciplines[indexPath.row].lesson[0].realHours) / \(discipline!.semesters[1].disciplines[indexPath.row].lesson[0].hours)"
            cell.lessonType2.text = "\(discipline!.semesters[1].disciplines[indexPath.row].lesson[1].realHours) / \(discipline!.semesters[1].disciplines[indexPath.row].lesson[1].hours)"
            cell.lessonType3.text =  "\(discipline?.semesters[1].disciplines[indexPath.row].lesson[2].realHours ?? 0) / \(discipline?.semesters[1].disciplines[indexPath.row].lesson[2].hours ?? 0)"
            break
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
