import SwiftUI

struct ContentView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var busVM: BusViewModel
    @State private var showingEditor = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Button("編輯課表") { showingEditor.toggle() }
                    Spacer()
                    Button("排今日下課提醒") { scheduleVM.scheduleLocalNotificationForLastClass() }
                }
                .padding()

                Button("立即查詢公車") { busVM.fetchAll() }
                    .padding(.bottom)

                List {
                    ForEach(busVM.results.sorted(by: { $0.key < $1.key }), id: \.key) { k, v in
                        HStack {
                            Text(k)
                            Spacer()
                            Text("\(v) 分鐘")
                        }
                    }
                }

                if let best = busVM.bestRoute() {
                    Text("建議：\(best.0)（約 \(best.1) 分鐘）")
                        .font(.headline)
                        .foregroundColor(.green)
                }

                Spacer()
            }
            .navigationTitle("TKU Bus Helper")
            .sheet(isPresented: $showingEditor) { ScheduleEditorView() }
        }
    }
}
