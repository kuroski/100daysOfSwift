//
//  ContentView.swift
//  Friendface
//
//  Created by Daniel Kuroski on 14.12.20.
//

import SwiftUI
import CoreData

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
    @Environment(\.managedObjectContext) var viewContext
    
    //    @FetchRequest(entity: CDUser.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var cdUsers: FetchedResults<CDUser>
    
    @State var users: [User] = [User]()
    @State var isLoading = true
    @State var usersClearedMessage = false
    
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
            .navigationBarItems(trailing: Button("Clear", action: self.deleteUsers))
            .onAppear(perform: fetchUsers)
            .alert(isPresented: $usersClearedMessage) {
                Alert(title: Text("Stored users cleared!"))
            }
        }
    }
    
    func fetchUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let cdUsers = try viewContext.fetch(fetchRequest) as! [CDUser]
            
            if !cdUsers.isEmpty {
                print("==== CORE DATA LOADED!")
                self.isLoading = false
                self.users = cdUsers.map({ User.init(user: $0) })
                return
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        print("++++ REQUEST LOADED!")
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
                    self.save(users: decodedUsers)
                    self.users = decodedUsers
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
    }
    
    func save(users: [User]) {
        viewContext.performAndWait {
            users.forEach({ user in
                let cdUser = CDUser(context: viewContext)
                cdUser.id = user.id
                cdUser.isActive = user.isActive
                cdUser.name = user.name
                cdUser.age = Int16(user.age)
                cdUser.company = user.company
                cdUser.email = user.email
                cdUser.address = user.address
                cdUser.about = user.about
                cdUser.registered = user.registered
                cdUser.tags = user.tags.joined()
                
                user.friends.forEach({ friend in
                    let cdFriend = CDFriend(context: viewContext)
                    cdFriend.id = friend.id
                    cdFriend.name = friend.name
                    cdFriend.user = cdUser
                })
            })
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    func deleteUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser")
        
        do {
            let cdUsers = try viewContext.fetch(fetchRequest) as! [CDUser]
            
            if !cdUsers.isEmpty {
                cdUsers.forEach({
                    viewContext.delete($0)
                })
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
            self.usersClearedMessage = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
