//
//  HouseLogCollectionViewCell.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 27/06/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import UIKit

enum SensorState {
    case green
    case red
}

class HouseLogCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var SensorImage: UIImageView!
    @IBOutlet weak var sensorStateLabel: UILabel!
    @IBOutlet weak var sensorPlacingButton: UIButton!
    @IBOutlet weak var houseLogSensorLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var sensorDelegate : HouseLogSensorDelegate?
    var isClose : Bool = false
    var isLooping : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sensorDelegate = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setIsLooping(_ boolean: Bool)
    {
        isLooping = boolean
    }
    
    func setCellTovisual() {
        SensorImage.isHidden = true
        sensorPlacingButton.isHidden = true
        houseLogSensorLabel.text = "Configure more Sensors"
        sensorStateLabel.text = "Disable"
        sensorStateLabel.textColor = UIColor.brown
    }
    
    func setCellToWork() {
        SensorImage.isHidden = false
        sensorPlacingButton.isHidden = false
        sensorPlacingButton.titleLabel?.textAlignment = .center
        houseLogSensorLabel.text = "House Log Sensor"
    }
    
    func updateCellState(_ state: SensorState) {
        print("updateCellState state = ", state)
        configSensorStateLabel(state)
        configSensorImage(state)
    }
    
    private func configSensorStateLabel(_ state: SensorState) {
        if (state == SensorState.green) {
            /*sensorStateLabel.textColor = UIColor(red: 52, green: 162, blue: 89, alpha: 1.0)*/
            sensorStateLabel.textColor = UIColor.customGreen
            sensorStateLabel.text = "Open"
        }
        else {
            sensorStateLabel.textColor = UIColor.red
            sensorStateLabel.text = "Close"
        }

    }
    
    private func configSensorImage(_ state: SensorState) {
        if (state == SensorState.green) {
            let image = #imageLiteral(resourceName: "Green_circle")
            SensorImage.image = image
        }
        else {
            let image = #imageLiteral(resourceName: "Red_circle")
            SensorImage.image = image
        }
    }
    
    @IBAction func askForPlacingSensor()
    {
        sensorDelegate?.wantToPlaceSensor()
    }
    
    func setAndLaunchCellBehavior(_ houseLogSensorDelegate: HouseLogSensorDelegate?)
    {
        if (houseLogSensorDelegate != nil) {
            sensorDelegate = houseLogSensorDelegate
            launchBehavior()

        }
        else {
            print("bizarre")
        }
    }
    
    func isNewState(_ state: SensorState) -> Bool {
        print(state)
        if ((state == SensorState.green && sensorStateLabel.textColor == UIColor.customGreen)
            || (state == SensorState.red && sensorStateLabel.textColor == UIColor.red))
        {
            print("not new state")
            return false
        }
        print("new state")
        return true
    }
    
    func launchBehavior()
    {
        var updatingStateDWI : DispatchWorkItem?
        updatingStateDWI = DispatchWorkItem {
            
            
            while (self.isLooping) {
                
                let params = ["username":getUsername()] as Dictionary<String, String>
                var request = URLRequest(url: URL(string: "http://0.0.0.0:80/check_doors/check_doors")!)

                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
                let httpBody = String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                print("Cell call httpBody = ", httpBody)

                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    if (response != nil) {
                        print("response = \n", response!)
                    }
                    do {
                        if (response != nil) {
                            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                            print(json)

                            if (json["data"] != nil) {
                                let jsonResponses = json["data"] as! NSArray
                                let randIndex = Int.random(in: 1..<200) % jsonResponses.count
                                print("randIndex = ", randIndex)

                                let jsonDoor = jsonResponses[randIndex] as! Dictionary<String, AnyObject>
                                print("jsonReponses[randIndex] = ", jsonDoor)
                                if (jsonDoor["ReqStatus"] != nil
                                    && jsonDoor["ReqStatus"] as! String == "ok") {
                                    let state = jsonDoor["status"] as! String == "open"
                                                ? SensorState.green
                                                : SensorState.red
                                    print(state)
                                    DispatchQueue.main.async {
                                        if (self.isNewState(state)) {
                                            self.updateCellState(state)
                                            self.sensorDelegate?.sensorUpdate(state)
                                        }
                                    }
                                }
                                
                            }
                        }
                    } catch {
                        print("Cell error")
                    }
                })
                task.resume()
                /*DispatchQueue.main.async {
                    if (self.isNewState(SensorState.green)) {
                        self.updateCellState(SensorState.green)
                        self.sensorDelegate?.sensorUpdate(SensorState.green)
                    }
                    else {
                        self.updateCellState(SensorState.red)
                        self.sensorDelegate?.sensorUpdate(SensorState.red)
                    }
                }*/
                sleep(10)
            }
        }
        DispatchQueue.global().async(execute:
            updatingStateDWI!)
    }
    
}
