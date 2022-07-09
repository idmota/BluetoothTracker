//
//  CompassView.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import UIKit

final class CompassView: UIView {

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let topLabel = UILabel.app.body("север")
    let leftLabel = UILabel.app.body("запад")
    let rigthLabel = UILabel.app.body("восток")
    let bottomLabel = UILabel.app.body("юг")
    
    private func setupView() {
        backgroundColor = .red
        [
            topLabel,
            leftLabel,
            rigthLabel,
            bottomLabel
        ].forEach { tView in
            tView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(tView)
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            rigthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rigthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        
    }
}
