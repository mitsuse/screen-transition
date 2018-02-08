import ScreenTransition

struct Example {
    let title: String
    let transition: Transition

    init(title: String, transition: Transition) {
        self.title = title
        self.transition = transition
    }
}

enum Transition {
    case presenter(Presenter)
    case segue(String)
}
