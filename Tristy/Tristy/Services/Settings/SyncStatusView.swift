//
//  SyncStatusView.swift
//  Tristy
//
//  Created by Frank Anderson on 6/13/25.
//

import CloudKitSyncMonitor
import SwiftUI

struct SyncStatusView: View {
    
    @StateObject private var syncMonitor = SyncMonitor.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(
                title: {
                    Text(syncMonitor.syncStateSummary.description)
                },
                icon: {
                    Image(systemName: syncMonitor.syncStateSummary.symbolName)
                        .foregroundColor(syncMonitor.syncStateSummary.symbolColor)
                }
            )
            
            if syncMonitor.syncStateSummary == .notStarted {
                Text("Sync occurs when the app is closed, so a status of **\"\(SyncMonitor.SyncSummaryStatus.notStarted.description)\"** may not reflect an issue requiring intervention.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        SyncStatusView()
    }
}
