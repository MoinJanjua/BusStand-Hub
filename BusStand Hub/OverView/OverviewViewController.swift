//
//  OverviewViewController.swift
//  ShareWise Ease
//
//  Created by Maaz on 16/10/2024.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var MianView: UIView!
    @IBOutlet weak var detailMianView2: UIView!
    @IBOutlet weak var detailMianView1: UIView!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var todaySalesAmount: UILabel!
    @IBOutlet weak var totalSalesAmount: UILabel!
    
    var Booking_Detail: [Booking] = [] // This contains all the orders
//    var filteredOrders: [AllSales] = [] // This will contain the filtered orders
//    var lineChartView: LineChartView!
    
    var currency = String()
    var noDataLabel: UILabel! // Add a label to show "No data available"
    
    var type = [String]()
    var Imgs: [UIImage] = [UIImage(named: "buses")!,
        UIImage(named: "routes")!
                           ,UIImage(named: "booking")!,UIImage(named: "history")!,
                           UIImage(named: "settings")!]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = ["Buses","Routes","Manul Booking","History","Settings"]
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        addBottomCurveforView(view: MianView)
        applyGradientToButtonTwo(view: MianView)
        addDropShadow(to: detailMianView2)
        ForDetailViews(view: detailMianView2)
        addDropShadow(to: detailMianView1)
        ForDetailViews(view: detailMianView1)
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"

        // Load data from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "BookingDetails") as? [Data] {
            let decoder = JSONDecoder()
            Booking_Detail = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(Booking.self, from: data)
                    return order
                } catch {
                    print("Error decoding order: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        // Calculate sales amounts
        calculateSalesAmounts()
        
    }
    private func applyGradientToButtonTwo(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                UIColor(hex: "#e00056").cgColor, // Purple
                UIColor(hex: "#c80048").cgColor, // Bright Purple
                UIColor(hex: "#ab0037").cgColor, // Violet
                UIColor(hex: "#8a0022").cgColor
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = view.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = view.layer.cornerRadius
            
            // Add the gradient to the button
        view.layer.insertSublayer(gradientLayer, at: 0)
        }
    private func ForDetailViews(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                UIColor(hex: "#fac35e").cgColor, // Purple
                UIColor(hex: "#e1ad71").cgColor, // Bright Purple
                UIColor(hex: "#c89a83").cgColor, // Violet
                UIColor(hex: "#b48992").cgColor
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = view.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = view.layer.cornerRadius
            
            // Add the gradient to the button
        view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
  private  func addBottomCurveforView(view: UIView, curveHeight: CGFloat = 80) {
          // Define the size of the view
          let viewBounds = view.bounds
          
          // Create a bezier path with a curved bottom
          let path = UIBezierPath()
          path.move(to: CGPoint(x: 0, y: 0))
          path.addLine(to: CGPoint(x: viewBounds.width, y: 0))
          path.addLine(to: CGPoint(x: viewBounds.width, y: viewBounds.height - curveHeight)) // Adjust height for curve
          path.addQuadCurve(to: CGPoint(x: 0, y: viewBounds.height - curveHeight), controlPoint: CGPoint(x: viewBounds.width / 2, y: viewBounds.height)) // Control point for curve
          path.close()
          
          // Create a shape layer mask
          let maskLayer = CAShapeLayer()
          maskLayer.path = path.cgPath
          
          // Apply the mask to the view
          view.layer.mask = maskLayer
      }

    func calculateSalesAmounts() {
        let today = Date()
        let calendar = Calendar.current
        
        // Format today's date to compare with order dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let todayString = dateFormatter.string(from: today)
        
        var totalSales: Double = 0.0
        var todaySales: Double = 0.0
        
        // Loop through all orders to calculate the total sales and today's sales
        for order in Booking_Detail {
            // Convert amount to Double (assuming it's a valid number)
            if let amount = Double(order.payment) {
                // Add to total sales
                totalSales += amount
                
                // Convert order.dateofday (String) to Date
                if let orderDate = dateFormatter.date(from: order.dateofday) {
                    // Check if the order date is today
                    let orderDateString = dateFormatter.string(from: orderDate)
                    if orderDateString == todayString {
                        todaySales += amount
                    }
                } else {
                    print("Invalid date format in order.dateofday: \(order.dateofday)")
                }
            }
        }
        
        // Update labels with the calculated values
        totalSalesAmount.text = String(format: "\(currency)%.2f", totalSales)
        todaySalesAmount.text = String(format: "\(currency)%.2f", todaySales)
    }

    
    @IBAction func ViewAllSalesbutton(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewSalesViewController") as! ViewSalesViewController
//        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        newViewController.modalTransitionStyle = .crossDissolve
//        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func CurrenctButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CurrencyViewController") as! CurrencyViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
extension OverviewViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HCollectionViewCell
    
        cell.Label.text = type [indexPath.item]
        cell.images.image? =  Imgs [indexPath.item]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width + 3, height: width + 14)
      // return CGSize(width: wallpaperCollectionView.frame.size.width , height: wallpaperCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0
            {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                          let newViewController = storyBoard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                          newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                          newViewController.modalTransitionStyle = .crossDissolve
                          self.present(newViewController, animated: true, completion: nil)
        }
        
        if indexPath.row == 1
        {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "RoutesViewController") as! RoutesViewController
          
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
          
        }
        
        if indexPath.row == 2
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                          let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateBookingViewController") as! CreateBookingViewController
                          newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                          newViewController.modalTransitionStyle = .crossDissolve
                          self.present(newViewController, animated: true, completion: nil)
            
               
        }
        
        if indexPath.row == 3
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
           self.present(newViewController, animated: true, completion: nil)

        }
        if indexPath.row == 4
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
           self.present(newViewController, animated: true, completion: nil)

        }
  
    }
}
