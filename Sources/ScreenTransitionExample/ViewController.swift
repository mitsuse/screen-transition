import UIKit

import ScreenTransition

final class ViewController: UITableViewController {
    private var items: [Example]!

    override func loadView() {
        super.loadView()
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        title = "Example"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        items = [
            Example(title: "Segue - Modal (Bottom)", transition: .segue("show_modal_bottom")),
            Example(title: "Segue - Drawer (Left)", transition: .segue("show_drawer_left")),
            Example(title: "Segue - Drawer (Right)", transition: .segue("show_drawer_right")),
            Example(title: "Presenter - Modal (Bottom)", transition: .presenter(screenTransition.presenter(with: BottomModalConfiguration(), for: storyboard))),
            Example(title: "Presenter - Drawer (Left)", transition: .presenter(screenTransition.presenter(with: DrawerConfiguration(position: .left, offset: 60), for: storyboard))),
            Example(title: "Presenter - Drawer (right)", transition: .presenter(screenTransition.presenter(with: DrawerConfiguration(position: .right, offset: 60), for: storyboard))),
        ]
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].transition {
        case let .segue(segue): performSegue(withIdentifier: segue, sender: nil)
        case let .presenter(presenter): presenter.present()
        }
    }
}
