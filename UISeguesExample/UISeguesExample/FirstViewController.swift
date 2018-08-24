//
//  FirstViewController.swift
//  UISeguesExample
//
//  Created by Ивлев Александр Евгеньевич on 24/08/2018.
//

import UIKit

class FirstViewController: UIViewController {

    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<10 {
            let button = UIButton(frame: CGRect(x: 50, y: 100 + i * 35, width: 200, height: 30))
            switch i {
                case 0: button.backgroundColor = .red
                case 1: button.backgroundColor = .blue
                case 2: button.backgroundColor = .green
                case 3: button.backgroundColor = .yellow
                case 4: button.backgroundColor = .darkGray
                case 5: button.backgroundColor = .cyan
                case 6: button.backgroundColor = .magenta
                case 7: button.backgroundColor = .orange
                case 8: button.backgroundColor = .purple
                case 9: button.backgroundColor = .brown
                default: button.backgroundColor = .white
            }

            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchDown)

            view.addSubview(button)
        }
    }

    @objc
    private func buttonClicked(_ button: UIButton)
    {
        showSecondViewController(color: button.backgroundColor ?? .white)
    }

}

