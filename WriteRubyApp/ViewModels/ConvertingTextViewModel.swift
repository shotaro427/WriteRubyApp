//
//  ConvertingTextViewModel.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/05.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ConvertingTextViewModel {


    private let disposeBag = DisposeBag()
    /// Model
    private let model = ConvertingTextModel()
    /// 変換したテキストを通知するRelay
    private let convertedTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    /// ローディングの状態を通知するRelay
    private let loadingReay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 変換したテキストを監視するDriver
    var convertedTextDriver: Driver<String> {
        convertedTextRelay.asDriver()
    }
    /// ローディングの状態を監視するDriver
    var loadingDriver: Driver<Bool> {
        loadingReay.asDriver()
    }

    ///　テキストを平仮名/カタカナに変換する
    func convertText(sentence: String, outputType: OutputType = .hiragana) {
        model.requestConvertedText(sentence: sentence, outputType: outputType)
            // ローディング状態の更新
            .do(onCompleted: {
                self.loadingReay.accept(false)
            }, onSubscribe: {
                self.loadingReay.accept(true)
            })
            // 結果の更新
            .subscribe(onNext: { entity in
                guard let textEntity = entity as? ConvertingTextResponseEntity else {
                    return
                }
                self.convertedTextRelay.accept(textEntity.converted)
            }, onError: { error in
                print("**** \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
}
