@testable import QuizEngine
import XCTest
class FlowTest: XCTestCase {
    let router = RouterSpy()
    override func setUp() {}

    override func tearDown() {}

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestions_RoutesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestions_RoutesToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }

    func test_start_withTwoQuestions_RoutesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_RoutesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFistAndSecondQuestion_withThreeQuestions_RoutesToSecondAndThridQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.aswerCallback("A1")
        router.aswerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFistQuestion_withOneQuestion_doesNotRoutesToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.aswerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withNoQuestions_routeToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult, [:])
    }

    func test_startAndAnswerFistQuestion_withOneQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.aswerCallback("A1")
        XCTAssertEqual(router.routedResult!, ["Q1": "A1"])
    }

    func test_startAndAnswerFistAndSecondQuestion_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.aswerCallback("A1")
        router.aswerCallback("A2")
        XCTAssertEqual(router.routedResult!, ["Q1": "A1", "Q2": "A2"])
    }

    // MARK: Helpers

    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: [String: String]?
        var aswerCallback: Router.AnswerCallback = { _ in }

        func routeTo(question: String, aswerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.aswerCallback = aswerCallback
        }

        func routeTo(result: [String: String]) {
            routedResult = result
        }
    }
}
