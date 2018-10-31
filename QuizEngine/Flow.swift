import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, aswerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]

    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, aswerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }

    private func nextCallback(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            if let strongSelf = self {
                strongSelf.routeNext(question, answer)
            }
        }
    }
    
    private func routeNext(_ question: String,_ answer: String) {
        if let currentQuestionIndex = questions.index(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, aswerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result:result)
            }
        }
    }
}
