//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Ирина Соловьева on 07/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var maxHeight: Int = 200
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var immediateTaskLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var headline: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        immediateTask()
        //обработка нажатия на вью
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(goUrl(_:)))
        self.view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    //заполнение лейблов данными задачи или информационным сообщением
    func immediateTask() {
        let key = searchImmediateTask()
        if key == -1 {
            note.text = ""
            headline.text = ""
            deadline.text = ""
            label.text = "Все задачи выполнены или просрочены"
            immediateTaskLabel.text = "Ближайшие задачи отсутсвуют"
            maxHeight = 50
            constraint.constant = 0
        } else {
            let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
            let dictionary = sharedDefaults?.dictionary(forKey: "\(key)") as? [String: String] ?? [String: String]()
            note.text = dictionary["note"] ?? ""
            headline.text = dictionary["headLine"] ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
            if let date = dateFormatter.date(from: dictionary["deadline"] ?? "") {
                deadline.text = dateFormatterPrint.string(from: date)
            }
        }
    }
    
    //функция поиска ближайшей не выпоненной задачи, если возвращает -1, значит таких задач нет, все просрочены или выполнены
    func searchImmediateTask() -> Int {
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
        let arrayKeys = sharedDefaults?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = NSDate().description
        var keyImmediateTask = -1
        guard let startDate = dateFormatter.date(from: date) else {return 0}
        var immediateDate = startDate
        for key in arrayKeys {
            let defaults = sharedDefaults?.dictionary(forKey: "\(key)") as? [String: String] ?? [String: String]()
            guard let deadlineDate = dateFormatter.date(from: defaults["deadline"] ?? "") else {return 0}
            if (startDate < deadlineDate) {
                if (startDate == immediateDate)&&(defaults["status"] != "Выполнено") {
                    keyImmediateTask = key
                    immediateDate = deadlineDate
                } else if (deadlineDate < immediateDate)&&(defaults["status"] != "Выполнено") {
                    immediateDate = deadlineDate
                    keyImmediateTask = key
                }
            }
        }
        return keyImmediateTask
    }
    
    //делаем виджет изменяемым по высоте, maxHeight зависит от наличия ближайшей невыполненной задачи
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(maxHeight))
        }
    }
    
   //функция перехода на нужный экран, если нет невыполненных задач, то переходим на список всех задач
    @objc func goUrl(_ sender: UITapGestureRecognizer) {
        let key = searchImmediateTask()
        if key == -1 {
            let url = URL(string: "ABBYYTestTaskUrl://TaskListTableViewController")!
            self.extensionContext?.open(url, completionHandler: { (success) in
                if (!success) {
                    print("error: failed to open app from Today Extension")
                }
            })
        } else {
            guard let sharedDefaults = UserDefaults(suiteName: "group.com.TDLSI") else { return }
            sharedDefaults.set(key, forKey: "viewTask")
            let url = URL(string: "ABBYYTestTaskUrl://ViewTaskViewController")!
            self.extensionContext?.open(url, completionHandler: { (success) in
                if (!success) {
                    print("error: failed to open app from Today Extension")
                }
            })
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
