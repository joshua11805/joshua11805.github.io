//
//  maxGridConstraint.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/4/24.
//

//this will bind the grid assignments to between 0 and 13
//essentially a useless propertyWrapper as of right now
//originally wrote this when I had my plant's structured differently.
@propertyWrapper
struct maxGridConstraint {
    private var value: Int?
    private var maxGrids: Int
    
    init(maxGrids: Int) {
        self.maxGrids = maxGrids
        self.value = nil
    }
    
    var wrappedValue: Int? {
        get { value }
        set {
            if let newValue = newValue {
                value = min(max(newValue, 0), maxGrids)
            } else {
                value = nil
            }
        }
    }
}
