//
//  ContentView.swift
//  Poker Payouts Swift
//
//  Created by Samuel Ridet on 10/23/23.
//

import SwiftUI

struct Details : Identifiable {
    let id : String
    let buy : String
    let winning : String
}

struct ContentView: View {
    @State var currentPlayerName = ""
    @State var currentPlayerBuyIn = ""
    @State var currentPlayerWinning = ""
    @State var finalList : [Details] = []
    @State var temporary : [Details] = []
    @State var resultsCall : String = ""
    @StateObject var apiConnector = ApiConnector()
    @State var totalPot = 0
    @State var participants = 0
    @State var tabSelection = 0
    var body: some View {
        GeometryReader {geometry in
            VStack (alignment: .leading){
                ScrollView (showsIndicators: false)
                {
                    HStack{
                        
                        Image(systemName: "suit.heart.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                        Text("Poker Payouts")
                            .font(.custom("main-bold", size: 20))
                            .foregroundColor(.white)
                        
                        Spacer()
                        Image(systemName: "suit.spade.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                        
                    }.padding(.horizontal, 15)
                        .onTapGesture {
                         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                    
                    fieldEnter(currentPlayerName: $currentPlayerName, currentPlayerBuyIn: $currentPlayerBuyIn, currentPlayerWinning: $currentPlayerWinning, finalList: $finalList)
                        .padding(.vertical, 10)
                        .frame(width: geometry.size.width * 0.95)
                    TabView(selection: $tabSelection){
                        listEditor(finalList: $finalList)
                            .tag(0)
                           
                        resultDisplay(apiConnector: apiConnector)
                            .tag(1)
                            
                    }.tabViewStyle(.page)
                        .padding().background(RoundedRectangle(cornerRadius: 15).stroke(.gray,lineWidth: 2.5).foregroundColor(Color("darkBlue")))
                     .frame(height: 475)
                     .frame(width: geometry.size.width * 0.92)
                    
              
                    Button {
                        apiConnector.getResponse(standings: finalList){
                            withAnimation {
                                if self.tabSelection != 1{
                                    self.tabSelection = 1
                                }
                                
                            }
                       
                        }
                     
                        
              
                    } label: {
                        Text("Split Payments")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                            .padding()
                        
                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
                        
                    }.padding(.vertical, 10)
                        
                }
            }
        
            
            }.background(Rectangle().foregroundColor(Color("darkBlue")).ignoresSafeArea(.all))
        }
}

#Preview {
    ContentView()
}
