//
//  UtilityViews.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-02.
//

import SwiftUI



struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}
//
//struct UtilityViews_Previews: PreviewProvider {
//    static var previews: some View {
//        UtilityViews()
//    }
//}
