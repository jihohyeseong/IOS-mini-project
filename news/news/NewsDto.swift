//
//  NewsDto.swift
//  news
//
//  Created by hyest on 2024/06/15.
//

import Foundation

struct NewsDto: Codable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String?
}
