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
            router.routeTo(question: firstQuestion, aswerCallback: routeNext(from: firstQuestion))
        } else {
            router.routeTo(result: result)
        }
    }

    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            guard let strongSelf = self else { return }
            if let currentQuestionIndex = strongSelf.questions.index(of: question) {
                strongSelf.result[question] = answer
                if currentQuestionIndex + 1 < strongSelf.questions.count {
                    let nextQuestion = strongSelf.questions[currentQuestionIndex + 1]
                    strongSelf.router.routeTo(question: nextQuestion, aswerCallback: strongSelf.routeNext(from: nextQuestion))
                } else {
                    strongSelf.router.routeTo(result: strongSelf.result)
                }
            }
        }
    }
}
