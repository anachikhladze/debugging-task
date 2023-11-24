//
//  Article.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

// MARK: - Article
struct Article: Decodable {
    let articles: [News]
    // News-ის ნაცვლად უნდა ყოფილიყო ნიუსების array
}

// MARK: - News
struct News: Decodable {
    let author: String?
    // s იყო ზედმეტი
    let title: String
    // ეს თაითლი არ უნდა ყოფილიყო ოფშენალი
    let urlToImage: String?
}
