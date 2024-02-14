//
//  resultDisplay.swift
//  Poker Payouts Swift
//
//  Created by Samuel Ridet on 10/24/23.
//

import SwiftUI

struct resultDisplay: View {
    @ObservedObject var apiConnector : ApiConnector

    var body: some View {
        VStack{
            HStack{
                Text("Payment Split")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .bold()
                    .underline()
                Spacer()
                ShareLink(item: apiConnector.holderString){
                    Image(systemName: "square.and.arrow.up.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
  
                  

            }.padding(.bottom,3)
            if apiConnector.errorMessage != " "{
                Text(apiConnector.errorMessage)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
            }else{
                ScrollView{
                    ForEach(apiConnector.resultList){res in
                        VStack(alignment: .leading){
                            Text("\(res.id) venmos:")
                                .foregroundStyle(.white)
                                .bold()
                            ForEach(res.amounts.indices, id: \.self) { index in
                                let amount = res.amounts[index]
                                //let roundedValue = String(format: "%.2g", amount.value)
                                Text("\t\(amount.id) for \(amount.value)$")
                                    .foregroundStyle(.white)

                                
                            }
                            
                            Rectangle().frame(height:1)
                                .foregroundStyle(.gray)
                                .opacity(0.6)
                        }
                        
                    }
                }
            }
            Spacer()
     
        }
            .onTapGesture {
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
         }
    }
}
struct resultDisplay_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var listOne: [Details] = []
        @StateObject var apiConnector = ApiConnector()
        var body: some View {
            resultDisplay(apiConnector: apiConnector)
                .background(Rectangle().foregroundColor(Color("darkBlue")).ignoresSafeArea(.all))
        }
    }
}
