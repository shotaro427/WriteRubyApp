//
//  ViewController.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/02.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import UIKit

class ConvertingTextViewController: UIViewController {

    var model = ConvertingTextModel()

    @IBOutlet weak var validateLabel: UILabel!
    
    @IBOutlet weak var convertingInputTextField: UITextField!

    @IBOutlet weak var convertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        convertingInputTextField.resignFirstResponder()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapConvertingButton(_ sender: UIButton) {
        if convertingInputTextField.text != nil && convertingInputTextField.text != "" {
            model.requestConvertedText()
            validateLabel.text = "変換したいテキスト"
            validateLabel.textColor = UIColor.black
        } else {
            validateLabel.text = "何か文字を入力してください"
            validateLabel.textColor = UIColor.red
        }
    }

}

