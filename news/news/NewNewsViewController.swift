//
//  NewNewsViewController.swift
//  news
//
//  Created by hyest on 2024/06/17.
//

import UIKit

class NewNewsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageUrlTextField: UITextField!
    
    var newsApiService = NewsApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let imageUrl = imageUrlTextField.text, !imageUrl.isEmpty else {
            return
        }
        
        let newNews = NewsDto(id: nil, title: title, description: description, imageUrl: imageUrl)
        
        newsApiService.createNews(news: newNews) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let createdNews):
                    NotificationCenter.default.post(name: NSNotification.Name("NewsCreated"), object: createdNews)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("Failed to create news: \(error)")
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

