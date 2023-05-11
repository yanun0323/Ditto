import SwiftUI
import Ditto

struct DataInteractor {
    let appstate: AppState
    let repo: Repository
}

extension DataInteractor {
    func pushStudentList() {
        System.async {
            return System.doCatch("push list student") {
                return try repo.listStudent()
            } ?? nil
        } main: { value in
            if let value = value {
                appstate.pubStudent.send(value)
            }
        }
    }
    
    func listStudent() -> [Student] {
        return System.doCatch("list student") {
            try repo.listStudent()
        } ?? []
    }
    
    func getStudent(_ id: Int64) -> Student? {
        System.doCatch("get student") {
            try repo.getStudent(id)
        }
    }
    
    func createStudent(_ s: Student) -> Int64? {
        return System.doCatch("create student") {
            try repo.createStudent(s)
        } ?? nil
    }
    
    func updateStudent(_ id: Int64, _ s: Student) {
        System.doCatch("update student") {
            try repo.updateStudent(id, s)
        }
    }
    
    func deleteStudent(_ id: Int64) {
        System.doCatch("delete student") {
            try repo.deleteStudent(id)
        }
    }
}
