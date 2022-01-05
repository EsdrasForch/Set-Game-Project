//
//  SetGameView.swift
//  Set
//
//  Created by Esdras Forch on 10/29/21.
//  This is only the past due HW 3 and not HW4

import SwiftUI

//View extension for our alert that will let us know that we cannot keep on dealing cards
public extension View {
    func alert(presented:Binding<Bool>,
               title:String,
               message:String? = nil,
               dismissButton:Alert.Button? = nil) -> some View {
        alert(isPresented: presented) { () -> Alert in
                Alert(title: Text(title),
                  message: {
                    if let m = message {return Text(m)}
                    else {return nil}
                  }(),
                  dismissButton: dismissButton)
        }
    }
}

struct SetGameView: View {
    @ObservedObject var model = SetGameViewModel()
    @State var disableDealsButton = false
    @State var showAlert = false
    
    //var setCards: [SetCard] = []
    
    var body: some View {
        VStack {
            Text("SET 🧚")
                .font(.largeTitle)
                .foregroundColor(Color.purple)
            Text(model.statusText)
            
            AspectVGrid(self.model.cards) { card in
                CardView(card: card)
                    .zIndex(card.isSelected ? 2:1)
                    .padding(max(0, CGFloat(-self.model.cards.count) + 24))
                    .onTapGesture {
                        withAnimation {
                            self.model.choose(card)
                        }
                    }
                    .transition(.offset(self.randomOffset))
            }
            .onAppear {
                //self.newGame() - We do not need to keep on loading a fresh game 
            }
            HStack {
            Button(action: dealMoreCards) {
                Text("Deal 3 More Cards")
                    .foregroundColor(Color.black)
                    .padding()
            }
            .disabled(self.disableDealsButton)
            
            //Calls upon the var for remaining cards in the deck to help us keep count
            Text("\(model.cardsRemaining) Cards Remained")
                .foregroundColor(Color.black)
                .padding()
            }
            
            Button(action: newGame) {
                Text("New Game")
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(20)
        
            }
        }
        .alert(presented: $showAlert, title: "Card Deck is Empty", message: nil, dismissButton: .default(Text("Ok"), action: {
            self.disableDealsButton.toggle()
        }))
    }
    
    var randomOffset: CGSize {
        let size = UIScreen.main.bounds.size
        
        let signs: [CGFloat] = [-1, 1]
        let x: CGFloat = .random(in: 0..<size.width) * signs.randomElement()!
        let y: CGFloat = .random(in: 0..<size.height) * signs.randomElement()!
        
        return CGSize(width: x, height: y)
    }
    
    func dealMoreCards() {
        guard model.cardsRemaining > 0 else {
            self.showAlert.toggle()
            return
        }
        withAnimation {
            self.model.drawCard(3)
        }
    }
    
    func newGame() {
        withAnimation(.easeInOut) {
            if self.disableDealsButton == true {
                self.disableDealsButton.toggle()
            }
            self.model.newGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
