//
//  PopDatePickerViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 12/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FSCalendar

class PopupDateViewController: UIViewController {
    
    let formatter = DateFormatter()
    var firstDay: Date?
    var lastDay: Date?
    var selectedRange: [Date]?
    var signleItemDateDelegate: signleItemDateDelegate?
    var uploadDelegate: uploadModalDelegate?
    @IBOutlet weak var startDayLbl: UILabel!
    @IBOutlet weak var endDayLbl: UILabel!
    
    @IBOutlet weak var headerView: customUIView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    
    @IBOutlet weak var selectBtn: CustomBtn!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        formatter.dateFormat = "yyyy MMM dd"
        headerView.setGradientBackground(colorOne: UIColor(red: 8.0/255.0, green: 74.0/255.0, blue: 196.0/255.0, alpha: 1.0),colorTwo: UIColor(red: 84.0/255.0, green: 144.0/255.0, blue: 248.0/255.0, alpha: 1.0))
        
        calendarConfig()
        selectBtn.setBtnStyle()
      
        
    }
    
    func calendarConfig(){
        
        
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.allowsMultipleSelection = true
        
        calendarView.calendarHeaderView.backgroundColor = UIColor(displayP3Red: 235.0/255, green: 235.0/255, blue: 234.0/255, alpha: 1)
        
        
    }
    func customButton(){
        selectBtn.layer.cornerRadius = 10
        selectBtn.layer.masksToBounds = true
        selectBtn.setGradient(colorOne: UIColor(red: 8.0/255.0, green: 74.0/255.0, blue: 196.0/255.0, alpha: 1.0),colorTwo: UIColor(red: 84.0/255.0, green: 144.0/255.0, blue: 248.0/255.0, alpha: 1.0))
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    @IBAction func selectBtnTapped(_ sender: Any) {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy"
        
        if firstDay == nil{
            signleItemDateDelegate?.getDayValue(startDay: "", endDay: "", dateRange: [Date]())
            uploadDelegate?.getDayValue(startDay: "", endDay: "", dateRange: [Date]())
        }else if firstDay != nil && lastDay == nil{
            
            signleItemDateDelegate?.getDayValue(startDay: dateFormater.string(from: firstDay!), endDay: dateFormater.string(from: firstDay!),dateRange: selectedRange!)
            uploadDelegate?.getDayValue(startDay: dateFormater.string(from: firstDay!), endDay: dateFormater.string(from: firstDay!),dateRange: selectedRange!)
        }else{
            signleItemDateDelegate?.getDayValue(startDay: dateFormater.string(from: firstDay!), endDay: dateFormater.string(from: lastDay!),dateRange: selectedRange!)
            uploadDelegate?.getDayValue(startDay: dateFormater.string(from: firstDay!), endDay: dateFormater.string(from: lastDay!),dateRange: selectedRange!)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension PopupDateViewController: FSCalendarDelegate, FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if date < calendar.today ?? Date(){
            return false
            
        }else{
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if firstDay == nil{
            firstDay = date
            selectedRange = [firstDay!]
            print("the rang is \(selectedRange!)")
            startDayLbl?.text = formatter.string(from: firstDay!)
            endDayLbl?.text = formatter.string(from: firstDay!)
            
            
            
            return
        }else if(firstDay != nil && lastDay == nil){
            if date <= firstDay!{
                calendar.deselect(firstDay!)
                firstDay = date
                selectedRange = [firstDay!]
                print("the rang is \(selectedRange!)")
                startDayLbl?.text = formatter.string(from: firstDay!)
                endDayLbl?.text = formatter.string(from: firstDay!)
                
                
            }
            
            let range = datesRange(from: firstDay!, to: date)
            
            lastDay = range.last
            
            for d in range{
                calendar.select(d)
            }
            
            selectedRange = range
            print("the rang is \(selectedRange!)")
            startDayLbl?.text = formatter.string(from: firstDay!)
            endDayLbl?.text = formatter.string(from: lastDay!)
            
            
        }else if(firstDay != nil && lastDay != nil){
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            firstDay = nil
            lastDay = nil
            selectedRange = []
            print("the rang is \(selectedRange!)")
            startDayLbl?.text = ""
            endDayLbl?.text = ""
            
        }
        
        
        
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDay != nil && lastDay == nil{
            calendar.deselect(date)
            firstDay = nil
            lastDay = nil
            selectedRange = []
            startDayLbl?.text = ""
            endDayLbl?.text = ""
            
            print("the rang is \(selectedRange!)")
           
        }else if (firstDay != nil && lastDay != nil){
            for d in calendar.selectedDates{
                calendar.deselect(d)
            }
            
            firstDay = nil
            lastDay = nil
            selectedRange = []
            startDayLbl?.text = ""
            endDayLbl?.text = ""
            
            print("the rang is \(selectedRange!)")
            
        }
        
    }
    
    
    
    
}






