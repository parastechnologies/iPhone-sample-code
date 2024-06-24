//
//  ApiEndPintManager.swift
//  GunInstructor
//
//  Created by iOS TL on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

extension NetworkManager {
    func markFav(Id: Int, favourite: Int, type: String, completion: @escaping ((Result<FavModel,APIError>) -> Void)){
        let param = [
            "Id"                 : Id,
            "favourite"          : favourite,
            "type"               : type] as [String: Any]
        print(param)
        handleAPICalling(request: .markFav(param: param), completion: completion)
    }
}
