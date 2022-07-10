//
//  ViewController.swift
//  SeeFood
//
//  Created by Kittisak Panluea on 10/7/2565 BE.
//

/*
 คือมันจะพังเรื่อง NSCameraUsageDescription เพราะว่าเราไม่ได้อธิบายเอาไว้ว่าเราใช้กล้องเพราะอะไร
 ดังนั้นเราต้องไปเขียนใน info.plist ก่อน ก็คือไปเพิ่มตัว Privacy เรื่องกล้องนั่นแหละ
 เพิ่ม
 Privacy - Photo Library Usage Description
 Privacy - Camera Usage Description
 */

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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //        มันจะอนุญาตให้เราสามารถเชื่อมต่อเข้ากลับกล้องได้
        imagePicker.sourceType = .camera
        //        ถ้าต้องการเปลี่ยนจากการเปิดใช้งานกล้องมาเป็นให้เลือกรูปจากแกลเลอรี่แทนก็ให้ใช้
        //        imagePicker.sourceType = .photoLibrary
        //        แต่ว่าตัว .photoLibrary มันจะถูกลบออกแล้วใน ios16 แหละนะ
        
        
        //        ตัวนี้จะอนุญาติให้เราสามารถที่จะแก้ไขรูปภาพ หรือเลือกรูปภาพได้
        imagePicker.allowsEditing = false
        //        false คือไม่อนุญาติแหละนะ
    }
    
    //    ฟังก์ชันนี้มาจากตัว delegate ของ pickerController
    //    หน้าที่ของมันคือหลังจากที่ user เขากดเลือกรูปมาแล้วว่าจะเอารูปนี้ จะให้ทำอะไรต่อ
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         มาอธิบาย params กันก่อน
         picker ก็คือตัว UIImagePickerController ที่ใช้สำหรับเลือกรูปภาพที่เราต้องการนั่นแหละ
         info ก็คือ ข้อมูลต่าง ๆ ของรูปภาพหรืออะไรก็ตามที่ user กดเข้ามา
         */
        
        //        ให้ตัวแปร image มันเก็บรูปภาพที่ผู้ใช้เขาถ่ายมานั่นแหละนะ
        //        ตัว info จะเป็นตัวแปรที่เป็น Dictionary แหละ
        if let userPickImage = info[.originalImage] as? UIImage {
            imageView.image = userPickImage
            
            //            ต่อไปเราจะทำการแปลง UIImage ให้ไปเป็น CIImage เพื่อให้ตัว Vision สามารถใช้งานรูปภาพแล้วให้ CoreML มันเอาไปใช้ได้ด้วย
            guard let ciimage = CIImage(image: userPickImage) else {
                fatalError("ไม่สามารถแปลงชนิดของข้อมูลไปเป็น CIImage ได้")
            }
            
            detect(image: ciimage)
            
            
        }
        
        //        ก็คือพอเรากดเลือกรูปนี้มาแล้วใช่ป่ะ ก็ให้มันปิดหน้าจอถ่ายรูปออกไปเลย
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image:CIImage){
        //        เรียกใช้งานตัว model ของ Inceptionv3
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("ไม่สามารถเรียกใช้งาน CoreML Model ได้")}
        
        //        ขอให้ตัว coreML ช่วยเอารูปของเราไปประมวลผลให้หน่อย
        let request = VNCoreMLRequest(model: model) { request, error in
            //        เมื่อ request สามารถทำงานได้สำเร็จ
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("ไม่สามารถวิเคราะห์ข้อมูลได้") }
            
            print(results)
            
            
        }
        //            ต่อไปถ้ามันประมวลผลรูปสำเร็จ ก็็ให้ตัว Vision เอารูปไปวิเคราะห์ข้อมูล
        let handler = VNImageRequestHandler(ciImage:image)
        
        do {
            try handler.perform([request])
        } catch let error {
            print("ไม่สามารถวิเคราะห์ข้อมูลได้เนื่องจาก \(error)")
        }
    }
    
    @IBAction func cameraTab(_ sender: UIBarButtonItem) {
        
        //        เมื่อเขากดปุ่มถ่ายรูปมาใช่ป่ะ ก็ให้เปิดใช้งานกล้อง
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}

