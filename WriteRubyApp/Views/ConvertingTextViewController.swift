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

    @IBOutlet weak var convertingInputTextField: UITextField!

    @IBOutlet weak var convertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        convertingInputTextField.resignFirstResponder()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapConvertingButton(_ sender: UIButton) {
        model.requestConvertedText()
    }

}

