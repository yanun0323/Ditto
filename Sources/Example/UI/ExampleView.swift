import SwiftUI
import Ditto

struct ExampleView: View {
    @Environment(\.injected) private var container: DIContainer
    @State var accentColor: Color = .accentColor
    @State var studentName: String = ""
    @State var studentAge: Double = 18
    @State var creating: Bool = false
    
    @State var students: [Student] = []
    
    let labelWidth: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 30) {
            accentColorPanel()
            studentCreaterPanel()
            studentList()
                .frame(height: 200)
        }
        .frame(width: 400)
        .padding()
        .onAppear{ handleOnAppear() }
        .onReceive(container.appstate.pubStudent) { handleConsumeStudent($0) }
    }
    
    @ViewBuilder
    private func accentColorPanel() -> some View {
        HStack {
            ColorPicker(selection: $accentColor, supportsOpacity: false) {
                HStack {
                    Text("Accent Color")
                        .frame(width: labelWidth, alignment: .leading)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func studentCreaterPanel() -> some View {
        VStack {
            HStack {
                Text("Student Name")
                    .frame(width: labelWidth, alignment: .leading)
                TextField("Yanun", text: $studentName)
            }
            HStack {
                Text("Student Age")
                    .frame(width: labelWidth, alignment: .leading)
                Text(String(format: "%.0f", studentAge))
                    .monospacedDigit()
                    .padding(.horizontal)
                
                Slider(value: $studentAge, in: 10...25, step: 1)
            }
            Button(width: 120, height: 30, color: accentColor, radius: 7, shadow: 5) {
                if students.isEmpty { return }
                if creating { return }
                defer { creating = false }
                creating = true
                _ = container.interactor.data.createStudent(Student(name: studentName, age: Int(studentAge)))
                studentName = ""
                studentAge = 18
                container.interactor.data.pushStudentList()
            } content: {
                Text("Create Student")
                    .foregroundColor(.white)
            }

        }
    }
    
    @ViewBuilder
    private func studentList() -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            if students.isEmpty {
                HStack {
                    Spacer()
                    Text("No student yet")
                        .font(.title2)
                        .foregroundColor(.section)
                    Spacer()
                }
            }
            
            LazyVStack {
                ForEach(students) { student in
                    HStack {
                        Text(student.name)
                            .frame(width: 100)
                        Text(student.age.description)
                            .frame(width: 100)
                    }
                }
            }
        }
    }
}

extension ExampleView {
    private func handleConsumeStudent(_ s: [Student]) {
        withAnimation {
            students = s
        }
    }
    
    private func handleOnAppear() {
        container.interactor.data.pushStudentList()
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
            .inject(DIContainer(isMock: true))
    }
}
