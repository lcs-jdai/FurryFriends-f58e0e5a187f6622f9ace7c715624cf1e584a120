//
//  FurryFriends.swift
//  FurryFriends
//
//  Created by Jerry Dai on 2022-02-28.
//

import Foundation


struct Items: Decodable, Hashable, Encodable, Identifiable {
    
    var id = UUID()
    let file: String
    let message: String
    let status: String
    
    

}


let PetComparison = [

    Items(file: "https://aws.random.cat/meow", message: "https://dog.ceo/api/breeds/image/random", status: "")

]
