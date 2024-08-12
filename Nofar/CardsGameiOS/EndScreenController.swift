//
//  EndScreenController.swift
//  New
//
//  Created by Nofar on 09/08/2024.
//

import UIKit

class EndScreenController:UIViewController {
    
    var isUserWinner: Bool?
    var score: Int = -1
    var winnerLabel: UILabel?
    var scoreLabel: UILabel?
    var backButton: UIButton?

    override func viewDidLoad() {
        winnerLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.midY - 15, width: self.view.frame.width, height: 30))
        winnerLabel!.textAlignment = .center
        winnerLabel!.text = isUserWinner == true ? UserDefaults.standard.value(forKey: "name") as? String ?? "" : "PC"
        winnerLabel!.font = UIFont(name: "Noteworthy Bold", size: 24) ?? .systemFont(ofSize: 18)
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: winnerLabel!.frame.maxY + 10, width: self.view.frame.width, height: 30))
        scoreLabel!.text = "score: \(score)"
        scoreLabel!.textAlignment = .center
        scoreLabel!.font = UIFont(name: "Noteworthy Bold", size: 18) ?? .systemFont(ofSize: 18)

        backButton = UIButton(frame: CGRect(x: self.view.midX - 100, y: self.view.frame.height - 70, width: 200, height: 40))
        backButton?.addTarget(self, action: #selector(didPressMainMenu), for:.touchUpInside)
        backButton?.setTitle("Back To Main Menu", for: .normal)
        backButton?.setTitleColor(.blue, for: .normal)
        backButton?.layer.cornerRadius = 10
        backButton?.setTitleColor(.white, for: .normal)
        backButton?.backgroundColor = .tintColor
        backButton!.titleLabel?.font = UIFont(name: "Noteworthy Bold", size: 18) ?? .systemFont(ofSize: 18)
        
        let backgroundView = UIImageView(frame: view.frame)
        backgroundView.contentMode = .scaleToFill
        backgroundView.image = UIImage(named: "background")
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(winnerLabel!)
        self.view.addSubview(scoreLabel!)
        self.view.addSubview(backButton!)
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
    
    @objc
    func didPressMainMenu(){
        navigationController?.popToRootViewController(animated: true)
    }
}

