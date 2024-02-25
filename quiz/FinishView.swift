//
//  FinishView.swift
//  quiz
//
//  Created by kehinde on 25/02/2024.
//

import SwiftUI

struct FinishView: View {
    @State var score:Int
    @State var total : Int
    var body: some View {
        VStack(spacing: 35){
            Spacer()
            Image("prize").resizable().scaledToFit().frame(width: 143, height: 151, alignment: .center)
            Text("Results of fantasy quiz")
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .font(.largeTitle)
            VStack(spacing : 20){
                HStack{
                    Text("SCORE GAINED")
                    Spacer()
                    Text("\(score * total)")
                }
                Divider()
                HStack{
                    Text("CORRECT PREDICTIONS")
                    Spacer()
                    Text("\(score)")
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(15)
            Spacer()
        }
        .padding()
            .background(Color("Cream"))
    }
}

#Preview {
    FinishView(score:10 , total: 20)
}
