//
//  ChangeAppIconView.swift
//  Tristy
//
//  Created by Frank Anderson on 5/7/24.
//

#if os(iOS)
import SwiftUI
import UIKit

struct ChangeAppIconView: View {
    @StateObject var viewModel = ChangeAppIconViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(AppIcon.allCases) { appIcon in
                        HStack(spacing: 16) {
                            Image(uiImage: appIcon.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                            Text(appIcon.description)
                                .font(.system(.headline, design: .rounded, weight: .regular))
                            Spacer()
                            Image(systemName: viewModel.selectedAppIcon == appIcon ? "checkmark.circle.fill" : "checkmark.circle")
                                .imageScale(.large)
                                .foregroundStyle(viewModel.selectedAppIcon == appIcon ? Color.mint : Color.accentColor)
                        }
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        #if os(iOS)
                        .background(Color.secondaryBackground)
                        #endif
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                viewModel.updateAppIcon(to: appIcon)
                            }
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct ChangeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAppIconView()
    }
}

#endif
