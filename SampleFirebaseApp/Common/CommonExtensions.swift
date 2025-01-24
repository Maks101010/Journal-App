//
//
// CommonExtensions.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//



import Foundation
import SwiftUI
import UIKit
struct TextFieldView:View {
    var placeholder :String
    var color : Color = .black
    @Binding var text : String
    @FocusState var focus
    var body: some View {
        
        
        ZStack (alignment: .leading){
            TextField("", text: $text)
                .padding(.leading)
                .frame(height: 50)
                .focused($focus)
                .background(focus ? FireBaseAppModel.shared.themeColor : Color.white ,in: RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2))
                .autocapitalization(.none)
                
            Text(placeholder)
                .padding(.horizontal,5)
                .background(color.opacity(focus || !text.isEmpty ? 1 : 0))
                .foregroundStyle(focus ? FireBaseAppModel.shared.themeColor : Color.white)
                .padding(.leading)
                .offset(x : focus || !text.isEmpty ? 5 : 0 ,y : focus || !text.isEmpty ? -25 : 0)
                .scaleEffect(focus ? 1.1 : 1)
                .onTapGesture{
                    focus.toggle()
                }
                
            
        }
        .animation(.linear(duration: 0.2), value: focus)
            
    }
}
struct SecureFieldView:View {
    @State var isSecure = true
    var placeholder :String
    var color : Color = .black
    @Binding var text : String
    @FocusState var focus
    var body: some View {
        ZStack (alignment: .leading){
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                }
                else {
                    TextField("", text: $text)
                }
                
                Button(action: {
                    isSecure.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        if !focus {
                            focus = true
                        }
                    })
                }, label: {
                    isSecure ? Image(systemName: "eye.slash.fill").font(.system(size: 20)).foregroundStyle(Color.gray) : Image(systemName: "eye.fill").font(.system(size: 20)).foregroundStyle(Color.gray)
                }
                    
                )
                .opacity(text.isEmpty ? 0 : 1)
                .padding(.trailing)
                
            }
            
                .padding(.leading)
                .frame(height: 50)
                .focused($focus)
                .background(focus ? FireBaseAppModel.shared.themeColor : Color.white ,in: RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2))
                
            Text(placeholder)
                .padding(.horizontal,5)
                .background(color.opacity(focus || !text.isEmpty ? 1 : 0))
                .foregroundStyle(focus ? FireBaseAppModel.shared.themeColor : Color.white)
                .padding(.leading)
                .offset(x : focus || !text.isEmpty ? 5 : 0   , y : focus || !text.isEmpty ? -25 : 0)
                .scaleEffect(focus   ? 1.1 : 1)
                .onTapGesture{
                    focus.toggle()
                }
                
            
        }
        .animation(.linear(duration: 0.2), value: focus)
    }
}



struct ButtonView:View {
    var title : String
    var action : (() -> ())
    var body: some View {
        Button(action: {action()}) {
            Text(title)
                .foregroundColor(Color.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(FireBaseAppModel.shared.themeColor)
                .cornerRadius(20)
                
               
        }
        .buttonStyle(shinkingButton())
    }
}



struct GenderPicker : View {
    var placeholder :String
    @FocusState var focus: Bool
    @Binding var text : String
   
    @State var pickerIsThere = false
    @State  var Gender = ["Male", "Female"]
    var body: some View {
        ZStack (alignment: .leading){
            TextField("", text: $text)
                .padding(.leading)
                .frame(height: 50)
                
                .background(focus || pickerIsThere ? FireBaseAppModel.shared.themeColor : Color.white ,in: RoundedRectangle(cornerRadius:20).stroke(lineWidth: 2))
                .autocapitalization(.none)
                .disabled(true)
                .onTapGesture {
                    pickerIsThere = true
                    focus = true
                    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
                }
                
            Text(placeholder)
                .padding(.horizontal,5)
                .background(Color.black.opacity(pickerIsThere || focus || !text.isEmpty ? 1 : 0))
                .foregroundStyle(pickerIsThere || focus ? FireBaseAppModel.shared.themeColor : Color.white)
                .padding(.leading)
                .offset( x : pickerIsThere || focus || !text.isEmpty ? 5 : 0 , y : pickerIsThere || focus || !text.isEmpty ? -25 : 0)
                .scaleEffect(pickerIsThere || focus ? 1.1 : 1)
                .onTapGesture {
                    pickerIsThere = true
                    focus = true
                    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
                }
                
            
        }
        .animation(.linear(duration: 0.2), value: focus || pickerIsThere)
        
        .focused($focus)
        
        
        
        .sheet(isPresented: $pickerIsThere, content: {
            PickerView1()
                .presentationDetents([.height(250), .fraction(0.50)])
        })
    }
}
extension GenderPicker {
    func PickerView1() -> some View {
        NavigationStack{
            List(Array((Gender).enumerated()),id: \.element){ index, gender in
                
            
               
                Text("\(gender)")
                    .foregroundStyle(Color.white)
            
            
           
            .onTapGesture {
                    focus = true
                    text = gender
                    pickerIsThere = false
            }
            .swipeActions(edge:index % 2 == 0 ? HorizontalEdge.leading : HorizontalEdge.trailing){
                Button(action:{
                    text = gender
                    pickerIsThere = false
                }){
                    Image(systemName: "arrow.up.right")
                        .symbolRenderingMode(.palette)
                }
                .tint(Color.black.opacity(0.3))
                .foregroundStyle(FireBaseAppModel.shared.themeColor)
            }
            .contextMenu{
                Button(action:{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        text = gender
                        pickerIsThere = false
                        
                    })
                   
                }){
                    Text( "Select It . ")
                        
                }
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                    
                    .background(Color.black)
            )
        }
            .listRowSpacing(2)
            .navigationTitle("Gender")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action:{
                    withAnimation{
                        focus = true
                        pickerIsThere = false
                    }
                   
                }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}






struct BtnWithoutBorder: View {
    let  img : String
    let  label : String
    let  fun : (()->Void)
    let color : Color
    
    var body: some View {
        Button(action: fun){
            HStack {
                Spacer()
                Image(systemName: img)
                Text(label)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding()
        .foregroundStyle(Color.white)
        
        .background(color,in: RoundedRectangle(cornerRadius: 30))
            
        
            
    }
}
struct BtnWithBorder: View {
    let  img : String
    let  label : String
    let  fun : (()->Void)
    let color : Color
    var body: some View {
        Button(action: fun){
            HStack {
                Spacer()
                Image(systemName: img)
                Text(label)
                Spacer()
            }
            
                .frame(maxWidth: .infinity)
        }
        .padding()
        .foregroundStyle(color)
        .background(color,in: RoundedRectangle(cornerRadius: 30).stroke())
           
            
    }
}


struct CommonText: View {
    var title: String
    var foregroundColor: Color = Color.white
    
    var body: some View {
        Text(title)
            .foregroundStyle(foregroundColor)
            .dynamicTypeSize(.medium)
    }
}




enum DividerOrientation {
    case horizontal
    case vertical
}

struct CustomDivider: View {
    var color: Color = .gray
    var thickness: CGFloat = 1
    var direction: DividerOrientation = .horizontal

    var body: some View {
        Group {
            if direction == .horizontal {
                Rectangle()
                    .fill(color)
                    .frame(height: thickness)
                    .edgesIgnoringSafeArea(.horizontal)
            } else {
                Rectangle()
                    .fill(color)
                    .frame(width: thickness)
                    .edgesIgnoringSafeArea(.vertical)
            }
        }
    }
}



struct CircularProgressView: View {
    // 1
    var progress: Double
    var color : Color = Color.green
    var lineWidth : CGFloat = 10
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            Text("\(String(format : "%.1f" , (progress * 100)))%")
                           .foregroundColor(color)
                           .padding(20)
        }
    }
}

struct shinkingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
           
    }
}



struct newPreView : View {
    @State var isSelected = false
    var body: some View {
        if isSelected {
            Button(action: {
                withAnimation(){
                    isSelected.toggle()
                }
                
            }){
                HStack {
                    Spacer()
                    Image(systemName: "circle")
                    Text("Button")
                    Spacer()
                }
                
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .buttonStyle(shinkingButton())
            .foregroundStyle(Color.white)
            .background(.white,in: RoundedRectangle(cornerRadius: 30).stroke())
        }
        else {
            Button(action: {
                withAnimation(){
                    isSelected.toggle()
                }
                
            }){
                HStack {
                    Spacer()
                    Image(systemName: "circle")
                    Text("Button")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding()
            .foregroundStyle(Color.black)
            
            .background(.white,in: RoundedRectangle(cornerRadius: 30))
        }
       
       
    }
}



extension UIApplication {
    /// `returns keyWindows from UIWindowScenes`
    static var keyWindow: UIWindow? {
        return self.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
struct NavigationUtil {
    
    ///`PopToRootView`
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.keyWindow?.rootViewController)?.popToRootViewController(animated: true)
    }
    
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
            
        }
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        return nil
    }
}


struct AlertButtonTintColor: ViewModifier {
    @Binding var color: Color
    @State private var previousTintColor: UIColor?

    func body(content: Content) -> some View {
        content
            .onAppear {
                previousTintColor = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
            }
            .onDisappear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = previousTintColor
            }
            .onChange(of: color) { _, newValue in
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
            }
    }
}





struct preloader:View {
    @State var appear : Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
    ZStack{
        Circle()
            .trim(from: 0,to: 0.3)
            .stroke(FireBaseAppModel.shared.themeColor)
            .frame(width: 70,height: 70)
            . rotationEffect(Angle(degrees: appear ? 360 : 0))
            .animation(.linear(duration: 0.5).repeatForever(autoreverses: false))
        VStack{
            Circle()
                
                .foregroundStyle(
                    .linearGradient(colors: [FireBaseAppModel.shared.themeColor,.white,FireBaseAppModel.shared.themeColor,.black], startPoint: .topLeading, endPoint: .bottomTrailing))
                . rotationEffect(Angle(degrees: appear ? 0 : 360))
                .animation(.linear(duration:0.7).repeatForever(autoreverses: true))
                .frame(width: 50)
                
        }
        
    }
    .onAppear {
            appear = true
        }
    .padding(30)
    
        
    }
}




struct customColorPicker: View {
    @State var allColors = [Color.orange, Color.yellow, Color.blue, Color.purple, Color.brown, Color.cyan, Color.gray, Color.indigo, Color.mint, Color.pink, Color.teal]
    @Binding var selectedColor : Color
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(allColors, id: \.self) { color in
                        ZStack() {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color)
                                .aspectRatio(1, contentMode: .fit)
//                                .blur(radius: selectedColor == Color.clear ? 0 :  selectedColor == color ? 0 : 5)
                                .scaleEffect(selectedColor == color ? 1.0 : 0.8)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                                        if selectedColor == color {
                                            selectedColor = color
                                            
                                        }
                                        else {
                                            selectedColor = color
                                            FireBaseAppModel.shared.themeColor = selectedColor
                                            UserDefaults.themeColor = selectedColor
                                        }
                                        
                                    }
                                }
                            Image(systemName:  "checkmark")
                                .opacity(selectedColor == color ? 1 : 0)
                        }
                        
                            
                    }
                }
                .padding()
            }
        }
    }
}






struct Glow : ViewModifier {
    func body (content : Content ) -> some View {
        ZStack {
            content
                .blur(radius: 20)
            content
        }
    }
}




struct CustomPopupView : View {
    var action : (() -> ())
    var color : Color = FireBaseAppModel.shared.themeColor
    var text = """
• Password Change:  If the password is changed, the user will be automatically logged out.

• Profile Update:   Any changes to the user's profile, such as name or gender, will be immediately reflected. 
"""
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            ZStack (alignment: .bottom){
                VStack{
                    Text("Note")
                        .font(.largeTitle)
                        .fontWidth(.expanded)
                    CustomDivider(color: color , thickness: 2)
                        .padding(.bottom)
                    Text(text)
                        .padding(.bottom,40)
                }
//                .foregroundStyle(color)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color , in: RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2))
                .padding()
                
               
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 40 , height: 40)
                        .padding(5)
                        .foregroundStyle(color)
                        .background(Color.black ,in: Circle())
                        .offset(y:9)
                        .onTapGesture {
                            action()
                        }
                       
                    
                
                
            }
           
            
        }
       
    }
}






struct ComplexShapeView : View {
    var text : String
    var offsetX : CGFloat
    var body: some View {
        ZStack {
            ZStack (alignment: .bottom){
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(FireBaseAppModel.shared.themeColor,lineWidth: 2)
                }
                .frame(width:250,height: 50)
                Image(systemName: "chevron.down")
                    .resizable()
                    .foregroundStyle(FireBaseAppModel.shared.themeColor)
                    .frame(width: 20,height: 15)
                    .background(.black)
                    .offset(x : offsetX ,  y : 13.5)
            }
            HStack {
                Text(text)
                    .foregroundStyle(FireBaseAppModel.shared.themeColor)
                    .bold()
            }
        }
        .padding(.horizontal)
        
        
        
    }
}


struct commonImageButtonView : View {
    var ImageName :  String = "plus.circle"
    var color = FireBaseAppModel.shared.themeColor
    var offsetX : CGFloat = 0
    var offsetY : CGFloat = 0
    var opacity : Double = 1.0
    var scale : Double = 1.0
    var degress : Double = 0
    var width : CGFloat = 50
    var height : CGFloat = 50
    var tapAction :  (() -> ()) = {}
    var pressing :  (() -> ()) = {}
    var elsepressing :  (() -> ()) = {}
    var perform:  (() -> ()) = {}
   
    var body: some View {
        VStack {
            Image(systemName: ImageName)
                .resizable()
                .frame(width: width,height: height)
                .offset( x : offsetX , y : offsetY)
                .opacity(opacity)
                .scaleEffect(scale)
                .rotationEffect(Angle(degrees: degress))
                .foregroundStyle(color)
                .onTapGesture {
                    tapAction()
                }
                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPress in
                    if isPress {
                        pressing()
                    }
                    else {
                        elsepressing()
                    }
                }, perform: {
                    perform()
                })
        }
    }
}




#Preview{
    commonImageButtonView()
}
