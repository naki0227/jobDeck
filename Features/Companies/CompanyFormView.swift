import SwiftUI

struct CompanyFormView: View {
    let title: String
    @Binding var draft: CompanyDraft
    let errorMessage: String?
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var interviewEnabled = false

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("企業名", text: $draft.name)
                    TextField("業界", text: $draft.industry)
                    TextField("職種", text: $draft.jobType)

                    Picker("選考状況", selection: $draft.selectionStatus) {
                        ForEach(SelectionStatus.allCases, id: \.self) { status in
                            Text(status.label).tag(status)
                        }
                    }

                    Stepper(value: $draft.priority, in: 1 ... 5) {
                        Text("志望度 \(draft.priority)")
                    }
                }

                Section("面接予定") {
                    Toggle("次回面接を登録する", isOn: $interviewEnabled.animation())

                    if interviewEnabled {
                        DatePicker(
                            "面接日時",
                            selection: interviewDateBinding,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }

                Section("メモ") {
                    TextField("企業メモ", text: $draft.memo, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存", action: onSave)
                        .disabled(draft.trimmedName.isEmpty)
                }
            }
            .onAppear {
                interviewEnabled = draft.nextInterviewAt != nil
            }
            .onChange(of: interviewEnabled) { _, isEnabled in
                if !isEnabled {
                    draft.nextInterviewAt = nil
                } else if draft.nextInterviewAt == nil {
                    draft.nextInterviewAt = .now
                }
            }
        }
    }

    private var interviewDateBinding: Binding<Date> {
        Binding(
            get: { draft.nextInterviewAt ?? .now },
            set: { draft.nextInterviewAt = $0 }
        )
    }
}

#Preview {
    CompanyFormView(
        title: "企業追加",
        draft: .constant(CompanyDraft()),
        errorMessage: nil,
        onSave: {}
    )
}
