//
//  ResultViewController.swift
//  Planetarium
//
//  Created by Irina Cercel on 14/02/2020.
//  Copyright © 2020 Irina Cercel. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    
    var pacientResult: PacientData!

    override func viewDidLoad() {
        super.viewDidLoad()
        getResult()
        view.setBackground()
        // Do any additional setup after loading the view.
    }
    
    func getPostString(params: [String: Any]) -> String {
          var data = [String]()
          for(key, value) in params
          {
              data.append(key + ":\(value)")
          }
          return data.map { String($0) }.joined(separator: "&")
      }
    
    func getResult() {
        
        let body = [
            "\"firstPhotoDetails\"": String(data: pacientResult.firstPhotoDetails!, encoding: String.Encoding.utf8)!,
            "\"secondPhotoDetails\"": String(data: pacientResult.secondPhotoDetails!, encoding: String.Encoding.utf8)!,
            "\"recordingDetails\"": String(data: pacientResult.recordingDetails!, encoding: String.Encoding.utf8)!,
            "\"armWeaknessDetails\"": String(data: pacientResult.armWeaknessDetails!, encoding: String.Encoding.utf8)!,
            "\"textDetails\"": String(data: pacientResult.textDetails!, encoding: String.Encoding.utf8)!
        ]
        let data = getPostString(params: body).data(using: String.Encoding.utf8)
        if let url = URL(string: "http://127.0.0.1:5001/send_final_result") {
            pacientResult.request(url: url, method: "POST", body: data) { (data, error) in
                if let error = error {
                    print(error)
                    self.resultLabel.text = error as? String
                }
                if data != nil {
                    let ceva = String(data: data!, encoding: String.Encoding.utf8)!
                    let verdict = ceva.index(ceva.startIndex,offsetBy: 16)
                    DispatchQueue.main.async {
                        if ceva[verdict] == "1" {
                            self.resultLabel.text = "Ai atac cerebral vascular!"
                            self.resultLabel.textColor = .red
                        } else {
                            self.resultLabel.text = "Esti sanatos!"
                            self.resultLabel.textColor = .green
                        }
                    }
                }
            }
        }
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
