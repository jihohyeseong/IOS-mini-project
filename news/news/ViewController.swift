//
//  ViewController.swift
//  news
//
//  Created by hyest on 2024/06/15.
//

import UIKit

struct NewsDto: Codable {
    let id: Int?
    let title: String
    let description: String
    let imageUrl: String
}

class NewsApiService {
    private let baseUrl = "http://192.168.73.1:8080/api/news"

    func fetchNewsList(completion: @escaping (Result<[NewsDto], Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let newsList = try JSONDecoder().decode([NewsDto].self, from: data)
                completion(.success(newsList))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func createNews(news: NewsDto, completion: @escaping (Result<NewsDto, Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(news)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let createdNews = try JSONDecoder().decode(NewsDto.self, from: data)
                completion(.success(createdNews))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var newsList: [NewsDto] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")

        // 뉴스 데이터를 불러옵니다.
        fetchNewsList()
        
        // 뉴스 생성 알림을 받음
        NotificationCenter.default.addObserver(self, selector: #selector(newsCreated(_:)), name: NSNotification.Name("NewsCreated"), object: nil)
    }

    func fetchNewsList() {
        let newsApiService = NewsApiService()
        newsApiService.fetchNewsList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newsList):
                    self.newsList = newsList
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch news: \(error)")
                }
            }
        }
    }
    
    @objc func newsCreated(_ notification: Notification) {
        if let createdNews = notification.object as? NewsDto {
            newsList.append(createdNews)
            tableView.reloadData()
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showNewNews", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        
        let news = newsList[indexPath.row]
        cell.textLabel?.text = news.title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = newsList[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: news)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.news = sender as? NewsDto
            }
        } else if segue.identifier == "showNewNews" {
            // Configure new news view controller if needed
        }
    }
}
