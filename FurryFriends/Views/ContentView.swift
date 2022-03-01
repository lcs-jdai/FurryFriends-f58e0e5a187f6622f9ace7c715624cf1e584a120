//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    @State var currentPetAddedToFavourites: Bool = false
    
    @State var currentCat: Cats = Cats(file: "")
    
    @State var favourites: [Cats] = []
    
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: currentImage)
            
            
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
                //                      CONDITION                        true   false
                .foregroundColor(currentPetAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentPetAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentCat)
                        
                        // Record that we have marked this as a favourite
                        currentPetAddedToFavourites = true

                    }
                    
                }
            
           
            
            // Push main image to top of screen
            Spacer()

        }
        // Runs once when the app is opened
        .task {
            
            // Example images for each type of pet
            let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
            
            // Replaces the transparent pixel image with an actual image of an animal
            // Adjust according to your preference ☺️
            currentImage = URL(string: remoteCatImage)!
                        
        }
        .navigationTitle("Furry Friends")
        
    }
}
    
    // MARK: Functions


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
