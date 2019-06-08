//
//  ViewTaskViewController.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 08/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class ViewTaskViewController: UIViewController {

    @IBOutlet weak var dateCreate: UILabel!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var status: UILabel!
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showTask()
    }

    func showTask() {
        guard let int = sharedDefaults?.integer(forKey: "viewTask") else { return }
        let defaults = sharedDefaults?.dictionary(forKey: "\(int)") as? [String: String] ?? [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: defaults["deadline"] ?? "") {
            print(dateFormatterPrint.string(from: date))
            deadline.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        if let date = dateFormatter.date(from: defaults["dataCreate"] ?? "") {
            print(dateFormatterPrint.string(from: date))
            dateCreate.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        headline.text = defaults["headLine"]
        status.text = defaults["status"]
        note.text = defaults["note"]
    }
    
}
