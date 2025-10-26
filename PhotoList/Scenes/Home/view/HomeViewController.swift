//
//  HomeViewController.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text_field: UITextField!
    
    let refreshControl = UIRefreshControl()

    private var debounceTimer: Timer?
    private var subscriptions = Set<AnyCancellable>()
    private let debounceInterval: RunLoop.SchedulerTimeType.Stride = .milliseconds(300)
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(viewModel:) instead.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCell()
        setupDebouncedSearch()
        text_field.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.clearDataAndCallAPI()
    }
    
    
    private func setupDebouncedSearch() {
        // Use NotificationCenter publisher to observe text changes
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: text_field)
        .compactMap { ($0.object as? UITextField)?.text }
        .map { $0.trimmingCharacters(in: .whitespaces) } // optional trim
        .removeDuplicates()
        .debounce(for: debounceInterval, scheduler: RunLoop.main)
        .sink { [weak self] query in
            dLog(query)
        }
        .store(in: &subscriptions)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }
        
        // Block non-ASCII (emoji, diacritics)
        if string.contains(where: { !$0.isASCII }) {
            return false
        }

        let allowed = CharacterSet
            .alphanumerics
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "!@#$%^&*():.\""))

        guard string.rangeOfCharacter(from: allowed.inverted) == nil else { return false }

        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return false }
        return current.replacingCharacters(in: range, with: string).count <= 15
    }

}
