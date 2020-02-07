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

/**
 * 入力されたテキストからひらがなに変換するModel
 */
struct ConvertingTextModel {

    func requestConvertedText(sentence: String, outputType: OutputType = .hiragana) {
        /// URLSessionの作成
        let session = URLSession.shared
        /// リクエストの作成
        guard let request = createRequest(sentence: sentence, outputType: outputType) else { return }
        /// API通信
        session.dataTask(with: request) { (data, response, error) in
            let dic = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]

            if let responseError = dic["error"] {
                print(" Error \(responseError)")
            } else {
                print("*** successed \(dic)")
            }
        }.resume()
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
