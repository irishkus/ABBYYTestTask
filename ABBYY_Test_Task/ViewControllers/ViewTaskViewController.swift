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
    
//функция заполнения лейблов данными выбранной на просмотр задачи
    func showTask() {
        guard let int = sharedDefaults?.integer(forKey: "viewTask") else { return }
        let defaults = sharedDefaults?.dictionary(forKey: "\(int)") as? [String: String] ?? [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: defaults["deadline"] ?? "") {
            deadline.text = dateFormatterPrint.string(from: date)
        }
        if let date = dateFormatter.date(from: defaults["dataCreate"] ?? "") {
            dateCreate.text = dateFormatterPrint.string(from: date)
        }
        headline.text = defaults["headLine"]
        status.text = defaults["status"]
        note.text = defaults["note"]
    }
    
}
