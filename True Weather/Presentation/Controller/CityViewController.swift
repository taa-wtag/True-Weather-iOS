import UIKit

class CityViewController: UICollectionViewController {
    private let reuseIdentifier = Constants.CellIdentifiers.CityItem

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
        return 20
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
        cell.layer.cornerRadius = cellCornerRadius
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        UIEdgeInsets(top: topInsets, left: sideInsets, bottom: topInsets, right: sideInsets)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        sideInsets
    }
}

extension CityViewController {
    private var cellHeight: CGFloat {
        return 198 * Constants.sizeMagnifier
    }

    private var cellWidth: CGFloat {
        return 162 * Constants.sizeMagnifier
    }

    private var topInsets: CGFloat {
        return 20 * Constants.sizeMagnifier
    }

    private var sideInsets: CGFloat {
        return 17 * Constants.sizeMagnifier
    }

    private var cellCornerRadius: CGFloat {
        return 15 * Constants.sizeMagnifier
    }

    private var sheetCornerRadius: CGFloat {
        return 20 * Constants.sizeMagnifier
    }
}
