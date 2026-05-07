//
//  LocationManagerProtocol.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

protocol LocationManagerProtocol: AnyObject {
    
    var delegate: LocationManagerDelegate? { get set }
    func requestLocation()
}
