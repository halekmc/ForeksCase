//
//  SymbolCell.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation
import UIKit

class SymbolCell: UITableViewCell {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var symbolName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(symbol: SymbolDataCarrier) {
        self.symbolName.text = symbol.symbolName
        self.time.text = symbol.time
        self.leftValue.text = symbol.leftValue
        self.rightValue.text = symbol.rightValue
        self.backgroundColor = UIColor.clear
        if symbol.needsHighlight {
            self.backgroundColor = UIColor.darkGray
        }
        self.selectImage(state: symbol.riseState)
        self.leftValue.textColor = self.selectColor(state: symbol.leftValueState)
        self.rightValue.textColor = self.selectColor(state: symbol.rightValueState)
    }
    
    private func selectImage(state: SymbolRiseState) {
        switch state {
        case .increasing:
            self.arrowImage.image = UIImage(systemName: "chevron.up") ?? UIImage()
            self.arrowImage.backgroundColor = UIColor.green
        case .noChange:
            self.arrowImage.image = UIImage()
            self.arrowImage.backgroundColor = UIColor.clear
        case .decreasing:
            self.arrowImage.image = UIImage(systemName: "chevron.down") ?? UIImage()
            self.arrowImage.backgroundColor = UIColor.red
        }
    }
    
    private func selectColor(state: SymbolRiseState) -> UIColor {
        switch state {
        case .increasing:
            return UIColor.green
        case .noChange:
            return UIColor.white
        case .decreasing:
            return UIColor.red
        }
    }

}
