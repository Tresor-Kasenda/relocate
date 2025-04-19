//
//  HomePage.swift
//  relocation
//
//  Created by Tresor KASENDA on 12/04/2025.
//

import SwiftUI
import MapKit

struct HomePage: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTab()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Main")
                }
                .tag(0)
            
            NavigationStack {
                MessagesTab()
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("News")
            }
            .tag(2)
            
            NavigationStack {
                ProfileTab()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
            .tag(3)
        }
        .tint(.blue)
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    
    enum AnnotationType {
        case user
        case station
        case special
    }
}

struct MapView: View {
    @Binding var position: MapCameraPosition
    let annotations: [LocationAnnotation]
    
    var body: some View {
        Map(position: $position) {
            // Current user location marker
            Marker("You", coordinate: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456))
                .tint(.blue)
            
            // Other annotations
            ForEach(annotations) { annotation in
                Marker("", coordinate: annotation.coordinate)
                    .tint(annotationColor(for: annotation.type))
            }
        }
        .ignoresSafeArea()
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    func annotationColor(for type: LocationAnnotation.AnnotationType) -> Color {
        switch type {
        case .user:
            return .blue
        case .station:
            return .red
        case .special:
            return .yellow
        }
    }
}

struct HomeTab: View {
    @State private var searchText = ""
    @State private var showUserDetails = false
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    // Sample annotations
    let annotations: [LocationAnnotation] = [
        LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456), type: .user),
        LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: -6.2078, longitude: 106.8446), type: .station),
        LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: -6.2098, longitude: 106.8466), type: .special)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    MapView(
                        position: $position,
                        annotations: annotations
                    )
                    // Search bar
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Where do you want to go?", text: $searchText)
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
                .sheet(isPresented: $showUserDetails){
                    
                }
                .onAppear {
                    
                }
                .navigationTitle("Welco")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ProfileTab()) {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileTab()) {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}

struct ChatPreview: Identifiable {
    let id = UUID()
    let user: User
    let lastMessage: String
    let time: String
    var hasUnread: Bool = false
    var isTyping: Bool = false
    var isDelivered: Bool = false
}

struct ChatRowView: View {
    let chat: ChatPreview
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile image
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
            
            // Message preview
            VStack(alignment: .leading, spacing: 4) {
                Text(chat.user.name)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(spacing: 4) {
                    if chat.isDelivered {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text(chat.lastMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Time and status
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.time)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                if chat.hasUnread {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ChatView: View {
    let user: User
    @State private var messageText = ""
    @Environment(\.dismiss) private var dismiss
    
    init(with user: User) {
        self.user = user
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    VStack(spacing: 16) {
                        // Sample messages with timestamps
                        Group {
                            Text("Tuesday")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top)
                            
                            ChatBubble(
                                message: "Hi Harry - Tom Mayes here. I'm a co-founder of Edmunds Cocktails. We're an RTD cocktail challenger brand busy raising. Is the consumer space of interest to you?",
                                time: "10:36",
                                isFromCurrentUser: false
                            )
                            
                            ChatBubble(
                                message: "Hi Tom! Yes! We do make many investments in consumer products. What stage is the raise?",
                                time: "11:22",
                                isFromCurrentUser: true
                            )
                            
                            ChatBubble(
                                message: "We're raising our Series A.",
                                time: "11:24",
                                isFromCurrentUser: false
                            )
                        }
                        
                        // Voice message
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Circle().fill(Color.blue))
                            }
                            
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 2)
                            
                            Text("0:40")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        
                        // File attachment
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "doc.fill")
                                VStack(alignment: .leading) {
                                    Text("Edmunds Cocktails - Pitch")
                                    Text("Deck - 2024.pdf")
                                }
                                Spacer()
                                Text("3.2 MB")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            ChatBubble(
                                message: "Here is the pitch deck mentioned.",
                                time: "17:28",
                                isFromCurrentUser: false
                            )
                        }
                    }
                    .padding()
                }
                
                // Message input
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                    
                    TextField("Message", text: $messageText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: {}) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.systemGray4)),
                    alignment: .top
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text("Typically responds within 1 hour")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

struct ChatBubble: View {
    let message: String
    let time: String
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer(minLength: 50) }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
                Text(message)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(isFromCurrentUser ? Color.blue : Color(.systemGray6))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .cornerRadius(20)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !isFromCurrentUser { Spacer(minLength: 50) }
        }
    }
}

struct User: Identifiable {
    let id = UUID()
    let name: String
    let image: String?
}

struct MessagesTab: View {
    @State private var searchText = ""
    let sampleConversations = [
        ChatPreview(
                    user: User(name: "Alex Thomson", image: nil),
                    lastMessage: "Thanks for reaching out. I'll get back to you...",
                    time: "16:03",
                    hasUnread: true,
                    isTyping: false
                ),
        ChatPreview(
                    user: User(name: "Kirsty McDonald", image: nil),
                    lastMessage: "Typing...",
                    time: "12:43",
                    hasUnread: false,
                    isTyping: true
                ),
                ChatPreview(
                    user: User(name: "Chris Leith", image: nil),
                    lastMessage: "When is good to meet?",
                    time: "12:43",
                    hasUnread: false,
                    isTyping: false,
                    isDelivered: true
                ),
                ChatPreview(
                    user: User(name: "Harry Stebbings", image: nil),
                    lastMessage: "Here is the pitch deck mentioned.",
                    time: "Yesterday",
                    hasUnread: false,
                    isTyping: false,
                    isDelivered: true
                ),
                ChatPreview(
                    user: User(name: "Sophie Scott", image: nil),
                    lastMessage: "Sounds good. Look forward to hearing back.",
                    time: "Tuesday",
                    hasUnread: false,
                    isTyping: false
                )
    ]
    var body: some View {
        NavigationStack {
                    VStack(spacing: 0) {
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                            Button(action: {}) {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding()
                        
                        // Conversations list
                        List {
                            ForEach(sampleConversations) { chat in
                                NavigationLink(destination: ChatView(with: chat.user)) {
                                                            ChatRowView(chat: chat)
                                                        }
                                                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                    }
                    .navigationTitle("Chats")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {}) {
                                Image(systemName: "square.and.pencil")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
    }
}

struct ProfileTab: View {
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Nom d'utilisateur")
                .font(.title2)
                .fontWeight(.bold)
            
            // Profile Options
            List {
                Section {
                    Button(action: {}) {
                        Label("Modifier le profil", systemImage: "pencil")
                    }
                    
                    Button(action: {}) {
                        Label("Paramètres", systemImage: "gear")
                    }
                    
                    Button(action: {}) {
                        Label("Aide", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(action: {}) {
                        Label("Déconnexion", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomePage()
}
