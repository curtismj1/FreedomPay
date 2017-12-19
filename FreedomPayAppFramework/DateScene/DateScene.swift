//
//  DateScene.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

public class DateScene {
    let interactor = DateViewControllerLogic()
    lazy var rvc = DateViewController(interactor: interactor)
    lazy var presenter = DateViewPresentationLogic(view: rvc)
    public lazy var navVC = UINavigationController(rootViewController: rvc)
    public init() {
        interactor.presenter = presenter
    }
}
