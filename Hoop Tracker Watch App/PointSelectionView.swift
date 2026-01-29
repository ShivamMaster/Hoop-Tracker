import SwiftUI

struct PointSelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Select Points")
                .font(.headline)
            
            HStack(spacing: 15) {
                // Button for Lower Point Value
                Button(action: {
                    viewModel.addMake(points: viewModel.currentLowPointOption)
                    isPresented = false
                }) {
                    Text("\(viewModel.currentLowPointOption)")
                        .font(.system(size: 40, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.green)
                .cornerRadius(15)
                
                // Button for Higher Point Value
                Button(action: {
                    viewModel.addMake(points: viewModel.currentHighPointOption)
                    isPresented = false
                }) {
                    Text("\(viewModel.currentHighPointOption)")
                        .font(.system(size: 40, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.green)
                .cornerRadius(15)
            }
            .frame(height: 100)
            
            Button("Cancel") {
                isPresented = false
            }
            .foregroundColor(.red)
        }
    }
}
