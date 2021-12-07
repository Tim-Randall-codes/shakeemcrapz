//
//  ContentView.swift
//  ShakeEmCraps
//
//  Created by Tim Randall on 7/12/21.
//

import SwiftUI

struct BossView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    var body: some View {
        if viewChanger.page == .p1 {
            TitleView(viewChanger: viewChanger, bet: bet, cash: cash)
        }
        else if viewChanger.page == .p2 {
            GameView(viewChanger: viewChanger, bet: bet, cash: cash)
        }
        else if viewChanger.page == .p3 {
            ResultView(viewChanger: viewChanger, bet: bet, cash: cash)
        }
    }
}

struct TitleView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @State var userEntry: String = ""
    @State var displayMessage: String = ""
    var body: some View {
        ZStack{
            Background()
            VStack{
                Title(words: "Shake'Em Crapz!")
                TextWidget(words: "You have $\(cash.num)")
                TextWidget(words: displayMessage)
                TextWidget(words: "How much would you like to bet?")
                TextField("enter amount here", text:$userEntry).padding()
                Button(action:{
                    do{
                        try checkInput()
                    } catch EntryError.emptyField {
                        displayMessage = "Please enter a bet"
                    } catch EntryError.notInt {
                        displayMessage = "Please only enter whole numbers"
                    } catch {
                        print("error")
                    }
                }, label:{
                    ButtonWidget(words: "Start Gaming!")
                })
            }
        }
    }
    func checkInput() throws {
        if userEntry == "" {
            throw EntryError.emptyField
        }
        if let betInt = Int(userEntry) {
            bet.num = betInt
            displayMessage = ""
        }
        else {
            throw EntryError.notInt
        }
    }
}

struct GameView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    var body: some View {
        Text("Hello World")
    }
}

struct ResultView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    var body: some View {
        Text("Hello World")
    }
}

struct Background: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.red, .red, .black]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}

struct ButtonWidget: View {
    var words: String
    var body: some View {
        Text(words).padding()
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(20)
    }
}

struct TextWidget: View {
    var words: String
    var body: some View {
        Text(words).padding()
            .foregroundColor(Color.white)
            .font(.system(size: 18))
    }
}

struct Title: View {
    var words: String
    var body: some View {
        Text(words).padding()
            .foregroundColor(Color.white)
            .font(.system(size: 22, weight: .bold))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BossView(viewChanger: ViewChanger(), bet: IntOO(), cash: IntOO2())
    }
}
