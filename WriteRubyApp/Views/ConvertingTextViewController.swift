//
//  ViewController.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/02.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ConvertingTextViewController: UIViewController {

    var model = ConvertingTextModel()

    let disposeBag = DisposeBag()

    @IBOutlet weak var validateLabel: UILabel!
    
    @IBOutlet weak var convertingInputTextField: UITextField!

    @IBOutlet weak var convertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        convertingInputTextField.resignFirstResponder()

        subscribeUI()
        // Do any additional setup after loading the view.
    }

    private func subscribeUI() {
        // 「変換」ボタンのイベントを購読
        convertButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let canConvert: Bool = self?.convertingInputTextField != nil && self?.convertingInputTextField.text != ""
                self?.switchValidateLable(canConvert: canConvert)
            }).disposed(by: disposeBag)
    }

    /// バリデーションの状態を表すラベルを更新させる
    /// - parameters:
    ///   - canConvert: 入力されたテキストが条件に合っているかどうか
    private func switchValidateLable(canConvert: Bool) {
        if canConvert {
            self.model.requestConvertedText()
            self.validateLabel.text = "変換したいテキスト"
            self.validateLabel.textColor = UIColor.black
        } else {
            self.validateLabel.text = "何か文字を入力してください"
            self.validateLabel.textColor = UIColor.red
        }
    }

}

