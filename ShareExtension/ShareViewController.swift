//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Ирина Соловьева on 08/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }
    
//сохраняем выделенный текст в UserDefaults и переходим в приложение по клику на кнопку Post
    override func didSelectPost() {
        guard let text = textView.text else {return}
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.TDLSI") else { return }
        sharedDefaults.set(text, forKey: "shareTask")
        let result = self.openURL(URL(string: "ABBYYTestTaskUrl://CreateTaskViewController")!)
        print(result)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }

}
