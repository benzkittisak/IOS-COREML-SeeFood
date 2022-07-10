//
//  ViewController.swift
//  SeeFood
//
//  Created by Kittisak Panluea on 10/7/2565 BE.
//

import UIKit
import CoreML

// Vision ช่วยให้เราสามารถประมวลผลรูปภาพเพื่อใช้กับ CoreML โดยที่เราไม่ต้องเขียนโค้ดเยอะ
import Vision
/*
 UIImagePickerControllerDelegate
 เอามาทำปุ่มที่เป็นรูปกล้อง พอกดไปแล้วมันไปเปิดแอปกล้องมาถ่ายภาพ แล้วก็จะถามว่า
 จะใช้รูปนี้ไหม หรือว่าจะถ่ายใหม่ดี แบบในแอปที่ชอบให้เราถ่ายบัตรประชาชนอะ
 */

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cameraTab(_ sender: UIBarButtonItem) {
        
    }
    
}

