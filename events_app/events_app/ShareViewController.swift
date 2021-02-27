////
////  ShareViewController.swift
////  eventsShare
////
////  Created by Борис Малашенко on 26.02.2021.
////
//
import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    private var textString: String?
    var selectedEvent: Event!
    
    var selectedTitle: String!
    var selectedDate: Date!
    var selectedStatus: String!
    
    let viewModel = EventsViewModel.self
    var events = [Event]()


    override func viewDidLoad() {
        super.viewDidLoad()

        events = viewModel.getEvents()

        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeText = kUTTypeText as String

        for attachment in extensionItem.attachments! {
            if attachment.isText {
                attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil, completionHandler: { (results, error) in
                    let text = results as! String
                    self.textString = text
                    _ = self.isContentValid()
                })
            }
        }
    }

    override func isContentValid() -> Bool {
        if textString != nil {
            if !contentText.isEmpty {
                return true
            }
        }
        return true
    }

    override func didSelectPost() {
        guard let text = textView.text else {return}

        events.append(Event(title: selectedTitle ?? "event",
                            date: selectedDate ?? Date(),
                            status: selectedStatus ?? "none",
                            comment: text))
        
        viewModel.setEvents(events: events)
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }


    override func configurationItems() -> [Any]! {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "Configure Note"
        item?.tapHandler = {
            let vc = ConfigurationViewController()
            vc.delegate = self
            self.pushConfigurationViewController(vc)
        }
        return [item as Any]
    }

}

extension ShareViewController: ShareViewControllerDelegate {
    func setTitle(title: String) {
        selectedTitle = title
        reloadConfigurationItems()
    }
    
    func setDate(date: Date) {
        selectedDate = date
        reloadConfigurationItems()
    }
    
    func setStatus(status: String) {
        selectedStatus = status
        reloadConfigurationItems()
    }
}

//MARK: NSItemProvider check
extension NSItemProvider {
    var isText: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeText as String)
    }
}
