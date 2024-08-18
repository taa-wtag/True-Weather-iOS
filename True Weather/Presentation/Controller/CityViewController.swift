import UIKit

class CityViewController: UICollectionViewController {
    private let reuseIdentifier = Constants.CellIdentifiers.CityItem

    var viewModel: CityViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!
            .register(
                UINib(nibName: reuseIdentifier, bundle: nil),
                forCellWithReuseIdentifier: reuseIdentifier
            )
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cityList.count ?? 0
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
        if let cityItemCell = cell as? CityItemCell, let cityItem = viewModel?.cityList[indexPath.row] {
            cityItemCell.delegate = self
            cityItemCell.isDeleteButtonHidden = viewModel?.isDeleteButtonHidden ?? true
            cityItemCell.configure(
                with: cityItem,
                weather: viewModel?.currentWeatherList[cityItem.cityName ?? ""] ?? HourlyWeatherItem(),
                NetworkRequestService.sharedInstance
            )
            cityItemCell.deleteThisCell = { [weak self] in
                self?.viewModel?.deleteCity(at: indexPath.row)
            }
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setDeleteButtonVisibility(isHidden: true)
        if segue.identifier == Constants.Segues.ShowCitySearch,
           let citySearchVC = segue.destination as? CitySearchViewController {
            if let sheet = citySearchVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = sheetCornerRadius
            }
            ViewModelFactory.initViewModel(for: citySearchVC)
            citySearchVC.delegate = self
        }
    }
}

extension CityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: topInset, left: sideInsets, bottom: bottomInset, right: 0.0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0.0
    }
}

extension CityViewController: CityItemCellDelegate {
    func onLongPress() {
        setDeleteButtonVisibility()
    }

    func onDeleteButtonPressed() {
        setDeleteButtonVisibility(isHidden: true)
    }

    func setDeleteButtonVisibility(isHidden flag: Bool? = nil) {
        viewModel?.isDeleteButtonHidden = flag ?? !viewModel!.isDeleteButtonHidden
        collectionView.reloadData()
    }
}

extension CityViewController: CityViewModelDelegate {
    func didFinishLoadingCities() {
        collectionView.reloadData()
    }
}

extension CityViewController: CitySearchViewControllerDelegate {
    func didFinishAddingCity() {
        viewModel?.getAllCities()
    }
}

extension CityViewController {
    private var cellHeight: CGFloat {
        return floor(215 * Constants.sizeMagnifier)
    }

    private var cellWidth: CGFloat {
        return floor(179 * Constants.sizeMagnifier)
    }

    private var topInset: CGFloat {
        return floor(3 * Constants.sizeMagnifier)
    }

    private var bottomInset: CGFloat {
        return floor(20 * Constants.sizeMagnifier)
    }

    private var sideInsets: CGFloat {
        return floor(17 * Constants.sizeMagnifier)
    }

    private var sheetCornerRadius: CGFloat {
        return floor(20 * Constants.sizeMagnifier)
    }
}
