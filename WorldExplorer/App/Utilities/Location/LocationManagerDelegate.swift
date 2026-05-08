//
//  LocationManagerDelegate.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

protocol LocationManagerDelegate: AnyObject {
    
    func didGetLocation(country: String)
}
