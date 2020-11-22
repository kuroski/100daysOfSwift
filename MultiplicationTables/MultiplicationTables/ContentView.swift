//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Daniel Kuroski on 22.11.20.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let title: String
    let answer: Int
    
    var userAnswer: Int?
    
    mutating func answerQuestion(_ answer: String) -> Void {
        self.userAnswer = Int(answer)
    }
}

struct SettingsView: View {
    @State var table: Int = 1
    @State var amount: Int = 5
    
    var generateQuestions: (Int, Int) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Multiplication table")) {
                Stepper(value: $table, in: 1...12, onEditingChanged: { val in
                    if table == 1 && amount == 20 {
                        amount = 10
                    }
                }) {
                    Text(String(table))
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
                .frame(height: .infinity)
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
    
    var questions: [Question]
    var questionAnswered: (String, Int) -> Void
    
    var body: some View {
        Form {
            Section {
                Text(questions[currentQuestion].title)
            }
            
            Section {
                TextField("Answer", text: $answer)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button("Submit", action: {
                    self.questionAnswered(answer, currentQuestion)
                    
                    if self.currentQuestion + 1 < questions.count {
                        self.currentQuestion += 1
                    }
                    
                    self.answer = ""
                })
            }
            
            ProgressView(value: Double(currentQuestion + 1), total: Double(questions.count))
        }
    }
}

struct ContentView: View {
    @State private var table: Int = 1
    @State private var amount: Int = 5
    @State private var questions: [Question] = []
    
    var allQuestionsAnswered: Bool {
        questions.allSatisfy { question -> Bool in
            question.userAnswer != nil
        }
    }
    
    var body: some View {
        Group {
            if (questions.isEmpty) {
                SettingsView(table: table, amount: amount, generateQuestions: generateQuestions)
            } else if allQuestionsAnswered {
                List {
                    ForEach(questions) { question in
                        HStack {
                            Text("\(question.title) = \(question.answer)")
                            Text("You answered \(question.userAnswer!)")
                        }
                    }
                }
            } else {
                GameView(questions: questions, questionAnswered: questionAnswered)
            }
        }
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