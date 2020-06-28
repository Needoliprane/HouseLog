//
//  HouseLogLoginViewController.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 23/05/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import UIKit

class HouseLogLoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var loginButton: UIButton?
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    var username : String? = nil
    var password : String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton?.contentMode = .scaleAspectFit
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func addSomeDoorsToAPI(completion: @escaping (_ response: [String: AnyObject]?) -> Void)
    {
        if (getUsername() != "doorName1") {
            setDoorName("doorName1")
        }

        let params = ["username":getUsername(), "name":getDoorName(), "position":"position", "status":"close"] as Dictionary<String, String>
        //let params = ["username":"test", "name":"testDoor", "position":"positionDoor", "status":"close"] as Dictionary<String, String>
        var request = URLRequest(url: URL(string: "http://0.0.0.0:80/add_door/add_door")!)

        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let httpBody = String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print("Add Doors httpBody = ", httpBody)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if (response != nil) {
                print(response!)
            }
            do {
                
                if (response != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    if (json["ReqStatus"] as! String == "ok") {
                        print("API Config oui")
                        completion(json)
                    }
                }
            } catch {
                print("API Config error")
                completion(nil)
            }
        })
        //EXECUTION
        task.resume()
    }
    
    func updateStateConnect(_ email: String, _ password: String,
                            completion: @escaping (_ response: [String: AnyObject]?) -> Void) {
    
        let params = ["username":email, "password":password] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "http://0.0.0.0:80/add_user/add_user")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loadingActivity.startAnimating()
        
        let httpBody = String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print("Update State httpBody = ", httpBody)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if (response != nil) {
                print(response!)
            }
            do {
                if (response != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    if (json["ReqStatus"] as! String == "ok") {
                        print("Login oui")
                        setUsername(email)
                        setPassword(password)
                        sleep(2)
                        completion(json)
                    }
                }
                else {
                    completion(nil)
                }
            } catch {
                print("Login error")
                completion(nil)
            }
        })
        task.resume()
    }

    @IBAction func loginAction(_ sender: Any) {
        let email = loginTextField?.text ?? "default"
        let password = passwordTextField?.text ?? "default"
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "HouseLog_Content_View")

        updateStateConnect(email, password, completion: { response -> Void in
            if (response != nil) {
                self.addSomeDoorsToAPI(completion: { response -> Void in
                    if (response != nil) {
                        DispatchQueue.main.async {
                            self.loadingActivity.stopAnimating()
                            controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.loadingActivity.stopAnimating()
                        }
                    }
                })

            }
            else {
                DispatchQueue.main.async {
                    self.loadingActivity.stopAnimating()
                }
            }
        })

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
