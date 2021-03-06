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

    private let disposeBag = DisposeBag()

    private let viewModel = ConvertingTextViewModel()

    @IBOutlet weak var validateLabel: UILabel!
    /// 変換前のテキストを表示するTextView
    @IBOutlet weak var convertingTextView: UITextView!
    /// 「変換」ボタン
    @IBOutlet weak var convertButton: UIButton!
    /// 返還後のテキストを表示するTextView
    @IBOutlet weak var convertedTextView: UITextView!

    // MARK: - インジケータ

    /// インジケータを表示するView
    @IBOutlet weak var indicatorView: UIView!
    /// インジケータ
    @IBOutlet weak var activityIndicator:
    UIActivityIndicatorView!

    /// 変換後のテキストをクリップボードにコピーするボタン
    @IBOutlet weak var textCopyButton: UIButton!
    /// テキストをクリアするボタン
    @IBOutlet weak var textClearButton: UIBarButtonItem!
    /// テキストの変換の種類（ひらがな/カタカナ）を変更するボタン
    @IBOutlet weak var convertTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextViewAndButton()
        subscribe()
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

    /// 通信結果などを監視する
    private func subscribe() {
        // 変換されたテキストを監視
        viewModel.convertedTextDriver
            .drive(onNext: { [weak self] convertedText in
                // 結果を表示するTextViewを更新
                self?.convertedTextView.text = convertedText
            }).disposed(by: disposeBag)

        // ローディング状態を監視してUIを更新
        viewModel.loadingDriver
            .drive(onNext: { [weak self] isLoading in
                self?.switchIndicator(isLoading: isLoading)
            }).disposed(by: disposeBag)

        // エラーが出たらアラートを表示する
        viewModel.errorObservable
            .subscribe(onNext: { [weak self] _ in
                self?.showSimpleAlert(alertType: .error)
            }).disposed(by: disposeBag)
    }

    /// UIの挙動を監視する
    private func subscribeUI() {
        // 「変換」ボタンのイベントを購読
        convertButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let _self = self, let convertingText = _self.convertingTextView.text, !convertingText.isEmpty else { return }
                let outputType: OutputType = _self.convertTypeSegmentedControl.selectedSegmentIndex == 0 ? OutputType.hiragana : OutputType.katakana
                // 変換開始
                _self.viewModel.convertText(sentence: convertingText, outputType: outputType)
                // キーボードを下げる
                _self.convertingTextView.resignFirstResponder()
            }).disposed(by: disposeBag)

        // テキスト欄のバリデーション
        convertingTextView.rx.text.asDriver()
            .map { $0 != "" }
            .drive(onNext: { [weak self] canConvert in
                self?.switchValidateLable(canConvert: canConvert)
            }).disposed(by: disposeBag)

        // 「コピー」ボタンを押した時の処理
        textCopyButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                UIPasteboard.general.string = self?.convertedTextView.text
                self?.showSimpleAlert(alertType: .pasted)
            }).disposed(by: disposeBag)

        // 「クリア」ボタンを押した時の処理
        textClearButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.convertingTextView.text = nil
                self?.convertedTextView.text = nil
            }).disposed(by: disposeBag)

        // ルビのタイプを変換するボタンが変わった時の処理
        convertTypeSegmentedControl.rx.selectedSegmentIndex.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [weak self] index in
                //　ボタンの文字を更新
                if index == 0 {
                    self?.convertButton.setTitle("ひらがなに変換", for: .normal)
                } else {
                    self?.convertButton.setTitle("カタカナに変換", for: .normal)
                }
            }).disposed(by: disposeBag)
    }

    /// バリデーションの状態を表すラベルを更新させる
    /// - parameters:
    ///   - canConvert: 入力されたテキストが条件に合っているかどうか
    private func switchValidateLable(canConvert: Bool) {
        // ボタンを使えなくする
        convertButton.isEnabled = canConvert
        if canConvert {
            convertButton.alpha = 1
            validateLabel.text = "変換したいテキスト"
            validateLabel.font = UIFont.systemFont(ofSize: 20)
            validateLabel.textColor = UIColor.black

        } else {
            convertButton.alpha = 0.5
            validateLabel.text = "文字を入力してください"
            validateLabel.font = UIFont.systemFont(ofSize: 15)
            validateLabel.textColor = UIColor.red
        }
    }

    /// ローディングインジケータの表示/非表示を切り替える
    private func switchIndicator(isLoading: Bool) {
        indicatorView.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    /// シンプルな「OK」ボタンだけがあるアラートを表示する
    /// - parameters:
    ///   - alertType: 表示するアラートの種類
    private func showSimpleAlert(alertType: AlertType) {
        let alertController = UIAlertController(title: alertType.title,
                                                message: alertType.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }

    /// アラートの表示タイプ
    enum  AlertType {
        case error
        case pasted

        /// アラートのタイトル
        var title: String {
            switch self {
            case .error:
                return "エラーが出ました"
            case .pasted:
                return "コピーしました！"
            }
        }

        /// アラートのメッセージ
        var message: String? {
            switch self {
            case .error:
                return "記号などが含まれていなか確認して\nもう一度入力してください。"
            case .pasted:
                return "クリップボードへの\nコピーが完了しました！"
            }
        }
    }
}

