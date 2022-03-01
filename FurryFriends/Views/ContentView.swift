//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    @Environment(\.scenePhase) var scenePhase
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage: Cats = Cats(file: "https://aws.random.cat/meow")
    
    @State var currentPetAddedToFavourites: Bool = false
    
    @State var favourites: [Cats] = []
    
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: URL(string: currentImage.file)!)
            
            
            
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
            //                      CONDITION                        true   false
                .foregroundColor(currentPetAddedToFavourites == true ? .red : .secondary)
                .padding()
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentPetAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentImage)
                        
                        // Record that we have marked this as a favourite
                        currentPetAddedToFavourites = true
                        
                    }
                    
                }
            
            Button(action: {
                
                // The Task type allows us to run asynchronous code
                // within a button and have the user interface be updated
                // when the data is ready.
                // Since it is asynchronous, other tasks can run while
                // we wait for the data to come back from the web server.
                Task {
                    // Call the function that will get us a new joke!
                    await loadNewPet()
                }
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            
            
            HStack {
                Text("Favourites")
                    .bold()
                    .padding()
                Spacer()
            }
            
            List(favourites, id: \.self) { currentFavourite in
                Text(currentFavourite.file)
            }
            
            Spacer()
            
            
            
            // Push main image to top of screen
            Spacer()
            
        }
        .navigationTitle("Furry Friend") // delete if you want no title
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // Runs once when the app is opened
        .task {
            
            await loadNewPet()
            
            print("I tried to load a new joke")
            
            loadFavourites()
            
        }
        .onChange(of: scenePhase){
            newPhase in
            
            if newPhase == .inactive{
                print("Inactive")
                
            } else if newPhase == .active{
                print("Active")
            } else if newPhase == .background{
                print("Background")
                
                persistFavourites()
            }
        }
        .navigationTitle("icanhazdadjoke?")
        .padding()
    }
    // MARK: Functions
    func loadNewPet() async {
        let url = URL(string: "https://aws.random.cat/meow")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentImage = try JSONDecoder().decode(Cats.self, from: data)
            
            // Reset the flag that tracks whether the current joke
            // is a favourite
            currentPetAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
    
    
    func loadFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(saveFavouritesLabel)
        print(filename)
        
        //Attempt to load the data
        do {
            
            //Load the raw data
            let data = try Data(contentsOf: filename)
            
            //see the data that was written
            print("Saved data to the Documents successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
            
            //Decode the JSON into the swift native data structure
            favourites = try JSONDecoder().decode([Cats].self, from: data)
            
        } catch {
            //What went wrong?
            print("Could not load the data from the stored JSON file")
            print("======")
            print(error.localizedDescription)
        }
        
    }
    
    func persistFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(saveFavouritesLabel)
        print(filename)
        
        do {
            
            //create a JSON encoder object
            let encoder = JSONEncoder()
            
            //COnfigure the encoder to "pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of Favourites we've collect
            let data = try encoder.encode(favourites)
            
            //write the JSON to a file in the filename location we came up with earlier
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //see the data that was written
            print("Saved data to the Documents successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
        } catch  {
            print("Unable  to write list of favourites to the Documents directly.")
            print("======")
            print(error.localizedDescription)
        }
        
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
