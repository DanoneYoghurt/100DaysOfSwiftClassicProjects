//
//  ViewController.swift
//  milestone5
//
//  Created by Антон Баскаков on 17.09.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Назначаем путь к файлу
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            // Присваеваевыем данные константе data
            if let data = try? Data(contentsOf: url) {
                // Создаем экземпляр декодера
                let decoder = JSONDecoder()
                // Декодируем данные
                guard let decoded = try? decoder.decode([Country].self, from: data) else { return }
                
                // Присваиваем переменной countries наши декодированные данные
                countries = decoded
                
                // Обновляем таблицу
                tableView.reloadData()
            }
        }
    }
    
    // Метод для определения количества ячеек в TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // Метод для регестрации переиспользуемых ячеек по идентификатору
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Создаем ячейку
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        // Назначаем имя страны каждой ячейке
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }

    // Метод для вызыва при выборе ячейки пользователем
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.country = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

