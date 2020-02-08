//
//  ConvertingTextModel.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/02.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import Foundation
import RxSwift

/// 変換する出力タイプ
enum OutputType: String {
    case hiragana = "hiragana"
    case katakana = "katakana"
}

/// エラータイプ
enum APIError: Error {
    case canNotMakeRequest
    case responseError(ConvertingTextErrorEntity)
    case notExistData

    /// エラーメッセージ
    var errorMessage: String {
        switch  self {
        case .canNotMakeRequest:
            return "Can not make URLReauest"
        case .responseError(let errorEntity):
            return errorEntity.error.message
        case .notExistData:
            return "Not exist response data"
        }
    }
}

/**
 * 入力されたテキストからひらがなに変換するModel
 */
struct ConvertingTextModel {

    func requestConvertedText(sentence: String, outputType: OutputType = .hiragana) -> Observable<ConvertingTextResponseProtocol> {
        return Observable.create( { observer in
            /// リクエストの作成
            guard let request = self.createRequest(sentence: sentence, outputType: outputType) else {
                observer.on(.error(APIError.canNotMakeRequest))
                return Disposables.create()
            }
            /// API通信
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // taskErrorを確認
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                // Dataがあるかを確認
                guard let data = data else {
                    observer.on(.error(APIError.notExistData))
                    return
                }
                //　レスポンスエラーを見る
                if let err = try? JSONDecoder().decode(ConvertingTextErrorEntity.self, from: data) {
                    observer.on(.error(APIError.responseError(err)))
                    return
                }

                do {
                    let res = try JSONDecoder().decode(ConvertingTextResponseEntity.self, from: data)
                    observer.on(.next(res))
                    observer.on(.completed)
                } catch let error {
                    observer.on(.error(error))
                }
            }.resume()

            return Disposables.create()
        })
    }

    /// URLRequestを作成する
    /// - returns: 作成されたURLRequest
    func createRequest(sentence: String, outputType: OutputType) -> URLRequest? {
        /// リクエスト先のURL
        guard let requestUrl = URL(string: "https://labs.goo.ne.jp/api/hiragana") else {
            print("can not convert URL from String")
            return nil
        }
        /// リクエストオブジェクトの作成
        var request = URLRequest(url: requestUrl)
        // POSTメッソドに指定
        request.httpMethod = "POST"
        /// body部分を設定
        request.httpBody = makeHTTPBody(sentence: sentence, outputType: outputType)

        return request
    }

    /// POSTメソッドを実行するためのHTTPBodyを生成する
    /// - parameters:
    ///   - sentence: 変換する文字列
    ///   - outputType: 変換する種類
    /// - returns: 作成されたHTTPBody
    func makeHTTPBody(sentence: String, outputType: OutputType) -> Data? {

        return "app_id=a6e97e3ed0331d34542d7e1f26b9efebe6629285d6a9ebac2c5ab3a03d729cc6&sentence=\(sentence)&output_type=\(outputType.rawValue)".data(using: String.Encoding.utf8)
    }
}
