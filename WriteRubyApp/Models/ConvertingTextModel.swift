//
//  ConvertingTextModel.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/02.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import Foundation

/**
 * 入力されたテキストからひらがなに変換するModel
 */
struct ConvertingTextModel {

    func requestConvertedText() {

        /// リクエスト先のURL
        guard let requestUrl = URL(string: "https://labs.goo.ne.jp/api/hiragana") else {
            print("can not convert URL from String")
            return
        }
        /// URLSessionの作成
        let session = URLSession.shared
        /// リクエストオブジェクトの作成
        var request = URLRequest(url: requestUrl)
        // POSTメッソドに指定
        request.httpMethod = "POST"
        request.httpBody = "app_id=a6e97e3ed0331d34542d7e1f26b9efebe6629285d6a9ebac2c5ab3a03d729cc6&sentence=これはテストです。漢字があります&output_type=hiragana".data(using: String.Encoding.utf8)

        /// API通信
        session.dataTask(with: request) { (data, response, error) in

            let dic = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
            print("*** successed \(dic)")
            }.resume()
    }


}
