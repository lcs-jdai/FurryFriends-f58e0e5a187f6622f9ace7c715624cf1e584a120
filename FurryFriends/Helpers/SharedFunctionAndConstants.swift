//
//  SharedFunctionAndConstants.swift
//  FurryFriends
//
//  Created by Jerry Dai on 2022-03-01.
//

import Foundation

func getDocumentsDirectory() -> URL {
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //return the first path
    return paths[0]
}

//Define a filename (label) that we will write the data to in
//the directory
let saveFavouritesLabel = "saveFavourites"
