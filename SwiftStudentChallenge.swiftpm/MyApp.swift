import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ViewOne().preferredColorScheme(.light)
            }
        }
    }
}
