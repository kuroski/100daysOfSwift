//
//  ContentView.swift
//  Friendface
//
//  Created by Daniel Kuroski on 14.12.20.
//

import SwiftUI

struct DetailView: View {
    var id: String
    var users: [User]
    
    let user: User
    
    init(id: String, users: [User]) {
        self.id = id
        self.users = users
        
        self.user = users.first(where: { $0.id == id })!
    }
    
    var body: some View {
        VStack {
            Text(user.about).padding()
            List {
                ForEach(user.friends) { friend in
                    NavigationLink(destination: DetailView(id: friend.id, users: users)) {
                        Text(friend.name)
                    }
                }
            }
            .navigationBarTitle(Text(user.name))
        }
    }
}

struct ContentView: View {
    @State var users: [User] = [User]()
    @State var isLoading = true
    
    //    init() {
    ////        self.users = Bundle.main.decode("friendface.json")
    //        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    //    }
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView()
                }
                
                ForEach(users) { user in
                    NavigationLink(destination: DetailView(id: user.id, users: users)) {
                        Text(user.name)
                    }
                }
            }
            .navigationBarTitle(Text("Friendface"))
            .onAppear(perform: fetchUsers)
        }
    }
    
    func fetchUsers() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decodedUsers = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    self.users = decodedUsers
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
