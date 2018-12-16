//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by apple on 09.12.2018.
//  Copyright © 2018 Aresandro. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date()
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        //print("Save button was pressed")
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        print("My name is: \(firstName) \(lastName).")
        let birthdate = birthdatePicker.date
        //print("My birthday is \(birthdate)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate as NSDate? as Date!
        newBirthday.birthdayId = UUID().uuidString
        if let uniqueId = newBirthday.birthdayId {
            print("birthdayId \(uniqueId)")
        }
        do {
            try context.save()
            let message = "Today \(firstName) \(lastName) celebrates Birthday!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour = 19
            dateComponents.minute = 14
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error {
            print("failed to save due to error \(error).")
        }
        dismiss(animated: true, completion: nil)
        print("Birthday record created")
        print("Name: \(newBirthday.firstName)")
        print("Last Name: \(newBirthday.lastName)")
        print("Date of birth: \(newBirthday.birthdate)")
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

