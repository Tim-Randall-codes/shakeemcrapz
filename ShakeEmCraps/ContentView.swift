//
//  ContentView.swift
//  ShakeEmCraps
//
//  Created by Tim Randall on 7/12/21.
//

import SwiftUI

// put in dice graphics
// put in page for game over when money is zero and game over for when money is too high

struct BossView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @StateObject var pass: BoolOO
    @StateObject var pointTotal: IntOO
    @StateObject var shooterWins: BoolOO
    @StateObject var winnings: IntOO
    var body: some View {
        if viewChanger.page == .p1 {
            TitleView(viewChanger: viewChanger, bet: bet, cash: cash)
        }
        else if viewChanger.page == .p2 {
            GameView1(viewChanger: viewChanger, bet: bet, cash: cash, pass: pass)
        }
        else if viewChanger.page == .p3 {
            GameView2(viewChanger: viewChanger, bet: bet, cash: cash, pass: pass, pointTotal: pointTotal, shooterWins: shooterWins, winnings: winnings)
        }
        else if viewChanger.page == .p4 {
            GameView3(viewChanger: viewChanger, bet: bet, cash: cash, pass: pass, pointTotal: pointTotal, shooterWins: shooterWins, winnings: winnings)
        }
        else if viewChanger.page == .p5 {
            ResultView(viewChanger: viewChanger, bet: bet, cash: cash, pass: pass, shooterWins: shooterWins, winnings: winnings)
        }
        else if viewChanger.page == .p6 {
            GameOverView(viewChanger: viewChanger, cash: cash)
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
            viewChanger.page = .p2
        }
        else {
            throw EntryError.notInt
        }
    }
}

struct GameView1: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @StateObject var pass: BoolOO
    var body: some View {
        ZStack{
            Background()
            VStack{
                Title(words: "Shake'Em Crapz!")
                TextWidget(words: "You have $\(cash.num). You bet $\(bet.num)")
                TextWidget(words: "Would you like to pass (bet the shooter will win) or not pass (bet the shooter will lose)?")
                HStack{
                    Button(action:{
                        pass.boo = true
                        viewChanger.page = .p3
                    }, label:{
                        ButtonWidget(words: "Pass")
                    })
                    Button(action:{
                        pass.boo = false
                        viewChanger.page = .p3
                    }, label:{
                        ButtonWidget(words: "Don't pass")
                    })
                }
            }
        }
    }
}

struct GameView2: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @StateObject var pass: BoolOO
    @StateObject var pointTotal: IntOO
    @StateObject var shooterWins: BoolOO
    @StateObject var winnings: IntOO
    @State var dice1: Int = Int.random(in: 1...6)
    @State var dice2: Int = Int.random(in: 1...6)
    @State var displayMessage: String = ""
    var body: some View {
        ZStack{
            Background()
            VStack{
                Title(words: "Shake'Em Crapz!")
                TextWidget(words: "You have $\(cash.num). You bet $\(bet.num).")
                ImageView(diceOneNum: dice1, diceTwoNum: dice2)
                if dice1 + dice2 == 2 || dice1 + dice2 == 3 || dice1 + dice2 == 12 {
                    TextWidget(words: "Score is \(dice1 + dice2), shooter loses!")
                    Button(action:{
                        shooterWins.boo = false
                        winnings.num = cash.num - bet.num
                        viewChanger.page = .p5
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
                if dice1 + dice2 == 7 || dice1 + dice2 == 11 {
                    TextWidget(words: "Score is \(dice1 + dice2), shooter wins!")
                    Button(action:{
                        shooterWins.boo = true
                        winnings.num = cash.num + bet.num
                        viewChanger.page = .p5
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
                if dice1 + dice2 == 4 || dice1 + dice2 == 5 || dice1 + dice2 == 6 || dice1 + dice2 == 8 || dice1 + dice2 == 9 || dice1 + dice2 == 10 {
                    TextWidget(words: "Score is \(dice1 + dice2), Point! So roll again and again. If same score again they win, if they get a seven first they lose.")
                    Button(action:{
                        viewChanger.page = .p4
                        pointTotal.num = dice1 + dice2
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
            }
        }
    }
}

struct GameView3: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @StateObject var pass: BoolOO
    @StateObject var pointTotal: IntOO
    @StateObject var shooterWins: BoolOO
    @StateObject var winnings: IntOO
    @State var dice1: Int = Int.random(in: 1...6)
    @State var dice2: Int = Int.random(in: 1...6)
    var body: some View {
        ZStack{
            Background()
            VStack{
                Title(words: "Shake'Em Crapz!")
                TextWidget(words: "You have $\(cash.num). You bet $\(bet.num). The total the shooter needs to win is \(pointTotal.num).")
                ImageView(diceOneNum: dice1, diceTwoNum: dice2)
                if dice1 + dice2 == 7 {
                    TextWidget(words: "Seven was rolled: shooter loses!")
                    Button(action:{
                        shooterWins.boo = false
                        wonOrLost()
                        viewChanger.page = .p5
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
                else if dice1 + dice2 == pointTotal.num {
                    TextWidget(words: "\(pointTotal.num) was rolled: shooter wins!")
                    Button(action:{
                        shooterWins.boo = true
                        wonOrLost()
                        viewChanger.page = .p5
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
                else if dice1 + dice2 == 12 {
                    TextWidget(words: "You rolled 12. Shooter doesn't win or lose.")
                    Button(action:{
                        viewChanger.page = .p5
                    }, label:{
                        ButtonWidget(words: "Continue")
                    })
                }
                else {
                    TextWidget(words: "Didn't get 7 or \(pointTotal.num). Need to roll again.")
                    Button(action:{
                        dice1 = Int.random(in: 1...6)
                        dice2 = Int.random(in: 1...6)
                    }, label:{
                        ButtonWidget(words: "Roll again")
                    })
                }
            }
        }
    }
    func wonOrLost() {
        if pass.boo == true && shooterWins.boo == true || pass.boo == false && shooterWins.boo == false {
            winnings.num = cash.num + bet.num
        }
        else if pass.boo == false && shooterWins.boo == true || pass.boo == true && shooterWins.boo == false {
            winnings.num = cash.num - bet.num
        }
    }
}

struct ResultView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var bet: IntOO
    @StateObject var cash: IntOO2
    @StateObject var pass: BoolOO
    @StateObject var shooterWins: BoolOO
    @StateObject var winnings: IntOO
    var body: some View {
        ZStack{
            Background()
            VStack{
                Title(words: "Shake'Em Crapz!")
                if pass.boo == true {
                    TextWidget(words: "You bet that the shooter would win")
                }
                else {
                    TextWidget(words: "You bet that the shooter would lose")
                }
                if shooterWins.boo == true {
                    TextWidget(words: "The shooter won!")
                }
                else {
                    TextWidget(words: "The shooter lost!")
                }
                TextWidget(words: "You have $\(cash.num). You bet $\(bet.num). So now you have \(winnings.num).")
                Button(action:{
                    cash.num = winnings.num
                    if cash.num > 0 {
                        viewChanger.page = .p1
                    }
                    else {
                        viewChanger.page = .p6
                    }
                }, label:{
                    ButtonWidget(words: "Continue")
                })
            }
        }
    }
}

struct GameOverView: View {
    @StateObject var viewChanger: ViewChanger
    @StateObject var cash: IntOO2
    var body: some View {
        ZStack{
            Background()
            VStack{
                Spacer()
                Title(words: "Game Over")
                TextWidget(words: "Sorry my man, game over you ran out of money.")
                Button(action:{
                    cash.num = 100
                    viewChanger.page = .p1
                }, label:{
                    ButtonWidget(words: "Start Again")
                })
                Spacer()
            }
        }
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

struct ImageView: View {
    var diceOneNum: Int
    var diceTwoNum: Int
    var body: some View{
        HStack{
            if diceOneNum == 1 {
                Image("Alea_1").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceOneNum == 2 {
                Image("Alea_2").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceOneNum == 3 {
                Image("Alea_3").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceOneNum == 4 {
                Image("Alea_4").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceOneNum == 5 {
                Image("Alea_5").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceOneNum == 6 {
                Image("Alea_6").resizable()
                    .frame(width: 50, height: 50)
            }
            if diceTwoNum == 1 {
                Image("Alea_1").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceTwoNum == 2 {
                Image("Alea_2").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceTwoNum == 3 {
                Image("Alea_3").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceTwoNum == 4 {
                Image("Alea_4").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceTwoNum == 5 {
                Image("Alea_5").resizable()
                    .frame(width: 50, height: 50)
            }
            else if diceTwoNum == 6 {
                Image("Alea_6").resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BossView(viewChanger: ViewChanger(), bet: IntOO(), cash: IntOO2(), pass: BoolOO(), pointTotal: IntOO(), shooterWins: BoolOO(), winnings: IntOO())
    }
}
