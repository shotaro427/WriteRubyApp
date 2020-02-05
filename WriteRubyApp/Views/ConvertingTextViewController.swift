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
    /// 変換前のテキストを表示するTextView
    @IBOutlet weak var convertingTextView: UITextView!
    /// 「変換」ボタン
    @IBOutlet weak var convertButton: UIButton!
    /// 返還後のテキストを表示するTextView
    @IBOutlet weak var convertedTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextViewAndButton()
        subscribeUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //　キーボードを閉じる
        convertingTextView.resignFirstResponder()
    }

    /// 変換前と変換後のテストを表示するTextViewとButtonのセットアップ
    private func setupTextViewAndButton() {
        convertingTextView.resignFirstResponder()
        convertingTextView.layer.borderWidth = 1
        convertingTextView.layer.borderColor = UIColor.black.cgColor

        convertedTextView.layer.borderWidth = 1
        convertedTextView.layer.borderColor = UIColor.black.cgColor

        convertButton.layer.cornerRadius = 5
    }

    private func subscribeUI() {
        // 「変換」ボタンのイベントを購読
        convertButton.rx.tap
            .subscribe(onNext: { [weak self] in
//                let canConvert: Bool = self?.convertingInputTextField != nil && self?.convertingInputTextField.text != ""
//                self?.switchValidateLable(canConvert: canConvert)
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

