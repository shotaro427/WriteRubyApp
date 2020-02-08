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

    // MARK: - Relay
    /// 変換したテキストを通知するRelay
    private let convertedTextRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
    /// エラーが出たときに通知するRelay
    private let errorRelay: PublishRelay<Error?> = PublishRelay()
    /// ローディングの状態を通知するRelay
    private let loadingReay: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    // MARK: - Driver
    /// 変換したテキストを監視するDriver
    var convertedTextDriver: Driver<String> {
        convertedTextRelay.asDriver()
    }
    /// エラーを監視するObservable
    var errorObservable: Observable<Error?> {
        errorRelay.asObservable()
    }
    /// ローディングの状態を監視するDriver
    var loadingDriver: Driver<Bool> {
        loadingReay.asDriver()
    }

    // MARK: - Functions

    ///　テキストを平仮名/カタカナに変換する
    func convertText(sentence: String, outputType: OutputType = .hiragana) {
        model.requestConvertedText(sentence: sentence, outputType: outputType)
            // ローディング状態の更新
            .do(onError: { _ in
                self.loadingReay.accept(false)
            }, onCompleted: {
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
                if let responseError = error as? APIError {
                    print("**** \(responseError.errorMessage)")
                    self.errorRelay.accept(responseError)
                } else {
                    print("**** \(error.localizedDescription)")
                    self.errorRelay.accept(error)
                }
            }).disposed(by: disposeBag)
    }
}
