//
//  Routing.swift
//  UISeguesExample
//
//  Created by Ивлев Александр Евгеньевич on 24/08/2018.
//

import UISegues
import UIKit

extension FirstViewController: UISegues {
    func showSecondViewController(color: UIColor) {
        let vc = doSegue(identifier: "ShowSecondViewController", on: SecondViewController.self)
        vc.setColor(color)
    }

}
