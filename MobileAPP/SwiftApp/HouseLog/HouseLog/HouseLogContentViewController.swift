//
//  HouseLogContentViewController.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 09/06/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import UIKit

class HouseLogContentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HouseLogSensorDelegate
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var modelImageView: UIImageView!
    @IBOutlet var modelChooseButton: UIButton!
    @IBOutlet var modelImageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var logoImage: UIImageView!
    var imagePicker = UIImagePickerController()
    var isAnImage = false
    var initState = 0

    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateDisplay()

        configCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Do any additional setup after loading the view.
        if (isAnImage) {
            if (modelImageViewCenterY.constant <= 0) {
                modelImageViewCenterY.constant += (modelImageView.frame.height * 0.3)
            }
        }
        else {
            modelImageViewCenterY.constant -= (modelImageView.frame.height * 0.3)
        }
    }
    
    func displayLoginViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "HouseLog_Starting_View")

        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnClicked()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func updateDisplay()
    {
        if ((modelImageView.image) != nil) {
            isAnImage = true
            self.viewDidLayoutSubviews()
            collectionView.isHidden = false
            //logoImage.isHidden = true
        }
        else {
            isAnImage = false
            collectionView.isHidden = true
            //logoImage.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.dismiss(animated: true, completion: { () -> Void in

        })
        if let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let imgName = imgUrl.lastPathComponent

                setModelImageName(imgName)
                setModelImageURL(imgUrl.absoluteString)
                
                modelImageView.image  = tempImage
                //print(getModelImageName())
                //print(getModelImageURL())

                updateDisplay()

            }
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 4
    }
    
    func addShadowToCell(_ cell: HouseLogCollectionViewCell)
    {
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseLogSensorCell", for: indexPath) as! HouseLogCollectionViewCell

        print("indexPath = ", indexPath)
        if (indexPath.row == 0) {
            cell.setCellToWork()
            if (initState == 0) {
                initState += 1
                cell.setAndLaunchCellBehavior(self)
                cell.updateCellState(SensorState.red)
            }
        }
        else {
            cell.setCellTovisual()
        }
        
        if (initState == 0) {
            addShadowToCell(cell)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height / 5) )
    }
    
    // Delegate
    
    func sensorUpdate(_ state: SensorState) {
        print("sensorUpdate")
    }

}
