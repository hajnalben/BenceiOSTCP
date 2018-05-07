//
//  ViewController.swift
//  benceTCP
//
//  Created by Hajnal Benjámin on 2018. 05. 01..
//  Copyright © 2018. Hajnal Benjámin. All rights reserved.
//

import UIKit

let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

class ViewController: UIViewController, StreamDelegate {
    
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    @IBOutlet weak var blueSwitch: UISwitch!
    
    var inputStream: InputStream?
    var outputStream: OutputStream?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        outputStream?.close()
    }
  
    @IBAction func connectSwitch(_ sender: UISwitch) {
        guard
            let ip = ipField.text, (ip.range(of: validIpAddressRegex, options: String.CompareOptions.regularExpression) != nil),
            let port = portField.text, (port.range(of: "[1-9][0-9]*?", options: String.CompareOptions.regularExpression) != nil)
        else {
            return
        }
        
        Stream.getStreamsToHost(withName: ip, port: Int(port)!, inputStream: &inputStream, outputStream: &outputStream)
        outputStream?.open()
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        var number = UInt8(sender.currentTitle!)!
        
        if redSwitch.isOn {
            number += 16
        }
        
        if greenSwitch.isOn {
            number += 32
        }
        
        if blueSwitch.isOn {
            number += 64
        }
        
        outputStream?.writeNumbers(numbers: number)
    }
}

extension OutputStream {
    func writeNumbers(numbers: UInt8...) {
        let data = Data(bytes: numbers)
        
        data.withUnsafeBytes {
            write($0, maxLength: data.count)
        }
    }
}

