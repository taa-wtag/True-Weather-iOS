import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!

    var viewModel: WeatherViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewModelFactory.initViewModel(for: self)
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        cityCollectionView
            .register(
                UINib(nibName: Constants.CellIdentifiers.CityPage, bundle: nil),
                forCellWithReuseIdentifier: Constants.CellIdentifiers.CityPage
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.HeaderTableView, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.HeaderTableView
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.CollectionViewInTableView, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.CollectionViewInTableView
            )
        weatherTableView
            .register(
                UINib(nibName: Constants.CellIdentifiers.DailyWeather, bundle: nil),
                forCellReuseIdentifier: Constants.CellIdentifiers.DailyWeather
            )
        let maxHeight = cityCollectionView.heightAnchor.constraint(equalToConstant: cityPageHeight + 20.0)
        maxHeight.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAllCities()
    }

    @IBAction func getLocationButtonAction(_ sender: UIBarButtonItem) {
        viewModel?.getCurrentLocation()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ViewModelFactory.initViewModel(for: segue.destination)
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellIndex = cityCollectionView.scrollToNearestVisibleCollectionViewCell()
        if cellIndex != -1 {
            viewModel?.currentCity = viewModel?.cityList[cellIndex]
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let cellIndex = cityCollectionView.scrollToNearestVisibleCollectionViewCell()
            if cellIndex != -1 {
                viewModel?.currentCity = viewModel?.cityList[cellIndex]
            }
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.cityList.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: Constants.CellIdentifiers.CityPage,
                for: indexPath
            )
        cell.layer.cornerRadius = cityPageCornerRadius
        if let city = viewModel?.cityList[indexPath.row] {
            (cell as? CityPageCell)?.configure(
                with: city,
                weather: WeatherUtil.getCurrentWeather(from: city.weatherEveryHour) ?? HourlyWeatherItem()
            )
        }
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cityPageWidth, height: cityPageHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10.0, left: cityPageInsetSide, bottom: 10.0, right: cityPageInsetSide)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cityPageInterimSpacing
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return hourlyCollectionHeight
        default:
            return UITableView.automaticDimension
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewModel?.dailyWeatherList.count ?? 0) + 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 2:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.HeaderTableView,
                    for: indexPath
                )
            (cell as? HeaderTableViewCell)?
                .configure(text: indexPath.row == 0 ? "Today" : "Next \(Constants.Weather.ForecastMaxDays - 1) Days")
            return cell
        case 1:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.CollectionViewInTableView,
                    for: indexPath
                )
            (cell as? CollectionViewTableViewCell)?.hourlyWeatherList = viewModel?.hourlyWeatherList
            return cell
        default:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.CellIdentifiers.DailyWeather,
                    for: indexPath
                )
            (cell as? DailyWeatherCell)?.configure(
                weather: viewModel?.dailyWeatherList[indexPath.row-3] ?? DailyWeatherItem()
            )
            return cell
        }
    }
}

extension UICollectionView {
   func scrollToNearestVisibleCollectionViewCell() -> Int {
       self.decelerationRate = UIScrollView.DecelerationRate.fast
       let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
       var closestCellIndex = -1
       var closestDistance: Float = .greatestFiniteMagnitude
       for index in 0..<self.visibleCells.count {
           let cell = self.visibleCells[index]
           let cellWidth = cell.bounds.size.width
           let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

           // Now calculate closest cell
           let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
           if distance < closestDistance {
               closestDistance = distance
               closestCellIndex = self.indexPath(for: cell)!.row
           }
       }
       if closestCellIndex != -1 {
           self.scrollToItem(
            at: IndexPath(row: closestCellIndex, section: 0),
            at: .centeredHorizontally, animated: true
           )
       }
       return closestCellIndex
   }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateCurrentWeather() {
        cityCollectionView.reloadData()
    }

    func didUpdateForecastWeather() {
        weatherTableView.reloadData()
        reloadHourlyWeatherCollectionView()
    }

    func didFinishLoadingCities() {
        cityCollectionView.reloadData()
    }

    func didUpdateCurrentCity() {
        cityCollectionView.reloadData()
        weatherTableView.reloadData()
        reloadHourlyWeatherCollectionView()
    }

    func reloadHourlyWeatherCollectionView() {
        (weatherTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CollectionViewTableViewCell)?
            .hourCollectionView.reloadData()
    }
}

extension WeatherViewController {

    private var cityPageCornerRadius: CGFloat {
        return floor(18 * Constants.sizeMagnifier)
    }

    private var cityPageWidth: CGFloat {
        return floor(330 * Constants.sizeMagnifier)
    }

    private var cityPageHeight: CGFloat {
        return floor(200 * Constants.sizeMagnifier)
    }

    private var cityPageInsetSide: CGFloat {
        return floor(22.5 * Constants.sizeMagnifier)
    }

    private var cityPageInterimSpacing: CGFloat {
        return cityPageInsetSide * 2
    }

    private var hourlyCollectionHeight: CGFloat {
        return floor(120 * Constants.sizeMagnifier)
    }
}
