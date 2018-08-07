//
//  SearchViewController.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import LocationPicker
import AirbnbDatePicker
import MBProgressHUD
import EmptyDataSet_Swift

class SearchViewController: UIViewController {
    
    // View UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchParamsContainerView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    @IBOutlet weak var sortFilterContainerView: UIView!
    @IBOutlet weak var sortFilterContainerViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var sortDescriptionContainerView: UIView!
    @IBOutlet weak var sortOptionsButton: UIButton!
    @IBOutlet weak var sortDescriptionLabel: UILabel!
    
    @IBOutlet weak var filterDescriptionContainerView: UIView!
    @IBOutlet weak var filterOptionsButton: UIButton!
    @IBOutlet weak var filterDescriptionLabel: UILabel!
    
    
    // The search request is the main powerhouse of the view
    // It handles all search parameters and fetching results
    var searchRequest = RentalSearchRequest()
    
    // This array will hold the vehicle options that we're currently showing
    var searchResults = [RentalCar]()
    
    // If the most recent search request encountered an error, we'll save it here
    var errorMessage: String?
    
    // The available ordering type options
    let resultsOrderTypes = [ResultsOrderType.priceLowToHigh, ResultsOrderType.priceHighToLow, ResultsOrderType.proximity]
    
    // This array will hold available 'provider' filters that the user can choose from
    var providerFilterOptions = [RentalProvider]()
        
    // The progress indicator we'll use when loading options
    var progressHUD: MBProgressHUD?
    


    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        setupDesign()
        initialViewSetup()
    }
    
    func setupDesign()
    {
        tableView.hideEmptyCells()
        searchParamsContainerView.setBorder(thickness: 1.2, color: UIColor.black, radius: 2.0)
    }
    
    func initialViewSetup()
    {
        view.addSubview(orderTypeTextField)
        view.addSubview(providerFilterTextField)
        updateLocationLabel()
        updateDateRangeLabel()
        updateOrderTypeLabel()
        updateProviderFilterLabel()
        setSortFilterDisplayState()
    }
    
    
    // MARK: - Search Location
    
    @IBAction func didRequestToEditLocation(_ sender: Any) {
        presentLocationPicker()
    }
    
    func presentLocationPicker()
    {
        let locationPicker = LocationPickerViewController()
        
        // Set the starting location if we have one
        var placemark: CLPlacemark?
        if let centerPoint = searchRequest.centerPoint {
            placemark = centerPoint
        } else if let currentPlacemark = UserLocationManager.sharedInstance.usersCurrentPlacemark() {
            placemark = currentPlacemark
        }
        
        if let placemark = placemark {
            locationPicker.location = Location(name: placemark.name, location: placemark.location, placemark: placemark)
        }
        
        locationPicker.showCurrentLocationButton = true
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .mutedStandard
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.searchBarPlaceholder = "Search Location"
        locationPicker.searchHistoryLabel = "Previous Locations"
        locationPicker.resultRegionDistance = 600
        
        locationPicker.completion = { location in
            if let location = location {
                self.updateSearchCenterToPlacemark(location.placemark)
            }
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    func updateSearchCenterToPlacemark(_ placemark: CLPlacemark )
    {
        searchRequest.centerPoint = placemark
        updateLocationLabel()
        didEditSearchParameter()
    }
    
    func updateLocationLabel()
    {
        if let location = searchRequest.centerPoint {
            locationLabel.text = location.briefDescription()
        } else {
            locationLabel.text = "Set Search Location"
        }
    }
    
    
    // MARK: - Search Date Range
    
    @IBAction func didRequestToEditDateRange(_ sender: Any)
    {
        presentDateRangePicker()
    }
    
    private lazy var datePickerTheme: ThemeManager = {
        var theme = ThemeManager()
        theme.mainColor = UIColor(red: 241/255, green: 107/255, blue: 111/255, alpha: 1)
        return theme
    }()
    
    func presentDateRangePicker()
    {
        AirbnbDatePicker.ThemeManager.current = datePickerTheme
        
        // By default, we'll show 1 year
        let dateInterval = DateInterval(start: Date(), duration: 86400*365)
        
        // If the user has set the pickup and dropoff dates already show them now
        var selectedDateInterval: DateInterval?
        if let interval = currentDateInterval() {
            selectedDateInterval = interval
        }
        
        dp.presentDatePickerViewController(dateInterval: dateInterval, selectedDateInterval: selectedDateInterval, delegate: self)
    }
    
    func updateDateRangeWithInterval(_ interval: DateInterval)
    {
        searchRequest.pickUpDate = interval.start
        searchRequest.dropOffDate = interval.end
        updateDateRangeLabel()
        didEditSearchParameter()
    }
    
    func updateDateRangeLabel()
    {
        if let interval = currentDateInterval() {
            dateRangeLabel.text = interval.asShortStyleMonthAndDayString()
        } else {
            dateRangeLabel.text = "Set Dates"
        }
    }
    
    func currentDateInterval() -> DateInterval?
    {
        if let pickupDate = searchRequest.pickUpDate, let dropoffDate = searchRequest.dropOffDate {
            return DateInterval(start: pickupDate, end: dropoffDate)
        } else {
            return nil
        }
    }
    
    
    // MARK: - Order Type
    
    @IBAction func didRequestToEditSortType(_ sender: Any)
    {
        presentOrderTypePicker()
    }
    
    func presentOrderTypePicker()
    {
        orderTypeTextField.becomeFirstResponder()
    }
    
    let orderTypePickerViewTag = 1
    
    lazy var orderTypeTextField: UITextField = {
        
        let textField = UITextField(frame: CGRect.zero)
        textField.inputView = orderTypePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Set Order Type", style: .plain, target: self, action: #selector(self.didChangeOrderType(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didCancelOrderTypePicker(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        return textField
    }()
    
    lazy var orderTypePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = orderTypePickerViewTag
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    @objc func didChangeOrderType(_ picker: UIPickerView)
    {
        orderTypeTextField.resignFirstResponder()
        let newOrderType = resultsOrderTypes[orderTypePickerView.selectedRow(inComponent: 0)]
        if newOrderType != searchRequest.resultsOrderType {
            updateOrderType(newOrderType)
        }
    }
    
    @objc func didCancelOrderTypePicker(_ picker: UIPickerView) {
        orderTypeTextField.resignFirstResponder()
    }
    
    func updateOrderType(_ orderType: ResultsOrderType)
    {
        searchRequest.resultsOrderType = orderType
        updateOrderTypeLabel()
        didEditSearchParameter()
    }
    
    func updateOrderTypeLabel()
    {
        sortDescriptionLabel.text = friendlyDescriptionForOrderType(searchRequest.resultsOrderType)
    }
    
    
    
    // MARK: Provider Filter
    let providerFilterPickerViewTag = 2
    
    lazy var providerFilterTextField: UITextField = {
        
        let textField = UITextField(frame: CGRect.zero)
        textField.inputView = providerFilterPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Set Filter", style: .plain, target: self, action: #selector(self.didChangeProviderFilter(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didCancelProviderFilter(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        return textField
    }()
    
    lazy var providerFilterPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = providerFilterPickerViewTag
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    
    @IBAction func didRequestToEditFilter(_ sender: Any) {
        presentProviderFilterPicker()
    }
    
    func presentProviderFilterPicker()
    {
        providerFilterTextField.becomeFirstResponder()
    }
    
    @objc func didChangeProviderFilter(_ picker: UIPickerView)
    {
        providerFilterTextField.resignFirstResponder()
        let selectedIndex = providerFilterPickerView.selectedRow(inComponent: 0)
        
        if selectedIndex == 0 {
            updateProviderFilter(nil)
            return
        }
        
        let actualIndex = selectedIndex - 1
        let newFilter = providerFilterOptions[actualIndex]
        
        // If its not the same filter, update now
        guard let currentFilter = searchRequest.rentalProviderFilter, currentFilter.isSameCompanyAs(rentalProvider: newFilter) else {
            updateProviderFilter(newFilter)
            return
        }
    }
    
    @objc func didCancelProviderFilter(_ picker: UIPickerView) {
        providerFilterTextField.resignFirstResponder()
    }
    
    func updateProviderFilter(_ filter: RentalProvider?)
    {
        searchRequest.rentalProviderFilter = filter
        updateProviderFilterLabel()
        didEditSearchParameter()
    }
    
    func updateProviderFilterLabel()
    {
        if let provider = searchRequest.rentalProviderFilter {
            filterDescriptionLabel.text = provider.companyName
        } else {
            filterDescriptionLabel.text = "Filter by Company"
        }
    }
    
    
    // MARK: - Loading Data
    
    func didEditSearchParameter()
    {
        if searchRequest.isValid() {
            refreshOptions()
        }
    }
    
    func refreshOptions()
    {
        print("Load search results!")
        showLoadingView()
        
        // Clear any old errors
        errorMessage = nil
        
        searchRequest.fetchSearchResults(completion: { result in
            
            switch result {
                
            case .success(let cars):
                print("Found \(cars.count) options:")
                self.searchResults = cars
                self.providerFilterOptions = self.searchRequest.rentalProviderFilterOptions()
                
            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
                self.errorMessage = description
            }
            
            self.tableView.reloadData()
            self.scrollTableViewToTop(animated: false)
            self.setSortFilterDisplayState()
            self.hideLoadingView()
        })
    }
    
    func scrollTableViewToTop(animated: Bool)
    {
        print("Scroll to top")
        if (searchResults.count > 0) {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    
    // MARK: Loading View
    
    func showLoadingView()
    {
        tableView.alpha = 0.2
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD?.bezelView.color = UIColor(red: 10/255, green: 196/255, blue: 186/255, alpha: 1.0)
        progressHUD?.bezelView.style = MBProgressHUDBackgroundStyle.solidColor;
        progressHUD?.contentColor = UIColor.white
        progressHUD?.label.text = "Loading options..."
    }
    
    func hideLoadingView()
    {
        tableView.alpha = 1.0
        progressHUD?.hide(animated: true)
    }
    
    
    // MARK: - Show / Hide Sort and Filter
    
    let sortFilterContainerViewDefaultHeight:CGFloat = 36
    
    func setSortFilterDisplayState()
    {
        if (providerFilterOptions.count == 0) {
            filterDescriptionContainerView.isHidden = true
            filterOptionsButton.isUserInteractionEnabled = false
        } else {
            filterDescriptionContainerView.isHidden = false
            filterOptionsButton.isUserInteractionEnabled = true
        }
    }
    
    func showSortFilterSection()
    {
        sortFilterContainerView.isHidden = false
        sortFilterContainerViewHeight.constant = sortFilterContainerViewDefaultHeight
    }
    
    func hideSortFilterSection()
    {
        sortFilterContainerView.isHidden = true
        sortFilterContainerViewHeight.constant = 0
    }

    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - User Interaction


    

    

    

}


// MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! CarRentalOptionCell
        
        let car = searchResults[indexPath.row]
        cell.carImageView.image = car.representativeImage()
        cell.providerImageView.image = car.provider.companyLogo()
        cell.priceLabel.text = car.priceCurrencyString()
        cell.setFeatures(car.features())
        cell.descriptionLabel.text = "\(car.provider.companyName)"
        
        var details = "\(car.provider.streetAddress())"
        if let centerLocation = searchRequest.centerPoint?.location {
            let distance = car.provider.distanceAwayStringFrom(location: centerLocation)
             details += " - \(distance) away"
        }
        
        cell.distanceAwayLabel.text = details
        return cell
    }
    
    func presentDetailsForCar(_ car: RentalCar)
    {
        print("Present details for car: \(car)")
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let car = searchResults[indexPath.row]
        presentDetailsForCar(car)
    }
}

extension SearchViewController: AirbnbDatePickerViewControllerDelegate {
    func datePickerController(_ picker: AirbnbDatePickerViewController, didFinishPicking dateInterval: DateInterval?)
    {
        if let interval = dateInterval {
            updateDateRangeWithInterval(interval)
        }
    }
}

// MARK:- PickerView Data Source
extension SearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView.tag {
        case orderTypePickerViewTag:
            return resultsOrderTypes.count
        case providerFilterPickerViewTag:
            return providerFilterOptions.count + 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView.tag {
        case orderTypePickerViewTag:
            return friendlyDescriptionForOrderType(resultsOrderTypes[row])
        case providerFilterPickerViewTag:
            return row == 0 ? "-- None --" : providerFilterOptions[row-1].companyName
        default:
            return ""
        }
    }
    
    func friendlyDescriptionForOrderType(_ orderType: ResultsOrderType) -> String
    {
        switch orderType {
        case .proximity:
            return "Closest to me"
        case .priceLowToHigh:
            return "Price, Low to High"
        case .priceHighToLow:
            return "Price, High to Low"
        }
    }
}


// MARK: - Empty Data Set Source
extension SearchViewController: EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        var title = ""
        if !searchRequest.isValid() {
            title = "Let's Find a Car!"
        } else if errorMessage != nil {
            title = "Search Error"
        } else {
            title = "Not Results Found"
        }
        
        let atts = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
        return NSAttributedString.init(string: title, attributes: atts)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        var descrip = ""
        if !searchRequest.isValid() {
            descrip = "Choose a location and date range to begin searching."
        } else if let errorMessage = errorMessage {
            descrip = "Error: \(errorMessage)"
        } else {
            descrip = "Could not find any options for your chosen location and date range.  Please try modifying your search."
        }
        
        let atts = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString.init(string: descrip, attributes: atts)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString?
    {
        guard errorMessage != nil else {
            return nil
        }
        
        let title = "Retry"
        let atts = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]
        return NSAttributedString.init(string: title, attributes: atts)
    }
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> UIImage?
    {
        guard errorMessage != nil else {
            return nil
        }
        
        let capInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let rectInsets = UIEdgeInsets(top: -19, left: -61, bottom: -19, right: -61)
        let image = UIImage.init(named: "empty-set-btn-bg")
        return image?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets)
    }
}

// MARK: - Empty Data Set Delegate
extension SearchViewController: EmptyDataSetDelegate {
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        refreshOptions()
    }
}

