import UIKit
protocol CitySearchViewControllerDelegate: AnyObject {
    func didFinishAddingCity()
}

class CitySearchViewController: UITableViewController {
    var viewModel: CitySearchViewModel?

    weak var delegate: CitySearchViewControllerDelegate?

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cityArray.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.SearchCity, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel?.cityArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.addCity(withIndex: indexPath.row)
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            viewModel?.searchForCities(with: text)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}

extension CitySearchViewController: CitySearchViewModelDelegate {
    func didFinishLoading() {
        tableView.reloadData()
    }

    func didFinishAddingCity() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didFinishAddingCity()
        }
    }
}
