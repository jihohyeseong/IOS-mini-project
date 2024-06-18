//
//  DetailViewController.swift
//  news
//
//  Created by hyest on 2024/06/16.
//

import UIKit

class DetailViewController: UIViewController {
    var news: NewsDto?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        guard let news = news else { return }
        titleLabel.text = news.title
        descriptionTextView.text = news.description
        if let url = URL(string: news.imageUrl) {
            loadImage(from: url)
        }
    }

    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func sumUp(_ sender: Any) {
        guard let news = news else { return }
               
               // Prepare the request
               guard let url = URL(string: "http://192.168.73.1:8080/api/summary") else { return }
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")

               // Create the request body
               do {
                   let jsonData = try JSONEncoder().encode(news)
                   request.httpBody = jsonData
               } catch {
                   print("Failed to encode news: \(error)")
                   return
               }

               // Send the request
               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Failed to fetch summary: \(error)")
                       return
                   }

                   guard let data = data else {
                       print("No data received")
                       return
                   }

                   // Parse the response
                   do {
                       if let summaryResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                          let summary = summaryResponse["summary"] {
                           DispatchQueue.main.async {
                               self.descriptionTextView.text = summary
                           }
                       } else {
                           print("Invalid response format")
                       }
                   } catch {
                       print("Failed to parse response: \(error)")
                   }
               }
               task.resume()
    }
}
