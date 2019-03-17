//
//  ViewController.swift
//  WalletTableDemoApp
//
//  Created by Henrik Panhans on 17.03.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clear
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.widthConstraint.constant = self.view.frame.width - (16 * 2)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateContentSize()
    }
    
    func updateContentSize() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.tableView.contentSize.height + 50)
        self.heightConstraint.constant = self.tableView.contentSize.height
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(arc4random_uniform(9)) + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(arc4random_uniform(5)) + 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
        
        let config = TableConfig(numberOfRowsInSection: tableView.numberOfRows(inSection: indexPath.section))
        cell.applyConfig(for: indexPath, config: config)
        
        return cell
    }
}

extension UITableViewCell {
    func applyConfig(for indexPath: IndexPath, config: TableConfig) {
        switch indexPath.row {
        case config.numberOfRowsInSection - 1:
            // This is the case when the cell is last in the section,
            // so we round to bottom corners
            self.roundCorners(.bottom, radius: 15)
            
            // However, if it's the only one, round all four
            if config.numberOfRowsInSection == 1 {
                self.roundCorners(.all, radius: 15)
            }
            
        case 0:
            // If the cell is first in the section, round the top corners
            self.roundCorners(.top, radius: 15)
            
        default:
            // If it's somewhere in the middle, round no corners
            self.roundCorners(.all, radius: 0)
        }
        
        if indexPath.row != 0 {
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRect(x: 16.0,
                                        y: 0,
                                        width: self.contentView.frame.size.width - 16,
                                        height: 0.2)
            bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
            self.contentView.layer.addSublayer(bottomBorder)
        }
    }
}

// Helper struct to keep track of how many cells there are in a section
struct TableConfig {
    var numberOfRowsInSection: Int
}
