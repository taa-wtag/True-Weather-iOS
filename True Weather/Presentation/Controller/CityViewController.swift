import UIKit

class CityViewController: UICollectionViewController {
    private let reuseIdentifier = Constants.CellIdentifiers.CityItem

    var itemArray = [true, true, true, true, true, true, true, true,
                     true, true, true, true, true, true, true, true,
                     true, true, true, true, true, true, true, true]

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
        return itemArray.count
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
        (cell as? CityItemCell)?.delegate = self
        (cell as? CityItemCell)?.isDeleteButtonHidden = itemArray[indexPath.row]
        (cell as? CityItemCell)?.deleteThisCell = { [weak self] in
            self?.itemArray.remove(at: indexPath.row)
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
        if let isHidden = flag {
            for index in 0...itemArray.count-1 {
                itemArray[index] = isHidden
            }
        } else {
            for index in 0...itemArray.count-1 {
                itemArray[index] = !itemArray[index]
            }
        }
        collectionView.reloadData()
    }
}

extension CityViewController {
    private var cellHeight: CGFloat {
        return 215 * Constants.sizeMagnifier
    }

    private var cellWidth: CGFloat {
        return 179 * Constants.sizeMagnifier
    }

    private var topInset: CGFloat {
        return 3 * Constants.sizeMagnifier
    }

    private var bottomInset: CGFloat {
        return 20 * Constants.sizeMagnifier
    }

    private var sideInsets: CGFloat {
        return 17 * Constants.sizeMagnifier
    }

    private var sheetCornerRadius: CGFloat {
        return 20 * Constants.sizeMagnifier
    }
}
