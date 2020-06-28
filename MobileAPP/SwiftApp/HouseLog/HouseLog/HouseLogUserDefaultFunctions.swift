//
//  HouseLogUserDefaultFunctions.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 17/06/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import Foundation
import UIKit

let modelImageNameKey = "modelImageName"
let modelImageURLKey = "modelImageUrl"
let modelImageKey = "modelImage"

let usernameKey = "username"
let passwordKey = "password"
let doorNameKey = "doorName"

func setModelImageName(_ name: String)
{
    let defaults = UserDefaults.standard
    let defaultValue = [modelImageNameKey: name]

    defaults.register(defaults: defaultValue)
}

func getModelImageName() -> String
{
    let defaults = UserDefaults.standard
    let token = defaults.string(forKey: modelImageNameKey)
    
    return token!
}

func setModelImageURL(_ url: String)
{
    let defaults = UserDefaults.standard
    let defaultValue = [modelImageURLKey: url]

    defaults.register(defaults: defaultValue)
}

func getModelImageURL() -> String
{
    let defaults = UserDefaults.standard
    let token = defaults.string(forKey: modelImageURLKey)

    return token!
}

func setModelImage(_ image: UIImage)
{
    let defaults = UserDefaults.standard
    let defaultValue = [modelImageKey: image]

    defaults.register(defaults: defaultValue)
}

func getModelImage() -> UIImage
{
    let defaults = UserDefaults.standard
    let token : UIImage = defaults.object(forKey: modelImageKey) as! UIImage

    return token
}

//--------------- USERNAME ---------------

func setUsername(_ username: String)
{
    let defaults = UserDefaults.standard
    let defaultValue = [usernameKey: username]

    defaults.register(defaults: defaultValue)

}

func getUsername() -> String
{
    //let defaults = UserDefaults.standard
    //let token : String = defaults.object(forKey: usernameKey) as! String

    return ""
    //return token
}

func setPassword(_ password: String)
{
    let defaults = UserDefaults.standard
    let defaultValue = [passwordKey: password]

    defaults.register(defaults: defaultValue)

}

func getPassword() -> String
{
    let defaults = UserDefaults.standard
    let token : String = defaults.object(forKey: passwordKey) as! String

    return token

}

func setDoorName(_ doorName: String)
{
    let defaults = UserDefaults.standard
    let defaultValue = [doorNameKey: doorName]

    defaults.register(defaults: defaultValue)
}

func getDoorName() -> String
{
    let defaults = UserDefaults.standard
    let token : String = defaults.object(forKey: doorNameKey) as! String

    return token
}
