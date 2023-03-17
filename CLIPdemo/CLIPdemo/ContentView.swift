//
//  ContentView.swift
//  CLIPdemo
//
//  Created by Rebecca Goldberg on 3/16/23.
//

import SwiftUI

import UIKit
import AVFoundation

struct ContentView: View {
    let controller = ViewController()

    var body: some View {
        VStack {
            Image(systemName: "camera")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button(action: {
                controller.takePhoto()
            }) {
                Text("Take a photo")
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        saveImage(image: image)
        sendImageToServer(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "myImage.jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
                print("URL:")
                print(fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func sendImageToServer(image: UIImage) {
        let url = URL(string: "https://clip.pythonanywhere.com/upload_photo")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let imageData = image.jpegData(compressionQuality: 0.5)!
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo_url\"; filename=\"myImage.jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            print("Image uploaded successfully!")
        }
        task.resume()
    }

}


