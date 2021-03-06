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
                        .frame(width: size.width, height: size.height, alignment: .center)
                        .cornerRadius(15)
                }
                .frame(height: 220)
                
                Marquee(text: "The most powerful MacBook Pro ever is here. With the blazing-fast M1 Pro or M1 Max chip — the first Apple silicon designed for pros", font: .systemFont(ofSize: 16, weight: .light))
                
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
    
    @State var text: String
    // Customimazation Options
    var font: UIFont
    
    // Storing Text Size
    @State var storedSize: CGSize = .zero
    
    // MARK: Animation Offset
    @State var offset: CGFloat = 0
    
    // MARK: Animation Speed
    var animationSpeed: Double = 0.02
    var delayTime: Double = 0.5
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        
        // Since it scroll horizontal using ScrollView
        ScrollView(.horizontal, showsIndicators: false) {
            
            Text(text)
                .font(Font(font))
                .offset(x: offset)
                .padding(.horizontal)
        }
        // Opacity Effect
        .overlay(content: {
            
            HStack{
                let color : Color = scheme == .dark ? .black : .white
                
                LinearGradient(colors: [color, color.opacity(0.7),color.opacity(0.5),color.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
                
                Spacer()
                
                // Use ".revesed()" to setup for the end of line.
                LinearGradient(colors: [color, color.opacity(0.7),color.opacity(0.5),color.opacity(0.3)].reversed(), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 20)
            }
        })
        // Disabling Manual Scrolling
        .disabled(true)
        .onAppear {
            
            // Base Text
            let baseText = text
            
            // MARK: Continous Text Animation
            // Adding Spacing For Continous Text
            (1...15).forEach { _ in
                text.append(" ")
            }
            // Stoping Animation exactly before the next text
            // "storedSize" được đặt trong hàm bất đồng bộ nên khi giá trị của nó được thay đổi thì hàm có chứa nó sẽ process ngay lập tức.
            storedSize = textSize()
            text.append(baseText)
            
            // Calculating Total Secs based on Text With
            // Our Animation Speed for Each Character will be 0.02s
            let timing: Double = (animationSpeed * storedSize.width)
            
            // Delaying First Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.linear(duration: timing)){
                    offset = -storedSize.width
                }
            }
        }
        // MARK: Repeating with the help of Timer
        // Optional: If you want some delay for next animation
        .onReceive(Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime), on: .main, in: .default).autoconnect()) { _ in
            
            // Resetting offset to 0
            // Thus its look like its looping
            offset = 0
            withAnimation(.linear(duration: (animationSpeed * storedSize.width))){
                offset = -storedSize.width
            }
        }
    }
    
    // MARK: Fetching Text Size for Offset Animation
    func textSize() -> CGSize {
        
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
