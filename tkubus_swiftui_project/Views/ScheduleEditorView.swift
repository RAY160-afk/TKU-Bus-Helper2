import SwiftUI

struct ScheduleEditorView: View {
    @EnvironmentObject var vm: ScheduleViewModel
    @Environment(\.presentationMode) var dismiss
    @State private var text: String = ""

    func loadText() {
        var lines: [String] = []
        for s in vm.schedules {
            let p = s.periods.map(String.init).joined(separator: ",")
            lines.append("\(s.weekday):\(p)")
        }
        text = lines.joined(separator: "\n")
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("輸入格式： 每行 weekday:comma-separated-periods  (weekday 1=Mon .. 7=Sun)")
                    .font(.caption)
                    .padding()
                TextEditor(text: $text)
                    .font(.body)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("課表編輯", displayMode: .inline)
            .navigationBarItems(leading: Button("取消") { dismiss.wrappedValue.dismiss() }, trailing: Button("儲存") {
                var arr: [ClassSchedule] = []
                for line in text.split(separator: "\n") {
                    let s = line.trimmingCharacters(in: .whitespaces)
                    if s.isEmpty { continue }
                    let parts = s.split(separator: ":", maxSplits: 1)
                    if parts.count != 2 { continue }
                    if let wd = Int(parts[0]) {
                        let ps = parts[1].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                        arr.append(ClassSchedule(weekday: wd, periods: ps))
                    }
                }
                vm.schedules = arr
                vm.save()
                dismiss.wrappedValue.dismiss()
            })
            .onAppear(perform: loadText)
        }
    }
}
