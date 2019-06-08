//
//  EditTaskViewController.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 06/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import Foundation

class EditTaskViewController: UIViewController {
    private let dataSource = ["Новая", "В процессе", "Выполнено"]
    private let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
    
    var editTask = -1
    private var statusTask = ""
    private var deadline = ""
    
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var status: UIPickerView!
    @IBOutlet weak var headLine: UITextField!
    @IBOutlet weak var deadlineDate: UIDatePicker!
    
    @IBAction func deadline(_ sender: UIDatePicker) {
        deadline = sender.date.description
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        var dictionary = sharedDefaults?.dictionary(forKey: "\(editTask)") as? [String: String] ?? [String: String]()
        dictionary["status"] = statusTask
        dictionary["note"] = note.text
        dictionary["deadline"] = String(deadline)
        if headLine.text == "" {
            showError()
        } else {
            dictionary["headLine"] = headLine.text
            sharedDefaults?.set(dictionary, forKey: "\(editTask)")
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    //показываем ошибку если Заголовок не заполнен
    func showError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Заполните поле Заголовок, это обязательное поле", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openTask()
    }
    
    func openTask() {
        if editTask == -1 {
            guard let int = sharedDefaults?.integer(forKey: "viewTask") else { return }
            editTask = int
        }
        let defaults = sharedDefaults?.dictionary(forKey: "\(editTask)") as? [String: String] ?? [String: String]()
        headLine.text = defaults["headLine"]
        note.text = defaults["note"]
        for index in 0...dataSource.count-1 {
            if defaults["status"] == dataSource[index] {
                status.selectRow(index, inComponent: 0, animated: false)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: defaults["deadline"] ?? "") ?? Date()
        deadlineDate.date = date
        statusTask = defaults["status"] ?? "Новая"
        deadline = defaults["deadline"] ?? NSDate().description
    }

}

extension EditTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        statusTask = dataSource[row]
    }
    
}
