//
//  Initialization.swift
//  AssetMgmt
//
//  Created by Hugooooo on 10/29/23.
//

import SwiftUI
import WebKit

/*
 TODO: Login View
 */
struct Initialization: View {
    @Environment(\.presentationMode) var presentationMode
    
    let initialURL = getGetAPIKeyURL()
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


/*
 Show login in webview
 */
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
                    // TODO: Save key to local
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
                logger.error("Error extracting value from HTML: \(error)")
                completion(nil)
            } else if let value = result as? String {
                completion(value)
            } else {
                logger.error("Value not found in HTML")
                completion(nil)
            }
        }
    }
}


/*
 TODO: This view should in Profile view
 */
struct UserInfoView: View {
    @State private var userInfo: String = "Loading..."
    
    var body: some View {
        VStack {
            Text(userInfo)
                .padding()
            
            Button(action: {
                getUserInfo { result in
                    self.userInfo = result?.firstName ?? "Empty"
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
            getUserInfo { result in
                self.userInfo = result?.firstName ?? "Empty"
            }
        }
    }
}


#Preview {
    Initialization()
}
