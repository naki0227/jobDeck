import SwiftUI

struct CompanyRowView: View {
    let company: Company

    var body: some View {
        Text(company.name)
    }
}
