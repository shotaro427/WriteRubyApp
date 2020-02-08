//
//  ConvertedTextResponseEntity.swift
//  WriteRubyApp
//
//  Created by 田内　翔太郎 on 2020/02/02.
//  Copyright © 2020 田内　翔太郎. All rights reserved.
//

import Foundation

protocol ConvertingTextResponseProtocol: Codable {}

/**
 * APIから返ってきたレスポンスの振る舞い
 */
struct ConvertingTextResponseEntity: ConvertingTextResponseProtocol {
    var converted: String
    var output_type: String
    var request_id: String
}

/**
* APIから返ってきたレスポンスがエラーだった時の振る舞い
*/
struct ConvertingTextErrorEntity: ConvertingTextResponseProtocol {
    var error: ConvertingTextError

    struct ConvertingTextError: Codable {
        var code: Int
        var message: String
    }
}
