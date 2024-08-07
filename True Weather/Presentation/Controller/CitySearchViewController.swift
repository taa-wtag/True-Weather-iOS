import UIKit

class CitySearchViewController: UITableViewController {

    var cityArray: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let cityService = CityService.shared
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.SearchCity, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cityArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cityArray[indexPath.row])
        self.dismiss(animated: true)
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            cityService.searchForPlaces(with: text) { [weak self] error, response in
                if let suggestions = response, error == nil {
                    self?.cityArray = suggestions.toCityList()
                }
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}
