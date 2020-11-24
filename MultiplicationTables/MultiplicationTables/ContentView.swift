//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Daniel Kuroski on 22.11.20.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

enum Animals: String, CaseIterable {
    case bear
    case buffalo
    case chick
    case chicken
    case cow
    case crocodile
    case dog
    case duck
    case elephant
    case frog
    case giraffe
    case goat
    case gorilla
    case hippo
    case horse
    case monkey
    case moose
    case narwhal
    case owl
    case panda
    case parrot
    case penguin
    case pig
    case rabbit
    case rhino
    case sloth
    case snake
    case walrus
    case whale
    case zebra
}

struct Question: Identifiable {
    let id = UUID()
    let title: String
    let answer: Int
    
    var userAnswer: Int?
    
    var isRight: Bool {
        guard let userAnswer = self.userAnswer else { return false }
        return userAnswer == self.answer
    }
    
    mutating func answerQuestion(_ answer: String) -> Void {
        self.userAnswer = Int(answer)
    }
}

struct SettingsView: View {
    @State private var table: Int = 1
    @State private var amount: Int = 5
    
    var generateQuestions: (Int, Int) -> Void
    
    var animals: [Animals] = Array(Animals.allCases.shuffled()[..<12])
    
    let animalColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        Form {
            Section(header: Text("Multiplication table")) {
                HStack {
                    Spacer()
                    VStack {
                        Stepper(String(table), value: $table, in: 1...12, onEditingChanged: { val in
                            if table == 1 && amount == 20 {
                                amount = 10
                            }
                        })
                        .labelsHidden()
                        .padding(.bottom, 20)
                        
                        LazyVGrid(columns: animalColumns, spacing: 16) {
                            ForEach((0...(table - 1)), id: \.self) { index in
                                ZStack(alignment: .topLeading) {
                                    Image(animals[index].rawValue).resizable().scaledToFit().frame(height: 50)
                                    Text(String(index+1))
                                        .font(.body)
                                        .padding(6)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2))
                                        )
                                        .offset(x: -10, y: -15)
                                }
                            }
                        }.animation(.spring())
                    }
                    Spacer()
                }
            }
            
            Section(header: Text("Question amount")) {
                Picker(selection: $amount, label: Text("Question amount")) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    if (table > 1) {
                        Text("20").tag(20)
                    }
                    Text("All").tag(0)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Button(action: {
                    self.generateQuestions(table, amount)
                }) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Image("cow")
                            Text("Start!")
                                .font(.title)
                        }
                        Spacer()
                    }
                }
                .contentShape(Capsule())
                .foregroundColor(Color.white)
                .listRowBackground(Color.purple)
            }
            
        }
    }
}

struct GameView: View {
    @State private var currentQuestion = 0
    @State private var answer = ""
    @State private var hasError = false
    
    var questions: [Question]
    var questionAnswered: (String, Int) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack(spacing: 0) {
                    Text("\(questions[currentQuestion].title) = ")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                    
                    TextField("?", text: $answer)
                        .keyboardType(.numberPad)
                        .padding(.vertical, 10)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(hasError ? Color.red.opacity(0.8) : Color.purple.opacity(0.8), lineWidth: 3)
                        )
                        .frame(maxWidth: 100)
                        .modifier(Shake(animatableData: CGFloat(hasError ? 1.0 : 0.0)))
                }.padding(.bottom, 50)
                
                Button(action: {
                    if (answer.isEmpty) {
                        withAnimation(.default) {
                            self.hasError = true
                        }
                        return
                    }
                    
                    self.questionAnswered(answer, currentQuestion)
                    self.hasError = false
                    
                    if self.currentQuestion + 1 < questions.count {
                        self.currentQuestion += 1
                    }
                    
                    self.answer = ""
                }) {
                    Image(systemName: "checkmark.seal")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .rotation3DEffect(.degrees(hasError ? 360.0 : 0.0), axis: (x: 0, y: 0, z: 1))
                .foregroundColor(.white)
                .colorMultiply(hasError ? .red : .blue)
                .animation(Animation.easeInOut(duration: 1).delay(0.3))
            }.padding()
            
            Spacer()
            
            ProgressView(value: Double(currentQuestion + 1), total: Double(questions.count))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct EndView: View {
    var questions: [Question]
    var newGame: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(questions) { question in
                    HStack {
                        Image(systemName: question.isRight ? "checkmark.circle" : "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundColor(question.isRight ? .green : .red)
                        Text("\(question.title) = \(question.answer)").font(.title2)
                        Spacer()
                        Text("\(question.userAnswer!)")
                            .fontWeight(.bold)
                            .foregroundColor(question.isRight ? .green : .red)
                            .padding(8)
                            .overlay(
                                Circle()
                                    .stroke(question.isRight ? Color.green : Color.red, lineWidth: 2)
                            )
                    }
                }
            }.navigationBarItems(trailing: Button("New game", action: self.newGame))
        }
    }
}

struct ContentView: View {
    @State private var questions: [Question] = []
    
    var hasAllQuestionsAnswered: Bool {
        questions.allSatisfy { question -> Bool in
            question.userAnswer != nil
        }
    }
    
    var body: some View {
        Group {
            if (questions.isEmpty) {
                SettingsView(generateQuestions: self.generateQuestions)
            } else if hasAllQuestionsAnswered {
                EndView(questions: questions, newGame: self.newGame)
            } else {
                GameView(questions: questions, questionAnswered: self.questionAnswered)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
            }
        }
        //        .onAppear {
        //            generateQuestions(withTable: 1, withAmount: 2)
        //
        //            questions.enumerated().forEach { index, _ in
        //                questionAnswered("1", forQuestion: index)
        //            }
        //        }
    }
    
    private func newGame() -> Void {
        self.questions = []
    }
    
    private func questionAnswered(_ answer: String, forQuestion index: Int) -> Void {
        self.questions[index].answerQuestion(answer)
    }
    
    private func generateQuestions(withTable table: Int, withAmount amount: Int) -> Void {
        let allQuestions = (1...table).reduce([Question](), { acc, value in
            let subQuestions: [Question] = (1...10).map { Question(title: "\(value) x \($0)", answer: value * $0) }
            
            return acc + subQuestions
        }).shuffled()
        
        if amount == 0 {
            questions = allQuestions
        } else {
            questions = Array(allQuestions[0...(amount - 1)])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
