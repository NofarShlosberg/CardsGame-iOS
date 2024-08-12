//
//  GameScreenController.swift
//  New
//
//  Created by Nofar on 02/08/2024.
//

import UIKit

class GameScreenController:UIViewController, GameTimerDelegate{
    
    var gameTimer: GameTimer?
    var imageViewLeft:UIImageView?
    var imageViewRight:UIImageView?
    var timeIndicator: UILabel?
    
    var names: [String]?
    var direction: String = "east"
    var scores: [Int] = [0, 0]
    
    var rightNameLabel: UILabel?
    var leftNameLabel: UILabel?
    
    var leftScoreLabel: UILabel?
    var rightScoreLabel: UILabel?
    
    var gamesPlayedLabel: UILabel?
    
    var timerLabel: UILabel?

    var gamesCount = 0
    
    final let GAMES_AMOUNT = 10

    override func viewDidLoad() {
        print("side: \(direction)")
        let rightName = direction == "east" ? names?[0] : names?[1]
        let leftName = direction == "east" ? names?[1]: names?[0]
        
        let safeInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let imageWidth = self.view.frame.width / 4
        
        let font = UIFont(name: "Noteworthy Bold", size: 20)
        
        rightNameLabel = UILabel(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: safeInsets.top + 5, width: imageWidth, height: 30))
        rightNameLabel?.textAlignment = .center
        rightNameLabel?.text = rightName ?? ""
        
        leftNameLabel = UILabel(frame: CGRect(x: safeInsets.left, y: safeInsets.top + 5, width: imageWidth, height: 30))
        leftNameLabel?.textAlignment = .center
        leftNameLabel?.text = leftName ?? ""
        
        rightScoreLabel = UILabel(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: rightNameLabel!.frame.maxY + 5, width: imageWidth, height: 30))
        rightScoreLabel?.textAlignment = .center
        rightScoreLabel?.text = "Score 0"
        
        leftScoreLabel = UILabel(frame: CGRect(x: safeInsets.left, y: leftNameLabel!.frame.maxY + 5, width: imageWidth, height: 30))
        leftScoreLabel?.textAlignment = .center
        leftScoreLabel?.text = "Score 0"
        
        timerLabel = UILabel(frame: CGRect(x: self.view.midX - 50, y: self.view.frame.midY - 25, width: 100, height: 50))
        timerLabel?.textAlignment = .center
        
        let timerImageWidth:CGFloat = 50
        let timerImage = UIImageView(frame: CGRect(x: CGFloat(timerLabel!.midX) - timerImageWidth/2, y: timerLabel!.frame.minY - timerImageWidth - 10, width: timerImageWidth, height: timerImageWidth))
        timerImage.image = UIImage(named: "timer")
        timerImage.alpha = 0
        timerImage.transform.ty = 20
        
        gamesPlayedLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height - safeInsets.bottom - 40, width: self.view.frame.width, height: 50))
        gamesPlayedLabel?.textAlignment = .center

        imageViewLeft = UIImageView(frame: CGRect(x: safeInsets.left, y: leftScoreLabel!.frame.maxY, width: self.view.frame.width / 4, height: self.view.frame.height * 3/5))
        imageViewLeft?.image = UIImage(named: "cardback")
        
        imageViewRight = UIImageView(frame: CGRect(x: self.view.frame.width - safeInsets.right - imageWidth, y: leftScoreLabel!.frame.maxY, width: self.view.frame.width / 4, height: self.view.frame.height * 3/5))
        imageViewRight?.image = UIImage(named: "cardback")
        
        gameTimer = GameTimer()
        gameTimer?.delegate = self
        gameTimer?.start()
        
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.view.addSubview(timerImage)
        self.view.addSubview(timerLabel!)
        self.view.addSubview(rightScoreLabel!)
        self.view.addSubview(leftScoreLabel!)
        self.view.addSubview(rightNameLabel!)
        self.view.addSubview(leftNameLabel!)
        self.view.addSubview(imageViewLeft!)
        self.view.addSubview(imageViewRight!)
        self.view.addSubview(gamesPlayedLabel!)
        
        for view in self.view.subviews {
            (view as? UILabel)?.font = font
        }
        
        UIView.animate(withDuration: 1){
            timerImage.alpha = 1
            timerImage.transform.ty = 0
        }
    }
 
    func didUpdateTime(time: Int) {
        timerLabel?.text = "\(time >= 5 ? 0 : 5 - time)"
        if(time == 5){
            revealCards()
            gamesCount += 1;
            gamesPlayedLabel?.text = "Games played: \(gamesCount)"
        }else if time == 8{
            if(gamesCount == GAMES_AMOUNT){
                gameTimer?.stop()
                navigateToEndScreen()
            }else{
                resetCards()
            }
        }
    }
    
    func navigateToEndScreen(){
        let endScreenController = EndScreenController()
        var isUserWinner = false
        
        if(scores[0] == scores[1]){
            isUserWinner = true
        }else if(scores[0] < scores[1] && direction == "east"){
            isUserWinner = true
        }else if(scores[0] > scores[1] && direction == "west"){
            isUserWinner = true
        }
        
        endScreenController.isUserWinner = isUserWinner
        endScreenController.score = max(scores[0], scores[1])
        self.navigationController?.pushViewController(endScreenController, animated: true)
    }
    
    func revealCards(){
        let cards = generateRandomCards()
        
        //0 - left
        let result = cards[0].compare(secondCard: cards[1])

        switch result{
        case .tie:
            scores[0] += 1
            scores[1] += 1
            leftScoreLabel?.text = "score \(scores[0])"
            rightScoreLabel?.text = "score \(scores[1])"
            break
        case .bigger:
            scores[0] += 1
            leftScoreLabel?.text = "score \(scores[0])"
            break
        default:
            scores[1] += 1
            rightScoreLabel?.text = "score \(scores[1])"
            break
        }
        
        //Flip card
        UIView.animate(withDuration: 0.5, animations: {
            
            //Flip y - 90
            self.imageViewLeft?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
            self.imageViewRight?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
        }){
            _ in
            
            //Set to new image
            self.imageViewLeft?.image = UIImage(named: "\(cards[0].number)")
            self.imageViewRight?.image = UIImage(named: "\(cards[1].number)")
            UIView.animate(withDuration: 0.5){
                //Flip back
                self.imageViewLeft?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
                self.imageViewRight?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
            }
        }
    }
        
    func resetCards(){
        //Flip Back
        UIView.animate(withDuration: 0.5, animations: {
            
            //Flip y - 90
            self.imageViewLeft?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
            self.imageViewRight?.layer.transform = CATransform3DMakeRotation(Double.pi/2, 0, 1, 0)
        }){
            _ in
            
            //Set to new image
            self.imageViewLeft?.image = UIImage(named: "cardback")
            self.imageViewRight?.image = UIImage(named: "cardback")

            UIView.animate(withDuration: 0.5){
                //Flip back
                self.imageViewLeft?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
                self.imageViewRight?.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
            }
        }
    }
    
    func generateRandomCards() -> [Card]{
        var number = Int.random(in: 0...12) + 1
        let CardRight = Card(number: number)
        
        number = Int.random(in: 0...12) + 1
        let CardLeft = Card(number: number)
        
        return [CardLeft, CardRight]
    }
}

enum CardCompare {
   case tie, bigger, smaller
}

struct Card {
    var number: Int
    
    func compare(secondCard: Card)->CardCompare{
        if number == secondCard.number{
            return .tie
        }else if number > secondCard.number{
            return .bigger
        }
        return .smaller
    }
}

protocol GameTimerDelegate {
    func didUpdateTime (time: Int)-> Void
}

class GameTimer {
    var timer: Timer?
    var timeLapsed = 0
    var delegate: GameTimerDelegate?
    
    @objc func fire(){
        timeLapsed += 1;
        delegate?.didUpdateTime(time: timeLapsed)
        if(timeLapsed == 8){
           reset()
        }
    }
    
    func reset(){
        timeLapsed = 0
    }
    
    func start(){
        timer = Timer(timeInterval: 1, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode:.common)
    }
    
    func stop(){
        timer?.invalidate()
    }
}
