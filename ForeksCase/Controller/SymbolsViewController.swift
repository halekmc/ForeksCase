//
//  SymbolsViewController.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import UIKit

class SymbolsViewController: UIViewController {
    
    var viewModel: SymbolsViewModelProtocol!
    var timer: Timer?
    var leftSelection: String?
    var rightSelection: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = SymbolsViewModel()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.leftButton.layer.borderColor = UIColor.white.cgColor
        self.rightButton.layer.borderColor = UIColor.white.cgColor
        self.updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    func updateData() {
        self.viewModel.updateData(leftKey: self.leftSelection, rightKey: self.rightSelection) { [unowned self] in
            self.pickerView.reloadAllComponents()
            self.tableView.reloadData()
            if self.leftSelection == nil && self.viewModel.keyList().count > 0 {
                self.leftSelection = self.viewModel.keyList()[0].key
                self.pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            if self.rightSelection == nil && self.viewModel.keyList().count > 1 {
                self.rightSelection = self.viewModel.keyList()[1].key
                self.pickerView.selectRow(1, inComponent: 1, animated: false)
            }
            self.leftButton.setTitle(self.viewModel.nameOfKey(key: self.leftSelection!), for: .normal)
            self.rightButton.setTitle(self.viewModel.nameOfKey(key: self.rightSelection!), for: .normal)
        }
    }
    
    func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] (timer) in
            self.updateData()
        })
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func restartTimer() {
        self.stopTimer()
        self.startTimer()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.pickerContainer.isHidden = false
        self.view.bringSubviewToFront(self.pickerContainer)
    }
    @IBAction func pickerCloserPressed(_ sender: Any) {
        self.pickerContainer.isHidden = true
        let leftIndex = self.pickerView.selectedRow(inComponent: 0)
        let rightIndex = self.pickerView.selectedRow(inComponent: 1)
        self.stopTimer()
        self.leftSelection = self.viewModel.keyList()[leftIndex].key
        self.rightSelection = self.viewModel.keyList()[rightIndex].key
        self.leftButton.setTitle(self.viewModel.nameOfKey(key: self.leftSelection!), for: .normal)
        self.rightButton.setTitle(self.viewModel.nameOfKey(key: self.rightSelection!), for: .normal)
        self.updateData()
        self.startTimer()
    }
}

extension SymbolsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfSymbols()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolCell", for: indexPath) as? SymbolCell {
            let symbol = self.viewModel.dataCarrierAtIndex(atIndex: indexPath.row)
            cell.configureCell(symbol: symbol)
            return cell
        }
        return UITableViewCell()
    }
}

extension SymbolsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.keyList().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.nameOfKey(key: self.viewModel.keyList()[row].key)
    }
}

