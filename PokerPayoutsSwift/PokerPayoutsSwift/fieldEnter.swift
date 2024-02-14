//
//  fieldEnter.swift
//  Poker Payouts Swift
//
//  Created by Samuel Ridet on 10/23/23.
//

import SwiftUI

struct fieldEnter: View {
    @Binding var currentPlayerName : String
    @Binding var currentPlayerBuyIn : String
    @Binding var currentPlayerWinning : String
    @Binding var finalList : [Details]
    var body: some View {
        
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text("Name")
                    .foregroundStyle(.white)
                    .font(.caption2)
                TextField("", text: $currentPlayerName)
                    .accentColor(.white)
                    .foregroundColor(.white)
                    .font(.callout)
                    .frame(width: 85)
            
                    Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 75, height: 1)
            }
      
            VStack(alignment: .leading){
                Text("Buy in")
                    .foregroundStyle(.white)
                    .font(.caption2)
                VStack(alignment: .leading){
                    HStack{
                        TextField("", text: $currentPlayerBuyIn)
                            .accentColor(.white)
                            .foregroundColor(.white)
                            .font(.callout)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 65)
                            .keyboardType(.decimalPad)
                        Text("$")
                            .foregroundColor(.white)
                            .font(.callout)
                            .frame(width: 20)
                    }
                    
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 85, height: 1)
                }
                    
            }
            VStack(alignment: .leading){
                Text("Winnings")
                    .foregroundStyle(.white)
                    .font(.caption2)
                VStack(alignment: .leading){
                    HStack{
                        TextField("", text: $currentPlayerWinning)
                            .accentColor(.white)
                            .foregroundColor(.white)
                            .font(.callout)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 65)
                            .keyboardType(.decimalPad)
                        Text("$")
                            .foregroundColor(.white)
                            .font(.callout)
                            .frame(width: 20)
                    }
                    
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 85, height: 1)
                }
                    
            }
            
            Button {
                if !self.currentPlayerName.isEmpty && !self.currentPlayerBuyIn.isEmpty && !self.currentPlayerWinning.isEmpty{
                    finalList.append(Details(id: currentPlayerName, buy: currentPlayerBuyIn, winning: currentPlayerWinning))
                    self.currentPlayerName = ""
                    self.currentPlayerBuyIn = ""
                    self.currentPlayerWinning = ""
                }
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(self.currentPlayerName.isEmpty || self.currentPlayerBuyIn.isEmpty || self.currentPlayerWinning.isEmpty ? Color.gray : Color.white)
                    .font(.title3)
                
                
            }  .disabled(self.currentPlayerName.isEmpty || self.currentPlayerBuyIn.isEmpty || self.currentPlayerWinning.isEmpty)
                .padding(.horizontal, 5)
      
        }.padding().background(RoundedRectangle(cornerRadius: 15).stroke(.gray,lineWidth: 2.5).foregroundColor(Color("darkBlue")))
      
      
 
    }
}

struct fieldEnter_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var currentPlayerName = ""
        @State private var currentPlayerBuyIn = ""
        @State private var currentPlayerWinning = ""
        @State private var finalList: [Details] = []

        var body: some View {
            fieldEnter(
                currentPlayerName: $currentPlayerName,
                currentPlayerBuyIn: $currentPlayerBuyIn,
                currentPlayerWinning: $currentPlayerWinning,
                finalList: $finalList
            )
            .background(Rectangle().foregroundColor(Color("darkBlue")).ignoresSafeArea(.all))
        }
    }
}

