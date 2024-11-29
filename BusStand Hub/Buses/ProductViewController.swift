//
//  ProductViewController.swift
//  POS
//
//  Created by Maaz on 09/10/2024.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var AddbusesBtn: UIButton!

    @IBOutlet weak var MianView: UIView!

    @IBOutlet weak var noDataLabel: UILabel!  // Add this outlet for the label

    var Bus_Detail: [Bus] = []
    var currency = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientToButtonTwo(view: MianView)
        applyGradientToButtonTwo(view: AddbusesBtn)
        applyCornerRadiusToBottomCorners(view: MianView, cornerRadius: 35)
        currency = UserDefaults.standard.value(forKey: "currencyISoCode") as? String ?? "$"
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
                
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       

        if let savedData = UserDefaults.standard.array(forKey: "BusesDetails") as? [Data] {
            let decoder = JSONDecoder()
            Bus_Detail = savedData.compactMap { data in
                do {
                    let productsData = try decoder.decode(Bus.self, from: data)
                    return productsData
                } catch {
                    print("Error decoding product: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "There is no data available" // Set the message
        // Show or hide the table view and label based on data availability
               if Bus_Detail.isEmpty {
                   CollectionView.isHidden = true
                   noDataLabel.isHidden = false  // Show the label when there's no data
               } else {
                   CollectionView.isHidden = false
                   noDataLabel.isHidden = true   // Hide the label when data is available
               }
        print(Bus_Detail)  // Check if data is loaded
        CollectionView.reloadData()
    }

  
    
    @IBAction func AddProductButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension ProductViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Bus_Detail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productsCell", for: indexPath) as! productsCollectionViewCell
        
        let BusData = Bus_Detail[indexPath.item]
        cell.productNameLabel.text = BusData.name
        cell.productQunatityLabel.text = "\(BusData.currentPlace) -"
        cell.DestinationPlace.text = BusData.destination
        cell.productPriceLabel.text = "Fair: \(currency) \(BusData.routeFair)"
        cell.DepartedTiming.text = "Departed Timing: \(BusData.starttiming)"

        
        cell.SellButton.tag = indexPath.row // Set tag to identify the row
        cell.SellButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        cell.updateButton.tag = indexPath.row // Set tag to identify the row
        cell.updateButton.addTarget(self, action: #selector(buttonTappedUpdate(_:)), for: .touchUpInside)
        
        // Set up delete action for the DeleteButton
         cell.deleteAction = { [weak self] in
             self?.confirmDelete(at: indexPath)
         }
        return cell
        
    }
    func confirmDelete(at indexPath: IndexPath) {
        // Show alert to confirm deletion
        let alert = UIAlertController(title: "Delete Product", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Remove product from array
            self.Bus_Detail.remove(at: indexPath.item)
            
            // Update UserDefaults with new product array
            let encoder = JSONEncoder()
            let savedData = self.Bus_Detail.compactMap { try? encoder.encode($0) }
            UserDefaults.standard.set(savedData, forKey: "BusesDetails")
            
            // Reload collection view
            self.CollectionView.reloadData()
            
            // Update visibility of noDataLabel
            self.noDataLabel.isHidden = !self.Bus_Detail.isEmpty
        }))
        
        present(alert, animated: true, completion: nil)
    }
    @objc func buttonTappedUpdate(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let busData = Bus_Detail[sender.tag]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        newViewController.selectedBusDetail = busData
        newViewController.selectedIndex = sender.tag // Pass the index for updating
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    @objc func buttonTapped(_ sender: UIButton) {
        
        let rowIndex = sender.tag
        print("Button tapped in row \(rowIndex)")
        let userData = Bus_Detail[sender.tag]
     //   let id = emp_Detail[sender.tag].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CreateBookingViewController") as! CreateBookingViewController
        newViewController.selectedOrderDetail = userData
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
 
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionViewWidth = collectionView.bounds.width
//        let spacing: CGFloat = 10
//        let availableWidth = collectionViewWidth - (spacing * 3)
//        let width = availableWidth / 1
//        return CGSize(width: width + 3, height: width + 1)
         return CGSize(width: CollectionView.frame.size.width , height: CollectionView.frame.size.height/5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5) // Adjust as needed
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if indexPath.row == 0
//        {
            //                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReligiousViewController") as! ReligiousViewController
            //                newViewController.isFromHomeName = titleList[indexPath.row]
            //                newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //                newViewController.modalTransitionStyle = .crossDissolve
            //                self.present(newViewController, animated: true, completion: nil)
      //  }}
    }

