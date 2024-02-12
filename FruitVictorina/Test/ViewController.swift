//
//  ViewController.swift
//  Test
//
//  Created by Maryna Bolotska on 11/02/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let fruitsNamesPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
       
    }()
    var rusFruitsNames = ["Банан", "Груша", "Яблоко", "Апельсин", "Вишня", "Ананас", "Клубника"]

    var engFruitsNames = ["Banan", "Pear", "Apple", "Orange", "Cherry", "Pineapple", "Strawberry"]

    
    let answers = ["Банан": "Banan", "Груша": "Pear", "Яблоко": "Apple", "Апельсин": "Orange", "Вишня": "Cherry", "Ананас": "Pineapple", "Клубника": "Strawberry"]
    
    let backgroundImage = UIImageView(image: UIImage(named: "pineapples-1606852_1280"))
    
    private let mainView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Result: 0"
        label.textColor = UIColor(red: 230/255, green: 115/255, blue: 0/255, alpha: 1)
        label.font = UIFont(name: "GillSans-Italic", size: 25)
        return label
    }()
    
    let restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(UIColor(red: 230/255, green: 115/255, blue: 0/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "GillSans-Italic", size: 25)
        button.addTarget(self, action: #selector(pressRestart), for: .touchUpInside)
        return button
    }()
    
    var fruitImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
        
    }()
    
   lazy var matchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Match", for: .normal)
        button.backgroundColor = UIColor(red: 230/255, green: 115/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(pressMatchButton), for: .touchUpInside)
        return button
    }()
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Result: \(score)"
        }
    }
    var correctAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
        rusFruitsNames.shuffle()
       fruitsNamesPickerView.selectRow(0, inComponent: 0, animated: false)
         loadImage(for: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    func loadImage(for row: Int) {
            let imageName = rusFruitsNames[row]
            let image = UIImage(named: imageName)
            fruitImage.image = image
        }
    
    func matchAnswers() {
        
        let selectedIndexRus = fruitsNamesPickerView.selectedRow(inComponent: 0)
      let selectedIndexEng = fruitsNamesPickerView.selectedRow(inComponent: 1)
        let selectedNameRus = rusFruitsNames[selectedIndexRus]
        let selectedNameEng = engFruitsNames[selectedIndexEng]
      
    
        if let correctEngName = answers[selectedNameRus] {
            
            
            if selectedNameEng == correctEngName {
                score += 1
                
                rusFruitsNames.remove(at: selectedIndexRus)
                 engFruitsNames.remove(at: selectedIndexEng)

                fruitsNamesPickerView.reloadAllComponents()
                let alertController = UIAlertController(title: "Win 🥳", message: "+1 point", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Next", style: .default)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            } else {
                score -= 1
                let alertController = UIAlertController(title: "Lose! 😢", message: "-1 point", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Next", style: .default)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
            
            if score == 5 {
                fruitImage.image = UIImage(named: "gameOver")
                let alertController = UIAlertController(title: "Game Over", message: "You have 5 points", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Restart", style: .default) { _ in
                    self.pressRestart()
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func pressMatchButton() {
      matchAnswers()
    }
    
    @objc func pressRestart() {
        score = 0
        rusFruitsNames = ["Банан", "Груша", "Яблоко", "Апельсин", "Вишня", "Ананас", "Клубника"]
        engFruitsNames = ["Banan", "Pear", "Apple", "Orange", "Cherry", "Pineapple", "Strawberry"]
         rusFruitsNames.shuffle()
         fruitsNamesPickerView.reloadAllComponents()
        loadImage(for: 0)
    }
    
    @objc func orientationChanged() {
        if UIDevice.current.orientation.isLandscape {
       
               fruitImage.snp.remakeConstraints { make in
                   make.centerY.equalToSuperview()
                   make.trailing.equalToSuperview().offset(-30)
                   make.width.equalTo(150)
               }
               fruitsNamesPickerView.snp.remakeConstraints { make in
                   make.centerY.equalToSuperview()
                   make.centerX.equalToSuperview()
                   make.width.equalTo(350)
               }
           }
       }
}

extension ViewController {
    func setupUI() {
 
        view.addSubview(mainView)
        mainView.addSubview(backgroundImage)
        mainView.addSubview(restartButton)
        mainView.addSubview(scoreLabel)
        mainView.addSubview(fruitImage)
        mainView.addSubview(fruitsNamesPickerView)
        mainView.addSubview(matchButton)
        
        backgroundImage.contentMode = .scaleAspectFill
        fruitsNamesPickerView.delegate = self
        fruitsNamesPickerView.dataSource = self
       
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        restartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(30)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalTo(restartButton)
        }
        
        fruitImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(scoreLabel.snp.bottom).offset(100)
        }
        
        fruitsNamesPickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fruitImage.snp.bottom).offset(40)
            make.height.equalTo(150)
        }
        
        matchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fruitsNamesPickerView.snp.bottom).offset(30)
            make.width.equalTo(100)
        }
    }
}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return rusFruitsNames.count
        } else {
            return engFruitsNames.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return rusFruitsNames[row]
            
        } else {
            return engFruitsNames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0 {
            
            //            let image = UIImage(named: "\(rusFruitsNames[row])")
            //
            //                 fruitImage.image = image
            
            loadImage(for: row)
        }
    }
}

