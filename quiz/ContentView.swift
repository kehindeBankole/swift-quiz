//
//  ContentView.swift
//  quiz
//
//  Created by kehinde on 24/02/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var quiz : Quiz!
    @State private var currentQuiz = 0
    @State private var selectedQuizIndex = -1
    @State private var score = 0
    @State private var isDone = false
    @Namespace var namespace
    
    private var shouldDisable: Bool {
        selectedQuizIndex == -1
    }
    
    var body: some View {
        ZStack{
            if(!isDone){
                VStack {
                    if(isLoading ){
                        Text("loading")
                    }
                    else{
                        
                        ScrollView(showsIndicators: false){
                            HStack{
                                Text("200")
                                    .padding()
                                    .background(
                                        Rectangle().fill(.white).cornerRadius(5)
                                    )
                                Spacer()
                                Text("Fantasy quiz")
                                Spacer()
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Image(systemName: "xmark")
                                        .padding()
                                        .background(Circle().fill(.white))
                                })
                            }
                            
                            
                            VStack{
                                if(quiz != nil){
                                    
                                    HStack {
                                        GeometryReader { geometry in
                                            ZStack(alignment: .leading) {
                                                Rectangle().fill(Color.white).cornerRadius(15).frame(width: geometry.size.width).frame(height: 12)
                                                Rectangle().fill(Color.green).cornerRadius(15)
                                                    .frame(width: min(CGFloat(currentQuiz + 1) / CGFloat(quiz.results.count) * geometry.size.width, geometry.size.width)).frame(height: 12)
                                            }
                                        }.frame(height: 12)
                                        
                                        Text("(\(currentQuiz + 1) / \(quiz.results.count))").font(.caption)
                                    }.padding(.bottom , 50)
                                    
                                    
                                    Text("\(String(htmlEncodedString: quiz.results[currentQuiz].question) ?? "")").multilineTextAlignment(.leading)
                                    
                                    VStack(alignment: .leading,spacing: 20){
                                        
                                        ForEach(Array(quiz.results[currentQuiz].incorrect_answers.enumerated()) , id:\.offset){ index , item in
                                            
                                            let isSelected = selectedQuizIndex == index
                                            Button(action: {
                                                selectedQuizIndex = index
                                            }, label: {
                                                HStack(spacing : 20 ){
                                                    
                                                    if(isSelected){
                                                        Image(systemName: "checkmark").foregroundStyle(.green)
                                                            .padding()
                                                            .background(Circle().fill(.white))
                                                    }else{
                                                        Text("\(alphabets[index])").foregroundStyle(.black).fontWeight(.bold)
                                                            .padding()
                                                            .background(Circle().fill(Color("Grey")))
                                                    }
                                                    
                                                    
                                                    Text(String(htmlEncodedString: item) ?? "").foregroundStyle(.black).fontWeight(.bold)
                                                    Spacer()
                                                }.frame(maxWidth: .infinity)
                                            }).multilineTextAlignment(.leading)
                                                .padding()
                                                .background(
                                                    Rectangle()
                                                        .fill(isSelected ? Color("LightGreen") : .white)
                                                        .cornerRadius(5)
                                                )
                                        }
                                    }.padding(.top, 50)
                                }
                            }
                            .padding(.top , 20 )
                            .padding(.bottom , 30)
                            Spacer()
                            
                            if(quiz != nil){
                                let isLastQuiz = currentQuiz == quiz.results.count - 1
                                
                                Button(action: {
                                    if(isLastQuiz){
                                        withAnimation{
                                            isDone = true
                                        }
                                        return
                                    }
                                    withAnimation{
                                        currentQuiz += 1
                                    }
                                    
                                    if(quiz.results[currentQuiz].incorrect_answers[selectedQuizIndex] == quiz.results[currentQuiz].correct_answer){
                                        score += 1
                                    }
                                    
                                    
                                    selectedQuizIndex = -1
                                }, label: {
                                    HStack{
                                        Text(isLastQuiz ? "FINISH" : "CONTINUE").foregroundStyle(.white).fontWeight(.bold)
                                    }.frame(maxWidth: .infinity)
                                }).disabled(shouldDisable)
                                    .padding()
                                    .background(
                                        Rectangle()
                                            .fill(selectedQuizIndex == -1 ? Color("Disabled") : Color("LightGreen"))
                                            .cornerRadius(5)
                                    )
                            }
                        }
                        
                        
                    }
                    
                }
                .matchedGeometryEffect(id: "text", in: namespace)
                .padding()
                .background(Color("Cream"))
            }else{
                FinishView(score: score, total: quiz?.results.count ?? 0)
                    .matchedGeometryEffect(id: "text", in: namespace)
            }
        }.edgesIgnoringSafeArea(.bottom)
            .task{
                do{
                    isLoading = true
                    let data: Quiz? =  try await callApi()
                    
                    if let quizData = data {
                        quiz = quizData
                        for index in quiz.results.indices {
                            quiz.results[index].incorrect_answers.append(quiz.results[index].correct_answer)
                            quiz.results[index].incorrect_answers.shuffle()
                        }
                        
                    }
                    isLoading = false
                }catch{
                    isLoading = false
                    
                }
            }
    }
}

#Preview {
    ContentView()
}
