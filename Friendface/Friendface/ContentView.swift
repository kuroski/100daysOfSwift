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
    let users: [User]
    
    init() {
        self.users = Bundle.main.decode("friendface.json")
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink(destination: DetailView(id: user.id, users: users)) {
                        Text(user.name)
                    }
                }
            }
            .navigationBarTitle(Text("Friendface"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
