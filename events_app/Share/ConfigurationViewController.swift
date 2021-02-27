//
//  ConfigurationViewController.swift
//  Share
//
//  Created by Борис Малашенко on 27.02.2021.
//

import UIKit

protocol ShareViewControllerDelegate: class {
    func setTitle(title: String)
    
    func setDate(date: Date)
    
    func setStatus(status: String)
}

class ConfigurationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!
    
    var statusses: [String]!
    
    weak var delegate: ShareViewControllerDelegate?
    
    @IBAction func titleChanged(_ sender: Any) {
        if let delegate = delegate {
            delegate.setTitle(title: titleTextField.text!)
        }
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        if let delegate = delegate {
            delegate.setDate(date: datePicker.date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusses = Event.getStatuses()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        statusses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let delegate = delegate {
            delegate.setStatus(status: statusses[row])
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
