//
//  Home.swift
//  TextAnimation
//
//  Created by Quang Bao on 26/01/2022.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 20){
                
                GeometryReader{ proxy in
                    
                    let size = proxy.size
                    
                    // Sample Image
                    Image("TextAnimation")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
//                        .frame(width: size.width, height: size.height, alignment: .center)
                        .cornerRadius(15)
                }
                .frame(height: 220)
                
                Marquee(text: "With the blazing-fast M1 Pro or M1 Max chip — the first Apple silicon designed for pros — you get groundbreaking performance and amazing battery life.", font: .systemFont(ofSize: 16, weight: .light))
                
            }
            .padding(.horizontal)
            .vTop()
            .navigationTitle("Apple")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View{
    
    func vTop() -> some View {
        frame(maxHeight: .infinity, alignment: .top)
    }
}

// MARK: Marquee Text View
struct Marquee: View {
    
    var text: String
    // Customimazation Options
    var font: UIFont
    
    // Storing Text Size
    @State var storedSize: CGSize = .zero
    
    var body: some View{
        
        // Since it scroll horizontal using ScrollView
        ScrollView(.horizontal, showsIndicators: false) {
            
            Text(text)
                .font(Font(font))
        }
        // Disabling Manual Scrolling
        .disabled(true)
        .onAppear {
            
            storedSize = textSize()
        }
    }
    
    // MARK: Fetching Text Size for Offset Animation
    func textSize() -> CGSize {
        
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
