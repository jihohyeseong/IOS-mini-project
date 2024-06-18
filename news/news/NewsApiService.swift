//
//  NewsApiService.swift
//  news
//
//  Created by hyest on 2024/06/15.
//

import Foundation

class NewsApiService {
    private let baseUrl = "http://192.168.73.1:8080/api/news"  // 여기에 실제 서버 주소를 입력하세요.

    // 뉴스 목록 가져오기
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

    // 특정 뉴스 항목 가져오기
    func fetchNews(by id: Int, completion: @escaping (Result<NewsDto, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(id)") else {
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
                let news = try JSONDecoder().decode(NewsDto.self, from: data)
                completion(.success(news))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

