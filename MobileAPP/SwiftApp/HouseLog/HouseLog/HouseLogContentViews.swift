//
//  HouseLogContentViews.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 23/05/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import Foundation
import SwiftUI

struct HouseLogViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "HouseLog_Starting_View")

        return controller;
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
