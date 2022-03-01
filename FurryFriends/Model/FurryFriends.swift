//
//  FurryFriends.swift
//  FurryFriends
//
//  Created by Jerry Dai on 2022-02-28.
//

import Foundation


struct Cats: Decodable,Hashable,Encodable {
    
    let file: String
    
}


struct Dogs: Decodable, Hashable, Encodable {
     
    let message: String
    let status: String
    
}
