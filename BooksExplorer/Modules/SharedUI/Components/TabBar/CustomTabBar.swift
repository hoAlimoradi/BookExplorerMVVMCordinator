//
//  CustomTabBar.swift
//  
//
//  Created by ho on 4/9/1403 AP.
//
 
import Foundation
import UIKit
import Combine

class CustomTabBar: UITabBar {
 
    let didSelectTap = PassthroughSubject<Int, Never>()
    private var cancellable: Set<AnyCancellable> = []
    private var selectedIndex = 0
    private let topLine = UIView()

    private enum TabBarConstant {
        static let indicatorHeight: CGFloat = 3
        static let indicatorWidth: CGFloat = 13
        static let indicatorAnimTime: CGFloat = 0.25
        static let circularViewSize: CGFloat = 60
        static let circularBgColor = UIColor(red: 0.95, green: 0.95, blue: 1.00, alpha: 1.00)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    private func customInit() {
        prepareTabBar()
        setupTopLine()
        didSelectTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index_ in
                //self?.animate(index: index_)
                self?.selectedIndex = index_
            }.store(in: &cancellable)
    }
 
    private func setupTopLine() {
            // Remove previous line if needed
            topLine.removeFromSuperview()

            // Setup the new line view
            topLine.backgroundColor = ThemeManager.shared.getCurrentThemeColors().grey1
            topLine.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
            addSubview(topLine)

            // Constraints for the line to stick to the top of the tab bar
            NSLayoutConstraint.activate([
                topLine.topAnchor.constraint(equalTo: topAnchor, constant: -10),
                topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
                topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
                topLine.heightAnchor.constraint(equalToConstant: 1) // Height of the line
            ])
        }
    
    private func prepareTabBar() { 
        backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
    }
 
    private func animate(index: Int) {
        let buttons = subviews
            .filter({ String(describing: $0).contains("Button") })

        guard index < buttons.count else {
            return
        }
         
    }

    private func getCircularView(for index: Int) -> UIView {
        let view = UIView()
        view.tag = index + 1000
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = TabBarConstant.circularBgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = TabBarConstant.circularViewSize / 2
        return view
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        animate(index: selectedIndex)
    }

    override var items: [UITabBarItem]? {
        didSet {
            if items?.count ?? 0 > 0 {
                selectedItem = items?[0]
            }
        }
    }
}

