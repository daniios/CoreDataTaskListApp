//
//  ViewController.swift
//  TaskListApp
//
//  Created by Vasichko Anna on 29.06.2023.
//  Modified by Chupin Daniil on 02.07.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        fetchData()
    }
    
 
    // MARK: - Private methods
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", message: "What would you like to do?", saveActionHandler: { [unowned self] taskName in
            save(taskName)
        })
    }
    
    private func fetchData() {
        taskList = CoreDataHelper.shared.fetchData()
        tableView.reloadData()
    }
    
    private func save(_ taskName: String) {
        guard let newTask = CoreDataHelper.shared.save(taskName) else { return }
        
        taskList.append(newTask)
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dismiss(animated: true)
    }
    
    private func update(_ task: Task, withName newName: String) {
        CoreDataHelper.shared.update(task, withName: newName)
        let indexPath = IndexPath(row: taskList.firstIndex(of: task)!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func delete(_ task: Task) {
        CoreDataHelper.shared.delete(task)
        fetchData()
    }
    
    private func showAlert(withTitle title: String, message: String, taskName: String? = nil, saveActionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = taskName
        }
        
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            saveActionHandler(taskName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        showEditAlert(for: task, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            delete(task)
        }
    }
    
    private func showEditAlert(for task: Task, at indexPath: IndexPath) {
        showAlert(withTitle: "Edit Task", message: "Edit task name:", taskName: task.title, saveActionHandler: { [unowned self] newTaskName in
            update(task, withName: newTaskName)
        })
    }
}


// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MainBlue")
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

