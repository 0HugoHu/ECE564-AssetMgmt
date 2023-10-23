//
//  ContentView.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/22/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let initialURL = URL(string: "https://mediabeacon.oit.duke.edu/wf/restapi/v2/getAPIKey")!
    
    @State private var currentURL: URL?
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: WebView(url: initialURL, currentURL: $currentURL)) {
                    Text("Log In")
                }
                NavigationLink(destination: UserInfoView()) {
                    Text("Get User Info")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Get API Key")
        }
        .onAppear {
            self.currentURL = initialURL
        }
    }
}


struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var currentURL: URL?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, webView: WKWebView())
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var authTokenChecked = false
        var webView: WKWebView
        
        init(_ parent: WebView, webView: WKWebView) {
            self.parent = parent
            self.webView = webView
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            if let url = webView.url {
                print("Real-time URL: \(url.absoluteString)")
                
                self.parent.checkAuth(url: url, webView: webView)
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                parent.currentURL = url
            }
        }
    }
    
    func checkAuth(url: URL, webView: WKWebView) {
        if url.absoluteString.contains("mediabeacon.oit.duke.edu/wf/restapi/v2/getAPIKey") {
            extractKeyFromHTML(from: webView) { key in
                if let key = key {
                    // Save the key in your app
                    UserDefaults.standard.setValue(key, forKey: "AuthToken")
                    print(key)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    
    func extractKeyFromHTML(from webView: WKWebView, completion: @escaping (String?) -> Void) {
        let script = """
        let preElement = document.querySelector("pre");
        if (preElement) {
            let text = preElement.textContent.trim();
            text;
        } else {
            null;
        }
        """
        
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                print("Error extracting value from HTML: \(error)")
                completion(nil)
            } else if let value = result as? String {
                completion(value)
            } else {
                print("Value not found in HTML")
                completion(nil)
            }
        }
    }
    
}


struct UserInfoView: View {
    @State private var userInfo: String = "Loading..."
    
    var body: some View {
        VStack {
            Text(userInfo)
                .padding()
            
            Button(action: {
                if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
                    getUserInfo(withAuthToken: authToken)
                }
            }) {
                Text("Get User Info")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            if let authToken = UserDefaults.standard.string(forKey: "AuthToken") {
                getUserInfo(withAuthToken: authToken)
            }
        }
    }
    
    func getUserInfo(withAuthToken authToken: String) {
        guard let url = URL(string: "https://mediabeacon.oit.duke.edu/wf/restapi/v2/userInfo?apikey=" + authToken) else {
            self.userInfo = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.userInfo = "Error: \(error.localizedDescription)"
            } else if let data = data {
                if let decodedData = try? JSONDecoder().decode(UserInfo.self, from: data) {
                    self.userInfo = "User Info: \(decodedData.username)"
                } else {
                    self.userInfo = "Error: Unable to decode data"
                }
            }
        }.resume()
    }
}

struct UserInfo: Codable {
    let username: String
}

struct FileObject: Codable {

}

struct SearchObject: Codable {
    
}

struct FilterObject: Codable {
    
}

struct Logs: Codable {
    
}


func getUserInfo() -> Bool { return true }
func downloadFiles(ids: [String], keepDirectoryStructure: Bool = false, noZip: Bool = false) -> Bool { return true }
func uploadFiles(files: [Data], dest: String) -> Bool { return true }
func renameFile(data: FileObject, newName: String) -> Bool { return true }
func deleteFiles(data: [FileObject]) -> Bool { return true }
func searchSimple(search: String, directory: String, pageSize: Int = 100, pageIndex: Int = 0) -> [FileObject]? { return nil }
func searchAdvanced(searchObj: SearchObject, directory: String, pageSize: Int = 100, pageIndex: Int = 0, sortField: String?, sortDirection: String?, FILTERS: FilterObject?) -> [FileObject]? { return nil }
func showDirectories(depth: Int = 0, paths: String = "/") -> [FileObject]? { return nil }
func createDirectory(path: String) -> Bool { return true }
func getPreview(id: String) -> String? { return nil }
func getDetails(id: String) -> FileObject? { return nil }



#Preview {
    ContentView()
}
