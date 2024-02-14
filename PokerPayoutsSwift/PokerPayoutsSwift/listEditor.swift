//
//  listEditor.swift
//  Poker Payouts Swift
//
//  Created by Samuel Ridet on 10/24/23.
//

import SwiftUI

struct listEditor: View {
    @Binding var finalList : [Details]
    @State var temporary : [Details] = []
    var body: some View {
        VStack{
            HStack{
                Text("Standings")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .bold()
                    .underline()
                Spacer()
            }.padding(.bottom,3)
            HStack{
                Text("Name")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 70)
                Spacer()
                Text("Buy in")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 70)
                Spacer()
                Text("Result")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 70)
                Spacer()
                
                Image(systemName: "minus.circle.fill")
                    .font(.title3)
                    .opacity(0)
                    .frame(width: 70)
            }
            
            ScrollView{
                ForEach(finalList){player in
                    VStack{
                        HStack{
                            Text(player.id)
                                .foregroundColor(.white)
                                .frame(width: 70)
                            Spacer()
                            Text("\(player.buy)$")
                                .foregroundColor(.white)
                                .frame(width: 70)
                            Spacer()
                            Text("\(player.winning)$")
                                .foregroundColor(.white)
                                .frame(width: 70)
                            Spacer()
                            Button {
                                self.temporary = finalList.filter { $0.id != player.id }
                                self.finalList = self.temporary
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.red)
                                
                            }.frame(width: 70)
                        }.padding(.vertical, 3)
                        Rectangle().frame(height:1)
                            .foregroundStyle(.gray)
                            .opacity(0.6)
                    }
                    
                }
            }
        }
            .onTapGesture {
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
         }
    }
}

struct listEditor_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var listOne: [Details] = []

        var body: some View {
            listEditor(finalList: $listOne)
                .background(Rectangle().foregroundColor(Color("darkBlue")).ignoresSafeArea(.all))
        }
    }
}
