//
//  CreateViewController.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 06/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    var deadline = ""
    var arrayKeys = UserDefaults.init(suiteName: "group.com.TDLSI")?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
    
    @IBAction func dataPicker(_ sender: UIDatePicker) {
        deadline = sender.date.description
    }
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButton(_ sender: UIButton) {
        var dictionary: [String: String] = [:]
        dictionary["dataCreate"] = NSDate().description
        dictionary["status"] = "Новая"
        dictionary["note"] = note.text
        if deadline == "" {
            dictionary["deadline"] = NSDate().description
        } else {
            dictionary["deadline"] = String(deadline)
        }
        if headline.text == "" {
            showError()
        } else {
            dictionary["headLine"] = headline.text
            arrayKeys.append((arrayKeys.last ?? -1)+1)
            guard let sharedDefaults = UserDefaults(suiteName: "group.com.TDLSI") else { return }
            sharedDefaults.set(arrayKeys, forKey: "arrayKeys")
            sharedDefaults.set(dictionary, forKey: "\(arrayKeys.last ?? 0)")
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var headline: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
