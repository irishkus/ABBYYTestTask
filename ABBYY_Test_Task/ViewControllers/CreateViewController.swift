//
//  CreateViewController.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 06/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    
    let sharedDefaults = UserDefaults.init(suiteName: "group.com.TDLSI")
    var deadline = ""
    lazy var arrayKeys = sharedDefaults?.array(forKey: "arrayKeys") as? [Int] ?? [Int]()
    
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var headline: UITextField!
    
    @IBAction func dataPicker(_ sender: UIDatePicker) {
        deadline = sender.date.description
    }
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //создание новой записи
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        showSharedTask()
    }
    
    //показываем ошибку если Заголовок не заполнен
    func showError() {
        let alter = UIAlertController(title: "Ошибка", message: "Заполните поле Заголовок, это обязательное поле", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    func showSharedTask() {
        guard let headlineShareTask = sharedDefaults?.string(forKey: "shareTask") else { return }
        headline.text = headlineShareTask
        sharedDefaults?.removeObject(forKey: "shareTask")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
