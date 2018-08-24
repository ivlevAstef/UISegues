//
//  SecondViewController.swift
//  UISeguesExample
//
//  Created by Ивлев Александр Евгеньевич on 24/08/2018.
//

import UIKit

class SecondViewController: UIViewController {

    private let coloredView: UIView = UIView(frame: CGRect(x: 50, y: 150, width: 50, height: 50))

    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        coloredView.layer.cornerRadius = 25.0
        view.addSubview(coloredView)

        let label = UILabel(frame: CGRect(x: 50, y: 215, width: 200, height: 25))
        label.text = "Это ваш цвет?"
        view.addSubview(label)
    }

    func setColor(_ color: UIColor) {
        coloredView.backgroundColor = color
    }

}
