//
//  NewsViewController.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var news = [News]()
    private var viewModel: NewsViewModel = DefaultNewsViewModel()
    // აქ იყო typo, ეწერა DefaultNewViewModel
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTableViewConstraints()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        // ესენი აქ ჩამოვიტანე
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        // Identifier იყო არასწორად, პატარა ასოთი
    }
    
    // MARK: - Setup TableView
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
        // აკლდა ვიუმოდელის დელეგატისთვის სელფის დასეტვა
    }
}

// MARK: - TableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
        // .zero შევცვალე ამით
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsTableViewCell {
            // ესეც შეცვლილია
            cell.configure(with: news[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
        // .zero შევცვალე ამით
    }
}

// MARK: - NewsListViewModelDelegate
extension NewsViewController: NewsViewModelDelegate {
    func newsFetched(_ news: [News]) {
        self.news = news
        // Main thread-ზე რომ მოხდეს ეს აკლდა
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
