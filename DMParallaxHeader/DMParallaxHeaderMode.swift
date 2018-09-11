//
//  DMParallaxHeaderMode.swift
//  DMParallaxHeader
//
//  Created by Dominic on 9/10/18.
//  Copyright © 2018 DominicMiller. All rights reserved.
//

import Foundation

public enum DMParallaxHeaderMode: Int {
    /// The option to scale the content to fill the size of the header. Some portion of the content may be clipped to fill the header’s bounds.
    case fill = 0
    
    /// The option to scale the content to fill the size of the header and aligned at the top in the header's bounds.
    case topFill
    
    /// The option to center the content aligned at the top in the header's bounds.
    case top
    
    /// The option to center the content in the header’s bounds, keeping the proportions the same.
    case center
    
    /// The option to center the content aligned at the bottom in the header’s bounds.
    case bottom
}
