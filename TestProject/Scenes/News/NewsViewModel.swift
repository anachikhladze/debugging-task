//
//  NewsViewModel.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//


import Foundation

protocol NewsViewModelDelegate: AnyObject {
    // მივამატეთ AnyObject
    func newsFetched(_ news: [News])
    func showError(_ error: Error)
}

protocol NewsViewModel {
    var delegate: NewsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultNewsViewModel: NewsViewModel {
    
    // MARK: - Properties
    private let newsAPI = "https://newsapi.org/v2/everything?q=tesla&from=2023-11-11&sortBy=publishedAt&apiKey=ce67ca95a69542b484f81bebf9ad36d5"
    
    private var newsList = [News]()
    
    weak var delegate: NewsViewModelDelegate?
    // ეს უნდა იყოს weak retain cycle-ს თავიდან ასარიდებლად
    
    // MARK: - Public Methods
    func viewDidLoad() {
        fetchNews()
        // ეს განვაკომენტარეთ
    }
    
    // MARK: - Private Methods
    private func fetchNews() {
        NetworkManager.shared.get(urlString: newsAPI) { [weak self] (result: Result<Article, Error>) in
            switch result {
            case .success(let articles):
                // ესენიც შეცვლილია მთლიანად
                self?.newsList = articles.articles
                self?.delegate?.newsFetched(articles.articles)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}
