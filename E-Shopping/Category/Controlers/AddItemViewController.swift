//
//  AddItemViewController.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 7.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var Discr: UITextView!
    @IBOutlet weak var addPhotoOutlet: UIButton!
    
    //MARK: - VARS
    
    var category: Category!
    var itemImages: [UIImage?] = []
    
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        priceTextField.delegate = self
        addPhotoOutlet.layer.cornerRadius = 30
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.7900321484, blue: 0.2253903747, alpha: 1), padding: nil)
    }
    
    //MARK: - Buttons
    
    @IBAction func doneBarButton(_ sender: UIBarButtonItem) {
        
            if fieldsAreCompleted() {
                saveToFirebase()
            } else {
                print("Error all fields are required")
                //TODO: SHow error to the user
                self.hud.textLabel.text = "All field are required"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)

            }
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        itemImages=[]
        showImageGallery()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func fieldsAreCompleted() -> Bool {
           
           return (titleTextField.text != "" && priceTextField.text != "" && Discr.text != "")
       }
    
    private func popTheView() {
           self.navigationController?.popViewController(animated: true)
       }

    
    //MARK:- Save Item
       private func saveToFirebase() {
           
        showLoadingIndicator()

           let item = Item()
           item.id = UUID().uuidString
           item.name = titleTextField.text!
           item.categoryId = category.id
           item.description = Discr.text
           item.price = Double(priceTextField.text!)
           
           if itemImages.count > 0 {
                
                uploadImages(images: itemImages, itemId: item.id) { (imageLikArray) in
                    
                    item.imageLinks = imageLikArray
                    
                    saveItemToFirestore(item)
                    saveItemToAlgolia(item: item)
                    
                    self.hideLoadingIndicator()
                    self.popTheView()
                }
                
           } else {
               saveItemToFirestore(item)
            saveItemToAlgolia(item: item)
               popTheView()
           }
           
       }
    
    //MARK:- Activity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }

    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
}

//MARK: - Gallery

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}

