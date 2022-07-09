//
//  TableDataSource.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import UIKit


class TableDataSource: NSObject {
    private var models: [BluetoothModel] = []
    
    func reloadData(models: [BluetoothModel], _ completion: (() -> Void)) {
        self.models = models
        
        completion()
    }
}

// MARK: - UITableViewDataSource
extension TableDataSource: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        let model = models[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = model.title
        content.secondaryText = "\(model.RSSI) \(model.power) \(model.signalmath)"
        content.prefersSideBySideTextAndSecondaryText = true
        content.imageProperties.tintColor = .purple

        cell.contentConfiguration = content
        return cell
    }
}
