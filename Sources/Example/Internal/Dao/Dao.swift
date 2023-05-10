import SwiftUI

struct Dao: DataDao, PreferenceDao {}

extension Dao: Repository {}
