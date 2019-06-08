//
//  TaskListTableViewController.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 06/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import Foundation

class TaskListTableViewController: UITableViewController {
    private let dataSource = ["Все задачи", "Новая", "В процессе", "Выполнено"]
    var editTask = 0
    var editBool = true
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
    var arrayKeys = UserDefaults.init(suiteName: "group.com.TDLSI")?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
    
    @IBOutlet weak var picker: UIPickerView!
//    @IBAction func moreButton(_ sender: UIButton) {
//        print("+++")
//        let data = arrayKeys[sender.tag]
//        guard let sharedDefaults = UserDefaults(suiteName: "group.com.TDLSI") else { return }
//        sharedDefaults.set(data, forKey: "viewTask")
//       // navigationController?.pushViewController(ViewTaskViewController(), animated: false)
//        present(ViewTaskViewController(), animated: true, completion: nil)
//    }
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.isEditing = false
            editBool = false
        } else {
            tableView.isEditing = true
            editBool = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        arrayKeys = sharedDefaults?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrayKeys)
        return arrayKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        let defaults = sharedDefaults?.dictionary(forKey: "\(arrayKeys[indexPath.row])") as? [String: String] ?? [String: String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: defaults["deadline"] ?? "") {
            print(dateFormatterPrint.string(from: date))
            cell.deadline.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        if let date = dateFormatter.date(from: defaults["dataCreate"] ?? "") {
            print(dateFormatterPrint.string(from: date))
            cell.dataCreate.text = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        cell.headLine.text = defaults["headLine"]
        cell.status.text = defaults["status"]
        cell.note.text = defaults["note"]
        cell.more.tag = indexPath.row
        cell.more.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        let data = arrayKeys[sender.tag]
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.TDLSI") else { return }
        sharedDefaults.set(data, forKey: "viewTask")
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewTaskViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewTask") as UIViewController
        navigationController?.pushViewController(viewTaskViewController, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            let editTaskViewController : EditTaskViewController = segue.destination as! EditTaskViewController
            //  Индекс выделенной ячейки
            if let indexPath = tableView.indexPathForSelectedRow {
              editTask = arrayKeys[indexPath.row]
                editTaskViewController.editTask = editTask
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Удалить") { (rowAction, indexPath) in
            let key = self.arrayKeys.remove(at: indexPath.row)
            print("key = \(key)")
            self.sharedDefaults?.removeObject(forKey: "\(key)")
            self.sharedDefaults?.set(self.arrayKeys, forKey: "arrayKeys")
            tableView.reloadData()
        }
        deleteButton.backgroundColor = UIColor.red
        return [deleteButton]
    }
}

extension TaskListTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            arrayKeys = sharedDefaults?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
            tableView.reloadData()
        default:
            arrayKeys = statusTask(status: dataSource[row])
            tableView.reloadData()
        }
    }
    
    func statusTask(status: String) -> [Int] {
        var arrayStatusTask = [Int]()
        arrayKeys = sharedDefaults?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
        for element in arrayKeys {
            let defaults = sharedDefaults?.dictionary(forKey: "\(element)") as? [String: String] ?? [String: String]()
            if defaults["status"] == status {
                arrayStatusTask.append(element)
            }
        }
        return arrayStatusTask
    }
}
