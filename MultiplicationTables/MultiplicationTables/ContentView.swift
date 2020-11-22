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
}

struct ContentView: View {
    @State private var table: Int = 1
    @State private var amount: Int = 5
    @State private var questions: [Question] = []
    
    var body: some View {
        Group {
            if (questions.isEmpty) {
                Form {
                    Section(header: Text("Multiplication table")) {
                        Stepper(value: $table, in: 1...12) {
                            Text(String(table))
                        }
                    }
                    
                    Section(header: Text("Question amount")) {
                        Picker(selection: $amount, label: Text("Question amount")) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("20").tag(20)
                            Text("All").tag(-1)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        Text(String(amount))
                    }
                    
                    Button("Start game", action: {
                        generateQuestions(withTable: table, withAmount: amount)
                    })
                }
            } else {
                List {
                    ForEach(questions) { question in
                        Text("\(question.title) = \(question.answer)")
                    }
                }
            }
        }
    }
    
    private func generateQuestions(withTable table: Int, withAmount amount: Int) -> Void {
        questions = (1...table).reduce([Question](), { acc, value in
            let subQuestions: [Question] = (1...10).map { Question(title: "\(value) x \($0)", answer: value * $0) }
            
            print(subQuestions)
            
            return acc + subQuestions
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
