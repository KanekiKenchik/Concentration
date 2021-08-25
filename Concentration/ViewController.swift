//
//  ViewController.swift
//  Concentration
//
//  Created by Афанасьев Александр Иванович on 16.07.2021.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = ConcentrationGame(numberOfPairedCards: numberOfPairedCards)
    
    var numberOfPairedCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    
    private func updateTouches() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 4.0,
            .strokeColor: UIColor.init(cgColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        ]
        let attributedString = NSAttributedString(string: "Нажатий: \(touches)", attributes: attributes)
        countTouch.attributedText = attributedString
    }
    
    private(set) var touches = 0 {
        didSet{
            updateTouches()
        }
    }

//    private var emojiCollection = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼", "🐻‍❄️", "🐨"]
    private var emojiCollection = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨"
    private var emojiDictionary = [Int:String]()
    
    private func emojiIdentifier (for card: Card) -> String {
        if emojiDictionary[card.identifier] == nil {
            let randomStringIndex = emojiCollection.index(emojiCollection.startIndex, offsetBy: emojiCollection.count.arc4randomExtension)
            emojiDictionary[card.identifier] = String(emojiCollection.remove(at: randomStringIndex))
        }
        return emojiDictionary[card.identifier] ?? "?"`     `123
    }
    
    private func updateViewFromModel() {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4905924201, blue: 1, alpha: 1)
            }
        }
    }
    
    
    @IBOutlet private var buttonCollection: [UIButton]!
    
    @IBOutlet private weak var countTouch: UILabel! {
        didSet {
            updateTouches()
        }
    }
    
    @IBAction private func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
    }
    

    @IBAction func buttonReset(_ sender: UIButton) {
        touches = 0
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 0, green: 0.4905924201, blue: 1, alpha: 1)
             
        }
    }
    
}

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else {
            return 0 
        }
    }
}
